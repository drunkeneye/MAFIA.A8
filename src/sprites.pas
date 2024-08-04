

const
    moveSpeed =  1;

// will return:
// 0=free-- TODO: does not happen right now.
// 1=end turn.
function gotoCourt():   byte;
var
    lawyer:   word;
    prisonTime:   shortint;
    r:   byte;
    i,j,k,t:   byte;
    change:   byte;
begin;
    // court means next location is police
    r := Random(4);
    case r of
        0: begin;
                i := 15; j := 2; k := 2;
            end;
        1: begin;
                i := 16; j := 2; k := 5;
            end;
        2: begin;
                i := 2; j :=10; k := 9;
            end;
        3: begin;
                i := 13; j := 10; k := 4;
            end;
    end;
    blackConsole();

    // we also do not allow any opportunities anymore
    plOpportunity[currentPlayer] := 0;

    // pretend we fought
    plMapPosX[currentPlayer] := i;
    plMapPosY[currentPlayer] := j;
    plCurrentMap[currentPlayer] := k;
    placeCurrentPlayer ();
    oldMapPos_X := mapPos_X;
    oldMapPos_Y := mapPos_Y;
    preloadMap();

    loadLocation(COURT_);
    enableConsole();
    prisonTime := 1+byte(plRank[currentPlayer] SHR 1);

    ShowLocationHeader;

    if plRank[currentPlayer] > 4 then
    begin;
        CRT_Writeln2_LocStr(1);
        r := getYesNo();
        if r = 1 then
        begin
            CRT_Write_LocStr(2);
            lawyer := readValue(0, 10000);
            CRT_NewLine();
            CRT_NewLine();
            t := payMoney (lawyer);
            if t = 1 then
            begin
                // yes, can affort it
                change := lawyer SHR 10+1; // if this is zero, Random(0) is 0..255
                change := Random(change) + 2;
                prisonTime := prisonTime - change;
                if prisonTime < 0 then
                    prisonTime := 0;
                plPrison[currentPlayer] := prisonTime;
                if prisonTime = 0 then
                begin;
                    addPoints(2);
                    CRT_Writeln_LocStr(3);
                    waitForKey;
                    result := 1;
                    exit;
                end;
                removePoints(3);
                CRT_Writeln_LocStr(4);
                CRT_Write (prisonTime);
                CRT_Writeln_LocStr(5);
                waitForKey;
                result := 1;
                exit;
            end;
        end;
    end;

    // lower than rank 5.
    plPrison[currentPlayer] := prisonTime;
    CRT_Write_LocStr(6);
    CRT_Write (prisonTime);
    CRT_Write_LocStr(7);
    plJob[currentPlayer] := 0;
    removePoints(3);
    waitForKey;
    result := 1;
    exit;
end;



// returns either 0=all ok or 1=end round, player was sentenced.
function gotCaught:   byte;
var
    a:   byte;
    r:   byte;
    price:   word;
begin
    loadLocation(CAUGHT_);
    enableConsole();

    ShowLocationHeader;

    // check bribe
    if (plBribe[currentPlayer] > 0) and (Random(2) = 1) then
    begin
        CRT_Writeln_LocStr(1);
        CRT_Writeln_LocStr(2);
        waitForKey;
        result := 0;
        exit;
    end;

    CRT_Writeln2_LocStr(3);
    CRT_Writeln_LocStr(4);
    CRT_Writeln_LocStr(5);
    CRT_Writeln2_LocStr(6);

    CRT_Write_LocStr(7);
    a := readValueNoZero(1,3);
    CRT_NewLine();
    CRT_NewLine();
    if a = 1 then
    begin
        price := 500 + 500*plRank[currentPlayer];
        CRT_Write_LocStr(8);
        CRT_Write(price);
        CRT_Writeln2_LocStr(9);
        r := getYesNo();
        if r = 1 then // N=0, Y=1
        begin
            if payMoney(price) = 0 then
            begin;
                // not enough money
                result := gotoCourt();
                exit;
            end
            else
                begin;
                    if Random(5) = 0 then
                    begin
                        CRT_Writeln_LocStr(10);
                        waitForKey;
                        result := gotoCourt();
                        exit;
                    end;

                    // paid and all ok
                    CRT_Writeln_LocStr(11);
                    waitForKey;
                    result := 0;
                    exit;
                end;
        end
        else
            begin
                // we ignore this, that a play er gets +2 points iff he refuses to pay the cops
                // after having asked for it!
                // addPoints(2)
                result := gotoCourt();
            end;
    end;

    if a = 2 then
    begin
        // 26040 ifint(rnd(1)*tr(sp)/11)=0thenx=-5:UPDATE_PUNKTE:goto26042
        if Random(80) > carRange[plCar[currentPlayer]] then
        begin
            removePoints(4);
            CRT_Writeln_LocStr(12);
            CRT_Writeln_LocStr(13);
            waitForKey;
            result := gotoCourt();
            exit;
        end;
        CRT_Writeln_LocStr(14);
        addPoints(2);
        waitForKey;
        result := 0;
        exit;
    end;

    if a = 3 then
        result := gotoCourt();
