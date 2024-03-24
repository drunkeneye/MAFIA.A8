
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
            CRT_Writeln(loc_string_1);
            waitForKey();
            exit;
        end;

        r := plNGangsters[currentPlayer];
        c := r*1000;
        CRT_Writeln(loc_string_2);
        CRT_Write(loc_string_3);
        if r > 1 then 
            CRT_Write (loc_string_4);
        CRT_Newline;
        CRT_Write(loc_string_5);
        CRT_Write(c);
        CRT_Writeln('$.'~);
        CRT_NewLine();
        CRT_Write(loc_string_6);

        r := getYesNo;
        if r = 0 then exit;
        if payMoney (c) = 0 then exit;
        
        CRT_NewLine();
        CRT_NewLine();
        CRT_Writeln(loc_string_7);
        plForgedID[currentPlayer] := 1;
        addPoints(1);
        waitForKey();
    end;


    // TODO: DU HAST SCHON BLUETEN? oder nur 1x blueten pro runde

    // 'Danke, Eddie, vielleicht beim naechs-   ten mal. Bye!'~,
    if currentChoice = 2 then
    begin;
        ShowLocationHeader;
        if plFakeMoney[currentPlayer] > 0 then
        begin;
            CRT_Writeln(loc_string_8);
            waitForKey();
            exit;
        end;

        CRT_Writeln(loc_string_9);
        CRT_Write(loc_string_10);

        m := 5000;
        if plMoney[currentPlayer] < m then m := plMoney[currentPlayer];
        CRT_Write(m);
        CRT_Write(')?'~);
        c := readValue(0,m);
        if c = 0 then
            exit;
        p := c+100+(Random(10)*(c SHR 4));
        CRT_NewLine();
        CRT_NewLine();
        CRT_Write(loc_string_11);
        CRT_Write(p);
        CRT_Write(loc_string_12);

        r := getYesNo;
        if r = 0 then exit;
        if payMoney (c) = 0 then exit;

        CRT_NewLine;
        CRT_NewLine;
        CRT_Writeln(loc_string_13);

        addMoney(p);
        plFakeMoney[currentPlayer] := 6;
        addPoints(1);
        waitForKey();
    end;
end;
