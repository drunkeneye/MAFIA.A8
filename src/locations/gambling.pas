
function gamblingChoices:   byte;
var //choice:byte;
    game:   byte;
    einsatz:   word;
    gewinn:   word;
begin;
    ShowLocationHeader;

    CRT_Writeln2(loc_string_1);
    CRT_Writeln(loc_string_2);
    CRT_Writeln(loc_string_3);
    CRT_Writeln(loc_string_4);
    CRT_NewLine();

    CRT_Write(loc_string_5);
    game := readValue(0,3);
    if game = 0 then
        exit;

    CRT_NewLine();
    CRT_NewLine();
    CRT_Write(loc_string_6);
    CRT_Write(plMoney[currentPlayer]);
    CRT_Write('$.'~);
    CRT_NewLine();
    einsatz := plMoney[currentPlayer];
    // the version i have has no limit
    // if einsatz > 5000 then
    //   einsatz := 5000;
    CRT_Write(loc_string_7);
    CRT_Write(einsatz);
    CRT_Write('$)? '~);
    einsatz := readValue(0,einsatz);
    if einsatz = 0 then
        exit;
    if payMoney(einsatz) = 0 then exit;
    // should NEVER happen, since we check for the money there

    CRT_NewLine();
    CRT_NewLine();
    CRT_Writeln2(loc_string_8);
    CRT_NewLine();

    effectWait();
    game := game+2;
    if Random(game) = 0 then
    begin
        //16030 fort=1to1000:next:ifint(rnd(1)*(1+x))=0thenp=int(p*(.5+x)):goto16040
        gewinn := einsatz SHR 1;
        gewinn := gewinn*game + einsatz;
        CRT_Write (loc_string_9);
        CRT_Write (gewinn);
        CRT_Write (loc_string_10);
        addMoney(gewinn);
    end
    else
        CRT_Write (loc_string_11);
    waitForKey();

end;
