
var 
    fp_winner:   byte absolute $ec00;
    fp_AI:   array[0..1] of byte absolute $ec01;
    fp_N :   array[0..1] of byte absolute $ec03;
    fp_posW :   array[0..16*2-1] of word absolute $ec05;
    fp_weapon:   array[0..16*2-1] of byte absolute $ec45;
    fp_energy:   array[0..16*2-1] of byte absolute $ec85; //FIXME
    fp_strength:   array[0..16*2-1] of byte absolute $ecc5;
    fp_brutality:   array[0..16*2-1] of byte absolute $ed05;
    fp_sex: array[0..16*2-1] of byte absolute $ed45;
    fp_gang_1:   XString absolute $ed85;
    fp_gang_2:   XString absolute $ed95;

    fp_name_1:   XString absolute $eda5;
    fp_name_2:   XString absolute $edb5;
    fp_name_3:   XString absolute $edc5;
    fp_name_4:   XString absolute $edd5;
    fp_name_5:   XString absolute $ede5;
    fp_name_6:   XString absolute $edf5;
    fp_name_7:   XString absolute $ee05;
    fp_name_8:   XString absolute $ee15;
    fp_name_9:   XString absolute $ee25;
    fp_name_10:   XString absolute $ee35;
    fp_name_11:   XString absolute $ee45;
    fp_name_12:   XString absolute $ee55;
    fp_name_13:   XString absolute $ee65;
    fp_name_14:   XString absolute $ee75;
    fp_name_15:   XString absolute $ee85;
    fp_name_16:   XString absolute $ee95;
    fp_name_17:   XString absolute $eea5;
    fp_name_18:   XString absolute $eeb5;
    fp_name_19:   XString absolute $eec5;
    fp_name_20:   XString absolute $eed5;

var 
    fp_currentPlayer:   byte absolute $eee5;
    fp_currentSite:   byte absolute $eee6;
    fp_currentCommand:   char absolute $eee7;
    fp_validCmd:   shortint absolute $eee8;

var 
    shoot_diff:   shortint absolute $eee9;
    shoot_start:   smallint absolute $eeea;
//    move_dir:   shortint absolute $eeee;
    f_curPos:   word absolute $eeef;
  //  f_simulate_shoot:   byte absolute $ef01;

const
    fight_bulletTime: byte = 3;
    fight_hitTime: byte = 5; 
    fight_textTime: byte = 5;
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
 
    //
