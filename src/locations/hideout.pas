
function hideoutChoices (var choice:byte):   byte;
var r, k, j, w:   byte;
    m:   byte;
    price:   byte;
    pl: byte;
    z: word;
begin;
    ShowLocationHeader;
    CRT_NewLine();

    // bandenkrieg
    if choice = 3 then 
    begin 
        pl := plRent[currentSubLocation];

        CRT_WriteCentered(4, loc_String_12);
        effectWait();

        if (pl = 99) or (pl = currentPlayer) then 
        begin 
            CRT_WriteCentered(6, loc_string_13);
            waitForKey;
            exit;
        end;

        CRT_NewLine;
        CRT_NewLine;
        CRT_Write(loc_string_14);
        CRT_Write(gangsterNames[pl SHL 3]);
        CRT_Writeln('...'~);
        effectWait();

        if (Random(3) > 0) or (plJob[pl] > 0) or (plPrison[pl] > 0) then begin 
            CRT_Writeln(loc_string_15);
            waitForKey;
            exit;
        end ;


        // other party was setup, only do own party
        fp_N[1] := plNGangsters[pl];
        fp_gang[1] := plGang[pl];
        fp_AI[1] := 0;

        k := 0;
        for j := 0 to 31 do
        begin;
            if plGangsters[j] = pl then 
            begin;
                fp_name[16+k] := gangsterNames[j];
                fp_energy[16+k] := gangsterHealth[j];
                fp_weapon[16+k] := gangsterWeapon[j];
                fp_sex[16+k] := gangsterSex[j];
                fp_strength[16+k] := gangsterStr[j];
                fp_brutality[16+k] := gangsterBrut[j];
                k := k + 1;
            end;
        end;

        w := doFight(); 
        enableConsole();

        ShowLocationHeader;
        CRT_NewLine();
        CRT_WriteCentered(4,loc_String_12);
        CRT_NewLine;
        CRT_NewLine;

        if w = 1 then 
        begin
            // lost it!
            CRT_Writeln(loc_string_16);
            CRT_Write(gangsterNames[pl SHL 3]);
            CRT_Write(' '~);
            CRT_Writeln(loc_string_17);
            CRT_Write(loc_string_18);
            m := pl;
            k := currentPlayer;
        end 
        else 
        begin
            // lost it!
            CRT_Writeln(loc_string_19);
            CRT_Write(loc_string_20);
            CRT_Writeln(gangsterNames[pl SHL 3]);
            CRT_Write(loc_string_21);
            m := currentPlayer;
            k := pl;
        end;

        z := plMoney[k] SHR 2;
        z := z + Random(4)*(z SHR 1);
        CRT_Write(z);
        CRT_Writeln('$!'~);
        plMoney[m] := plMoney[m] + z;
        plMoney[k] := plMoney[k] - z;

        if plAlcohol[k] > 0 then 
        begin
            if w = 1 then 
                CRT_Writeln(loc_string_22)
            else 
                CRT_Writeln(loc_string_23);
            plAlcohol[m] := plAlcohol[m] + plAlcohol[k];
            plAlcohol[k] := 0;
            r := plCar[k];
            if plAlcohol[pl] > carCargo[r]  then plAlcohol[pl] := carCargo[r];
        end;

        if plCar[k] > 0 then 
        begin 
            if w = 1 then 
                CRT_Writeln(loc_string_24)
            else
                CRT_Writeln(loc_string_25);
            plCar[k] := 0;
        end;
        plNewPoints[m] := plNewPoints[m] + 3;
        plNewPoints[k] := plNewPoints[k] - 1;
        waitForKey;
        result := END_TURN_;
        exit;
    end;
 

    // 'Eine Unterkunft, aber zack, zack! Und   ich moechte nicht gestoert werden!'~,
    if choice = 1 then
    begin;
        if plRent[currentSubLocation] <> 99 then
        begin;
            CRT_NewLine();
            if plRent[currentSubLocation] = currentPlayer then
                CRT_Write(loc_string_1)
            else
                CRT_Write(loc_string_2);
            waitForKey();
            exit;
        end;

        // its empty
        // check if we player stays somewhere else
        for r := 0 to 3 do
            if plRent[r] = currentPlayer then
            begin
                CRT_Write(loc_string_3);
                waitForKey();
                exit;
            end;
    end;

    if choice = 2 then
    begin;
        if plRent[currentSubLocation] <> currentPlayer then
        begin
            CRT_Write(loc_string_4);
            waitForKey();
            exit;
        end;
    end;

    price := 50;
    if (currentSubLocation > 1) then
        price := price + 50;
    if (currentSubLocation = 1) then
        price := price + 50;

    CRT_Write(loc_string_5);
    CRT_Write(price);
    CRT_Write(loc_string_6);
    CRT_NewLine();
    CRT_Write(loc_string_7);
    CRT_NewLine();
    CRT_NewLine();

    if plRentMonths[currentPlayer] > 0 then
    begin;
        CRT_NewLine();
        CRT_Write(loc_string_8);
        CRT_Write(plRentMonths[currentPlayer]);
        CRT_Write(loc_string_9);
        CRT_NewLine();
    end;
    CRT_Write(loc_string_10);
    m := readValue(0, 99);
    // FIXME, maybe we need readByteValue? no overflow should happen value < 100
    if (m = 0) then exit;

    if payMoney (price*m) = 0 then exit;

    // update rent
    plRentMonths[currentPlayer] := plRentMonths[currentPlayer]+m;
    plRentCost[currentPlayer] := price;
    plRent[currentSubLocation] := currentPlayer;

    CRT_NewLine();
    CRT_NewLine();
    CRT_Write(loc_string_11);
    waitForKey();
end;
