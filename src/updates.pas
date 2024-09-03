

procedure jobWorking();
begin;
    enableConsole();
    CRT_Clear;
    CRT_WriteCentered(1, loc_name);
    CRT_Invert(0, 1, CRT_screenWidth);
    CRT_GotoXY(0, 3);
end;



procedure updateRank();
var oldRank, newRank:   byte;
    k: smallint;
    d: byte;
begin
    // update points, TODO: weighting is missing, maybe drop it altogether
    oldRank := plRank[currentPlayer];
    if plNewPoints[currentPlayer] > 0 then begin
        plPoints[currentPlayer] := plPoints[currentPlayer] + plNewPoints[currentPlayer];
        // add some slack (10 pt) just in case player gets some minus points, else it would
        // be tough fight to get exactly to gamePoints
        if plPoints[currentPlayer] > gamePoints+10 then plPoints[currentPlayer] := gamePoints+10; 
    end
    else 
    begin
        k := plPoints[currentPlayer] + plNewPoints[currentPlayer];
        if k < 0 then k := 0;
        plPoints[currentPlayer] := k;
    end; 
    plNewPoints[currentPlayer] := 0;

    d := gamePoints div 10;
    newRank := (plPoints[currentPlayer]+5) div d;
    if newRank > 10 then newRank := 10;

    // newRank := (plPoints[currentPlayer]+5) div 10;
    // if newRank > 10 then newRank := 10;

    // this means that if we loose points, we never loose rank
    if newRank > oldRank then
    begin
        blackConsole();
        loadLocation(MAIN_);
        PLAYERPOS_X := 0;
        PLAYERPOS_Y := 0;
        FillChar(Pointer(MAP_SCR_ADDRESS), 40*24, 0);
        tmp := currentPlayer SHL 3;
        if gangsterSex[tmp] = 0 then 
            loadxAPL (wanted_m_fname, Pointer(MAP_FNT_ADDRESS))
        else 
            loadxAPL (wanted_f_fname, Pointer(MAP_FNT_ADDRESS));
        enableMapConsole();
        mapColorA := $04;
        mapColorB := $0a;
        CRT_WriteCentered_LocStr(19, 3);
        CRT_NewLine();
        CRT_Write_LocStr(4);
        CRT_Write(gangsterNames[tmp]);
        CRT_Writeln_LocStr(5);
        CRT_Write_LocStr(6);
        CRT_Write(plGang[currentPlayer]);
        CRT_Writeln_LocStr(7);
        CRT_Writeln_LocStr(8);
        CRT_Write_LocStr(9);
        CRT_Write(rankNames[newRank]);
        CRT_Write(', '~);
        CRT_Write(plPoints[currentPlayer]);
        CRT_Write_LocStr(10);
        CRT_ReadKey();
        mapColorA := $88;
        mapColorB := $06;
        blackConsole();
        FillChar(Pointer(MAP_SCR_ADDRESS+40*15), 40*9, 0);
        plRank[currentPlayer] := newRank;
    end;
end;


procedure updateRent();
var pr:   word;
    k, r:   byte;
begin;
    for r := 0 to 3 do
    begin
        if plRent[r] <> currentPlayer then continue;

        if plRentMonths[currentPlayer] > 0 then
        begin
            plRentMonths[currentPlayer] := plRentMonths[currentPlayer] - 1;
            exit;
        end;

        loadLocation(MAIN_);

        // FIXME
        enableConsole();
        CRT_Clear;
        CRT_WriteCentered_LocStr(1, 13);
        CRT_Invert(0, 1, CRT_screenWidth);
        CRT_GotoXY(0, 3);

        pr := 250+Random(200); // should be more expensive than any hotel (<=200)
        CRT_Writeln_LocStr(14);
        CRT_Writeln_LocStr(15);

        // player has pay extra for overdue rent

        // has the money 
        if pr < plMoney[currentPlayer] then
        begin
            CRT_Writeln_LocStr(16);
            CRT_Write_LocStr(17);
            CRT_Write(pr);
            CRT_Writeln_LocStr(18);
            subMoney(pr);
            plRentMonths[currentPlayer] := 0;
            // next round has pay extra again
        end
        else
        begin
            // player has not the money, then we leave the rest
            // but clear out the gang
            CRT_Writeln_LocStr(19);
            if plNGangsters[currentPlayer] > 1 then
            begin
                CRT_Writeln_LocStr(20);
                CRT_Writeln_LocStr(21);
                for k := 0 to 31 do begin
                    if plGangsters[k] = currentPlayer then plGangsters[k] := 99;
                end;
                // but player is still there
                plGangsters[currentPlayer SHL 3] := currentPlayer;
                plNGangsters[currentPlayer] := 1;
                // and we do not rent anything anymore
            end;
            plRent[r] := 99; 
        end;
        waitForKey();
    end;
end;


