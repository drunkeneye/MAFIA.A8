

//2,3,6,7 //4,5,8,9
//2,3,10,11 //4,5,12,13 = male 
//6,7,14,15 //8,9,16,17 = female
procedure fight_putPlayer(p:word; s:byte; d:byte; x:byte);
begin;
    s := s SHL 7 + d SHL 1;
    if x = 1 then 
        s := s + 4;
    Poke(MAP_SCR_ADDRESS+p, s+2);
    Poke(MAP_SCR_ADDRESS+p+1, s+3);
    Poke(MAP_SCR_ADDRESS+p+40, s+10);
    Poke(MAP_SCR_ADDRESS+p+41, s+11);
end;


// TODO: add facing direction maybe
procedure fight_drawCurrentPlayer;
var p:   word;
    s:   byte;
begin;
    s := fp_currentSite SHL 7 + fp_currentSite SHL 1;
    if fp_sex[fp_currentPlayer] = 1 then 
        s := s + 4;
    p := fp_posW[fp_currentPlayer];
    Poke(MAP_SCR_ADDRESS+p, s+2);
    Poke(MAP_SCR_ADDRESS+p+1, s+3);
    Poke(MAP_SCR_ADDRESS+p+40, s+10);
    Poke(MAP_SCR_ADDRESS+p+41, s+11);
end;


procedure fight_clearPlayer(p: word);
begin;
    Poke(MAP_SCR_ADDRESS+p, 0);
    Poke(MAP_SCR_ADDRESS+p+1, 0);
    Poke(MAP_SCR_ADDRESS+p+40, 0);
    Poke(MAP_SCR_ADDRESS+p+41, 0);
end;


procedure fight_clearCurrentPlayer;
var p:   word;
begin;
    p := fp_posW[fp_currentPlayer];
    Poke(MAP_SCR_ADDRESS+p, 0);
    Poke(MAP_SCR_ADDRESS+p+1, 0);
    Poke(MAP_SCR_ADDRESS+p+40, 0);
    Poke(MAP_SCR_ADDRESS+p+41, 0);
end;


procedure fight_drawPlayers();
var i:   byte;
    s:   byte;
    q: byte;
begin
    for s := 0 to 1 do
        for i := 0 to fp_N[s]-1 do
        begin
            q := s SHL 4 + i;
            if fp_energy[q] > 0 then
            begin
                fight_putPlayer(fp_posW[q], s, s, fp_sex[q]);
            end;
        end;
end;



// return 128 if no player was hit, else player number
function checkHit (k: word):   byte;
var z:   word;
    s, i:   byte;
begin
    for s := 0 to 1 do
        for i := 0 to fp_N[s]-1 do
        begin;
            // do not hit ghosts, please
            if fp_energy[s SHL 4 + i] = 0 then continue;

            z := MAP_SCR_ADDRESS + fp_posW[s SHL 4 + i];
            result := s SHL 4 + i;
            if (k = z) then exit;
            z := z + 1;
            if (k = z) then exit; 
            z := z + 39;
            if (k = z) then exit; 
            z := z + 1;
            if (k = z) then exit; 
            // if (k = z) or (k = z+1) or (k = z+40) or (k = z+41) then
            // begin
            //     result := s SHL 4 + i;
            //     exit;
            // end;
        end;
    result := 128;
end;


// set the shoot start depending on shoot_dir
procedure fight_setShootStart ();
begin;
    case shoot_diff of 
        -1:   shoot_start := 40;
        1:   shoot_start := 41;
        -40:   shoot_start := 0;
        40:   shoot_start := 40;
    end;
end;


function fight_shoot ():   byte;
var 
    k:   word;
    e, r, v, w, t:   byte;
    hit:   byte;
    hitPlayer:   byte;
    t1, t2, t3, t4: byte;
    st: string[40];
