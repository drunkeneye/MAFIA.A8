
procedure increaseCurrentGangster (inc_st:byte; inc_in:byte; inc_bt:byte);
begin;
    gangsterStr[currentGangster] := gangsterStr[currentGangster] + inc_st;
    if (  gangsterStr[currentGangster]  > 99) then
        gangsterStr[currentGangster]  := 99;

    gangsterInt[currentGangster] := gangsterInt[currentGangster]  + inc_in;
    if ( gangsterInt[currentGangster]  > 99) then
        gangsterInt[currentGangster]  := 99;

    gangsterBrut[currentGangster]  := gangsterBrut[currentGangster] + inc_bt;
    if (  gangsterBrut[currentGangster] > 99) then
        gangsterBrut[currentGangster] := 99;

    // print some infos
    CRT_Writeln(loc_string_19);
    CRT_Writeln(loc_string_20);
end;
 


function armsDealerChoices (var choice:byte):   byte;
var r:   byte;
    maxWeapon:   byte;
    minWeapon:   byte;
    selectedWeapon:   byte;
    ga:   shortint;
    price:   word;
    inc_in, inc_bt, inc_st:   byte;
    oldWeaponPrice:   word;
    camp:   byte;

begin;
    if choice = 1 then
    begin;
        ShowLocationHeader;

        CRT_Writeln2(loc_string_1);
        minWeapon := 1;
        maxWeapon := 5;
        if currentSubLocation = 2 then
        begin
            // check for granade
            maxWeapon := 7;
            if (plRank[currentPlayer] > 5) and (Random(4) = 0) then
            begin
                CRT_Writeln(loc_string_2);
                CRT_Writeln(loc_string_3);
                CRT_NewLine;
                maxWeapon := 8;
            end;
            minWeapon := 3;
        end;

        if currentSubLocation = 1 then maxWeapon := 5;
        if currentSubLocation = 4 then 
        begin;
            minWeapon := 2;
            maxWeapon := 6;
        end;

        // this is only displayed here, so no need to refactor
        for r := minWeapon to maxWeapon do
        begin
            CRT_Write('  '~);
            CRT_Write(r);
            CRT_Write(' - '~);
            CRT_Write(weaponNames[r]);
            CRT_Write(', '~);
            CRT_Write(weaponPrices[r]);
            CRT_NewLine();
        end;
        CRT_NewLine;
        CRT_Write(loc_string_4);
        selectedWeapon := readValue(minWeapon, maxWeapon);
        if selectedWeapon = 0 then exit; // TODO this will not work
    

        // for welchen gangster?
        ShowLocationHeader;
        selectGangster();
        if currentGangster = 99 then exit;

        ga := 0;
        if (gangsterInt[currentGangster] < 40) and (selectedWeapon > 5) then
        begin
            CRT_Writeln (loc_string_5);
            waitForKey();
            ga := -1;
        end
        else if (gangsterStr[currentGangster]  < 20) and ((selectedWeapon = 2) or (selectedWeapon = 3)) then
            begin
                CRT_Write (loc_string_6);
                waitForKey();
                ga := -1;
            end
        else if (gangsterBrut[currentGangster]  < 40) and ((selectedWeapon = 3) or (selectedWeapon > 6)) then
            begin
                CRT_Write (loc_string_7);
                waitForKey();
                ga := -1;
            end;
        if ga < 0 then exit;

        // pay
        if payMoney (weaponPrices[selectedWeapon]) = 0 then exit;

        ga := gangsterWeapon[currentGangster];
        if  ga <> 0 then
        begin;
            oldWeaponPrice := weaponPrices[ga] SHR 2 + Random(500);
            CRT_NewLine();
            CRT_Write (loc_string_8);
            CRT_Write (oldWeaponPrice);
            CRT_Write ('$ '~);
            CRT_Writeln(loc_string_9);
            CRT_Write(loc_string_10);
            CRT_Write(weaponNames[ga]);
            CRT_Writeln(') '~);
            CRT_Writeln(loc_string_11);

            r := getYesNo();
            if r = 0 then
            begin
                // ok, you dont want it, then we quit transcation
                addMoney(weaponPrices[selectedWeapon]);
                CRT_Write (loc_string_22);
                waitForKey();
                exit;
            end; 
        end;

        // weapon downgrade gives minus points FIXME
        // 13072 ifx>gw(sp,y)thenPUNKTE_SP=PUNKTE_SP-SPIEL_SCHWIERIGKEIT*1*(PUNKTE_SP<100):goto13075
        if gangsterWeapon[currentGangster] < selectedWeapon then
            plNewPoints[currentPlayer] := plNewPoints[currentPlayer] + 2
        else
            plNewPoints[currentPlayer] := plNewPoints[currentPlayer] - 2;

        addMoney(oldWeaponPrice);
        gangsterWeapon[currentGangster] := selectedWeapon;
        CRT_NewLine;
        CRT_Write (loc_string_12);
        waitForKey();
    end;

    //  'Kannst du meine Jungs im Schiessen     ausbilden? Sind einfach zu schlapp!'
    if choice = 2 then
    begin;
        ShowLocationHeader;

        if plNGangsters[currentPlayer] > 1 then 
        begin
            CRT_Writeln (loc_string_13); // who
            selectGangster();
            if currentGangster = 99 then exit;
        end;

        camp := 0;
        // schiesstand
        if plRank[currentPlayer] >= 5 then
        begin
            CRT_Writeln (loc_string_14);
            CRT_Write (loc_string_21);
            r := getAnswer(shooting_range_keycode, training_camp_keycode); // 3e=s, 2d=t
            if r = 1 then  camp := 1;
        end;

        // schiesstand
        if camp = 0 then
            price := 800 + 200*plRank[currentPlayer]
        else
            price := 2500 + 500*plRank[currentPlayer];

        CRT_Newline();
        CRT_Write (loc_string_15);
        CRT_Write(price);
        CRT_Write (loc_string_16);
        ga := getYesNo();
        if ga = 0 then exit; // N=35, Y=1
        if payMoney(price) = 0 then exit;

        CRT_NewLine;
        CRT_NewLine;
        CRT_Write (gangsterNames[currentGangster]);
        if camp = 0 then
        begin;
            CRT_Write (loc_string_17);
            inc_st := 5;
            inc_in := 3 + 2*byte(currentSubLocation = 1);
            inc_bt := 2 + 3*byte(currentSubLocation = 3);
            plNewPoints[currentPlayer] := plNewPoints[currentPlayer] + 1;
            // one more for schiessstand
        end
        else
            begin;
                CRT_Write (loc_string_18);
                inc_st := Random(8)+8;
                inc_in := Random(8)+8;
                inc_bt := Random(8)+8;
            end;

        effectWait();

        CRT_NewLine;
        CRT_NewLine;
        increaseCurrentGangster (inc_st, inc_in, inc_bt);
        plNewPoints[currentPlayer] := plNewPoints[currentPlayer] + 1;

        CRT_ReadKey();
    end;
end;
