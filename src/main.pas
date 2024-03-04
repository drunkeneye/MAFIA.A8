{$DEFINE ROMOFF}    // http://mads.atari8.info/doc/en/syntax/#romoff
{$DEFINE NOROMFONT}
// https://github.com/tebe6502/Mad-Pascal/commit/cd5e0df799e0a7c51ff0af1f26e839fc02c2cbf9


program MAFIA;


{$define basicoff}
{$librarypath '../../tools/Mad-Pascal/blibs/'}
{$librarypath '../../tools/Mad-Pascal/base/'}
{$librarypath '../../tools/Mad-Pascal/lib/'}

{$r ./resources.rc}


uses atari, joystick, pmg, xbapLib, xbios, crt, cio, aplib, b_utils, rmt, b_pmg, sysutils, b_system, b_crt;
// b_utils;

const 
{$i const.inc}

{$i vars.pas}
{$i vars_fight.pas}
{$i vars_location.pas}
{$i vars_gangsters.pas}
{$I strings.pas}
 


{$I helpers.pas}
{$I interrupts.inc}
{$I console.pas}
{$I locations.pas}
{$I player.pas}
{$I helpersGame.pas}
{$I sprites.pas}

{$I fight_utils.pas}
{$I fight_ai.pas}
{$I fight.pas}
{$I helpersFight.pas}


var 
    lastLocation:   byte;


{$I locations/armsdealer.pas}
{$I locations/bank.pas}
{$I locations/cardealer.pas}
{$I locations/forgery.pas}
{$I locations/gambling.pas}
{$I locations/hideout.pas}
{$I locations/loanshark.pas}
{$I locations/police.pas}
{$I locations/pub.pas}
{$I locations/store.pas}
{$I locations/subway.pas}

{$I locations/centralstation.pas}
{$I locations/major.pas}
{$I locations/moneytransporter.pas}

{$I map.pas}
// {$ I bitmap.pas}
{$i setupGame.pas}

{$I updates.pas}



procedure clearMemory();
begin;
    FillChar (Pointer($e000), $fc00-$e000, 0);
    FillChar (Pointer($be80), $cc00-$be80, 0);
end; 



procedure initGlobalVars();
var k:byte;
begin;
    for k := 0 to 3 do
    begin;
        plRent[k] := 99;
        plLoanShark[k] := 99;
        plFreed[k] := 99;
    end;
end;


var 
    k:   byte;
    choice:   byte;
    outcome: byte;
    cs:   word;
    ch:   char;
