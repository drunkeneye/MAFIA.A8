
const
    baseAddress = $BE80;

var 
    tmpStr: ^String;
    tmp: byte;

var
    loc_name:                       YString absolute baseAddress + $0000;
    loc_sublocation_name_1: YString absolute baseAddress + $0028;
    loc_sublocation_name_2: YString absolute baseAddress + $0050;
    loc_sublocation_name_3: YString absolute baseAddress + $0078;
    loc_sublocation_name_4: YString absolute baseAddress + $00A0;

    loc_options_1:          YString absolute baseAddress + $0C8;
    loc_options_2:          YString absolute baseAddress + $0F0;
    loc_options_3:          YString absolute baseAddress + $118;
    loc_options_4:          YString absolute baseAddress + $140;
    loc_options_5:          YString absolute baseAddress + $168;
    loc_options_6:          YString absolute baseAddress + $190;
    loc_options_7:          YString absolute baseAddress + $1B8;
    loc_options_8:          YString absolute baseAddress + $1E0;
    loc_options_9:          YString absolute baseAddress + $208;
    loc_options_10:         YString absolute baseAddress + $230;

    loc_description_1:      YString absolute baseAddress + $258;
    loc_description_2:      YString absolute baseAddress + $280;
    // loc_bgcolor_dummy:            Byte absolute baseAddress + $2A8;
    loc_nOptions:           Byte absolute baseAddress + $2A9;
    loc_map_places:        array[0..3] of Byte absolute baseAddress + $2AA;
    // 2 bytes just there
    loc_string_1:           YString absolute baseAddress + $2B0;
    loc_string_2:           YString absolute baseAddress + $2B0 + 1  * $28;
    loc_string_3:           YString absolute baseAddress + $2B0 + 2  * $28;
    loc_string_4:           YString absolute baseAddress + $2B0 + 3  * $28;
    loc_string_5:           YString absolute baseAddress + $2B0 + 4  * $28;
    loc_string_6:           YString absolute baseAddress + $2B0 + 5  * $28;
    loc_string_7:           YString absolute baseAddress + $2B0 + 6  * $28;
    loc_string_8:           YString absolute baseAddress + $2B0 + 7  * $28;
    loc_string_9:           YString absolute baseAddress + $2B0 + 8  * $28;
    loc_string_10:          YString absolute baseAddress + $2B0 + 9  * $28;
    loc_string_11:          YString absolute baseAddress + $2B0 + 10 * $28;
    loc_string_12:          YString absolute baseAddress + $2B0 + 11 * $28;
    loc_string_13:          YString absolute baseAddress + $2B0 + 12 * $28;
    loc_string_14:          YString absolute baseAddress + $2B0 + 13 * $28;
    loc_string_15:          YString absolute baseAddress + $2B0 + 14 * $28;
    loc_string_16:          YString absolute baseAddress + $2B0 + 15 * $28;
    loc_string_17:          YString absolute baseAddress + $2B0 + 16 * $28;
    loc_string_18:          YString absolute baseAddress + $2B0 + 17 * $28;
    loc_string_19:          YString absolute baseAddress + $2B0 + 18 * $28;
    loc_string_20:          YString absolute baseAddress + $2B0 + 19 * $28;
    loc_string_21:          YString absolute baseAddress + $2B0 + 20 * $28;
    loc_string_22:          YString absolute baseAddress + $2B0 + 21 * $28;
    loc_string_23:          YString absolute baseAddress + $2B0 + 22 * $28;
    loc_string_24:          YString absolute baseAddress + $2B0 + 23 * $28;
    loc_string_25:          YString absolute baseAddress + $2B0 + 24 * $28;
    loc_string_26:          YString absolute baseAddress + $2B0 + 25 * $28;
    loc_string_27:          YString absolute baseAddress + $2B0 + 26 * $28;
    loc_string_28:          YString absolute baseAddress + $2B0 + 27 * $28;
    loc_string_29:          YString absolute baseAddress + $2B0 + 28 * $28;
    loc_string_30:          YString absolute baseAddress + $2B0 + 29 * $28;
    loc_string_31:          YString absolute baseAddress + $2B0 + 30 * $28;
    loc_string_32:          YString absolute baseAddress + $2B0 + 31 * $28;
    loc_string_33:          YString absolute baseAddress + $2B0 + 32 * $28;
    loc_string_34:          YString absolute baseAddress + $2B0 + 33 * $28;
    loc_string_35:          YString absolute baseAddress + $2B0 + 34 * $28;
    loc_string_36:          YString absolute baseAddress + $2B0 + 35 * $28;
    loc_string_37:          YString absolute baseAddress + $2B0 + 36 * $28;
    loc_string_38:          YString absolute baseAddress + $2B0 + 37 * $28;
    loc_string_39:          YString absolute baseAddress + $2B0 + 38 * $28;
    loc_string_40:          YString absolute baseAddress + $2B0 + 39 * $28;
    loc_string_41:          YString absolute baseAddress + $2B0 + 40 * $28;

    loccolbk:            Byte absolute baseAddress + $2B0 + 41 * $28; // $c798 now with $be80 starting
    loccolpf0:            Byte absolute baseAddress + $2B0 + 41 * $28 + 1;
    loccolpf1:            Byte absolute baseAddress + $2B0 + 41 * $28 + 2;
    loccolpf2:            Byte absolute baseAddress + $2B0 + 41 * $28 + 3; // $c79b

    loc_options: array[0..9] of ^YString = (@loc_options_1, @loc_options_2, @loc_options_3, @loc_options_4, @loc_options_5, 
                                                            @loc_options_6, @loc_options_7, @loc_options_8, @loc_options_9, @loc_options_10 );
    loc_sublocation_names:   array[0..3] of ^YString =   (@loc_sublocation_name_1, @loc_sublocation_name_2, @loc_sublocation_name_3, @loc_sublocation_name_4);

    //
