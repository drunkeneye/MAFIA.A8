var 
    fp_winner:   byte absolute VARFIGHT;
    fp_AI:   array[0..1] of byte absolute VARFIGHT + $1;
    fp_N :   array[0..1] of byte absolute VARFIGHT + $3;
    fp_posW :   array[0..16*2-1] of word absolute VARFIGHT + $5;
    fp_weapon:   array[0..16*2-1] of byte absolute VARFIGHT + $45;
    fp_energy:   array[0..16*2-1] of byte absolute VARFIGHT + $85; 
    fp_strength:   array[0..16*2-1] of byte absolute VARFIGHT + $C5;
    fp_brutality:   array[0..16*2-1] of byte absolute VARFIGHT + $105;
    fp_sex: array[0..16*2-1] of byte absolute VARFIGHT + $145;
    fp_gang_1:   XString absolute VARFIGHT + $185;
    fp_gang_2:   XString absolute VARFIGHT + $195;

    fp_name_1:   XString absolute VARFIGHT + $1A5;
    fp_name_2:   XString absolute VARFIGHT + $1B5;
    fp_name_3:   XString absolute VARFIGHT + $1C5;
    fp_name_4:   XString absolute VARFIGHT + $1D5;
    fp_name_5:   XString absolute VARFIGHT + $1E5;
    fp_name_6:   XString absolute VARFIGHT + $1F5;
    fp_name_7:   XString absolute VARFIGHT + $205;
    fp_name_8:   XString absolute VARFIGHT + $215;
    fp_name_9:   XString absolute VARFIGHT + $225;
    fp_name_10:   XString absolute VARFIGHT + $235;
    fp_name_11:   XString absolute VARFIGHT + $245;
    fp_name_12:   XString absolute VARFIGHT + $255;
    fp_name_13:   XString absolute VARFIGHT + $265;
    fp_name_14:   XString absolute VARFIGHT + $275;
    fp_name_15:   XString absolute VARFIGHT + $285;
    fp_name_16:   XString absolute VARFIGHT + $295;
    fp_name_17:   XString absolute VARFIGHT + $2A5;
    fp_name_18:   XString absolute VARFIGHT + $2B5;
    fp_name_19:   XString absolute VARFIGHT + $2C5;
    fp_name_20:   XString absolute VARFIGHT + $2D5;

var 
    fp_currentPlayer:   byte absolute VARFIGHT + $2E5;
    fp_currentSite:   byte absolute VARFIGHT + $2E6;
    fp_currentCommand:   char absolute VARFIGHT + $2E7;
    fp_validCmd:   shortint absolute VARFIGHT + $2E8;

var 
    shoot_diff:   shortint absolute VARFIGHT + $2E9;
    shoot_start:   smallint absolute VARFIGHT + $2EA;
    f_curPos:   word absolute VARFIGHT + $2EF;



const
    fight_bulletTime: byte = 3;
    fight_hitTime: byte = 20; 
    fight_textTime: byte = 50;
    fight_roundTime: byte = 5;
    fight_deadTime: byte = 70;

    // locals
var
    fp_gang:   array[0..1] of ^XString =   (@fp_gang_1, @fp_gang_2);
    fp_name:   array[0..16*2-1] of ^XString =   (@fp_name_1, @fp_name_2, @fp_name_3, @fp_name_4,
                                                 @fp_name_5, @fp_name_6, @fp_name_7, @fp_name_8, @fp_name_9, @fp_name_10,
                                                 @fp_name_10, @fp_name_10, @fp_name_10, @fp_name_10, @fp_name_10, @fp_name_10,
                                                 @fp_name_11, @fp_name_12, @fp_name_13, @fp_name_14,
                                                 @fp_name_15, @fp_name_16, @fp_name_17, @fp_name_18, @fp_name_19, @fp_name_20,
                                                 @fp_name_20, @fp_name_20, @fp_name_20, @fp_name_20, @fp_name_20, @fp_name_20);