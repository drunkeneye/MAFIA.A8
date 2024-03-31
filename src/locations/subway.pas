
function subwayChoices:   byte;
var 
    loot: shortint;
    value: word;
    hops: boolean;
    i,j,k:byte;
begin
    result := SUBWAY_;
    ShowLocationHeader;

    if currentChoice = 2 then
    begin
        CRT_Writeln_LocStr(1);
        CRT_Writeln_LocStr(2);
        if getYesNo() =0 then exit;
        if payMoney (50) = 0 then exit;
        loot := Random(4); // =new place on map
        case loot of 
            0: begin;
                    i := 8; j := 2; k := 2;
                end;
            1: begin;
                    i := 4; j := 1; k := 5;
                end;
            2: begin;
                    i := 8; j := 3; k := 9;
                end;
            3: begin;
                    i := 4; j := 7; k := 7;
                end;
        end;
        // pretend we fought
        plMapPosX[currentPlayer] := i;
        plMapPosY[currentPlayer] := j;
        plCurrentMap[currentPlayer] := k;
        placeCurrentPlayer ();
        oldMapPos_X := mapPos_X; // just to be sure...
        oldMapPos_Y := mapPos_Y;
        oldPlayerPos_X := playerPos_X;
        oldPlayerPos_Y := playerPos_Y; 
    end;

    ShowLocationHeader;
    if plNGangsters[currentPlayer] > 1 then 
        CRT_Write_LocStr(3);
    showWeapons :=0 ;
    selectGangster();
    if currentGangster = 99 then exit;

    ShowLocationHeader;
    CRT_Newline;
    CRT_Writeln_LocStr(4);
    WaitFrames(90);

    // 18040 ifint(rnd(1)*15)=10goto18052
    // 18041 ifint(rnd(1)*(in/10))goto18045
    hops := Random(gangsterInt[currentGangster]) < 10; 
    loot := Random(17) SHR 1;
    loot := loot - Random(currentSubLocation+1); //+1 to avoid Random(0)
    if loot < 0 then loot := 0;
    if hops = True then loot := 0;
    value := 0;
    case loot of 
        0: CRT_Writeln_LocStr(5);
        1,2: CRT_Writeln_LocStr(6);
        3: CRT_Writeln_LocStr(7);
        4: begin;
                CRT_Writeln_LocStr(8); 
                value := 50;
            end;
        5: begin;
                CRT_Writeln_LocStr(9); 
                value := 250;
            end;
        6: begin;
                CRT_Writeln_LocStr(10);
                value := 500;
            end;
        7: begin;
                CRT_Writeln_LocStr(11);
                value := 800;
            end;    
        8: begin;
                CRT_Writeln_LocStr(12);
                plStuff[currentPlayer] := plStuff[currentPlayer] or 32;
                waitForKey;
                exit;
            end;
    end;
    waitForKey;
    if loot < 1 then begin;
        gotCaught;
        result := END_TURN_;
        exit;
    end; 
    if currentChoice = 2 then loadMap();
    addMoney( value);
    addPoints(1);
end;

