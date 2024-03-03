
{$ifdef LOCATION_DE}
const 
    fight_string_1: YString = 'Du hast '~;
    fight_string_2: YString = ' getroffen!'~;
    fight_string_3: YString = 'Leider ist '~;
    fight_string_4: YString = ' jetzt tot!'~;
    fight_string_5: YString = 'Du hast verfehlt!'~;
    fight_string_6: YString = 'Gewonnen hat '~;
    waitKey_String: YString = 'Taste druecken!'~;
    map_string_weapon: YString = 'Waffe:'~;
    map_string_gangster: YString = 'Gangster:'~;
    map_string_rent: YString = 'Miete:'~;
    map_string_bribe: YString = 'Bestechung:'~;
    map_string_car: YString = 'Car:'~;
    map_string_steps: YString = 'Schritte:'~;
    map_string_cargo: YString = 'Cargo:'~;
    map_string_money: YString = 'Geld:'~;
    map_string_credit: YString = 'Kredit:'~;
    fight_police_string_1: YString = 'Die Polizei'~;
    fight_police_string_2: YString = 'Polizist'~;
    not_enough_money_string: YString = 'Du hast nicht genug Geld!'~;
    your_choice_string: YString = 'Deine Wahl? '~;
    police_string_1: YString = 'The police await you outside the store!'~;

// 'n, j, see CRT_keycode
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




{$ifdef LOCATION_EN}
var 
    fight_string_1: YString = 'You hit '~;
    fight_string_2: YString = ' !'~;
    fight_string_3: YString = 'Unfortunately, '~;
    fight_string_4: YString = ' is now dead.'~;
    fight_string_5: YString = 'You missed!'~;
    fight_string_6: YString = 'Winner is '~;
    waitKey_String: YString = 'Press a key!'~;
    map_string_weapon: YString = 'Weapon:'~;
    map_string_gangster: YString = 'Gangster:'~;
    map_string_rent: YString = 'Rent:'~;
    map_string_bribe: YString = 'Bribe:'~;
    map_string_car: YString = 'Car:'~;
    map_string_steps: YString = 'Steps:'~;
    map_string_cargo: YString = 'Cargo:'~;
    map_string_money: YString = 'Money:'~;
    map_string_credit: YString = 'Credit:'~;
    fight_police_string_1: YString = 'The police'~;
    fight_police_string_2: YString = 'Officer'~;
    not_enough_money_string: YString = 'You do not have enough money!'~;
    your_choice_string: YString = 'Your choice? '~;
    police_string_1: YString = 'In front of the building !'~;

// 'n, j, see CRT_keycode
// 'n, j, see CRT_keycode
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

