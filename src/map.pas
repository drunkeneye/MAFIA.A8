

procedure printMapStatus();
var 
    l, z, i, p: byte;
    w: word;
begin
    // static part first
    if mapReloaded = 0 then 
    begin
        FillChar(Pointer(MAP_SCR_ADDRESS+40*19), 40*6, 0);
        z := plRank[currentPlayer];
        l := Length(rankNames[z]) + 3; // 3 fors space+( .. )
        i := currentPlayer SHL 3;
        p := l + Length(gangsterNames[i]) ;
        tmp := 40-p;
        tmp := tmp SHR 1;
        CRT_GotoXY(tmp, 19);
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

        CRT_GotoXY(40-len_string_gangster, 20);
        CRT_Write(map_string_gangster);
        tmp := plNGangsters[currentPlayer]-1;
        CRT_Write(tmp);

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
        tmp := plSteps[currentPlayer];
        CRT_Write(tmp);
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
        w := plLoan[currentPlayer];
        CRT_Write(w);
        CRT_GotoXY(35, 23);
        CRT_Write('('~);
        tmp := plLoanTime[currentPlayer];
        CRT_Write(tmp);
        CRT_Write(' M)'~);
        mapReloaded := 1;
    end;
    Waitframe;
    CRT_GotoXY(15,22);
    CRT_Write(map_string_steps);
    tmp := plSteps[currentPlayer];
    CRT_Write(tmp);
    CRT_Write('   '~);
end;



