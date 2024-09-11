
function majorChoices:   byte;
var k:   byte;
begin;
    loadLocation(MAJOR_);
    ShowLocationHeader;
    
    CRT_Writeln_LocStr(6);
    CRT_Writeln_LocStr(7);
    waitForKey;

    plOpportunity[currentPlayer] := plOpportunity[currentPlayer] and (255 - 1 SHL 4);
        
    // first escorte
        asm; 
            lda loc_string_8
            sta adr.FP_GANG+$02
            lda loc_string_8+1
            sta adr.FP_GANG+1+$02
        end;
    // fp_gang[1] := loc_string_3;
    fp_AI[1] := 1;
    fp_N[1] := 5;
    // for k := 0 to fp_N[1] -1 do 
    // begin;
    //     fp_name[16+k] := loc_string_3;
    //     fp_energy[16+k] := 20;
    //     fp_weapon[16+k] := 7;
    // end;
    asm
        ldy #$00
    @:
        tya 
        asl 
        tay

        lda loc_string_12
        sta adr.FP_NAME+$20,y
        lda loc_string_12+1
        sta adr.FP_NAME+1+$20,y

        tya
        lsr 
        tay

        lda #20
        sta adr.FP_ENERGY+$10,y
        lda #07
        sta adr.FP_WEAPON+$10,y
        iny
        cpy adr.FP_N+$01
        bne @- 
    end; 

    if doFight() = 1 then
    begin;
        gotCaught();
        result := END_TURN_;
        exit;
    end;

    asm; 
        lda loc_string_9
        sta adr.FP_GANG+$02
        lda loc_string_9+1
        sta adr.FP_GANG+1+$02
    end;

    // fp_gang[1] := loc_string_4;
    fp_AI[1] := 1;
    fp_N[1] := 1;
    fp_name[16] := loc_string_9;
    fp_energy[16] := 30;
    fp_weapon[16] := 1;
    tmp := Random(2);
    fp_sex[16] := tmp;


    if doFight() = 1 then
    begin;
        gotCaught();
        result := END_TURN_;
        exit;
    end;

    ShowLocationHeader;
    CRT_Writeln_LocStr(10);
    CRT_Writeln_LocStr(11);
    waitForKey;
    addMoney(7000); 
    // no points in original, here we add 4
    addPoints(4);
    plKilledMajor[currentPlayer] := 1;
    plForgedID[currentPlayer] := 1;
end;

