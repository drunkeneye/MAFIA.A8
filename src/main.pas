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

// const
//     W_keycode = $2e;
//     A_keycode = $3f;
//     S_keycode = $3e;
//     D_keycode = $3a;

{$i vars_e000_main.pas}
{$i vars_ec00_fight.pas}
{$i vars_be80_location.pas}
{$i vars_e100_gangsters.pas}
{$I vars_ea00_strings.pas}
 


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


procedure showCredits();
var k: byte;
    cur_loc_str: ^YString;
begin;
    loadLocation(CREDITS_);
    ShowLocationHeader;
    cur_loc_str := Pointer(loc_string_1);
    for k := 0 to 14 do
    begin 
        CRT_Writeln(cur_loc_str);
        cur_loc_str := Pointer(cur_loc_str) + $28;
    end;
    waitForKey();
end; 

var 
    k:   byte;
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
    xbunAPL (e7fname, Pointer(e7adrm6));
    //setupGame();
    initGlobalVars();
    showCredits();
    setupGame();
    initPlayers();
    Poke($D20E, 0);
    // turn off all IRQs

    // for k:= 0 to 31 do
    // begin;
    //     CRT_Clear();
    //     loadGangster(k);
    //     waitForKey();
    // end;

    // plOpportunity[currentPlayer] := 255;
    // plNewPoints[currentPlayer] := 70;
    // plMoney[currentPlayer] := 5550005;

    currentPlayer := 0;
    currentMonth := 1;
    currentYear := 0;
    repeat;
        loadLocation(MAIN_);
        enableConsole();
        if playersTurn() = RESET_ then 
        begin; 
            continue;
        end; 
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
                jobWorking;
                CRT_Writeln_LocStr(11);
                waitForKey();
            end;
        end;

        // update fake id, here we just drop it randomly, like loosing it 
        if plForgedID[currentPlayer] >0 then 
        begin
            if Random(12) = 1 then 
            begin // once a year
                enableConsole();
                jobWorking;
                CRT_Writeln_LocStr(12);
                waitForKey();
                plForgedID[currentPlayer] := 0;
            end;
        end;

        updateGangsters();
        updateRent();
        updateOpportunities(); //incl _26
        updatePrison();

        // 4050 pl(sp)=pl(sp)+(pl(sp)>0)
        if plBribe[currentPlayer] > 0 then
            plBribe[currentPlayer] := plBribe[currentPlayer] - 1;

        if currentLocation = END_TURN_ then begin
            nextPlayer; 
            continue;
        end; 
        

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
                // overview page
                if ch = #$1c then begin;
                    // ensure we have loaded the main location
                    loadLocation(UPDATES_);
                    ShowLocationHeader;  
                    CRT_WriteCentered_LocStr(3, 18);
                    CRT_Gotoxy(15,4);
                    CRT_Write( gameLength- currentYear);
                    CRT_Write_LocStr(19);
                    CRT_WriteCentered_LocStr(6, 20);
                    CRT_GotoXY(0,4);
                    showWeapons := 1;
                    printGangsters();
                    showWeapons := 0;
                    CRT_GotoXY(0,20);
                    waitForKey();
                    enableMapConsole();
                    printMapStatus();
                    paintPlayer(0);
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
            plSteps[currentPlayer] := plSteps[currentPlayer] - 6;
            // also clear sprite
            clearSprites();

            // now we either entered a location or the turn ended
            blackConsole();

            currentChoice := ShowLocation(currentLocation);
            if currentChoice = loc_nOptions then
                currentLocation := NONE_;

            case currentLocation of 
                BANK_:   outcome := bankChoices;
                FORGERY_:   outcome := forgeryChoices;
                MONEYTRANSPORT_: outcome := moneyTransporterChoices;
                LOANSHARK_: outcome := loanSharkChoices;
                POLICE_: outcome:= policeChoices;
                CARDEALER_: outcome := carDealerChoices;
                PUB_: outcome := pubChoices;
                CENTRALSTATION_: outcome := centralStationChoices;
                STORE_: outcome := storeChoices ;
                HIDEOUT_: outcome := hideoutChoices;
                GAMBLING_:outcome := gamblingChoices;
                SUBWAY_: outcome := subwayChoices ;
                ARMSDEALER_:outcome := armsDealerChoices;
                MAJOR_: outcome := majorChoices;
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
            if (plPoints[k] > gamePoints-1) and (plMoneyTransporter[k] = 1) and (plKilledMajor[k] = 1) then  gameEnds := gameEnds + 1;
    until gameEnds = 1;

    // reuse plCurrentMap for winners
    enableConsole();
    CRT_Clear();

    playerPos_X := 0;
    for k := 0 to nPlayers-1 do
    begin
        if (plPoints[k] > gamePoints-1) and (plMoneyTransporter[k] = 1) and (plKilledMajor[k] = 1) then 
            plCurrentMap[k] := 1
        else plCurrentMap[k] := 0;
        playerPos_X := playerPos_X + plCurrentMap[k];
    end;

    loadLocation(MAIN_);
    // if one player won, it sok, if not all have won
    if playerPos_X = 1 then begin 
        for k := 0 to nPlayers-1 do
        begin
            if plCurrentMap[k] = 1 then 
            begin 
                CRT_WriteCentered(5,gangsterNames[k SHR 3]);
                CRT_WriteCentered_LocStr(7, 35);
                CRT_WriteCentered_LocStr(8, 36);
                CRT_WriteCentered_LocStr(9, 37);
                if gangsterSex[k SHL 3] = 1 then 
                    finalfname := 'FINALWAPAPL'
                else
                    finalfname := 'FINALMAPAPL';
                break;
            end; 
        end;
    end 
    else  
    begin 
        CRT_WriteCentered_LocStr(5, 38);
        currentChoice := 0;
        for k := 0 to nPlayers-1 do
        begin;
            if plCurrentMap[k] = 1 then 
            begin 
                CRT_WriteCentered(7+currentChoice,gangsterNames[k SHL 3]);
                currentChoice := currentChoice + 1;
            end; 
        end;
        CRT_WriteCentered_LocStr(7+currentChoice+2, 39);
        finalfname := 'FINALGAPAPL';
    end; 
    waitForKey();

    DisableDLI;
    DLISTL := DL_BLACK_CONSOLE_ADR;
    Waitframes(10);

    xbunAPL (finalfname, Pointer($2000-6));
    asm
    lpend:
        jsr $5800;
        jmp lpend
    end;
    
end.
