
function storeChoices (var choice:byte):   byte;
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
        CRT_Writeln(loc_string_1);
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


    if choice = 1 then
    begin;
        if (gangsterBrut[currentPlayer SHL 3] < 30) or (currentSubLocation = 1) then begin;
            CRT_Writeln(loc_string_2);
            CRT_NewLine;
            CRT_Writeln(loc_string_3);
            waitForKey();
            result := fightPolice();
            exit;
        end; 
    end;


    if choice = 2 then
    begin;
        if (currentSubLocation = 4) or (currentSubLocation = 3) then begin;
            CRT_Writeln(loc_string_4);
            exit;
        end;
    end;


    if choice = 3 then begin;
        if (currentSubLocation = 2) or (currentSubLocation = 1) then begin;
            CRT_Writeln(loc_string_5);
            CRT_Writeln(loc_string_6);
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
            CRT_Writeln(loc_string_7);
            CRT_Writeln(loc_string_8);
            waitForKey;
        end;
    end;


    if choice = 4 then begin;
        if (currentSubLocation = 3) or (gangsterInt[currentPlayer SHL 3] < 30) then begin;
            CRT_Writeln(loc_string_9);
            CRT_Writeln(loc_string_10);
            waitForKey;
            exit;
        end;
    end;
 
    // common to all: 
    addPoints(1);
     p := Random(200) + 800;
    if (currentSubLocation = 2) or (currentSubLocation = 3) then 
        p := p - 200;
    if choice = 2 then p := p + 600;

    if choice = 1 then begin
        CRT_Writeln(loc_string_11);
        CRT_Write(loc_string_12);
        CRT_Write(p);
        CRT_Writeln('$!'~);
    end; 

    if choice =2 then begin 
        CRT_Writeln(loc_string_13);
        CRT_Write(p);
        CRT_Writeln('$!'~);
        // TODO: here do not clear sublocation, so doing it twice, the store will understand that you are fraud
    end;        

    if choice = 3 then begin 
        CRT_Write(loc_string_14);
        CRT_Write(p);
        CRT_Writeln(loc_string_15);
    end;

    if choice = 4 then begin 
        CRT_Writeln(loc_string_16);
        CRT_Write(loc_string_17);
        CRT_Write(p);
        CRT_Writeln('$!'~);
    end; 


    CRT_Newline;
    CRT_Writeln2(loc_string_18);
    CRT_Writeln(loc_string_19);
    CRT_Writeln(loc_string_20);
    CRT_Writeln2(loc_string_21);
    CRT_Write(loc_string_22);
    r := readValue(1, 3);
    CRT_NewLine;
    CRT_NewLine;


    if r = 1 then begin;
        addMoney(p);
        CRT_Writeln(loc_string_23);
        waitForKey();
        exit; 
    end; 

    if r = 2 then begin; 
        if (currentSubLocation = 0) or (currentSubLocation = 2) then begin;
            CRT_Writeln(loc_string_24);
            CRT_Writeln(loc_string_25);
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

                lda loc_string_26
                sta adr.FP_NAME+$20,y
                lda loc_string_26+1
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
            CRT_Writeln(loc_string_27);
            CRT_Writeln(loc_string_28);
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
            CRT_Writeln(loc_string_29);
            CRT_Writeln(loc_String_30);
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
            fp_weapon[16] := 7;
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
            q := Random(100) SHL 1 + 150;
            CRT_Writeln(loc_string_32);
            CRT_Write(loc_string_33);
            CRT_Write(q);
            CRT_Write(loc_string_34);
            addMoney(p);
            addMoney(q);
            waitForKey();
        end; 
    end;
 end; 


 