procedure drawMajorMoney();
begin 
    if currentMap = 7 then 
    begin 
        // major is drawn by default 
        // if Random(2) = 1 then i :=0 else i := 1;
        // plOpportunity[currentPlayer] := (i SHL 4) + (i SHL 2);

        if plOpportunity[currentPlayer] and (1 SHL 2) = 0 then 
        begin;
    	    // FA40 : 58 58 4D 4D 4D 4D 4D 4D 58 58 58 58 52 52 52 52 XXMMMMMMXXXXRRRR
            DPoke(MAP_FNT_ADDRESS + $a42, $5858);
            DPoke(MAP_FNT_ADDRESS + $a44, $5858);
            DPoke(MAP_FNT_ADDRESS + $a46, $5858);

            Poke(MAP_FNT_ADDRESS + $642, $04);
            Poke(MAP_FNT_ADDRESS + $644, $04);
            Poke(MAP_FNT_ADDRESS + $646, $04);
            Poke(MAP_FNT_ADDRESS + $643, $05);
            Poke(MAP_FNT_ADDRESS + $645, $05);
            Poke(MAP_FNT_ADDRESS + $647, $05);
            // 	FA60 : 58 58 44 44 44 44 2E 2E 2E 2E 4D 4D 4D 4D 4D 4D XXDDDD....MMMMMM
            DPoke(MAP_FNT_ADDRESS + $a6a, $2e2e);
            DPoke(MAP_FNT_ADDRESS + $a6c, $2e2e);
            DPoke(MAP_FNT_ADDRESS + $a6e, $2e2e);

            Poke(MAP_FNT_ADDRESS + $66a, $1c);
            Poke(MAP_FNT_ADDRESS + $66c, $1c);
            Poke(MAP_FNT_ADDRESS + $66e, $1c);
            Poke(MAP_FNT_ADDRESS + $66b, $1c);
            Poke(MAP_FNT_ADDRESS + $66d, $1c);
            Poke(MAP_FNT_ADDRESS + $66f, $1c);
        end
        else 
        begin  
            // car
    	    // FA40 : 58 58 4D 4D 4D 4D 4D 4D 58 58 58 58 52 52 52 52 XXMMMMMMXXXXRRRR
            DPoke(MAP_FNT_ADDRESS + $a42, $4d4d);
            DPoke(MAP_FNT_ADDRESS + $a44, $4d4d);
            DPoke(MAP_FNT_ADDRESS + $a46, $4d4d);
            DPoke(MAP_FNT_ADDRESS + $a6a, $4d4d);
            DPoke(MAP_FNT_ADDRESS + $a6c, $4d4d);
            DPoke(MAP_FNT_ADDRESS + $a6e, $4d4d);
            // 	FA60 : 58 58 44 44 44 44 2E 2E 2E 2E 4D 4D 4D 4D 4D 4D XXDDDD....MMMMMM

            {$I moneytransporter_poke.pas}
        end; 

        // major 
        if plOpportunity[currentPlayer] and (1 SHL 4) = 0 then 
        begin
            // 	F900 : 52 52 52 52 58 58 2E 2E 58 58 58 58 58 58 58 58 RRRRXX..XXXXXXXX
            // 	F910 : 48 48 48 48 58 58 58 58 50 50 50 50 58 58 58 58 HHHHXXXXPPPPXXXX
            DPoke(MAP_FNT_ADDRESS + $90c, $5858);
            DPoke(MAP_FNT_ADDRESS + $90e, $5858);
            //	F930 : 58 58 58 58 58 58 58 58 48 48 48 48 58 58 58 58 XXXXXXXXHHHHXXXX
            DPoke(MAP_FNT_ADDRESS + $934, $2e2e);
            DPoke(MAP_FNT_ADDRESS + $936, $2e2e);

            Poke(MAP_FNT_ADDRESS + $50c, $04);
            Poke(MAP_FNT_ADDRESS + $50e, $04);
            Poke(MAP_FNT_ADDRESS + $534, $04);
            Poke(MAP_FNT_ADDRESS + $536, $04);
            Poke(MAP_FNT_ADDRESS + $50d, $05);
            Poke(MAP_FNT_ADDRESS + $50f, $05);
            Poke(MAP_FNT_ADDRESS + $535, $05);
            Poke(MAP_FNT_ADDRESS + $537, $05);
	        // F960 : 2E 2E 2E 2E 2E 2E 2E 2E 50 50 50 50 58 58 2E 2E ........PPPPXX..
            DPoke(MAP_FNT_ADDRESS + $960-4, $2e2e);
            DPoke(MAP_FNT_ADDRESS + $962-4, $2e2e);
            Poke(MAP_FNT_ADDRESS + $560-4, $1c);
            Poke(MAP_FNT_ADDRESS + $562-4, $1c);
            Poke(MAP_FNT_ADDRESS + $561-4, $1c);
            Poke(MAP_FNT_ADDRESS + $563-4, $1c);
        end
        else 
        begin 
            // 	F900 : 52 52 52 52 58 58 2E 2E 58 58 58 58 58 58 58 58 RRRRXX..XXXXXXXX
            // 	F910 : 48 48 48 48 58 58 58 58 50 50 50 50 58 58 58 58 HHHHXXXXPPPPXXXX
            DPoke(MAP_FNT_ADDRESS + $90c, $4e4e);
            DPoke(MAP_FNT_ADDRESS + $90e, $4e4e);
	        // F960 : 2E 2E 2E 2E 2E 2E 2E 2E 50 50 50 50 58 58 2E 2E ........PPPPXX..
            //	F930 : 58 58 58 58 58 58 58 58 48 48 48 48 58 58 58 58 XXXXXXXXHHHHXXXX
            DPoke(MAP_FNT_ADDRESS + $934, $4e4e);
            DPoke(MAP_FNT_ADDRESS + $936, $4e4e);
            DPoke(MAP_FNT_ADDRESS + $960-4, $4e4e);
            DPoke(MAP_FNT_ADDRESS + $962-4, $4e4e);

            {$I ./major_poke.pas}
        end 
    end;
end; 




procedure preloadMap;
begin;
    blackConsole();
    fntname[1] := char($41+currentMap);
    loadxAPL (fntname, Pointer(MAP_FNT_ADDRESS));
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
 
