

function policeChoices:   byte;
var r:   byte;
    m:   byte;
    p: word;
begin;
    result := POLICE_;
    if currentChoice = 1 then
    begin;
        gotoCourt();
        result := END_TURN_;
        exit;
    end;

    if currentChoice = 2 then
    begin;
        ShowLocationHeader;
        CRT_Writeln_LocStr(1);
        CRT_Write_LocStr(2);
        m := readValue (0, 100);
        if m = 0 then exit;
        if payMoney(m*1000) = 0 then exit;

        // plMoney[currentPlayer] := plMoney[currentPlayer] - m*1000;
        plBribe[currentPlayer] := plBribe[currentPlayer] + m;
        addPoints(2);

        CRT_Newline;
        CRT_Newline;
        CRT_Writeln_LocStr(3);
        CRT_Writeln_LocStr(4);
        waitForKey();
        exit;
    end;

    if currentChoice = 3 then
    begin;
        ShowLocationHeader;
        // who is in prison? currentplayer cannot
        CRT_Writeln2(loc_string_5);
        r := 0;
        for m := 0 to nPlayers-1 do 
        begin 
            if plPrison[m] > 0 then begin 
                CRT_Write(' '~);
                CRT_Write(m+1);
                CRT_Write(' - '~);
                CRT_Writeln(gangsterNames[m SHL 3]);
                r := r + 1;
            end;
        end; 
        if r = 0 then begin 
            CRT_Writeln_LocStr(6);
            waitForKey;
            exit;
        end; 

        CRT_NewLine;        
        CRT_Writeln_LocStr(7);
        repeat;
            r := readValueNoZero(1,nPlayers);
        until plPrison[r-1] > 0;
        r := r -1;
        p  := Random(5) SHL 9 + 3000;
        CRT_NewLine;        
        CRT_NewLine;        
        CRT_Write_LocStr(8);
        CRT_Write(p);
        CRT_Writeln_LocStr(9);
        CRT_Writeln_LocStr(10);
        waitForKey;
        CRT_Newline;
        CRT_Newline;
        if payMoney(p) = 0 then exit;
        CRT_Writeln_LocStr(11);
        CRT_Writeln_LocStr(12);
        waitForKey;
        plFreed[r] := currentPlayer;
        plPrison[r] := 0;
        // TODO: add randomly free a person who becomes one of your gangsters.
    end;


end;
