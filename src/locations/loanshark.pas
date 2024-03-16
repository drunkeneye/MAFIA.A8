function loanSharkChoices(var choice: byte): byte;
var 
    r, k: byte;
    allPaid: byte;
    loan: smallint;
    p: word;
    LN: byte;

begin
    result := LOANSHARK_;
    ShowLocationHeader;

    if choice = 1 then
    begin
        if plLoan[currentPlayer] > 0 then
        begin
            CRT_Write(loc_string_1);
            CRT_ReadChar();
            exit;
        end;

        if plLoanShark[currentPlayer] <> 99 then
        begin;
            CRT_Writeln(loc_string_37);
            CRT_Writeln(loc_string_38);
            waitForKey;
            exit;
        end; 
        
        CRT_Write(loc_string_2);
        CRT_Newline();
        CRT_Write(loc_string_3);
        loan := readValue(0, 5000);
        if loan = 0 then 
            exit;

        CRT_NewLine();
        CRT_NewLine();
        CRT_Writeln(loc_string_4);
        CRT_Writeln(loc_string_5);
        plLoan[currentPlayer] := loan + Round(loan SHR 4);
        plLoanTime[currentPlayer] := 6+Random(4);
        addMoney(loan);
        waitForKey();
        exit;
    end;

    if choice = 2 then
    begin
        if plLoan[currentPlayer] = 0 then
        begin
            CRT_Writeln(loc_string_6);
            waitForKey();
            exit;
        end;

        CRT_Writeln(loc_string_7);
        CRT_Write('(0-'~);
        CRT_Write(plLoan[currentPlayer]);
        CRT_Write('$)? '~);
        loan := readValue(0, plLoan[currentPlayer]);
        if loan = 0 then 
            exit;

        if payMoney(loan) = 0 then exit;
        plLoan[currentPlayer] := plLoan[currentPlayer] - loan;
        if plLoan[currentPlayer] = 0 then
        begin
            CRT_NewLine();
            CRT_NewLine();
            plLoanTime[currentPlayer] := 0;
            CRT_Writeln(loc_string_8);
        end
        else
        begin
            CRT_NewLine();
            CRT_NewLine();
            CRT_Write(loc_string_9);
            CRT_Write(plLoan[currentPlayer]);
            CRT_Write('$ '~);
            CRT_Write(loc_string_10);
        end;
        waitForKey();
    end;

    // Laden aufkaufen bzw. verkaufen
    if choice = 3 then
    begin
        // cannot buy the place with loan 
        if plLoan[currentPlayer] <> 0 then begin
            CRT_Writeln(loc_string_21);
            waitForKey;
            exit;
        end;

        if plLoanShark[currentPlayer] = currentSubLocation then
        begin
            // owned by player, want to sell this
            p := Random(11)*100+4500;
            CRT_Write(loc_string_22);
            CRT_Write(p);
            CRT_Writeln(loc_string_23);
            CRT_Writeln(loc_string_24);
            if getYesNo() =0 then exit;
            addMoney(p);
            plLoanShark[currentPlayer] := 99;
            CRT_NewLine;
            CRT_Writeln(loc_string_25);
            waitForKey();
            exit;
        end
        else
        begin
           if plLoanShark[currentPlayer] <> 99 then
            begin
                CRT_Write(loc_string_11); //Du hast schon ein Kreditgeschaeft!
                waitForKey();
                exit;
            end;
            for r := 0 to 3 do 
            begin
                if plLoanShark[r] = currentSubLocation then begin;
                    CRT_Write(loc_string_26);
                    k := r SHL 3;
                    CRT_Write(gangsterNames[k]);
                    CRT_Writeln('!!'~);
                    waitForKey;
                    exit;
                end;
            end;

            // want to buy this
            p := Random(11)*100+5000;
            CRT_Write(loc_string_27);
            CRT_Write(p);
            CRT_Writeln(loc_string_28);
            CRT_Writeln(loc_string_29);
            if getYesNo() =0 then exit;
            if payMoney(p) =0 then exit;
            plLoanShark[currentPlayer] := currentSubLocation;
            CRT_NewLine;
            CRT_Writeln(loc_string_30);
            waitForKey();
        end;
    end;


    if choice = 4 then
    begin
        if plLoanShark[currentPlayer] <> currentSubLocation then
        begin
            CRT_Write(loc_string_12);
            waitForKey();
            exit;
        end;
        CRT_Write(loc_string_31);
        CRT_Write(plLoanInvest[currentPlayer]);
        CRT_Writeln(loc_string_32);
        CRT_Writeln(loc_string_33);
        CRT_Write(loc_string_34);

        loan := readValue(-plLoanInvest[currentPlayer], 5000-plLoanInvest[currentPlayer]);
        if loan = 0 then exit;
        if payMoney(loan) = 0  then exit;
        plLoanInvest[currentPlayer] := plLoanInvest[currentPlayer] + loan; 
        CRT_NewLine;
        CRT_Write(loc_string_35);
        CRT_Write(plLoanInvest[currentPlayer]);
        CRT_Write('$ '~);
        CRT_Writeln(loc_string_36);
        waitForKey;
    end;

    if choice = 5 then
    begin
        if plLoanShark[currentPlayer] <> currentSubLocation then
        begin
            CRT_Write(loc_string_12);
            waitForKey();
            exit;
        end;

        // random if all paid well
        allPaid := 0;
        if (Random(3) > 0) and (plLoanInvest[currentPlayer] > 0) then allPaid := 1;
        if allPaid = 0 then
        begin
            CRT_Write(loc_string_13);
            waitForKey();
            exit;
        end;

        CRT_Writeln(loc_string_14);
        CRT_Writeln(loc_string_15);
        CRT_Writeln(loc_string_16);
        waitForKey();

        asm; 
            lda loc_string_17
            sta adr.FP_GANG+$02
            lda loc_string_17+1
            sta adr.FP_GANG+1+$02
        end;
        fp_AI[1] := 1;
        fp_N[1] := 1;
        fp_name[16] := loc_string_17;
        fp_weapon[16] := 6;
        fp_sex[16] := Random(2);
        fp_energy[16] := 35;

        // lost, so we ignore this simply;
        if doFight() = 1 then begin
            removePoints(1); 
            exit;
        end;

        loan := 500 + Random(0) SHL 2;
        CRT_NewLine();
        //loan := 500;
        // p=int(rnd(1)*1000)+500:pokera+1,11
        ShowLocationHeader;
        CRT_Writeln(loc_string_18);
        CRT_Write(loc_string_19);
        CRT_Write(loan);
        CRT_Write(loc_string_20);
        waitForKey();
        addPoints(2);
        addMoney(loan);
    end;
end;