begin;
    fight_setShootStart();
    f_curPos := MAP_SCR_ADDRESS+fp_posW[fp_currentPlayer];
    e := fp_weapon[fp_currentPlayer];
    r := weaponReach[e];
    hitPlayer := 0;
    for v := 0 to 40 do
    begin;
        // check for reach
        if v = r then exit;

        // 40=max of screen in any direction
        k := f_curPos+shoot_start+shoot_diff;
        w := Peek(k);
        if (shoot_diff = 1) or (shoot_diff = -1) then
            Poke (k, 18) //char code for bullet is 10, for vertical 11
        else
            Poke (k, 19);
        WaitFrames(fight_bulletTime);
        Poke(f_curPos+shoot_start+shoot_diff, w);

        if w = 0 then
        begin;
            shoot_start := shoot_start + shoot_diff;
            continue;
        end;
        if w = 1 then break;

        // we hit something!
        t := checkHit (k);
        if t < 128 then
        begin;
            WaitFrames(fight_hitTime);
            // compute damage
            // the same i think // 30247 ifint(rnd(1)*ts(w))=0orint(rnd(1)*(kr/10+1))=0goto30235
            //             2 --> 0..2 --> 1/4 miss , 7 --> 0..7 --> 1/14 miss 
            t1 := Random(8);
            t2 := weaponPrecision[e] SHL 1;
            t3 := Random(12);
            t4 := fp_strength[fp_currentPlayer] SHR 3+1;
            if (t1 > t2) and (t3 > t4) then break;
            // if (Random(8) > weaponPrecision[e] SHL 1) and (Random(12) < fp_strength[fp_currentPlayer] SHR 3+1) then break;
            hit := (weaponEffect[e] + fp_brutality[fp_currentPlayer] SHR 3);
            if hit = 0 then break;

            CRT_Gotoxy(0,20);
            CRT_Write(fight_string_1);
            CRT_Write(fp_name[t]);
            CRT_Write(' '~);
            CRT_Write(fight_string_2);

            // st := Concat(fight_string_1, fp_name[t]);
            // st := Concat(st, fight_string_2);
//            CRT_WriteCentered(20, st);
            WaitFrames(fight_textTime);
            if fp_energy[t] <= hit then
            begin
                fp_energy[t] := 0;
                CRT_Gotoxy(0,20);
                CRT_Write(fight_string_3);
                CRT_Write(fp_name[t]);
                CRT_Write(' '~);
                CRT_Write(fight_string_4);
                WaitFrames(fight_deadTime);
                fight_clearPlayer(fp_posW[t]);
            end
            else
                fp_energy[t] := fp_energy[t] - hit;
            result := t;
            // clean 
            FillChar (Pointer (MAP_SCR_ADDRESS+20*40), 1*40, ' '~);

            exit;
        end;
    end;
    CRT_GotoXY(0, 20);
    CRT_Write(fight_string_5);
    WaitFrames(fight_textTime);
    result := hitPlayer;
end;

 

procedure fight_checkWinner();
var 
    s, i:   byte;
    partyDead:   byte;
begin;
    for s := 0 to 1 do
    begin;
        partyDead := 1;
        for i := 0 to fp_N[s]-1 do
        begin;
            if fp_energy[s SHL 4 +i] = 0 then
                continue;
            partyDead := 0;
        end;
        if partyDead <> 0 then
        begin;
            fp_winner := 1-s;
            exit;
        end;
    end;
end;



procedure fight_displayStats();
begin;
    FillChar (Pointer (MAP_SCR_ADDRESS+21*40), 3*40, ' '~);
    if fp_currentSite = 0 then
    begin;
        CRT_GotoxY(0,21);
        CRT_Write(fp_Name[fp_currentPlayer]);
        CRT_GotoxY(0,22);
        CRT_Write('E:'~);
        CRT_Write(fp_energy[fp_currentPlayer]);
        CRT_GotoxY(0,23);
        CRT_Write('W:'~);
        CRT_Write(weaponNames[fp_weapon[fp_currentPlayer]]);
    end
    else 
    begin 
        CRT_WriteRightAligned(21, fp_Name[fp_currentPlayer]);
        CRT_WriteRightAligned(22, Concat ('E:'~, Atascii2Antic(IntToStr(fp_energy[fp_currentPlayer]))));
        CRT_WriteRightAligned(23, Concat ('W:'~, weaponNames[fp_weapon[fp_currentPlayer]]));
    end;
