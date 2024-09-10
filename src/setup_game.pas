

procedure setupGame();
var 
    j, r:   byte;
    k: byte;
begin
    loadLocation(SETUP_);

    // check if we have a savegame
    ShowLocationHeader;
    if checkSavedGame() <> 0 then begin;
        CRT_WriteCentered_LocStr(3, 15);
        CRT_WriteCentered_LocStr(4, 16);
        if getYesNo() = 1 then begin;
            loadGame();
            lastLocationStrings := 254; // force reloading MAIN_ location
            exit;
        end;
    end;

    ShowLocationHeader;
    CRT_WriteCentered_LocStr(3, 14);
    CRT_ClearRow(4);
    CRT_GotoXY(20-2,4);
    r := getAnswer(short_game_keycode, long_game_keycode);  
    if r =0 then begin 
        gameLength := 25; // 25 years 
        gamePoints := 100;
    end
    else 
    begin 
        gameLength := 50; // 50 years
        gamePoints := 200;
    end;
    CRT_NewLine2();
    k := 6;

    // repeat
    //     CRT_WriteCentered(3, loc_string_1);
    //     CRT_ClearRow(4);
    //     CRT_GotoXY(20-2,4);
    //     gameLength := StrToInt(CRT_ReadString(2));
    // until (gameLength>2) and (gameLength<51);
    // CRT_NewLine();

    // CRT_WriteCentered(6, loc_string_2);
    // CRT_ClearRow(7);
    // CRT_GotoXY(20-2,7);
    // gamePoints := readValue(100, 1000);
    // CRT_NewLine();

    CRT_WriteCentered_LocStr(k ,3);
    repeat
        nPlayers := readValue(1,5);
    until (nPlayers > 0) and (nPlayers < 5);
    CRT_NewLine();

    // get all player stats
    FillChar(plGangsters, 32, 99);
    for j := 0 to nPlayers-1 do
    begin;
        currentPlayer := j;
        tmp := currentPlayer SHL 3;
        //initCurrentPlayer();
        ShowLocationHeader;

        // create player 1 in memory..
        CRT_WriteCentered_LocStr(4, 4);
        CRT_Write(j+1);
        CRT_NewLine();

        repeat;
            CRT_WriteCentered_LocStr(6, 5);
            CRT_GotoXY(20-8-1,7);
            gangsterNames[tmp] := Atascii2Antic(CRT_ReadString(15));
        until Length(gangsterNames[tmp]) > 0;

        // init gangsters as well
        plNGangsters[currentPlayer] := 1;
        plGangsters[tmp] := j;

        repeat;
            CRT_WriteCentered_LocStr(9, 6);
            CRT_GotoXY(20-8-1,10);
            plGang[currentPlayer] := Atascii2Antic(CRT_ReadString(15));
        until Length(plGang[currentPlayer]) > 0;

        CRT_WriteCentered_LocStr(12, 7);
        CRT_WriteCentered_LocStr(14, 13);
        r := getAnswer(F_keycode, M_keycode);  
        gangsterSex[tmp] := 1-r; // so M=0, F=1

        CRT_WriteCentered_LocStr(15, 8);
        gangsterStr[tmp] := getRandom (10, 99, 5, 26, 15);
        CRT_WriteCentered_LocStr(16, 9);
        gangsterInt[tmp] := getRandom (10, 99, 5, 26, 16);
        CRT_WriteCentered_LocStr(17, 10);
        gangsterBrut[tmp] := getRandom (10, 99, 5, 26, 17);
        CRT_WriteCentered_LocStr(18, 11);
        gangsterHealth[tmp] := getRandom (10, 99, 5, 26, 18);
        CRT_WriteCentered_LocStr(19, 12);
        plMoney[currentPlayer] := getRandom (5000, 9999, 250, 24, 19);
        waitForKey;
    end;

    // some init routines 
    initPlayers();
    currentPlayer := 0;
    currentMonth := 1;
    currentYear := 0;

end;


