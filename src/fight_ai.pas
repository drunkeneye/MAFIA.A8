

function fight_checkShoot ():   byte;
var 
    k:   word;
    r, v, w, t:   byte;
begin;
    result := 0;
    fight_setShootStart();
    f_curPos := MAP_SCR_ADDRESS+fp_posW[fp_currentPlayer];
    r := weaponReach[fp_weapon[fp_currentPlayer]];

    // 40=max of screen in any direction
    for v := 0 to 40 do
    begin;
        // check for reach
        if v = r then exit;

        k := f_curPos+shoot_start+shoot_diff;
        w := Peek(k);
        if w = 0 then
        begin;
            shoot_start := shoot_start + shoot_diff;
            continue;
        end;
        if w = 1 then break;

        // we hit something!
        t := checkHit (k);
        if t = 128 then continue; // double-check 

        // would hit our own guy
        if ((fp_currentSite = 0) and (t < 16)) or ((fp_currentSite = 1) and (t > 15)) then
        begin;
            result := 0;
            exit;
        end;

        // currently only wall, or players, so this will hit an enemy
        result := 1;
        exit;
    end;
    // can come here if we hit a wall
    result := 0;
end;


procedure fight_aiMove();
var s:   byte;
    dx, dy:   shortint;
    ii: byte;
    cp, ep, dist, ne, nd:   smallint;
begin;
    for s := 0 to 3 do
    begin;
        case s of 
            0: shoot_diff := -1;
            1: shoot_diff := 1;
            2: shoot_diff := -40;
            3: shoot_diff := 40;
        end;
        if fight_checkShoot() <> 0 then
        begin;
            fight_shoot();
            exit;
        end;
    end;

    // we have to move
    // find nearest enemy 
    ne := 0;
    nd := 999;
    cp := fp_posW[fp_currentPlayer];
    for ii := 0 to fp_N[1-fp_currentSite]-1 do
    begin;
        // ignore dead ones
        dx := (1-fp_currentSite) SHL 4;
        if fp_energy[dx + ii] = 0 then continue;
        ep := fp_posW[dx + ii];

        dx := cp mod 40 - ep mod 40;
        dy := cp div 40 - ep div 40;
        dist := dx*(1 - 2*byte(dx < 0)) + dy*(1 - 2*byte(dy < 0));
        if dist < nd then
        begin;
            ne := ii;
            nd := dist;
        end;
    end;

            // #$02: = left 
            // #$73: = right
            // #$60: = up
            // #$26:  = down

    dx := (1-fp_currentSite) SHL 4;
    dx := dx + ne;
    ep := fp_posW[dx];
    dx := cp mod 40 - ep mod 40;
    dy := cp div 40 - ep div 40;

    // choose randomly where to go
    if Random(2) = 1 then 
    begin 
        if dx < 0 then fp_currentCommand := #$73 else fp_currentCommand := #$02;
    end 
    else 
    begin
        if dy < 0 then fp_currentCommand := #$26 else fp_currentCommand := #$60;
    end;
    // TODO; if diff is 1/-1 do close this gap to get in shooting range... more or less.
 
    fight_clearCurrentPlayer;
    fight_moveCurrentPlayer;
    // not able to move? then move in a random direction
    if fp_validCmd = 0 then 
    begin;
        case fp_currentCommand of 
            #$26: if Random(2) =1 then fp_currentCommand := #$02 else fp_currentCommand := #$73;
            #$60: if Random(2) =1 then fp_currentCommand := #$02 else fp_currentCommand := #$73;
            #$02: if Random(2) =1 then fp_currentCommand := #$26 else fp_currentCommand := #$60;
            #$73: if Random(2) =1 then fp_currentCommand := #$26 else fp_currentCommand := #$60;
        end; 
        fight_moveCurrentPlayer;
    end; 
end;

