function centralStationChoices:  byte;
var r:   byte;
    k: byte;
    outcome:   byte;
begin;
    result := CENTRALSTATION_;
    if currentChoice = 1 then
    begin;
        loadLocation(PUB_);
        currentChoice := ShowLocation(PUB_);
        if currentChoice = loc_nOptions then
        begin
            currentLocation := NONE_;
            exit;
        end;
        result := pubChoices;
        exit;
    end;

    if currentChoice = 2 then
    begin;
        loadLocation(SUBWAY_);
        currentChoice := 1;
        result := subwayChoices;
        exit;
    end;

    if currentChoice = 3 then 
    begin 
        ShowLocationHeader();
        if plOpportunity[currentPlayer] and 1 = 0 then // lowerst bit = postzug
        begin 
            CRT_Writeln_LocStr(1);
            waitForKey;
            exit; 
        end;

        plOpportunity[currentPlayer] := plOpportunity[currentPlayer] and (255- 1);
        
        if plNGangsters[currentPlayer] < 3 then begin 
            CRT_Writeln_LocStr(2);
            waitForKey();
            exit;
        end; 

        CRT_Writeln_LocStr(3);
        CRT_Writeln_LocStr(4);
        CRT_Writeln_LocStr(5);
        waitForKey;
        
        asm; 
            lda loc_string_7
            sta adr.FP_GANG+$02
            lda loc_string_7+1
            sta adr.FP_GANG+1+$02
        end;

        // fp_gang[1] := loc_string_7;
        fp_AI[1] := 1;
        fp_N[1] := 3;

        asm
            ldy #$00
        @:
            tya 
            asl 
            tay

            lda loc_string_8
            sta adr.FP_NAME+$20,y
            lda loc_string_8+1
            sta adr.FP_NAME+1+$20,y

            tya
            lsr 
            tay

            lda #30
            sta adr.FP_ENERGY+$10,y
            lda #7
            sta adr.FP_WEAPON+$10,y
            iny
            cpy adr.FP_N+$01
            bne @- 
        end;         
        // for k := 0 to fp_N[1] -1 do 
        // begin;
        //     fp_name[16+k] := loc_string_8;
        //     fp_energy[16+k] := 30;
        //     fp_weapon[16+k] := 7;
        // end;

        if doFight() = 1 then
        begin;
            gotCaught();
            result := END_TURN_;
            exit;
        end;
        crackedBank(5000);
    end;

end;