end;


function roadBlock():   byte;
begin;
    // ensure the map status below reloads, e.g. if alcohol is confiscated
    mapReloaded := 1;
    result := 0;
    // in original: every 20 steps+10% probabilty, here we just make it randomy 1/224
    if plRank[currentPlayer] < 4 then exit;
    if Random(224) > 0 then exit;

    loadLocation(ROADBLOCK_);
    enableConsole();
    ShowLocationHeader;

    CRT_Writeln_LocStr(1);
    CRT_Newline();
    Waitframes(120);

    if Random(2) = 0 then
    begin
        result := 1;
        if plFakeMoney[currentPlayer] > 0 then
            CRT_Writeln(loc_string_2)
        else if plAlcohol[currentPlayer] > 0 then
            begin
                CRT_Writeln_LocStr(3);
                CRT_Writeln_LocStr(4);
                plAlcohol[currentPlayer] := 0;
            end
        else if plForgedID[currentPlayer] = 0 then
                 CRT_Writeln(loc_string_5)
        else
            result := 0;
    end;

    if result = 0 then
        CRT_Writeln_LocStr(6);
    waitForKey();
end;



// only for y-direction, x-direction taken care of DLI
procedure paintPlayer(clear: byte);
var
    playerHeight:   byte;
    playerOfs:   byte;
    z: byte;
begin
    //  for now player is there
    // FIXME: length of player must  be written somewhere
    playerOfs := 0;
    z := currentPlayer SHL 3;
    if gangsterSex[z] = 1 then playerOfs := 48;
    playerHeight := 12;
    // color for color
    Move (Pointer(PMG_BASE_ADR+playerOfs), Pointer(PMG_BASE_ADR+1024+playerPos_Y), playerHeight);
    Move (Pointer(PMG_BASE_ADR+playerOfs+playerHeight), Pointer(PMG_BASE_ADR+1280+playerPos_Y), playerHeight);
    Move (Pointer(PMG_BASE_ADR+playerOfs+2*playerHeight), Pointer(PMG_BASE_ADR+1536+playerPos_Y), playerHeight);
    Move (Pointer(PMG_BASE_ADR+playerOfs+3*playerHeight), Pointer(PMG_BASE_ADR+1792+playerPos_Y), playerHeight);
    if clear = 1 then
    begin
        playerOfs := playerPos_Y-1;
        FillChar (Pointer(PMG_BASE_ADR+1024+playerOfs), 1, 0);
        FillChar (Pointer(PMG_BASE_ADR+1280+playerOfs), 1, 0);
        FillChar (Pointer(PMG_BASE_ADR+1536+playerOfs), 1, 0);
        FillChar (Pointer(PMG_BASE_ADR+1792+playerOfs), 1, 0);

        playerOfs := playerPos_Y+playerHeight;
        FillChar (Pointer(PMG_BASE_ADR+1024+playerOfs), 1, 0);
        FillChar (Pointer(PMG_BASE_ADR+1280+playerOfs), 1, 0);
        FillChar (Pointer(PMG_BASE_ADR+1536+playerOfs), 1, 0);
        FillChar (Pointer(PMG_BASE_ADR+1792+playerOfs), 1, 0);
    end;
end;


function MoveCurrentPlayer (ch: char):   byte;
var
    j:   byte;
    dir_x:   shortint;
    dir_y:   shortint;
    lencID:   byte;
    leaveMap:   byte;
    curLoc:   byte;
    r:   byte;
