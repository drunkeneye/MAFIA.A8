
function storeChoices:   byte;
var r:   byte;
    k: byte;
    p, q: word;
begin;
    ShowLocationHeader;
    result := STORE_;

	{$ifndef norank}
    // any choice needs a rank
    if plRank[currentPlayer] < 2 then 
    begin;
        CRT_Writeln_LocStr(1);
        waitForKey();
        exit;
    end;
    {$endif}

    // check if tried it twice
    // FIXME 
    if lastLocation = STORE_ then
    begin
        result := fightPolice();
        exit;
    end;


    if currentChoice = 1 then
    begin;
        tmp := currentPlayer SHR 3;
        if (gangsterBrut[tmp] < 30) or (currentSubLocation = 1) then begin;
            CRT_Writeln_LocStr(2);
            CRT_NewLine;
            CRT_Writeln_LocStr(3);
            waitForKey();
            result := fightPolice();
            exit;
        end; 
    end;


    if currentChoice = 2 then
    begin;
        if (currentSubLocation = 4) or (currentSubLocation = 3) then begin;
            CRT_Writeln_LocStr(4);
            waitForKey();
            exit;
        end;
    end;


    if currentChoice = 3 then begin;
        if (currentSubLocation = 2) or (currentSubLocation = 1) then begin;
            CRT_Writeln_LocStr(5);
            CRT_Writeln_LocStr(6);
            waitForKey();
            // fp_gang[1] := loc_string_35;
            asm; 
                lda loc_string_35
                sta adr.FP_GANG+$02
                lda loc_string_35+1
                sta adr.FP_GANG+1+$02
            end;

            fp_AI[1] := 1;
            fp_N[1] := 3+byte(plRank[currentPlayer] > 5) SHL 1;
            for k := 0 to fp_N[1] -1 do 
                fp_sex[k] := Random(2);
            // for k := 0 to fp_N[1] -1 do 
            // begin;
            //     fp_name[16+k] := loc_string_36;
            //     fp_weapon[16+k] := 7;
            //     fp_energy[16+k] := 30;
            // end;

            asm
                ldy #$00
            @:
                tya 
                asl 
                tay

                lda loc_string_36
                sta adr.FP_NAME+$20,y
                lda loc_string_36+1
                sta adr.FP_NAME+1+$20,y

                tya
                lsr 
                tay

                lda #30
                sta adr.FP_ENERGY+$10,y
                lda #07
                sta adr.FP_WEAPON+$10,y
                iny
                cpy adr.FP_N+$01
                bne @- 
            end; 

            if doFight() = 1 then
            begin
                result := END_TURN_;
                exit;
            end;
            ShowLocationHeader;
            CRT_Writeln_LocStr(7);
            CRT_Writeln_LocStr(8);
            waitForKey;
        end;
    end;


    if currentChoice = 4 then begin;
        tmp := currentPlayer SHL 3;
        if (currentSubLocation = 3) or (gangsterInt[tmp] < 30) then begin;
            CRT_Writeln_LocStr(9);
            CRT_Writeln_LocStr(10);
            waitForKey;
            exit;
        end;
    end;
 
    // common to all: 
    ShowLocationHeader;
    addPoints(1);
     p := Random(200) + 800;
    if (currentSubLocation = 2) or (currentSubLocation = 3) then 
        p := p - 200;
    if currentChoice = 2 then p := p + 600;

    if currentChoice = 1 then begin
        CRT_Writeln_LocStr(11);
        CRT_Write_LocStr(12);
        CRT_Write(p);
        CRT_Writeln('$!'~);
    end; 

    if currentChoice =2 then begin 
        CRT_Writeln_LocStr(13);
        CRT_Write(p);
        CRT_Writeln('$!'~);
        // TODO: here do not clear sublocation, so doing it twice, the store will understand that you are fraud
    end;        

    if currentChoice = 3 then begin 
        CRT_Write_LocStr(14);
        CRT_Write(p);
        CRT_Writeln_LocStr(15);
    end;

    if currentChoice = 4 then begin 
        CRT_Writeln_LocStr(16);
        CRT_Write_LocStr(17);
        CRT_Write(p);
        CRT_Writeln('$!'~);
    end; 


    CRT_Newline;
    CRT_Writeln2_LocStr(18);
    CRT_Writeln_LocStr(19);
    CRT_Writeln_LocStr(20);
    CRT_Writeln2_LocStr(21);
    CRT_Write_LocStr(22);
    r := readValue(1, 3);
    CRT_NewLine;
    CRT_NewLine;


    if r = 1 then begin;
        addMoney(p);
        CRT_Writeln_LocStr(23);
        waitForKey();
        exit; 
    end; 

    if r = 2 then begin; 
        if (currentSubLocation = 0) or (currentSubLocation = 2) then begin;
            CRT_Writeln_LocStr(24);
            CRT_Writeln_LocStr(25);
            waitForKey();
            // fp_gang[1] := loc_string_26;
            asm; 
                lda loc_string_26
                sta adr.FP_GANG+$02
                lda loc_string_26+1
                sta adr.FP_GANG+1+$02
            end;

            fp_AI[1] := 1;
            fp_N[1] := 5;

            asm
                ldy #$00
            @:
                tya 
                asl 
                tay

                lda loc_string_37
                sta adr.FP_NAME+$20,y
                lda loc_string_37+1
                sta adr.FP_NAME+1+$20,y

                tya
                lsr 
                tay

                lda #30
                sta adr.FP_ENERGY+$10,y
                lda #03
                sta adr.FP_WEAPON+$10,y
                iny
                cpy adr.FP_N+$01
                bne @- 
            end; 
            // for k := 0 to fp_N[1] -1 do 
            // begin
            //     fp_name[16+k] := loc_string_26;
            //     fp_weapon[16+k] := 3;
            //     fp_energy[16+k] := 30;
            // end;

            if doFight() = 1 then
            begin
                result := END_TURN_;
                exit;
            end;
            addMoney(p);
          end
        else
        begin
            q := Random(200) + 300;
            CRT_Writeln_LocStr(27);
            CRT_Writeln_LocStr(28);
            CRT_Write(q);
            CRT_Writeln('$.'~);
            addMoney(p);
            addMoney(q);
            addPoints(1);
            waitForKey();
            exit;
        end;
    end;

    if r = 3 then begin
        if (currentSubLocation = 3) or (currentSubLocation = 4) then 
        begin; 
            CRT_Writeln_LocStr(29);
            CRT_Writeln_LocStr(30);
            // fp_gang[1] :=loc_string_31;
            asm; 
                lda loc_string_31
                sta adr.FP_GANG+$02
                lda loc_string_31+1
                sta adr.FP_GANG+1+$02
            end;
            fp_AI[1] := 1;
            fp_N[1] := 1;
            fp_name[16] := loc_string_31;
            fp_weapon[16] := 6;
            fp_energy[16] := 30;

            if doFight() = 1 then
            begin;
                result := END_TURN_;
                exit;
            end;
            addMoney(p);
        end
        else 
        begin
            q := Random(100);
            q := q SHL 1 + 150;
            CRT_Writeln_LocStr(32);
            CRT_Write_LocStr(33);
            CRT_Write(q);
            CRT_Write_LocStr(34);
            addMoney(p);
            addMoney(q);
            waitForKey();
        end; 
    end;
 end; 


 