procedure updateLoanShark();
var p:   word;
    k:   byte;
begin
    p := plLoanInvest[currentPlayer];
    // if there is invest, there cannot be any loan, so can skip below
    if p > 0 then
    begin;
        loadLocation(UPDATES_);
        jobWorking;
        if Random(3) = 0 then
        begin
            p := p SHR 6 + Random(0);
            addMoney(p);
            CRT_Writeln_LocStr(1);
            CRT_Write_LocStr(2);
            CRT_Write(p);
            CRT_Writeln_LocStr(3);
            waitForKey();
            exit;
        end
        else
            begin
                CRT_Writeln_LocStr(4);
                CRT_Writeln_LocStr(5);
                waitForKey();
                exit;
            end;
    end;

    // check for loan 
    if plLoan[currentPlayer] > 0 then
    begin
        k := plLoanTime[currentPlayer];
        loadLocation(UPDATES_);
        jobWorking;
        if k > 0 then
        begin
            CRT_Write_LocStr(6);
            CRT_Write(plLoan[currentPlayer]);
            CRT_Writeln_LocStr(7);
            CRT_Write_LocStr(8);
            CRT_Write(k);
            CRT_Writeln_LocStr(9);
            waitForKey();
            plLoanTime[currentPlayer] := k - 1;
            exit;
        end;

        CRT_Writeln_LocStr(10);
        CRT_Writeln2_LocStr(11);
        waitForKey();
        // fight 
        fp_AI[1] := 1;
        fp_N[1] := 5;
        fp_gang[1] := loc_string_12;
        for k := 0 to 4 do
        begin
            tmp := Random(2);
            fp_sex[16+k] := tmp;
            fp_name[16+k] := loc_string_12;
            fp_weapon[16+k] := 3;
            fp_energy[16+k] := 30;
            fp_strength[16+k] := 30;
            fp_brutality[16+k] := 30;
        end;

        if doFight() = 1 then
        begin
            enableConsole();
            // lost 
            jobWorking; //FIXME, maybe other title then
            CRT_Writeln_LocStr(13);
            CRT_Writeln_LocStr(14);
            plMoney[currentPlayer] := 0;
            plLoan[currentPlayer] := 0;
            waitForKey();
            exit;
        end;

        enableConsole();
        // lost 
        jobWorking;
        CRT_Writeln_LocStr(15);
        CRT_Writeln_LocStr(16);
        CRT_Writeln_LocStr(17);
        waitForKey();
        plLoanTime[currentPlayer] := 3+Random(3);
    end;
end;



// update opportunity, only weapon deal
procedure updateOpportunities();
var 
    pr:   word;
begin;
    if (plOpportunity[currentPlayer] and (1 SHL 3)) <> (1 SHL 3) then
        exit;

    loadLocation(MAIN_);

    enableConsole();
    CRT_Clear;
    CRT_WriteCentered_LocStr(1, 22);
    CRT_Invert(0, 1, CRT_screenWidth);
    CRT_GotoXY(0, 3);


    // no need to check, we now it already
    //    if plOpportunity[currentPlayer] and 128 = 128 then //weapondeal
    plOpportunity[currentPlayer] := plOpportunity[currentPlayer] and (255 - (1 SHL 3));
    if Random(5) = 0 then
    begin
        // armsdealer given 5000cash
        CRT_Writeln_LocStr(23);
        CRT_Writeln_LocStr(24);
    end
    else
        begin
            pr := 5500 + Random(150) SHL 6;
            CRT_Writeln_LocStr(25);
            CRT_Write_LocStr(26);
            CRT_Write(pr);
            CRT_Writeln('$!'~);
            addMoney(pr);
        end;
    waitForKey();
end;


procedure updateGangsters();
var   j,en, maxx:   byte;
begin
    for j := 0 to 31 do
    begin
        en := gangsterHealth[j];
        en := en + gangsterStr[j] SHR 3+1 + 1;
        maxx := 2 + gangsterBrut[j] SHR 2 + gangsterInt[j] SHR 2;
        if en > maxx then en := maxx;
        gangsterHealth[j] := en;
    end;
end;



procedure updatePrison();
var k, r:   byte;
    pr:   word;
begin
    loadLocation(MAIN_);
    // update prision
    if plPrison[currentPlayer] > 0 then
    begin
        currentMap := loc_map_places[0];
        loc_name := loc_string_27;
        ShowLocationHeader();
        CRT_Writeln_LocStr(28);
        CRT_Writeln_LocStr(29);
        CRT_Write('('~);
        CRT_Write( plPrison[currentPlayer]);
        CRT_Writeln_LocStr(30);
        plPrison[currentPlayer] := plPrison[currentPlayer] - 1;
        waitForKey;
        currentLocation := END_TURN_;
        exit;
    end;

    if plFreed[currentPlayer] <> 99 then
    begin
        CRT_Write_LocStr(31);
        k := plFreed[currentPlayer];
        r := k SHL 3;
        CRT_Write(gangsterNames[r]);
        CRT_Writeln_LocStr(32);
        CRT_Writeln_LocStr(33);
        CRT_Write_LocStr(34);
        CRT_Write(plMoney[currentPlayer]);
        CRT_Writeln(')? '~);
        pr := readValue(0, plMoney[currentPlayer]);
        if pr > 0 then
        begin
            payMoney(pr);
            addPoints(2);
            plMoney[k] := plMoney[k] + pr;
        end;
        plFreed[currentPlayer] := 99;
    end;
