// helpers for game


// could save some bytes
procedure addMoney(amount: word); 
begin;
    plMoney[currentPlayer] := plMoney[currentPlayer] + amount;
end; 


procedure subMoney(amount: word); 
begin;
    plMoney[currentPlayer] := plMoney[currentPlayer] - amount;
end; 


procedure crackedBank(p: word);
var m:word;
    k:byte;
begin;
    loadLocation(BANK_);
    m := Random(0)*11+4000 + p; // TODO + sublocation
    // TODO: check for tipp and add more money
    // 20051 if(x=1andla=9)or(x=2andla=10andln=2)or(x=3andla=13)thenTIPP_=0:p=p+3000
    enableConsole();
    ShowLocationHeader;
    CRT_WriteCentered(6, loc_string_10);
    k := 7;

    // check for gold 
    if p = BANK_ then 
    begin
        if plOpportunity[currentPlayer] or 2 > 0 then 
        begin
            CRT_WriteCentered(7, loc_string_15);
            k := k +2;
            m := m + 7500;
        end;
        plOpportunity[currentPlayer]:= plOpportunity[currentPlayer] and (255- 2);
    end;

    CRT_WriteCentered(k, loc_string_14);
    CRT_Gotoxy(17,k+1);
    CRT_Write(m); 
    CRT_Writeln('$!'~);
    waitForKey();
    addMoney(m);
    plNewPoints[currentPlayer] := plNewPoints[currentPlayer] + 4;
end;





procedure prepareFightAgainstPolice();
var k:   byte;
begin;
    fp_gang[1] := fight_police_string_1;
    fp_AI[1] := 1;
    if plRank[currentPlayer] > 4 then
        fp_N[1] := 5+Random(plRank[currentPlayer] SHR 1)
    else
        fp_N[1] := 5;
    for k := 0 to fp_N[1] -1 do
    begin;
        fp_sex[16+k] := Random(2);
        fp_name[16+k] := fight_police_string_2;
        fp_weapon[16+k] := 5+2*Byte(plRank[currentPlayer] > 5);
        fp_energy[16+k] := 18+2*Byte(plRank[currentPlayer]) - Random(10);
    end;
    // asm
    //     ldy #$00
    // @:
    //     lda loc_string_4
    //     lda adr.FP_NAME+$20,y
    //     lda loc_string_4+1
    //     lda adr.FP_NAME+1+$20,y
    //     lda #$1E
    //     sta adr.FP_ENERGY+$10,y
    //     lda #$06
    //     sta adr.FP_WEAPON+$10,y
    //     iny
    //     cpy adr.FP_N+$01
    //     bne @- 
    // end; 
end;



// 0 = not worked
// 1 = worked
function payMoney (price: smallint):   byte;
begin;
    if plMoney[currentPlayer] < price then
    begin
        CRT_NewLine();
        CRT_Writeln(not_enough_money_string);
        CRT_ReadKey();
        result := 0;
        exit;
    end;
    subMoney(price);
    result := 1;
end;


procedure selectGangster();
var j, k, x, y:   byte;
    map: array[0..8] of byte;
begin;
    if plNGangsters[currentPlayer] = 1 then begin;
        currentGangster := currentPlayer SHL 3;
        exit;
    end;

    j := 0;
    y := CRT_WhereY-1;
    for k := 0 to 31 do
    begin
        if  plGangsters[k] = currentPlayer then 
        begin 
            x := 0;
            if j and $1 = 1 then
                x := 20
            else 
                y := y + 3; 
            CRT_GotoXY(x,y);
            CRT_Write(j+1);
            CRT_Write(' - '~);
            CRT_Write(gangsterNames[k]);
            CRT_GotoXY(x,y+1);
            CRT_Write('E:'~);
            CRT_Write(gangsterHealth[k]);
            CRT_Write(' B:'~);
            CRT_Write(gangsterBrut[k]);
            CRT_Write(' I:'~);
            CRT_Write(gangsterInt[k]);
            CRT_Write(' S:'~);
            CRT_Write(gangsterStr[k]);
            map[j] := k;
            j := j + 1;
        end;
    end;
    CRT_Newline;       
    CRT_Newline;       
    CRT_Write(your_choice_string);
    x := readValue(1, j);
    if x =0 then currentGangster := 99 
        else currentGangster := map[x-1];
    CRT_Newline;
end;



    // function displayWeapons(minWeapon:byte; maxWeapon:byte):   byte;
    // var 
    //     i:   byte;
    // begin;
    //     for i := minWeapon to maxWeapon do
    //     begin;
    //         CRT_Write ('  '~);
    //         CRT_Write (i);
    //         CRT_Write (' - '~);
    //         CRT_Writeln (weaponNames[i]);
    //     end;
    //     CRT_NewLine();
    //     CRT_Write ('Deine Wahl:'~);
    //     result := readValue (minWeapon, maxWeapon);
    //     // ALLOW ZERO AS WELL
    // end;


    procedure saveGame ();
    begin;
        enableConsole();
        CRT_Clear;
        CRT_WriteCentered(1,'Saving...'~);
        xBiosOpenFile(saveFname);
        xBiosSetLength($1000); // just dump all of it 
        xBiosWriteData(Pointer($e000));
        // we pray instead.
        // if (xBiosIOresult = 0) then
        //     CRT_WriteCentered(3,'Successful!'~)
        // else
        //     CRT_WriteCentered(3,'ERROR!'~);
        xBiosFlushBuffer();
        waitForKey();
        enableMapConsole();
    end;


    procedure loadGame ();
    var tmp: byte;
    begin;
        enableConsole();
        CRT_Clear;
        CRT_WriteCentered(1,'Loading...'~);
        xBiosOpenFile(saveFname);
        // first check if its plausible

        tmp := 99;
        xBiosSetLength($1); // just dump all of it 
        xBiosLoadData(@tmp);
        if  (tmp > 4) or (tmp = 0) then begin 
            CRT_WriteCentered(3, 'Invalid save game!'~);
            waitForKey;
            enableMapConsole();
            exit;
        end;
        // if (xBiosIOresult = 0) then
        //     CRT_WriteCentered(3,'Successful!'~)
        // else
        //     CRT_WriteCentered(3,'ERROR!'~);

        // reopen 
        xBiosOpenFile(saveFname);
        xBiosSetLength($1000); // just dump all of it 
        xBiosLoadData(Pointer($e000));
        // if (xBiosIOresult = 0) then
        //     CRT_WriteCentered(3,'Successful!'~)
        // else
        //     CRT_WriteCentered(3,'ERROR!'~);
        xBiosFlushBuffer();
        waitForKey();
        placeCurrentPlayer ();
        loadMap();
        enableMapConsole();
    end; 


