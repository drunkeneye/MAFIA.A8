

function carDealerChoices (var choice:byte):   byte;
var r:   byte;
    minCar:   byte;
    maxCar:   byte;
    price:   word;
    oldPrice:   word;
    newCar:   byte;
begin;
    // load strings 

    if choice = 1 then
    begin;
        ShowLocationHeader;
        CRT_Writeln(loc_string_1);
        CRT_Writeln(loc_string_2);

        // depends on location
        minCar := 1;
        maxCar := 4;
        if currentSubLocation > 2 then
            maxCar := 5;

        // show cars
        CRT_NewLine;
        for r := minCar to maxCar do
        begin
            CRT_Write('  '~);
            CRT_Write(r);
            CRT_Write(' - '~);
            CRT_Write(carNames[r]);
            CRT_Write(' ('~);
            CRT_Write(carPrices[r]);
            CRT_Writeln('$)'~);
        end;

        CRT_NewLine();
        CRT_Write(loc_string_3);
        newCar := readValue (minCar, maxCar);
        if newCar = 0 then exit;
        CRT_Newline;
        price := carPrices[newCar];
        if payMoney(price) = 0 then exit;

        r := plCar[currentPlayer];
        if r <> 0 then
        begin;
            oldPrice := 1000+Random(r) SHL 9+Random(0);
            CRT_NewLine;
            CRT_Write(loc_string_4);
            CRT_Write(oldPrice);
            CRT_Writeln(loc_string_5);
            CRT_Write(loc_string_18);

            r := getYesNo();
            if r = 0 then exit;
            addMoney(oldprice);
            CRT_NewLine;
        end;

        CRT_Writeln(loc_string_6);
        if oldPrice > 0 then
        begin;
            CRT_Write(loc_string_7);
            CRT_Write(oldPrice);
            CRT_Writeln(loc_string_5);
        end;
        plCar[currentPlayer] := newCar;
        waitForKey();
        exit;
    end;

 
    if choice = 2 then
    begin
        ShowLocationHeader;

        // 14100 ifln<>4andint(rnd(1)*3)<>0the
        if (currentSubLocation < 2) and (Random(3) > 0) then
        begin
            CRT_Write(loc_string_8);
            waitForKey();
            exit;
        end;

        if plNGangsters[currentPlayer] > 1 then 
            CRT_Write(loc_string_9);
        selectGangster();
        if currentGangster = 99 then exit;

        // ifint(rnd(1)*(in/40+kr/30))=0
        r := gangsterInt[currentGangster] shr 2;
        // reuse 
        minCar := gangsterStr[currentGangster] shr 2;
        minCar := minCar + r+r+r;
        if (Random(100) < minCar) then
        begin
            // worked
            CRT_Writeln(loc_string_10);
            CRT_NewLine();

            if plCar[currentPlayer] = 0 then
            begin
                CRT_Writeln(loc_string_11);
            end 
            else 
            begin 
                CRT_Writeln(loc_string_12);
                CRT_Write(loc_string_13);
            end;

            plCar[currentPlayer] := 1+Random(5); // FIXME or Random 6?
            waitForKey();
            exit;
        end;

        // did not work
        CRT_NewLine;
        CRT_Writeln(loc_string_14);
        CRT_Writeln(loc_string_17);
        waitForKey();
        r := 0;


        // fp_gang[1] := loc_string_19;
        asm; 
            lda loc_string_19
            sta adr.FP_GANG+$02
            lda loc_string_19+1
            sta adr.FP_GANG+1+$02
        end;
        fp_AI[1] := 1;
        fp_N[1] := 1;
        // fp_name[16] := loc_string_19;
        asm; 
            lda loc_string_19
            sta adr.fp_Name+16*2
            lda loc_string_19+1
            sta adr.fp_Name+1+16*2
        end;
        fp_weapon[16] := 5;
        fp_sex[16] := Random(2);
        fp_energy[16] := 30;

        if doFight() = 1 then
        begin;
            gotCaught();
            result := END_TURN_;
            exit;
        end;

        enableConsole();
        ShowLocationHeader();
        CRT_Writeln(loc_string_15);
        CRT_Writeln(loc_string_16);
        waitForKey();
        result := CARDEALER_;
    end;
end;
