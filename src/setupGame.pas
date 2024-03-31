

// procedure initCurrentPlayer ();
// begin;
//     plCar[currentPlayer] := 0;
//     plRentMonths[currentPlayer] := 0;
//     plBribe[currentPlayer] := 0;
// end;


{$ifndef fake}
procedure setupGame();
var 
    j, r:   byte;
    k: byte;
begin
    loadLocation(SETUP_);

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
    CRT_NewLine();
    CRT_NewLine();
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
        //initCurrentPlayer();
        ShowLocationHeader;

        // create player 1 in memory..
        CRT_WriteCentered_LocStr(4, 4);
        CRT_Write(j+1);
        CRT_NewLine();
        CRT_WriteCentered_LocStr(6, 5);
        CRT_GotoXY(20-8-1,7);
        gangsterNames[currentPlayer SHL 3] := Atascii2Antic(CRT_ReadString(15));

        // init gangsters as well
        plNGangsters[currentPlayer] := 1;
        plGangsters[currentPlayer SHL 3] := j;

        CRT_WriteCentered_LocStr(9, 6);
        CRT_GotoXY(20-8-1,10);
        plGang[currentPlayer] := Atascii2Antic(CRT_ReadString(15));

        CRT_WriteCentered_LocStr(12, 7);
        CRT_WriteCentered_LocStr(14, 13);
        r := getAnswer(F_keycode, M_keycode);  
        gangsterSex[currentPlayer SHL 3] := 1-r; // so M=0, F=1

        CRT_WriteCentered_LocStr(15, 8);
        gangsterStr[currentPlayer SHL 3] := getRandom (10, 99, 5, 23, 15);
        CRT_WriteCentered_LocStr(16, 9);
        gangsterInt[currentPlayer SHL 3] := getRandom (10, 99, 5, 26, 16);
        CRT_WriteCentered_LocStr(17, 10);
        gangsterBrut[currentPlayer SHL 3] := getRandom (10, 99, 5, 26, 17);
        CRT_WriteCentered_LocStr(18, 11);
        gangsterHealth[currentPlayer SHL 3] := getRandom (10, 99, 5, 26, 18);
        CRT_WriteCentered_LocStr(19, 12);
        plMoney[currentPlayer] := getRandom (5000, 9999, 250, 24, 19);
        waitForKey;
    end;
end;
{$endif}



{$ifdef fake}
// print stats
procedure setupGame();
var 
    i, j, k:   byte;

begin
    gameLength := 10;
    gamePoints := 100;
    nPlayers := 1;
    k := nPlayers;

    // init some gangsters too 
    FillChar(plGangsters, 32, 99);

    for j := 0 to k-1 do
    begin;
        CRT_Write('Selecting player');
        CRT_Write(j);
        currentPlayer := j;
        gangsterNames[currentPlayer SHL 3] := Concat('pummel '~, Atascii2Antic(IntToStr(j)));
        plGang[currentPlayer] := Concat('team '~, Atascii2Antic(IntToStr(j)));
        gangsterStr[currentPlayer SHL 3] := 32+j*10;
        gangsterInt[currentPlayer SHL 3] := 52+j*21;
        gangsterBrut[currentPlayer SHL 3] := 90-j*12;
        gangsterHealth[currentPlayer SHL 3] := 99-j*15;
        plMoney[currentPlayer] := 100000+j*100*Random(50);
        plCar[currentPlayer] := 5;
        plNGangsters[currentPlayer] := 1;
        plGangsters[currentPlayer SHL 3] := j;
    end;
    CRT_Write('Done.');

    // print stats
    CRT_Clear;
    k := 1;
    i := nPlayers;
    for j := 0 to i-1 do
    begin;
        currentPlayer := j;
        CRT_WriteCentered(k, 'Spieler '~);
        //    CRT_Write(Concat(currentPlayer^.name);
        CRT_Write(j);
        CRT_NewLine();
        CRT_GotoXY(20-8-1,7);
        CRT_WriteCentered(k+2, 'Deine Eigenschaften:'~);
        CRT_WriteCentered(k+3, Concat('Kraft:'~, Atascii2Antic(IntToStr(gangsterStr[currentPlayer SHL 3]))));
        CRT_WriteCentered(k+4, Concat('Intelligenz:'~, Atascii2Antic(IntToStr(gangsterInt[currentPlayer SHL 3]))));
        CRT_WriteCentered(k+5, Concat('Brutalitaet:'~, Atascii2Antic(IntToStr(gangsterBrut[currentPlayer SHL 3]))));
        CRT_WriteCentered(k+6, Concat('Gesundheit:'~, Atascii2Antic(IntToStr(gangsterHealth[currentPlayer SHL 3]))));
        CRT_WriteCentered(k+7, Concat('Kapital:'~, Atascii2Antic(IntToStr(plMoney[currentPlayer]))));
        k := k + 8;
    end;
    CRT_ReadKey();
end;
{$endif}