begin
    DMACTL := $22;
    asm;
        pha
        jsr xbios.xBIOS_SET_DEFAULT_DEVICE
        lda #$00
        sta xbios.xIRQEN
        pla
    end;

    randomize;
    SystemOff;

    // check xbios from StarVagrant
    cs := dPeek($0800);
    if (char(Lo(cs)) <> 'x') or (char(Hi(cs)) <> 'B') then
        // make it crash if no xbios is there
        repeat;
            CRT_Write('NO XBIOS!'~);
        until false;

    enableConsole();
    // repeat; until false;
    clearMemory();
    xbunAPL (e7fname, Pointer(e7adr));
    //setupGame();
    initGlobalVars();
    setupGame();
    initPlayers();
    // plMoney[0] := 55000;
    // plRank[0] := 7;
    // plCar[0] := 4;
    // plAlcohol[0] := 50;
    // plMoney[1] := 55000;
    // plRank[1] := 7;
    // plCar[0] := 3;
    // plAlcohol[1] := 30;
    Poke($D20E, 0);
    // turn off all IRQs

    // for k:= 0 to 31 do
    // begin;
    //     CRT_Clear();
    //     loadGangster(k);
    //     waitForKey();
    // end;



    currentPlayer := 0;
    currentMonth := 1;
    currentYear := 0;
    repeat;
        loadLocation(MAIN_);
        enableConsole();
        playersTurn();
        blackConsole();
        currentLocation := NONE_;
        lastLocation := NONE_;

        updateRank();
 
        // update fake money: in original, remove it with 12% probability
        // here we just have 6 month of it
        // 4055 ifint(rnd(1)*8)=0thenag(sp)=ag(sp)and254
        // 4056 ifint(rnd(1)*8)=0thenag(sp)=ag(sp)and253
        if plFakeMoney[currentPlayer] > 0 then 
        begin
            plFakeMoney[currentPlayer] := plFakeMoney[currentPlayer] - 1;
            if plFakeMoney[currentPlayer] = 0 then 
            begin
                enableConsole();
                CRT_Writeln(loc_string_11);
                waitForKey();
            end;
        end;

        // update fake id, here we just drop it randomly, like loosing it 
        if plForgedID[currentPlayer] >0 then 
        begin
            if Random(12) = 1 then 
            begin // once a year
                enableConsole();
                CRT_Writeln(loc_string_12);
                waitForKey();
                plForgedID[currentPlayer] := 0;
            end;
        end;

        updateGangsters();
        updateRent();
        updateOpportunities(); //incl _26
        updatePrison();
        if currentLocation = END_TURN_ then begin
            nextPlayer; 
            continue;
        end; 
        
        // 4050 pl(sp)=pl(sp)+(pl(sp)>0)
        if plBribe[currentPlayer] > 0 then
            plBribe[currentPlayer] := plBribe[currentPlayer] - 1;

        loadLocation (JOB_);
        updateLoanShark();
        if plJob[currentPlayer] > 0 then 
        begin
            updateJob();
            currentLocation := END_TURN_;

            nextPlayer();
            continue;
        end;

        plSteps[currentPlayer] := carRange[plCar[currentPlayer]];
        placeCurrentPlayer();
        loadMap();
        enableSprites();
        printMapStatus();


        while (plSteps[currentPlayer] > 0) and (currentLocation <> END_TURN_) do
        begin;
            enableMapConsole();
            printMapStatus();
            paintPlayer(0);

            repeat;
                ch := readKeyAndStick();
                if byte(ch) = $1e then begin;
                    loadGame();
                    continue;
                end;
                if byte(ch) = $1f then begin;
                    saveGame();
                    continue;
                end;
                currentLocation := MoveCurrentPlayer(ch);
                if currentLocation = END_TURN_ then break;
                printMapStatus();
                mapReloaded := 1;
                ChangeMap();
            until (currentLocation <> STREET_) or (plSteps[currentPlayer] <= 0);

            if currentLocation = END_TURN_ then
            begin;
                plSteps[currentPlayer] := 0;
                blackConsole();
                break;
            end;

            // allow entering a location if steps are less than 4 etc.
            if (currentLocation = NONE_) or (currentLocation = STREET_) then break;

            // whatever we do, we need to move back
            mapPos_X := oldMapPos_X;
            mapPos_Y := oldMapPos_Y;
            playerPos_X := oldPlayerPos_X;
            playerPos_Y := oldPlayerPos_Y;
            plSteps[currentPlayer] := plSteps[currentPlayer] - 4;
            // also clear sprite
            clearSprites();

            // now we either entered a location or the turn ended
            blackConsole();

            choice := ShowLocation(currentLocation);
            if choice = loc_nOptions then
                currentLocation := NONE_;

            case currentLocation of 
                BANK_:   outcome := bankChoices (choice);
                FORGERY_:   outcome := forgeryChoices (choice);
                MONEYTRANSPORT_: outcome := moneyTransporterChoices (choice);
                LOANSHARK_: outcome := loanSharkChoices (choice);
                POLICE_: outcome:= policeChoices (choice);
                CARDEALER_: outcome := carDealerChoices (choice);
                PUB_: outcome := pubChoices (choice);
                CENTRALSTATION_: outcome := centralStationChoices (choice);
                STORE_: outcome := storeChoices (choice);
                HIDEOUT_: outcome := hideoutChoices (choice);
                GAMBLING_:outcome := gamblingChoices (choice);
                SUBWAY_: outcome := subwayChoices (choice);
                ARMSDEALER_:outcome := armsDealerChoices (choice);
                MAJOR_: outcome := majorChoices(choice);
                NONE_: outcome := NONE_;
           end;

            mapReloaded := 0;
            lastLocation := currentLocation;
            currentLocation := outcome;

            // did we go into a fight? if sn, reload map
            if didFight = 1 then begin;
                loadMap();
                enableSprites();
                didFight := 0;
                mapPos_X := oldMapPos_X;
                mapPos_Y := oldMapPos_Y;
                playerPos_X := oldPlayerPos_X;
                playerPos_Y := oldPlayerPos_Y;
                printMapStatus();
            end;
        end;

        // deinit player
        plMapPosX[currentPlayer] :=   mapPos_X;
        plMapPosY[currentPlayer] :=   mapPos_Y;
        plCurrentMap[currentPlayer] := currentMap;
        
        nextPlayer();

        gameEnds := Byte(currentYear > gameLength);
        for k := 0 to nPlayers-1 do
            if (plRank[k] = 11) and (plMoneyTransporter[k] = 1) and (plKilledMajor[k] = 1) then  gameEnds := gameEnds + 1;
    until gameEnds = 1;

    // reuse plCurrentMap for winners
    enableConsole();
    CRT_Clear();

    playerPos_X := 0;
    for k := 0 to nPlayers-1 do
    begin
        if (plRank[k] = 11) and (plMoneyTransporter[k] = 1) and (plKilledMajor[k] = 1) then 
            plCurrentMap[k] := 0
        else plCurrentMap[k] := 1;
        playerPos_X := playerPos_X + plCurrentMap[k];
    end;

    loadLocation(MAIN_);
    // if one palyer won, it sok, if not all have won
    if playerPos_X = 1 then begin 
        for k := 0 to nPlayers-1 do
        begin
            if plCurrentMap[k] = 1 then 
            begin 
                CRT_WriteCentered(5,gangsterNames[k SHR 3]);
                CRT_WriteCentered(7,loc_string_35);
                CRT_WriteCentered(8,loc_string_36);
                CRT_WriteCentered(9,loc_string_37);
                break;
            end; 
        end;
    end 
    else  
    begin 
        CRT_WriteCentered(5,loc_string_38);
        choice := 0;
        for k := 0 to nPlayers-1 do
        begin;
            if plCurrentMap[k] = 1 then 
            begin 
                CRT_WriteCentered(7+choice,gangsterNames[k SHL 3]);
                choice := choice + 1;
            end; 
        end;
        CRT_WriteCentered(7+choice+2,loc_string_39);
    end; 
    waitForKey();

    DisableDLI;
    DLISTL := DL_BLACK_CONSOLE_ADR;
    Waitframes(10);

    xbunAPL (finalfname, Pointer($2000-6));
    asm
    lpend:
        jsr $5000;
        jmp lpend
    end;
    
end.
