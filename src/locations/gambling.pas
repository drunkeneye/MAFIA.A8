
function gamblingChoices:   byte;
var //choice:byte;
    game:   byte;
    einsatz:   word;
    gewinn:   word;
    ch: char;
begin;
    ShowLocationHeader;

    CRT_Writeln2_LocStr(1);

    CRT_Writeln_LocStr(2);  
    CRT_Writeln_LocStr(3);  
    CRT_Writeln2_LocStr(4);  

    CRT_Write_LocStr(5);
    game := 99;
    repeat;
        ch := readKeyAndStick();
        case byte(ch) of 
            $1f: game := 1;
            $1e: game := 2;
            $1a: game := 3;
            $32: exit;
        end;
    until game <> 99;

    CRT_NewLine2();
    CRT_Write_LocStr(6);
    CRT_Write(plMoney[currentPlayer]);
    CRT_Write('$.'~);
    CRT_NewLine();
    einsatz := plMoney[currentPlayer];
    // do not allow more than 10k
    if einsatz > 10000 then
      einsatz := 10000;
    CRT_Write_LocStr(7);
    CRT_Write(einsatz);
    CRT_Write('$)? '~);
    einsatz := readValue(0,einsatz);
    if einsatz = 0 then
        exit;
    if payMoney(einsatz) = 0 then exit;
    // should NEVER happen, since we check for the money there

    CRT_NewLine2();
    CRT_Writeln2_LocStr(8);
    CRT_NewLine();

    effectWait();
    game := game+2;
    if Random(game) = 0 then
    begin
        //16030 fort=1to1000:next:ifint(rnd(1)*(1+x))=0thenp=int(p*(.5+x)):goto16040
        gewinn := einsatz SHR 1;
        gewinn := gewinn*game + einsatz;
        CRT_Write_LocStr(9);
        CRT_Write (gewinn);
        CRT_Write_LocStr(10);
        addMoney(gewinn);
    end
    else
        CRT_Write_LocStr(11);
    waitForKey();

end;
