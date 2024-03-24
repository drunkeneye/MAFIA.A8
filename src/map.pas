

procedure printMapStatus();
var 
    l, z, i, p: byte;
begin
    // static part first
    if mapReloaded = 0 then 
    begin
        FillChar(Pointer(MAP_SCR_ADDRESS+40*19), 40*6, 0);
        z := plRank[currentPlayer];
        l := Length(rankNames[z]) + 3; // 3 fors space+( .. )
        i := currentPlayer SHL 3;
        p := l + Length(gangsterNames[i]) ;
        CRT_GotoXY((40-p) SHR 1, 19);
        CRT_Write(gangsterNames[i]);
        CRT_Write(' ('~);
        CRT_Write(rankNames[z]);

        // show points here too, well whatever
        // CRT_Write(', '~);
        // CRT_Write(plPoints[currentPlayer]);
        CRT_Write(')'~);
        CRT_Invert(0, 19, CRT_screenWidth);
    
        CRT_GotoXY(0, 20);
        CRT_Write(map_string_weapon);
        z := gangsterWeapon[i];
        CRT_Write(weaponNames[z]);

        CRT_GotoXY(40-10, 20);
        CRT_Write(map_string_gangster);
        CRT_Write(plNGangsters[currentPlayer]-1);

        CRT_GotoXY(0, 21);
        CRT_Write(map_string_car);
        // actually steps should be shown
        z := plCar[currentPlayer];
        CRT_Write(carNames[z]);

        i := 40-3-len_string_bribe;
        if plBribe[currentPlayer] < 10 then i := i + 1;
        CRT_GotoXY(i, 21);
        CRT_Write(map_string_bribe);
        CRT_Write(plBribe[currentPlayer]);

        CRT_GotoXY(0, 22);
        CRT_Write(map_string_rent);
        CRT_Write(plRentMonths[currentPlayer]);

        CRT_GotoXY(15,22);
        CRT_Write(map_string_steps);
        CRT_Write(plSteps[currentPlayer]);
        CRT_Write('   '~);
        z := plAlcohol[currentPlayer];
        i := 40 - 8 - 3;
        if z < 10 then i := i + 1;
        if z < 100 then i := i + 1;
        CRT_GotoXY(i, 22);
        CRT_Write(map_string_cargo);
        CRT_Write(z);

        CRT_GotoXY(0, 23);
        CRT_Write(map_string_money);
        CRT_Write(plMoney[currentPlayer]);

        CRT_GotoXY(23, 23);
        CRT_Write(map_string_credit);
        CRT_Write(plLoan[currentPlayer]);
        CRT_GotoXY(35, 23);
        CRT_Write('('~);
        CRT_Write(plLoanTime[currentPlayer]);
        CRT_Write(' M)'~);
        mapReloaded := 1;
    end;
    Waitframe;
    CRT_GotoXY(15,22);
    CRT_Write(map_string_steps);
    CRT_Write(plSteps[currentPlayer]);
    CRT_Write('   '~);
end;