end;




procedure fight_moveCurrentPlayer();
// needs fp_currentCommand, fp_currentPlayer, fp_validCmd
begin;
    fp_validCmd := 0;
    f_curPos := MAP_SCR_ADDRESS+fp_posW[fp_currentPlayer];
    if (#$02 = fp_currentCommand) then // left
        if (Peek(f_curPos - 1) = 0) then
            if (Peek(f_curPos + 40 - 1) = 0) then
                fp_validCmd := -1;

    if (#$73 = fp_currentCommand) then //right
        if (Peek(f_curPos + 2) = 0) then
            if (Peek(f_curPos + 40 + 2) = 0) then
                fp_validCmd := 1;

    if (#$60 = fp_currentCommand) then //up
        if (Peek(f_curPos - 40) = 0) then
            if (Peek(f_curPos - 40 + 1) = 0) then
                fp_validCmd := -40;

    if (#$26 = fp_currentCommand) then // down
        if (Peek(f_curPos + 80) = 0) then
            if (Peek(f_curPos + 80 + 1) = 0) then
                fp_validCmd := 40;

    if fp_validCmd <> 0 then
    begin
        fight_clearCurrentPlayer();
        fp_posW[fp_currentPlayer] := fp_posW[fp_currentPlayer] + fp_validCmd;
    end;
end;


// just for return key for now
procedure waitForKeyRelease;
var ch: char;
begin;
    // wait for return key to be released 
    repeat;
        ch := checkKeyAndStick ();
    until ch <> #$0c;
end;


procedure fight_attackCurrentPlayer();
var ch:   char;
    currentBlink:   byte;
begin;
    // shoot with enter
    if (fp_currentCommand = #$0c) then
    begin;
        // ensure player is drawn
        fight_drawCurrentPlayer();
        waitForKeyRelease();

        currentBlink := 0;
        repeat;
            WaitFrame;
            if currentBlink = 5 then
                fight_clearCurrentPlayer();
            if currentBlink = 10 then
            begin
                currentBlink := 0;
                fight_drawCurrentPlayer();
            end;
            currentBlink := currentBlink + 1;
            ch := checkKeyAndStick ();
        until (ch = #$26) or (ch = #$60) or (ch = #$73) or (ch = #$02) or (ch = #$0c);

        fight_drawPlayers;
        case ch of 
            #$02:   shoot_diff := -1;
            #$73:   shoot_diff := 1;
            #$60:   shoot_diff := -40;
            #$26:   shoot_diff := 40;
            #$0c:
                    begin;
                        waitForKeyRelease();
                        fp_validCmd := 0;
                        exit;
                    end;
        end;
        fight_shoot();
        fp_validCmd := 1;
        exit;
    end;
    fp_validCmd := 0;
end;



// returns fp_currentCommand
procedure fight_waitForCommand();
var ch:   char;
    currentBlink :   byte;
begin;
    currentBlink := 0;
    repeat;
        WaitFrame;
        if currentBlink = 30 then
            fight_clearCurrentPlayer;
        if currentBlink = 60 then
        begin
            currentBlink := 0;
            fight_drawCurrentPlayer;
        end;
        currentBlink := currentBlink + 1;
        ch := checkKeyAndStick ();
    until ch <> #$0;
    fp_currentCommand := ch;
end;



procedure fight_playerMove();
begin;
    repeat;
        fight_waitForCommand();

        // next player if space is pressed
        if (fp_currentCommand = #$21) then exit;

        // loose if q is pressed
        if (fp_currentCommand = #$2f) then
        begin;
            fp_winner := 1-fp_currentSite;
            exit;
        end;

        // else we first try to move
        fight_moveCurrentPlayer();
        // no valid move or command was not move
        if fp_validCmd = 0 then
            fight_attackCurrentPlayer();
    until fp_validCmd <> 0;
end;



