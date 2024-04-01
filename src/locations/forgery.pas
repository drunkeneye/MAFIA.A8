
// TODO: could have: each gangster has itws own fake id,
// so adding gangsters later on will make some gangsters have no ID
// and if caught, only these go to prison. new ones must be recruited.

function forgeryChoices:   byte;
var r:   byte;
    c:   word;
    p:   word;
    m:   word;
begin;
    // 'Yeah, kannst du mir einen neuen Pass    machen? Er muss gut sein, klar?'~,
    if currentChoice = 1 then
    begin;
        ShowLocationHeader;

        // TODO: how this is solved in the original game?
        if plForgedID[currentPlayer] > 0 then
        begin;
            CRT_Writeln_LocStr(1);
            waitForKey();
            exit;
        end;

        r := plNGangsters[currentPlayer];
        c := r*1000;
        CRT_Writeln_LocStr(2);
        CRT_Write_LocStr(3);
        if r > 1 then 
            CRT_Write_LocStr(4);
        CRT_Newline;
        CRT_Write_LocStr(5);
        CRT_Write(c);
        CRT_Writeln('$.'~);
        CRT_NewLine();
        CRT_Write_LocStr(6);

        r := getYesNo;
        if r = 0 then exit;
        if payMoney (c) = 0 then exit;
        
        CRT_NewLine();
        CRT_NewLine();
        CRT_Writeln_LocStr(7);
        plForgedID[currentPlayer] := 1;
        addPoints(1);
        waitForKey();
    end;


    if currentChoice = 2 then
    begin;
        ShowLocationHeader;
        if plFakeMoney[currentPlayer] > 0 then
        begin;
            CRT_Writeln_LocStr(8);
            waitForKey();
            exit;
        end;

        CRT_Writeln_LocStr(9);
        CRT_Write_LocStr(10);

        m := 5000;
        // if plMoney[currentPlayer] < m then m := plMoney[currentPlayer];
        CRT_Write(m);
        CRT_Write(')?'~);
        c := readValue(0,m);
        if c = 0 then
            exit;

        tmp := Random(0);
        p := c + c + tmp + tmp + tmp;
        CRT_NewLine();
        CRT_NewLine();
        CRT_Write_LocStr(11);
        CRT_Write(p);
        CRT_Write_LocStr(12);

        r := getYesNo;
        if r = 0 then exit;
        if payMoney (c) = 0 then exit;

        CRT_NewLine;
        CRT_NewLine;
        CRT_Writeln_LocStr(13);

        addMoney(p);
        plFakeMoney[currentPlayer] := 6;
        addPoints(1);
        waitForKey();
    end;
end;