procedure drawMajorMoney();
var i:byte;
begin 
    if currentMap = 7 then 
    begin 
        // major is drawn by default 
        // if Random(2) = 1 then i :=0 else i := 1;
        // plOpportunity[currentPlayer] := (i SHL 4) + (i SHL 2);

        if plOpportunity[currentPlayer] and (1 SHL 2) = 0 then 
        begin;
    	    // FA40 : 58 58 4D 4D 4D 4D 4D 4D 58 58 58 58 52 52 52 52 XXMMMMMMXXXXRRRR
            DPoke($fa42, $5858);
            DPoke($fa44, $5858);
            DPoke($fa46, $5858);
            Poke($f642, $04);
            Poke($f644, $04);
            Poke($f646, $04);
            Poke($f643, $05);
            Poke($f645, $05);
            Poke($f647, $05);
            // 	FA60 : 58 58 44 44 44 44 2E 2E 2E 2E 4D 4D 4D 4D 4D 4D XXDDDD....MMMMMM
            DPoke($fa6a, $2e2e);
            DPoke($fa6c, $2e2e);
            DPoke($fa6e, $2e2e);
            Poke($f66a, $1c);
            Poke($f66c, $1c);
            Poke($f66e, $1c);
            Poke($f66b, $1d);
            Poke($f66d, $1d);
            Poke($f66f, $1d);
        end
        else 
        begin  
    	    // FA40 : 58 58 4D 4D 4D 4D 4D 4D 58 58 58 58 52 52 52 52 XXMMMMMMXXXXRRRR
            DPoke($fa42, $4d4d);
            DPoke($fa44, $4d4d);
            DPoke($fa46, $4d4d);
            DPoke($f642, $4c4b);
            DPoke($f644, $4e4d);
            DPoke($f646, $504f);
            // 	FA60 : 58 58 44 44 44 44 2E 2E 2E 2E 4D 4D 4D 4D 4D 4D XXDDDD....MMMMMM
            DPoke($fa6a, $4d4d);
            DPoke($fa6c, $4d4d);
            DPoke($fa6e, $4d4d);
            DPoke($f66a, $5756);
            DPoke($f66c, $5958);
            DPoke($f66e, $5b5a);
        end; 

        if plOpportunity[currentPlayer] and (1 SHL 4) = 0 then 
        begin
            // 	F900 : 52 52 52 52 58 58 2E 2E 58 58 58 58 58 58 58 58 RRRRXX..XXXXXXXX
            // 	F910 : 48 48 48 48 58 58 58 58 50 50 50 50 58 58 58 58 HHHHXXXXPPPPXXXX
            DPoke($f90c, $5858);
            DPoke($f90e, $5858);
            //	F930 : 58 58 58 58 58 58 58 58 48 48 48 48 58 58 58 58 XXXXXXXXHHHHXXXX
            DPoke($f934, $2e2e);
            DPoke($f936, $2e2e);

            Poke($f50c, $04);
            Poke($f50e, $04);
            Poke($f534, $04);
            Poke($f536, $04);
            Poke($f50d, $05);
            Poke($f50f, $05);
            Poke($f535, $05);
            Poke($f537, $05);
	        // F960 : 2E 2E 2E 2E 2E 2E 2E 2E 50 50 50 50 58 58 2E 2E ........PPPPXX..
            DPoke($f960-4, $2e2e);
            DPoke($f962-4, $2e2e);
            Poke($f560-4, $1c);
            Poke($f562-4, $1c);
            Poke($f561-4, $1d);
            Poke($f563-4, $1d);
        end
        else 
        begin 
            // 	F900 : 52 52 52 52 58 58 2E 2E 58 58 58 58 58 58 58 58 RRRRXX..XXXXXXXX
            // 	F910 : 48 48 48 48 58 58 58 58 50 50 50 50 58 58 58 58 HHHHXXXXPPPPXXXX
            DPoke($f90c, $4e4e);
            DPoke($f90e, $4e4e);
            DPoke($f50c, $2d2c);
            DPoke($f50e, $2f2e);
            //	F930 : 58 58 58 58 58 58 58 58 48 48 48 48 58 58 58 58 XXXXXXXXHHHHXXXX
            DPoke($f934, $4e4e);
            DPoke($f936, $4e4e);
            DPoke($f534, $3938);
            DPoke($f536, $3b3a);
	        // F960 : 2E 2E 2E 2E 2E 2E 2E 2E 50 50 50 50 58 58 2E 2E ........PPPPXX..
            DPoke($f960-4, $4e4e);
            DPoke($f962-4, $4e4e);
            DPoke($f560-4, $4241);
            DPoke($f562-4, $4443);
        end 
    end;
end; 


procedure preloadMap;
begin;
    blackConsole();
    // scrname[1] := char($41+currentMap);
    fntname[1] := char($41+currentMap);
    // locname[1] := char($41+currentMap);
    xbunAPL (fntname, Pointer(MAP_FNT_ADDRESS));
    // xbunAPL (scrname, Pointer(MAP_SCR_ADDRESS));
    // xbunAPL (locname, Pointer(LOC_MAP_ADR));
    clearSprites();
    paintPlayer(0);

    // draw major if this is a thing
    drawMajorMoney();
    mapreloaded := 0;
end;



procedure loadMap ;
begin;
    preloadMap();
    enableMapConsole();
    printMapStatus();
end;



// map is 5x2
procedure ChangeMap();
begin;
    if playerPos_X > 202 then
    begin;
        // nextt map
        playerPos_X := 49;
        mapPos_X := 0;
        if (currentMap <> 4) and (currentMap <> 9) then
        begin
            currentMap := currentMap + 1;
            loadMap();
            exit;
        end;
    end;

    if playerPos_X < 47 then
    begin;
        // nextt map
        playerPos_X := 201;
        mapPos_X := 19;
        if (currentMap <> 0) and (currentMap <> 5) then
        begin
            currentMap := currentMap - 1;
            loadMap();
            exit;
        end;
    end;

    if playerPos_Y > 172 then
    begin;
        playerPos_Y := 36;
        mapPos_Y := 0;
        if currentMap < 5 then
        begin
            currentMap := currentMap + 5;
            loadMap();
            exit;
        end;
    end;

    if playerPos_Y < 35 then
    begin;
        playerPos_Y := 172;
        mapPos_Y := 17;
        if currentMap > 4 then
        begin
            currentMap := currentMap - 5;
            loadMap();
            exit;
        end;
    end;
end;
 
