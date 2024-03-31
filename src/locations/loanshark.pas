function loanSharkChoices: byte;
var 
    r, k: byte;
    allPaid: byte;
    loan: smallint;
    p: word;
begin
    result := LOANSHARK_;
    ShowLocationHeader;

    if currentChoice = 1 then
    begin
        if plLoan[currentPlayer] > 0 then
        begin
            CRT_Write_LocStr(1);
            CRT_ReadChar();
            exit;
        end;

        if plLoanShark[currentPlayer] <> 99 then
        begin;
            CRT_Writeln_LocStr(37);
            CRT_Writeln_LocStr(38);
            waitForKey;
            exit;
        end; 
        
        CRT_Write_LocStr(2);
        CRT_Newline();
        CRT_Write_LocStr(3);
        loan := readValue(0, 5000);
        if loan = 0 then 
            exit;

        CRT_NewLine();
        CRT_NewLine();
        CRT_Writeln_LocStr(4);
        CRT_Writeln_LocStr(5);
        plLoan[currentPlayer] := loan + Round(loan SHR 4);
        plLoanTime[currentPlayer] := 6+Random(4);
        addMoney(loan);
        waitForKey();
        exit;
    end;

    if currentChoice = 2 then
    begin
        if plLoan[currentPlayer] = 0 then
        begin
            CRT_Writeln_LocStr(6);
            waitForKey();
            exit;
        end;

        CRT_Writeln_LocStr(7);
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
            CRT_Writeln_LocStr(8);
        end
        else
        begin
            CRT_NewLine();
            CRT_NewLine();
            CRT_Write_LocStr(9);
            CRT_Write(plLoan[currentPlayer]);
            CRT_Write('$ '~);
            CRT_Write_LocStr(10);
        end;
        waitForKey();
    end;

    // Laden aufkaufen bzw. verkaufen
    if currentChoice = 3 then
    begin
        // cannot buy the place with loan 
        if plLoan[currentPlayer] <> 0 then begin
            CRT_Writeln_LocStr(21);
            waitForKey;
            exit;
        end;

        if plLoanShark[currentPlayer] = currentSubLocation then
        begin
            // owned by player, want to sell this
            p := Random(11)*100+4500;
            CRT_Write_LocStr(22);
            CRT_Write(p);
            CRT_Writeln_LocStr(23);
            CRT_Writeln_LocStr(24);
            if getYesNo() =0 then exit;
            addMoney(p);
            plLoanShark[currentPlayer] := 99;
            CRT_NewLine;
            CRT_Writeln_LocStr(25);
            waitForKey();
            exit;
        end
        else
        begin
           if plLoanShark[currentPlayer] <> 99 then
            begin
                CRT_Write_LocStr(11); //Du hast schon ein Kreditgeschaeft!
                waitForKey();
                exit;
            end;
            for r := 0 to 3 do 
            begin
                if plLoanShark[r] = currentSubLocation then begin;
                    CRT_Write_LocStr(26);
                    k := r SHL 3;
                    CRT_Write(gangsterNames[k]);
                    CRT_Writeln('!!'~);
                    waitForKey;
                    exit;
                end;
            end;

            // want to buy this
            p := Random(11)*100+5000;
            CRT_Write_LocStr(27);
            CRT_Write(p);
            CRT_Writeln_LocStr(28);
            CRT_Writeln_LocStr(29);
            if getYesNo() =0 then exit;
            if payMoney(p) =0 then exit;
            plLoanShark[currentPlayer] := currentSubLocation;
            CRT_NewLine;
            CRT_Writeln_LocStr(30);
            waitForKey();
        end;
    end;


    if currentChoice = 4 then
    begin
        if plLoanShark[currentPlayer] <> currentSubLocation then
        begin
            CRT_Write_LocStr(12);
            waitForKey();
            exit;
        end;
        CRT_Write_LocStr(31);
        CRT_Write(plLoanInvest[currentPlayer]);
        CRT_Writeln_LocStr(32);
        CRT_Writeln_LocStr(33);
        CRT_Write_LocStr(34);

        loan := readValue(-plLoanInvest[currentPlayer], 5000-plLoanInvest[currentPlayer]);
        if loan = 0 then exit;
        if payMoney(loan) = 0  then exit;
        plLoanInvest[currentPlayer] := plLoanInvest[currentPlayer] + loan; 
        CRT_NewLine;
        CRT_Write_LocStr(35);
        CRT_Write(plLoanInvest[currentPlayer]);
        CRT_Write('$ '~);
        CRT_Writeln_LocStr(36);
        waitForKey;
    end;

    if currentChoice = 5 then
    begin
        if plLoanShark[currentPlayer] <> currentSubLocation then
        begin
            CRT_Write_LocStr(12);
            waitForKey();
            exit;
        end;

        // random if all paid well
        allPaid := 0;
        if (Random(3) > 0) and (plLoanInvest[currentPlayer] > 0) then allPaid := 1;
        if allPaid = 0 then
        begin
            CRT_Write_LocStr(13);
            waitForKey();
            exit;
        end;

        CRT_Writeln_LocStr(14);
        CRT_Writeln_LocStr(15);
        CRT_Writeln_LocStr(16);
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
        CRT_Writeln_LocStr(18);
        CRT_Write_LocStr(19);
        CRT_Write(loan);
        CRT_Write_LocStr(20);
        waitForKey();
        addPoints(2);
        addMoney(loan);
    end;
end;
