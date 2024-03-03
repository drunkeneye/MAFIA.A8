
 

var
    safeclmfname:   TString =   'SAFECLMFAPL';
    safeclmsname:   TString =   'SAFECLMSAPL';

    
function bankChoices (var choice:byte):  byte;
var k: byte;
    nAttempts: byte;
    t, c:array[0..2] of shortint; // true code
    ch: char;
    safeOpen: byte;
    base:word;
    whpos: byte;
    hops: boolean;
begin;
    result := BANK_;
    loadLocation(BANK_);
    ShowLocationHeader;
    {$ifndef norank}
    if plRank[currentPlayer] < 3 then
    begin
        CRT_Write(loc_string_13);
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
        CRT_WriteCentered(6, loc_string_1);
        waitForKey();
        lastLocation := NONE_;
        exit;
    end;


    if choice = 1 then
    begin
        if Random(3) = 0 then
        begin
            CRT_Writeln(loc_string_2);
            CRT_Writeln(loc_string_3);
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


    if choice = 2 then
    begin;
        ShowLocationHeader;
        k := currentPlayer SHL 3;
        if (gangsterBrut[k] < 20) or (gangsterStr[k] < 15)  or (gangsterInt[k] < 40) then 
            begin;
                CRT_WriteCentered(6, loc_string_5);
                waitForKey();
                exit;
            end; 
        
        CRT_Writeln(loc_string_6);
        selectGangster();
        if currentGangster = 99 then exit;

        CRT_Writeln(loc_string_7);
        CRT_Writeln(loc_string_8);
        CRT_Newline;

        //CRT_Writeln('Nutze ...'~);
        nAttempts := 10 + gangsterInt[currentPlayer SHL 3] SHR 4 + currentSubLocation;
        if plStuff[currentPlayer] OR 32 = 1 then 
        begin;
            nAttempts := nAttempts + 9;
            plStuff[currentPlayer]  := plStuff[currentPlayer] AND (255-32);
        end;

        waitForKey();

        // show safe
        FillChar(Pointer(MAP_SCR_ADDRESS), 40*24, 0);
        enableMapConsole();
        xbunAPL (safeclmfname, Pointer(MAP_FNT_ADDRESS));
        xbunAPL (safeclmsname, Pointer(MAP_SCR_ADDRESS));
        FillChar(Pointer(MAP_SCR_ADDRESS+17*40), 80, 0); // remove number chars
        didFight := 1; // remember to reload map
        t[0] := Random(10);
        t[1] := Random(10);
        t[2] := Random(10);
        c[0] := Random(10);
        c[1] := Random(10);
        c[2] := Random(10);

        safeOpen := 0; 
        whpos := 0;
        base := MAP_SCR_ADDRESS+6*40+17;
        repeat;    
            Poke(base+whpos SHL 1, 107);
            Poke(base+whpos SHL 1+2, 108);
            for k := 0 to 2 do 
                Poke(base+1+k+k, 109+c[k]);
            repeat;
                ch := checkKeyAndStick ();
            until (ch = #$26) or (ch = #$60) or (ch = #$73) or (ch = #$02) or (ch = #$2f);
            waitForKeyRelease();
            WaitFrames(5);
            case ch of
                #$26: c[whpos] := c[whpos] - 1; 
                #$60: c[whpos] := c[whpos] + 1;
            end; 

            if (ch = #$73) or (ch = #$02) then 
            begin;
                Poke(base+whpos SHL 1, 0);
                Poke(base+whpos SHL 1+2, 0);
                if ch = #$73 then
                begin;
                    if whpos < 2 then whpos := whpos + 1; 
                end;
                if ch = #$02 then
                begin;
                    if whpos > 0 then whpos := whpos - 1;
                end;
            end;

            hops := Random(gangsterInt[currentPlayer SHL 3]) < 4; //            ifint(rnd(1)*(in/8))=0
            if (ch = #$26) or (ch =#$60) then 
            begin;
                if c[whpos] > 9 then c[whpos] := 0;
                if c[whpos] < 0 then c[whpos] := 9;
                nAttempts := nAttempts - 1;

                if (hops = False) and (t[whpos] = c[whpos]) then sound(0,121,10,15)
                    else sound(0,96,10,15);
                WaitFrames(5);
                NoSound;
            end;
            if (hops = False) and (t[0] = c[0]) and (t[1] = c[1]) and (t[2] = c[2]) then safeOpen := 1;
        until (ch = #$2f) or (nAttempts = 0) or (safeOpen = 1);

        CRT_GotoXY(0,21);
        if ch = #$2f then 
        begin;
            CRT_WriteCentered(21, loc_string_9);
            WaitFrames(100);
            waitForKey();
            enableConsole();
            exit;
        end;

        if safeOpen = 1 then begin;
            CRT_WriteCentered(21, loc_string_10);
            // SAFE ANIMATION TODO
            WaitFrames(60); 
            waitForKey();
            crackedBank(BANK_); 
            exit;
        end;

        // SAFE ANIMATION TODO
        CRT_WriteCentered(21, loc_string_11);
        CRT_WriteCentered(22, loc_string_12);
        WaitFrames(100); 
        waitForKey();
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
