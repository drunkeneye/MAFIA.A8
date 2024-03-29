

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


    procedure saveGame_in_map ();
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


    procedure loadGame_in_map ();
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




procedure waitForKey_new();
var k, m:byte;
begin
  k := CRT_WhereY();
  m := (40 - Length(waitKey_String)) SHR 1;
  CRT_Gotoxy(k+2, m);
  CRT_Write(waitKey_String);
  CRT_ReadKey();
end;



