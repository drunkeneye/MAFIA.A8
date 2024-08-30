 
function moneyTransporterChoices:   byte;
begin;
    loadLocation(MONEYTRANSPORT_);
    ShowLocationHeader;

    if plNGangsters[currentPlayer] < 3 then 
    begin 
        CRT_Writeln_LocStr(1);
        waitForKey();
        plOpportunity[currentPlayer] := plOpportunity[currentPlayer] and (255 - 1 SHL 2);
        loadMap(); //reload map to remove transporter
        exit;
    end;

    CRT_Writeln_LocStr(2);
    CRT_Writeln_LocStr(3);
    waitForKey;
        

    asm; 
        lda loc_string_4
        sta adr.FP_GANG+$02
        lda loc_string_4+1
        sta adr.FP_GANG+1+$02
    end;
    // fp_gang[1] := loc_string_4;
    fp_AI[1] := 1;
    fp_N[1] := 10;

    asm
        ldy #$00
    @:
        tya 
        asl 
        tay

        lda loc_string_5
        sta adr.FP_NAME+$20,y
        lda loc_string_5+1
        sta adr.FP_NAME+1+$20,y

        tya
        lsr 
        tay

        lda #50
        sta adr.FP_ENERGY+$10,y
        lda #07
        sta adr.FP_WEAPON+$10,y
        iny
        cpy adr.FP_N+$01
        bne @- 
    end; 
    // // FIXME: names missing
    // for k := 0 to fp_N[1] -1 do 
    // begin;
    //     fp_name[16+k] := loc_string_5;
    //     fp_energy[16+k] := 50;
    //     fp_weapon[16+k] := 7;
    // end;

    plOpportunity[currentPlayer] := plOpportunity[currentPlayer] and (255 - 1 SHL 2);
    if doFight() = 1 then
    begin;
        gotCaught();
        result := END_TURN_;
        exit;
    end;
    plMoneyTransporter[currentPlayer] := 1;
    crackedBank(10000); // a bit more
end;
