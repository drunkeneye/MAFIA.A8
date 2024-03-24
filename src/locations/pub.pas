
function pubChoices: byte;
var r:   byte;
    wage:   smallint;
    duration:   byte;
    joblocation:   byte;
    g, k, z: byte;
    tipp: byte;
    hasHideout: byte;
    p: word;
    al, w: smallint;
begin;
    result := PUB_;
    ShowLocationHeader;

    // 'Nein, keine Milch! Hast du was          alkoholisches da?'~,
    if currentChoice = 1 then
    begin;
        if (currentSubLocation > 1) then 
        begin;
            if (Random(2) = 0) and (plAlcohol[currentPlayer] > 0) then 
            begin;
                p := Random(20) + 10;
                CRT_Writeln(loc_string_1);
                CRT_Write(loc_string_2);
                CRT_Write(p);
                CRT_writeln(loc_string_3);

                CRT_write(loc_string_4);
                CRT_Write(plAlcohol[currentPlayer]);
                CRT_Write(')?'~);
                al := readValue(0, plAlcohol[currentPlayer]); 
                if al = 0 then exit;

                CRT_NewLine();
                CRT_Writeln(loc_string_5);
                addMoney(al*p);
                plAlcohol[currentPlayer] := plAlcohol[currentPlayer] - al;
            end 
            else 
            begin;
                CRT_Writeln(loc_string_6);
            end; 
            waitForKey;
            exit;
        end; 
        al := Random(200) + 100;
        p := Random(10)+5;
        CRT_Write(loc_string_7);
        CRT_Write(p);
        CRT_Writeln('$.'~);
 
       // compute current capacity
        w := carCargo[plCar[currentPlayer]] - plAlcohol[currentPlayer];
        if w <= 0 then begin;
            CRT_NewLine();
            CRT_Writeln(loc_string_8);
            CRT_Writeln(loc_string_9);
            waitForKey();
            exit;
        end;
        if w < al then al := w;
        CRT_Write(loc_string_10);
        CRT_Write(al);
        CRT_Write(')?'~);
        w := readValue(0, al); 
        if w <= 0 then exit;
        p := w*p; 
        if payMoney (p) = 0 then exit;
        plAlcohol[currentPlayer] := plAlcohol[currentPlayer] + w;  
        addPoints(2);
    end;

    // 'Ich suche ein paar Jungs fuer meine     Gang. Mal sehen, wer da ist...'~,
    if currentChoice = 2 then
    begin;
        ShowLocationHeader;
        {$ifndef norank}
        if plRank[currentPlayer] < 5 then
        begin
            CRT_Write(loc_string_11);
            CRT_Write(rankNames[plRank[currentPlayer]]);
            CRT_Writeln(loc_string_12);
            CRT_Writeln(loc_string_13);
            waitForKey();
            exit;
        end; 
        {$endif}

        // check if player has rented something
        for r := 0 to 3 do
            if plRent[r] = currentPlayer then hasHideout := 1;

        if hasHideout = 0 then 
        begin 
            CRT_Writeln(loc_string_14);
            CRT_Writeln(loc_string_15);
            waitForKey();
            exit;
        end;         

        if plNGangsters[currentPlayer] > 7 then 
        begin;
            CRT_Writeln(loc_string_16);
            CRT_Writeln(loc_string_17);
            waitForKey();
            exit;
        end;

        // original is more complex 12106 y=0:fori=1to30:y=y-(sg(i)=0):next:ify>3theny=3
        // we try max. four times, if not then not.
        // plGangsters contain either player number 0..3 or 99. if 99 the gangster at that
        // position is available. means also that we cannot have gangster 0, 7, 15 and 23.
        g := 99;
        for k := 0 to 4 do 
        begin; 
            r := Random(42);
            if r > 31 then break;
            if plGangsters[r] = 99 then begin;
                g := r;
                break;
            end;
        end; 

        if g = 99 then 
        begin; 
            CRT_Writeln(loc_string_18);
            waitForKey();
            exit;
        end;

        // load gangster 
        loadGangster(g);
        CRT_NewLine;
        CRT_Write(loc_string_39);
        CRT_Write(buf_gangsterPrice);
        CRT_Write(loc_string_40);
        CRT_Write(buf_gangsterAnrede);
        CRT_Writeln2(loc_string_41);
        if getYesNo() =0 then exit;
        if payMoney (buf_gangsterPrice) = 0 then exit;
        plGangsters[g] := currentPlayer;
        z := plNGangsters[currentPlayer];
        plNGangsters[currentPlayer] := z + 1;
        gangsterHealth[g] := 10;
        gangsterNames[g] := buf_gangsterName;
        gangsterStr[g] := buf_gangsterStr;
        gangsterBrut[g] := buf_gangsterBrut;
        gangsterInt[g] := buf_gangsterInt;
        gangsterWeapon[g] := buf_gangsterWeapon;
        gangsterSex[g] := buf_gangsterSex;

        CRT_Write(loc_string_19);
        CRT_Write(' '~);
        CRT_Write(plNGangsters[currentPlayer]-1);
        CRT_Writeln(loc_string_20);
        waitForKey();
    end;

    // 'Hast du vielleicht '~+#$07+'n guten Tip fuer    '~+#$07+'nen ueberfall oder sowas?'~,
    if currentChoice = 3 then
    begin;
        {$ifndef norank}
        if plRank[currentPlayer] < 4 then 
        begin;
            CRT_Writeln(loc_string_21);
            waitForKey();
            exit;
        end; 
        {$endif}

        if Random(3) = 0 then begin; 
            CRT_Writeln(loc_string_22);
            waitForKey();
            exit;
        end;

        p := Random(4)*500 + 1000;
        CRT_Writeln(loc_string_23);
        CRT_Write(loc_string_24);
        CRT_Write(p);
        CRT_Writeln(loc_string_25);
        if getYesNo() =0 then exit;
        if payMoney (p) = 0 then exit;
        
        CRT_NewLine;
        tipp := Random(5);
        case tipp of
            0: begin; //postzug
                    CRT_Writeln(loc_string_26);
                    CRT_Writeln(loc_string_27);
                end;
            1: begin; //bank
                    CRT_Writeln(loc_string_28);
                    CRT_Writeln(loc_string_29);
                end;
            2: begin; //cashtransporter
                    CRT_Writeln(loc_string_30);
                    CRT_Writeln(loc_string_31);
                    CRT_Writeln(loc_string_32);
                end;
            3: begin; //weaponsmuggle
                    CRT_Writeln(loc_string_33);
                    CRT_Writeln(loc_string_34);
                    if getYesNo() =0 then exit;
                    if payMoney (p) = 0 then exit;
                    CRT_Writeln(loc_string_35);
                end;
            4: begin; //major
                    CRT_Writeln(loc_string_36);
                    CRT_Writeln(loc_string_37);
                    CRT_Writeln(loc_string_38);
                end; 
        end; 
        plOpportunity[currentPlayer] := plOpportunity[currentPlayer] or (1 SHL tipp);
        waitForKey();
        exit;
    end;


    // 'Ich brauche dringend einen Job, einen   Auftrag! Du verstehst schon...'~,
    if currentChoice = 4 then
    begin;
        // need to reload location text
        loadLocation(PUB2_);
        {$ifndef norank}
        if plRank[currentPlayer] > 3 then
        begin;
            CRT_Write (loc_string_1);
            CRT_Write (rankNames[plRank[currentPlayer]]);
            CRT_Writeln (loc_string_2);
            waitForKey();
            exit;
        end;
        {$endif}

        if Random(5) = 0 then
        begin
            CRT_Writeln(loc_string_3);
            waitForKey();
            exit;
        end;

        // jobs
        case Random(4) of 
            0:
                 begin
                     CRT_Writeln(loc_string_4);
                     CRT_Writeln(loc_string_5);
                     CRT_Writeln(loc_string_6);
                     joblocation := PUB_;
                     duration := 3;
                     wage := Random(2)*1000 + 2000;
                 end;
            1:
                 begin
                     CRT_Writeln(loc_string_7);
                     CRT_Writeln(loc_string_8);
                     duration := 2;
                     wage := Random(3)*500 + 1000;
                     joblocation := GAMBLING_;
                 end;
            2:
                 begin
                     CRT_Writeln(loc_string_9);
                     CRT_Writeln(loc_string_10);
                     duration := 2;
                     wage := Random(3)*500 + 2000;
                     joblocation := HIDEOUT_;
                 end;
            3:
                 begin
                     CRT_Writeln(loc_string_11);
                     CRT_Writeln(loc_string_12);
                     CRT_Writeln(loc_string_13);
                     duration := 1;
                     wage := Random(2)*500 + 2000;
                     joblocation := STREET_;
                 end;
        end;

        CRT_NewLine();
        CRT_Write(loc_string_14);
        CRT_Write(wage);
        CRT_Writeln2('$.'~);
        CRT_Writeln(loc_string_15);
        if getYesNo() =1 then
        begin
            CRT_NewLine();
            CRT_Writeln(loc_string_16);
            waitForKey();

            plJob[currentPlayer] := duration;
            plJobWage[currentPlayer] := wage;
            plJobLocation[currentPlayer] := joblocation;
            result := END_TURN_;
        end;
    end;
end ;
