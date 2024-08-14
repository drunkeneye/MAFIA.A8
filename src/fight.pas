
function setupFightArena(): byte;
var i:   byte;
    c:   byte;
begin
    // no sprites, all soft-sprite, so turn sprites off
    PLAYERPOS_X := 0;
    PLAYERPOS_Y := 0;
    // clear area below, since map will not cover all screen
    FillChar(Pointer(MAP_SCR_ADDRESS), 40*24, 0);
    enableMapConsole();
    loadxAPL (fightfntname, Pointer(MAP_FNT_ADDRESS));
    loadxAPL (fightscrname, Pointer(MAP_SCR_ADDRESS));
    FillChar (Pointer (MAP_SCR_ADDRESS+19*40), 5*40, ' '~);
    
    // remember that we loaded a new map
    didFight := 1;

    if (fp_N[0] < 1) or (fp_N[1] < 1) then begin 
        CRT_WriteCentered(22, 'ERROR:0 enemy.'~);
        CRT_ReadKey();
        exit;
    end;

    // set positions
    for i := 0 to 31 do
        fp_posW[i] := fpPosStart[i];

    c := 0;
    CRT_WriteRightAligned(19, fp_gang[1]);
    CRT_GotoXY(0,19);
    CRT_Write(fp_gang[0]);
    CRT_Invert(0, 19, CRT_screenWidth);

    fp_winner := 99;
    repeat;
        for fp_currentSite := 0 to 1 do
        begin;
            for i := 0 to fp_N[fp_currentSite]-1 do
            begin;
                fp_currentPlayer := fp_currentSite SHL 4 + i;
                if fp_energy[fp_currentPlayer] = 0 then continue;
                fight_displayStats();
                fight_drawPlayers;
                WaitFrames(fight_roundTime);

                if fp_AI[fp_currentSite] = 1 then fight_aiMove()
                else fight_playerMove();

                fight_checkWinner();
                if fp_winner <> 99 then break;
            end;
            if fp_winner <> 99 then break;
        end;
    until fp_winner <> 99;

    // TODO; depends on who started the fight
    FillChar (Pointer (MAP_SCR_ADDRESS+19*40), 5*40, ' '~);
    CRT_WriteCentered(21, fight_string_6);
    CRT_WriteCentered(22, fp_gang[fp_winner]);
    CRT_ReadKey();
    result := fp_winner;
end;



function doFight:   byte;
var j, k, w: byte;
begin;
    result := 1;

    // other party only if AI
    for j := 0 to 1 do 
        if fp_AI[j] = 1 then 
        begin
            for k := 0 to fp_N[j]-1 do begin
                fp_strength[j SHL 4+k] := 30;
                fp_brutality[j SHL 4+k] := 30;
            end;
        end;

    // other party was setup, only do own party
    fp_N[0] := plNGangsters[currentPlayer];
    fp_gang[0] := plGang[currentPlayer];
    fp_AI[0] := 0;

    k := 0;
    for j := 0 to 31 do
    begin;
        if plGangsters[j] = currentPlayer then 
        begin;
            fp_name[k] := gangsterNames[j];
            fp_energy[k] := gangsterHealth[j];
            fp_weapon[k] := gangsterWeapon[j];
            fp_strength[k] := gangsterStr[j];
            fp_brutality[k] := gangsterBrut[j];
            fp_sex[k] := gangsterSex[j];
            k := k + 1;
        end;
    end;

    //fp_AI[1] := 1;
    w := setupFightArena();

    // update energy
    k := 0;
    for j := 0 to 31 do
    begin;
        if plGangsters[j] = currentPlayer then 
        begin;
            gangsterHealth[j] := fp_energy[k];
            // dead people get at least 5 energy back       
            if gangsterHealth[j] < 5 then gangsterHealth[j] := 5;
            k := k + 1;
        end;
    end;

    result := w;
    // enable map console after fight
    enableMapConsole();
end;



