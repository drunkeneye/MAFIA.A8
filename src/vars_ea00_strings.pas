
    // CRT_keycode: array [0..255] of char = ( //@nodoc
    //     'l', 'j', ';', #$ff, #$ff, 'k', '+', '*', 'o', #$ff, 'p', 'u', CHAR_RETURN, 'i', '-', '=', //@nodoc
    //     'v', #$ff, 'c', #$ff, #$ff, 'b', 'x', 'z', '4', #$ff, '3', '6', CHAR_ESCAPE, '5', '2', '1',
    //     ',', ' ', '.', 'n', #$ff, 'm', '/', CHAR_INVERSE, 'r', #$ff, 'e', 'y', CHAR_TAB, 't', 'w', 'q',
    //     '9', #$ff, '0', '7', CHAR_BACKSPACE, '8', '>', #$ff, 'f', 'h', 'd', #$ff, CHAR_CAPS, 'g', 's', 'a',
    //     'L', 'J', ':', #$ff, #$ff, 'K', '\', '^', 'O', #$ff, 'P', 'U', #$ff, 'I', '_', '|',
    //     'V', #$ff, 'C', #$ff, #$ff, 'B', 'X', 'Z', '$', #$ff, '#', '&', #$ff, '%', '"', '!',
    //     '[', ';', ']', 'N', #$ff, 'M', '?', #$ff, 'R', #$ff, 'E', 'Y', #$ff, 'T', 'W', 'Q',
    //     '(', #$ff, ')', '''', #$ff, '@', #$ff, #$ff, 'F', 'H', 'D', #$ff, #$ff, 'G', 'S', 'A',
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff,
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff,
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff,
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff,
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff,
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff,
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff,
    //     #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff, #$ff
    // );



{$ifdef LOCATION_PL}
const 
    N_keycode = 35;
    Y_keycode = $2d; //Tak
    F_keycode = $05; //Kobeta
    M_keycode =  $25; //Mezczyzna
    short_game_keycode =  $05; //Krotka
    long_game_keycode =  $3a; //Dluga
    shooting_range_keycode = $3a; //d
    training_camp_keycode$= $23; //n
{$endif}


{$ifdef LOCATION_DE}
const 
    N_keycode = 35;
    Y_keycode = 1;
    F_keycode = $2e;
    M_keycode =  $25;
    short_game_keycode =  $05;
    long_game_keycode =  $00;
    shooting_range_keycode = $3e;
    training_camp_keycode$= $2d;
{$endif}



{$ifdef LOCATION_EN}
const 
    N_keycode = 35;
    Y_keycode = 43;
    F_keycode = $38;
    M_keycode =  $25;
    short_game_keycode =  $3e;
    long_game_keycode =  $00;
    shooting_range_keycode = $3e;
    training_camp_keycode$= $2d;
{$endif}


const 
    stradr = $ea20;

var 
    fight_string_1: XString absolute stradr;
    fight_string_2: XString absolute stradr + 40*0 + $10*1;  
    fight_string_3: XString absolute stradr + 40*0 + $10*2;  
    fight_string_4: XString absolute stradr + 40*0 + $10*3;  
    fight_string_5: XString absolute stradr + 40*0 + $10*4;  
    fight_string_6: XString absolute stradr + 40*0 + $10*5; 
    waitKey_String: YString absolute stradr + 40*0 + $10*6; //? 41?
    map_string_weapon: XString absolute stradr + 40*1 + $10*6;
    map_string_gangster: XString absolute stradr + 40*1 + $10*7;
    map_string_rent: XString absolute stradr + 40*1 + $10*8;
    map_string_bribe: XString absolute stradr + 40*1 + $10*9;
    map_string_car: XString absolute stradr + 40*1 + $10*10;
    map_string_steps: XString absolute stradr + 40*1 + $10*11;
    map_string_cargo: XString absolute stradr + 40*1 + $10*12;
    map_string_money: XString absolute stradr + 40*1 + $10*13;
    map_string_credit: XString absolute stradr + 40*1 + $10*14;
    fight_police_string_1: XString absolute stradr + 40*1 + $10*15;
    fight_police_string_2: XString absolute stradr + 40*1 + $10*16;
    not_enough_money_string: YString absolute stradr + 40*1 + $10*17;
    your_choice_string: XString absolute stradr + 40*2 + $10*17;
    police_string_1: YString absolute stradr + 40*2 + $10*18;

    len_string_bribe: byte  absolute stradr + 40*3 + $10*18;


