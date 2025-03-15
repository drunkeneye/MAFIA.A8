
// optimzied version of CRT_ReadStringI from b_crt, no function,
// and writes diretly into string instead of returning something
// (which yields bug in 1.7.2 since the result-stackpointer is copied into r,
// so r will change every time something is pushed into the stack)
procedure m_ReadStringI(limit: byte; var r:string);
var a: char;
begin
    r := '';
    repeat
        a := char(CRT_ReadCharI);
        if a = ICHAR_RETURN then exit;
        if (a = ICHAR_BACKSPACE) and (byte(r[0])>0) then begin
            Dec(CRT_cursor);
            Poke(CRT_cursor,0);
            Dec(r[0]);
        end else
        if (a <> ICHAR_CAPS)
        and (a <> ICHAR_INVERSE)
        and (a <> ICHAR_TAB)
        and (a <> ICHAR_ESCAPE)
        and (a <> ICHAR_BACKSPACE)
        and (byte(r[0])<limit) then begin
            CRT_Put(byte(a));
            Inc(r[0]);
            r[byte(r[0])] := a;
        end;
    until false;
end;



procedure setupGame();
var 
    j, r:   byte;
    k: byte;
begin
    loadLocation(SETUP_);

    // check if we have a savegame
    ShowLocationHeader;
    checkForSavedGame();
    if save_gameFound = 1 then begin;
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
    r := getAnswerChar(short_game_keycode, long_game_keycode, short_game_charcode, long_game_charcode);  
    if r = 0 then begin 
        gameLength := 25; // 25 years 
        gamePoints := 100;
    end
    else 
    begin 
        gameLength := 50; // 50 years
        gamePoints := 200;
    end;

    CRT_WriteCentered_LocStr(5,3);
    nPlayers := readValue(1,4);
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
            m_ReadStringI(15, gangsterNames[tmp]);
        until Length(gangsterNames[tmp]) > 0;

        // init gangsters as well
        plNGangsters[currentPlayer] := 1;
        plGangsters[tmp] := j;

        repeat;
            CRT_WriteCentered_LocStr(9, 6);
            CRT_GotoXY(20-8-1,10);
            m_ReadStringI(15, plGang[currentPlayer]);
        until Length(plGang[currentPlayer]) > 0;

        CRT_WriteCentered_LocStr(12, 7);
        CRT_WriteCentered_LocStr(14, 13);
        r := getAnswerChar(F_keycode, M_keycode, F_charcode, M_charcode);  
        
        gangsterSex[tmp] := 1-r; // so M=0, F=1

        CRT_WriteCentered_LocStr(15, 8);
        gangsterStr[tmp] := getRandom (10, 35, 2);
        CRT_NewLine();

        CRT_WriteCentered_LocStr(16, 9);
        gangsterInt[tmp] := getRandom (10, 35, 2);
        CRT_NewLine();

        CRT_WriteCentered_LocStr(17, 10);
        gangsterBrut[tmp] := getRandom (10, 35, 2);
        CRT_NewLine();

        gangsterHealth[tmp] := 30;
        CRT_WriteCentered_LocStr(18, 12);
        plMoney[currentPlayer] := getRandom (5000, 9999, 250);
        waitForKey;
    end;

    // some init routines 
    initPlayers();
    currentPlayer := 0;
    currentMonth := 1;
    currentYear := 0;

end;


