
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
    N_charcode = 'N'~; //nie
    Y_keycode = $2d; //Tak
    Y_charcode = 'T'~; //Tak
    F_keycode = $05; //Kobeta
    F_charcode = 'K'~;
    M_keycode =  $25; //Mezczyzna
    M_charcode = 'M'~;
    short_game_keycode =  $05; //Krotka
    short_game_charcode = 'K'~;
    long_game_keycode =  $3a; //Dluga
    long_game_charcode = 'D'~;
    shooting_range_keycode = $3e; //s
    shooting_range_charcode = 'S'~;
    training_camp_keycode= $08; //o
    training_camp_charcode = 'O'~;
    health_char = 'E:'~;
    weapon_char = 'B:'~;
    len_string_gangster = 12;
{$endif}


{$ifdef LOCATION_DE}
const
    N_keycode = 35;
    N_charcode = 'N'~; //nein
    Y_keycode = 1;
    Y_charcode = 'J'~; //ja
    F_keycode = $2e;
    F_charcode = 'W'~;
    M_keycode =  $25;
    M_charcode = 'M'~;
    short_game_keycode =  $05;
    short_game_charcode = 'K'~;
    long_game_keycode =  $00;
    long_game_charcode = 'L'~;
    shooting_range_keycode = $3e;
    shooting_range_charcode = 'S'~;
    training_camp_keycode = $2d;
    training_camp_charcode = 'T'~;
    health_char = 'E:'~;
    weapon_char = 'W:'~;
    len_string_gangster = 10;
{$endif}



{$ifdef LOCATION_EN}
const
    N_keycode = 35;
    N_charcode = 'N'~; //no
    Y_keycode = 43;
    Y_charcode = 'Y'~; //yes
    F_keycode = $38;
    F_charcode = 'F'~;
    M_keycode =  $25;
    M_charcode = 'M'~;

    short_game_keycode =  $3e;
    short_game_charcode = 'S'~;
    long_game_keycode =  $00;
    long_game_charcode = 'L'~;
    shooting_range_keycode = $3e;
    shooting_range_charcode = 'S'~;
    training_camp_keycode = $2d;
    training_camp_charcode = 'T'~;
    health_char = 'E:'~;
    weapon_char = 'W:'~;
    len_string_gangster = 11;
{$endif}