end;




function updateJob ():   byte;
var jobdone:   byte;
    r:   byte;
    p:   word;
begin;
    loadLocation(JOB_);
    jobWorking;

    if (plJobLocation[currentPlayer] = PUB_) or (plJobLocation[currentPlayer] = HIDEOUT_) then
    begin;
        CRT_Writeln_LocStr(1);
        CRT_Writeln_LocStr(2);
        effectWait();
        CRT_NewLine;
        if Random(2) = 0 then
        begin;
            CRT_Writeln_LocStr(3);
            waitForKey();
            jobdone := 1;
        end
        else
            begin;
                CRT_Writeln_LocStr(4);
                CRT_Writeln_LocStr(5);
                waitForKey;
                fp_sex[16] := 0;
                case Random(3) of 
                    0:   begin;
                            fp_gang[1] := loc_string_6;
                            fp_sex[16] := 1;
                          end;
                    1:   fp_gang[1] := loc_string_7;
                    2:   fp_gang[1] := loc_string_8;
                end;
                fp_AI[1] := 1;
                fp_N[1] := 1;
                fp_name[16] := fp_gang[1];
                fp_weapon[16] := 5;
                fp_energy[16] := 30;

                if doFight() = 1 then
                    jobdone := 0
                else
                    jobdone := 1;
                enableConsole();
            end;
    end;

    if plJobLocation[currentPlayer] = GAMBLING_ then
    begin;
        CRT_Writeln_LocStr(9);
        CRT_Writeln2_LocStr(10);
        CRT_Writeln_LocStr(11);
        CRT_Writeln_LocStr(12);
        CRT_Writeln_LocStr(13);
        CRT_Write_LocStr(14);
        CRT_Newline();
        r := readValue(1, 3);
        CRT_NewLine;
        CRT_NewLine;

        if Random(6) > r then
        begin
            p := Random(100)*r + 300;
            CRT_Writeln_LocStr(15);
            CRT_Write_LocStr(16);
            CRT_Write(p);
            CRT_Writeln('$!'~);
            addMoney(p);
            waitForKey();
            jobdone := 1;
        end
        else
            begin
                CRT_Writeln_LocStr(17);
                CRT_Writeln_LocStr(18);
                waitForKey();
                fp_AI[1] := 1;
                fp_N[1] := 1;
                fp_name[16] := loc_string_30;
                fp_gang[1] := loc_string_30;
                fp_sex[16] := 0;
                fp_weapon[16] := 1;
                fp_energy[16] := 10;
                fp_strength[16] := 30;
                fp_brutality[16] := 30;

                if doFight() = 1 then
                    jobdone := 0
                else
                    jobdone := 1;
                enableConsole();
            end;
    end;

    if plJobLocation[currentPlayer] = STREET_ then
    begin;
        CRT_Writeln_LocStr(19);
        CRT_Writeln_LocStr(20);
        waitForKey();
        fp_AI[1] := 1;
        fp_N[1] := 1;
        fp_name[16] := loc_string_31;
        fp_gang[1] := loc_string_31;
        fp_sex[16] := 0;
        fp_weapon[16] := 0;
        fp_energy[16] := 20;
        fp_strength[16] := 30;
        fp_brutality[16] := 30;

        if doFight() = 1 then
            jobDone := 0
        else
            jobDone := 1;
        enableConsole();
    end;


    if jobDone = 1 then
    begin
        plJob[currentPlayer] := plJob[currentPlayer] - 1;
        if plJob[currentPlayer] > 0  then exit;
        jobWorking;
        CRT_Writeln_LocStr(21);
        CRT_Write(plJobWage[currentPlayer]);
        CRT_Writeln_LocStr(22);
        waitForKey();
        addMoney(plJobWage[currentPlayer]);
        addPoints(3);
        // every job is 3, in original JOB=2 +6
        plJob[currentPlayer] := 0;
        plJobLocation[currentPlayer] := NONE_;
        exit;
    end;

    jobWorking;
    CRT_Writeln_LocStr(23);
    CRT_Writeln_LocStr(24);
    waitForKey();
    removePoints(2);
    plJobLocation[currentPlayer] := 0;
    plJob[currentPlayer] := 0;
end;
