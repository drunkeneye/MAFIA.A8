
 

var
    safeclmfname:   TString =   'SAFECBMPAPL';

    
function bankChoices: byte;
var k: byte;
    nAttempts: byte;
    t, c:array[0..2] of shortint; // true code
    ch: char;
    safeOpen: byte;
    base:word;
    whpos: byte;
    hops: boolean;
begin;
    tmpOpportunity := plOpportunity[currentPlayer] and 2;
    // clear it, whatever happens, the opportunity is gone
    plOpportunity[currentPlayer]:= plOpportunity[currentPlayer] and (255- 2);

    result := BANK_;
    loadLocation(BANK_);
    ShowLocationHeader;
    {$ifndef norank}
    if plRank[currentPlayer] < 1 then
    begin
        CRT_Write_LocStr(13);
        waitForKey();
        exit;
    end;
    {$endif}

    // check if tried it twice
    // FIXME 
    if lastLocation = BANK_ then
    begin
        prepareFightAgainstPolice;
        if doFight() = 1 then
        begin;
            gotCaught();
            result := END_TURN_;
            exit;
        end;
        exit;
    end;

    if plNGangsters[currentPlayer] < 2 then
    begin
        CRT_WriteCentered_LocStr(6, 1);
        waitForKey();
        lastLocation := NONE_;
        exit;
    end;


    if currentChoice = 1 then
    begin
        if Random(3) = 0 then
        begin
            CRT_Writeln_LocStr(2);
            CRT_Writeln_LocStr(3);
            waitForKey();
            // TODO: depends on sublocation

            asm; 
                lda loc_string_4
                sta adr.FP_GANG+$02
                lda loc_string_4+1
                sta adr.FP_GANG+1+$02
            end;

            fp_AI[1] := 1;
            fp_N[1] := 3;
            if currentMap = 1 then 
                fp_N[1] := fp_N[1] + 1;
            // for k := 0 to fp_N[1] -1 do 
            // begin;
            //     fp_name[16+k] := loc_string_4;
            //     fp_energy[16+k] := 30;
            //     fp_weapon[16+k] := 6;
            // end;
            asm
                ldy #$00
            @:
                tya 
                asl 
                tay

                lda loc_string_4
                sta adr.FP_NAME+$20,y
                lda loc_string_4+1
                sta adr.FP_NAME+1+$20,y

                tya
                lsr 
                tay

                lda #$1E
                sta adr.FP_ENERGY+$10,y
                lda #$06
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
        end;
        crackedBank (BANK_); //15=this location
    end;


    if currentChoice = 2 then
    begin;
        ShowLocationHeader;
        k := currentPlayer SHL 3;
        if (gangsterBrut[k] < 25) or (gangsterStr[k] < 25)  or (gangsterInt[k] < 40) then 
            begin;
                CRT_WriteCentered_LocStr(6, 5);
                waitForKey();
                exit;
            end; 
        
        CRT_Writeln_LocStr(6);
        showWeapons := 0;
        selectGangster();
        if currentGangster = 99 then exit;

        ShowLocationHeader;
        CRT_Writeln_LocStr(7);
        CRT_Writeln_LocStr(8);
        CRT_Newline;

        //CRT_Writeln('Nutze ...'~);
        nAttempts := 13 + gangsterInt[currentPlayer SHL 3] SHR 4 + currentSubLocation SHL 1;
        if plStuff[currentPlayer] and 32 > 0 then 
        begin;
            nAttempts := nAttempts + 9;
            plStuff[currentPlayer]  := plStuff[currentPlayer] AND (255-32);
        end;

        waitForKey();

        // show safe
        blackConsole();
        FillChar(Pointer(MAP_SCR_ADDRESS), 40*24, 0);
        loadxAPL (safeclmfname, Pointer(MAP_FNT_ADDRESS));
        FillChar(Pointer(MAP_SCR_ADDRESS+17*40), 80, 0); // remove number chars
        enableMapConsole();
        mapColorA := $04;
        mapColorB := $0a;
        didFight := 1; // remember to reload map
        t[0] := Random(10);
        t[1] := Random(10);
        t[2] := Random(10);
        c[0] := Random(10);
        c[1] := Random(10);
        c[2] := Random(10);

        safeOpen := 0; 
        whpos := 0;
        base := MAP_SCR_ADDRESS+6*40+16; 
        repeat;
            // the two 'handles' $70=pos of 0
            Poke(base+whpos SHL 1, $70-2);
            Poke(base+whpos SHL 1+2, $70-1);
            for k := 0 to 2 do 
                Poke(base+1+k+k, $70+c[k]);
            repeat;
                ch := checkKeyAndStick ();
            until (ch = #15) or (ch = #14) or (ch = #07) or (ch = #06) or (ch = #$2f);
            waitForKeyRelease();
            WaitFrames(5);
            case ch of
                #15: c[whpos] := c[whpos] - 1; 
                #14: c[whpos] := c[whpos] + 1;
            end; 

            if (ch = #07) or (ch = #06) then 
            begin;
                Poke(base+whpos SHL 1, 0);
                Poke(base+whpos SHL 1+2, 0);
                if ch = #07 then
                begin;
                    if whpos < 2 then whpos := whpos + 1; 
                end;
                if ch = #06 then
                begin;
                    if whpos > 0 then whpos := whpos - 1;
                end;
            end;

            hops := Random(gangsterInt[currentPlayer SHL 3]) < 4; //            ifint(rnd(1)*(in/8))=0
            if (ch = #15) or (ch =#14) then 
            begin;
                if c[whpos] > 9 then c[whpos] := 0;
                if c[whpos] < 0 then c[whpos] := 9;
                nAttempts := nAttempts - 1;

                {$ifdef CART}
                if (hops = False) and (t[whpos] = c[whpos]) then 
                    msx.init ($0a)
                else 
                    msx.init ($0c);
                msx.play();
                playMusic := 1;
                WaitFrames(10);
                msx.stop();
                playMusic := 0;
                {$else}
                if (hops = False) and (t[whpos] = c[whpos]) then 
                    msx.init ($0a)
                else 
                    msx.init ($0c);
                msx.play();
                playMusic := 1;
                WaitFrames(10);
                msx.stop();
                playMusic := 0;
                {$endif}
            end;
            if (hops = False) and (t[0] = c[0]) and (t[1] = c[1]) and (t[2] = c[2]) then safeOpen := 1;
        until (ch = #$2f) or (nAttempts = 0) or (safeOpen = 1);

        CRT_GotoXY(0,21);
        if ch = #$2f then 
        begin;
            CRT_WriteCentered_LocStr(21, 9);
            WaitFrames(100);
            waitForKey();
            enableConsole();
            mapColorA := $88;
            mapColorB := $06;
            exit;
        end;

        if safeOpen = 1 then begin;
            CRT_WriteCentered_LocStr(21, 10);
            // SAFE ANIMATION TODO
            WaitFrames(60); 
            waitForKey();
            mapColorA := $88;
            mapColorB := $06;
            crackedBank(BANK_); 
            exit;
        end;

        // SAFE ANIMATION TODO
        CRT_WriteCentered_LocStr(20, 11);
        CRT_WriteCentered_LocStr(21, 12);
        CRT_GotoXY(0,21);

        playMusic := 1;
        msx.init ($08);
        msx.play();
        for k := 0 to 6 do 
        begin;
            loccolbk := $34;
            WaitFrames(15); 
            loccolbk := $0;
            WaitFrames(15); 
        end;
        msx.stop();
        playMusic := 0;

        waitForKey();
        mapColorA := $88;
        mapColorB := $06;
        prepareFightAgainstPolice();
        if doFight() = 1 then
        begin;
            gotCaught();
            result := END_TURN_;
            exit;
        end;
    end;

end;

//
