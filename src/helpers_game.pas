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


procedure addPoints (pt: byte);
begin
    plNewPoints[currentPlayer] := plNewPoints[currentPlayer] + pt;
end;


procedure removePoints (pt: byte);
begin
    if plNewPoints[currentPlayer] < pt then begin 
        plNewPoints[currentPlayer] := 0;
        exit;
    end;
    plNewPoints[currentPlayer] := plNewPoints[currentPlayer] - pt;
end;


procedure crackedBank(p: word);
var m:word;
    k:byte;
begin;
    loadLocation(BANK_);
    // m := Random(0)*11+4000 + p; // TODO + sublocation
    m :=  Random(175) SHL 4;
    m := m + 4000 + p; // TODO + sublocation
    // TODO: check for tipp and add more money
    // 20051 if(x=1andla=9)or(x=2andla=10andln=2)or(x=3andla=13)thenTIPP_=0:p=p+3000
    enableConsole();
    ShowLocationHeader;
    CRT_WriteCentered_LocStr(6, 10);
    k := 7;

    // check for gold 
    if p = BANK_ then 
    begin
        // klomerzbank cracking
        if (tmpOpportunity >0) and (currentSubLocation = 0) then 
        begin
            CRT_WriteCentered_LocStr(7, 15);
            k := k +2;
            m := m + 7500;
        end;
    end;

    CRT_WriteCentered_LocStr(k, 14);
    CRT_Gotoxy(17,k+1);
    CRT_Write(m); 
    CRT_Writeln('$!'~);
    waitForKey();
    addMoney(m);
    addPoints(4);
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
        tmp := Random(2);
        fp_sex[16+k] := tmp;
        fp_name[16+k] := fight_police_string_2;
        fp_weapon[16+k] := 5+Byte(plRank[currentPlayer] > 5) SHL 1;
        fp_energy[16+k] := 18+Byte(plRank[currentPlayer]) SHL 1 - Random(10);
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


procedure printGangsters();
var k, x, y, t:   byte;
begin;
    gangsterCount := 0;
    y := CRT_WhereY-1;
    for k := 0 to 31 do
    begin
        if  plGangsters[k] = currentPlayer then 
        begin 
            x := 0;
            if gangsterCount and $1 = 1 then
                x := 20
            else 
            begin
                y := y + 3; 
                if showWeapons = 1 then y := y + 1;
            end;

            CRT_GotoXY(x,y);
            CRT_Write(gangsterCount+1);
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
            if showWeapons = 1 then begin 
                CRT_GotoXY(x,y+2);
                t := gangsterWeapon[k];
                CRT_Write(weaponNames[t]);
            end; 
            gangsterMap[gangsterCount] := k;
            gangsterCount := gangsterCount + 1;
        end;
    end;
    CRT_Newline;       
end;


procedure selectGangster();
var x: byte;
begin;
    if plNGangsters[currentPlayer] = 1 then begin;
        currentGangster := currentPlayer SHL 3;
        exit;
    end;

    printGangsters();
    CRT_Newline;       
    CRT_Write(your_choice_string);
    x := readValue(1, gangsterCount);
    if x =0 then currentGangster := 99 
        else currentGangster := gangsterMap[x-1];
    CRT_Newline;
end;