begin
    // mad pascal treats there as local static
    curLoc := STREET_;
    result := STREET_;
    // we must be on the street because else.
    dir_x := 0;
    dir_y := 0;
    case ch of
        #06:   dir_x := -1;
        #07:   dir_x := +1;
        #14:   dir_y := -1;
        #15:   dir_y := +1;
        else
            begin;
                WaitFrames(moveSpeed);
                exit;
            end;
    end;

    // check if we leave the map
    // to right
    leaveMap := 0;
    if (mapPos_X = 19) and (dir_x = 1) then leaveMap := 1;
    if (mapPos_X = 0) and (dir_x = -1) then leaveMap := 1;
    if (mapPos_Y = 17) and (dir_y = 1) then leaveMap := 1;
    if (mapPos_Y = 0) and (dir_y = -1) then leaveMap := 1;
    if leaveMap = 0 then
    begin
        lencID := Peek(LOC_MAP_ADR+(mapPos_Y+1+dir_y)*40+mapPos_X SHL 1+dir_x SHL 1);
        // repeat;
        // until false;
        case lencID of
            65:   curLoc := ARMSDEALER_;
            66:   curLoc := CARDEALER_;
            67:   curLoc := FORGERY_;
            68:   curLoc := LOANSHARK_;
            69:   curLoc := PUB_;
            70:   curLoc := SUBWAY_;
            71:   curLoc := BANK_;
            72:   curLoc := GAMBLING_;
            73:   curLoc := HIDEOUT_;
            74:   curLoc := POLICE_;
            75:   curLoc := STORE_;
            76:   curLoc := CENTRALSTATION_;
            77:   curLoc := MONEYTRANSPORT_;
            78:   curLoc := MAJOR_;
            46:   curLoc := STREET_;
            else
                curLoc := NONE_;
        end;
    end;

    if curLoc = NONE_ then
    begin;
        result := STREET_;
        exit;
    end;

    plSteps[currentPlayer] := plSteps[currentPlayer] - 1;
    oldMapPos_X := mapPos_X;
    oldMapPos_Y := mapPos_Y;
    oldPlayerPos_X := playerPos_X;
    oldPlayerPos_Y := playerPos_Y;
    mapPos_X := mapPos_X + dir_x;
    mapPos_Y := mapPos_Y + dir_y;


    // we can walk
    playMusic := 1;
    msx.init ($0e);
    msx.play();

    if dir_y <> 0 then
    begin;
        for j := 0 to 7 do
        begin
            // take care of things...
            playerPos_Y := playerPos_Y + dir_y;
            paintPlayer (1);
            WaitFrames(moveSpeed);
        end;
    end;

    if dir_x <> 0 then
    begin;
        for j := 0 to 7 do
        begin
            playerPos_X := playerPos_X + dir_x;
            paintPlayer (0);
            WaitFrames(moveSpeed);
        end;
    end;

    msx.stop();
    playMusic := 0;


    // check for roadblock now
    if curLoc = STREET_ then
    begin
        // END_TURN_
        j := roadBlock();
        if j > 0 then
        begin
            // this is the police
            r := gotCaught();
            if r = 0 then
            begin;
                result := STREET_;
                enableMapConsole();
                // FOR NOW
            end
            else
                begin;
                    result := END_TURN_;
                    exit;
                end;
        end
        else
            begin
                enableMapConsole();
            end;
    end;
    result := curLoc;
end;


procedure clearSprites();
begin;
    FillChar(Pointer(PMG_BASE_ADR+768),2048-768,$0);
end;


procedure enableSprites();
begin;
    // clear sprite first
    clearSprites();
    //https://github.com/playermissile/dli_tutorial/blob/master/src/util_pmg.s
    asm;
        // we need to put it into registers directly,  because we do not have
        // the OS activated, so we have no routine that copies shadow to registers.
        lda #$3e        // single line, both players & missiles
        sta SDMCTL      // shadow of DMACTL
        sta DMACTL
        lda #1          // players in front of playfields
        sta $26f        // shadow of PRIOR WHY GPRIOR DOES NOT EXIST?
        sta $D01B
        lda #3          // turn on missiles & players
        sta GRACTL      // no shadow for this one
        lda #>PMG_BASE_ADR      // high byte of player storage
        sta PMBASE      // missiles = $7b00, player0 = $7c00

        lda #$00     // eyes and tie
        sta PCOLR0
        lda #$14   // face/beard
        sta PCOLR1
        lda #$74        // main player color
        sta PCOLR2
        lda #$0e   //face and shirt
        sta PCOLR3
    end;
end;
