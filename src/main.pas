{$DEFINE ROMOFF}    // http://mads.atari8.info/doc/en/syntax/#romoff
{$DEFINE NOROMFONT}
// https://github.com/tebe6502/Mad-Pascal/commit/cd5e0df799e0a7c51ff0af1f26e839fc02c2cbf9


program MAFIA;


{$define basicoff}
{$librarypath '../../tools/Mad-Pascal/blibs/'}
{$librarypath '../../tools/Mad-Pascal/base/'}
{$librarypath '../../tools/Mad-Pascal/lib/'}

{$r ./resources.rc}


uses atari, pmg, xbios, crt, cio, aplib, b_utils, rmt, b_pmg, sysutils, b_system, b_crt;


const 
{$i const.inc}


var 
    lastLocation:   byte;
	msx: TRMT;


{$i vars_e000_main.pas}
{$i vars_ec00_fight.pas}
{$i vars_be80_location.pas}
{$i vars_e100_gangsters.pas}
{$I vars_ea00_strings.pas}
 



procedure musicproxy();
begin;
    if playMusic = 1 then 
        msx.play();
end;




{$I helpers.pas}
{$I interrupts.inc}
{$I xbaplib.pas}


procedure loadxAPL(var fname: TString; outputPointer: pointer);
var msxstatus: byte;
begin;
    msxstatus := playMusic;
    if playMusic = 1 then 
        msx.stop();
    playMusic := 0;
    xbunAPL(fname, outputPointer);
    playMusic := msxstatus;
end;


{$I console.pas}
{$I locations.pas}
{$I player.pas}
{$I helpers_game.pas}
{$I sprites.pas}

{$I fight_utils.pas}
{$I fight_ai.pas}
{$I fight.pas}
{$I helpers_fight.pas}

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
{$i setup_game.pas}

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
    ShowLocationHeader;
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

    playMusic := 0;

    // force inclusion of musciproxy, wont be executed here
    if playMusic = 99 then 
        musicproxy();

    enableConsole();
    // repeat; until false;
    clearMemory();
    loadxAPL (e7fname, Pointer(e7adrm6));
    //setupGame();
    initGlobalVars();
    showCredits();
    setupGame();
    initPlayers();

    // turn off all IRQs
    // Poke($D20E, 0);

    // for k:= 0 to 31 do
    // begin;
    //     CRT_Clear();
    //     loadGangster(k);
    //     waitForKey();
    // end;


    msx.player:=pointer(rmt_player);
    msx.modul:=pointer(rmt_modul);
    msx.init(0);
    playMusic := 0; // for now

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
            // EnableVBLI(@vbl);
            enableMapConsole();
            printMapStatus();
            paintPlayer(0);

            repeat;
                ch := readKeyAndStick();
                // overview page
                if byte(ch) = $65 then 
                    addMoney(10000);
                if byte(ch) = $6e then 
                begin;
                    plPoints[currentPlayer] := gamePoints+10;
                    plMoneyTransporter[currentPlayer] := 1;
                    plKilledMajor[currentPlayer] := 1;
                end;

                if byte(ch) = $20 then begin;
                    if playMusic = 1 then 
                    begin 
                        msx.Stop();
                        playMusic := 0;
                    end
                    else  
                    begin 
                        playMusic := 1;
                        msx.Play();
                    end;
                    waitForKeyRelease();
                    WaitFrames(20);
                end;
                if ch = #$1c then begin;
                    // ensure we have loaded the main location
                    loadLocation(UPDATES_);
                    ShowLocationHeader;  
                    CRT_WriteCentered_LocStr(3, 18);
                    CRT_Gotoxy(15,4);
                    tmp := gameLength - currentYear;
                    CRT_Write( tmp);
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
            if (plPoints[k] >= gamePoints) then 
                if (plMoneyTransporter[k] = 1) then 
                  if (plKilledMajor[k] = 1) then  
                    begin
                        plWinners[k] := 1;
                        gameEnds := gameEnds + 1;
                        plNWinners := plNWinners + 1;
                    end;
    until gameEnds = 1;

    // reuse plCurrentMap for winners
    enableConsole();
    CRT_Clear();

    loadLocation(MAIN_);
    // if one player won, it sok, if not all have won
    if plNWinners = 1 then begin 
        for k := 0 to nPlayers-1 do
        begin
            if plWinners[k] = 1 then 
            begin 
                tmp := k SHL 3;
                CRT_WriteCentered(5,gangsterNames[tmp]);
                CRT_WriteCentered_LocStr(7, 35);
                CRT_WriteCentered_LocStr(8, 36);
                CRT_WriteCentered_LocStr(9, 37);
                if gangsterSex[tmp] = 1 then 
                    finalfname := 'FINAWPICAPL'
                else
                    finalfname := 'FINAMPICAPL';
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
            if plWinners[k] = 1 then 
            begin 
                tmp := k SHL 3;
                CRT_WriteCentered(7+currentChoice,gangsterNames[k]);
                currentChoice := currentChoice + 1;
            end; 
        end;
        CRT_WriteCentered_LocStr(7+currentChoice+2, 39);
        finalfname := 'FINAGPICAPL';
    end; 
    waitForKey();

    DisableDLI;
    DLISTL := DL_BLACK_CONSOLE_ADR;
    Waitframes(10);

    // DisableVBLI;
    loadxAPL (finalfname, Pointer($3000-6));


    // this will be around $9890 right now
    finalfname := 'FMUSB800APL';
    loadxAPL(finalfname, pointer($b800));
    finalfname := 'PLAYB000APL';
    loadxAPL(finalfname, pointer($b000));

    // http://atariki.krap.pl/index.php/CMC_(format_pliku)
    asm
        lda #$70
        ldx #$00  ; low byte of music
        ldy #$b8 ; high byte <-- CHANGE TOO if music addr changes
        jsr $b000+3
        lda #$00
        ldx #$00
        jsr $b000+3
    end;

    asm
    lpend:
        jsr $6800;
        jmp lpend
    end;
    
end.
