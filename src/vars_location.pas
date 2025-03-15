// starts with $c000


var 
    tmpStr: ^String;
    tmp: byte;

var
    loc_name:               YString absolute LOCATION_ADR + $0000;
    loc_sublocation_name_1: YString absolute LOCATION_ADR + $0028;
    loc_sublocation_name_2: YString absolute LOCATION_ADR + $0050;
    loc_sublocation_name_3: YString absolute LOCATION_ADR + $0078;
    loc_sublocation_name_4: YString absolute LOCATION_ADR + $00A0;

    loc_options_1:          YString absolute LOCATION_ADR + $0C8;
    loc_options_2:          YString absolute LOCATION_ADR + $0F0;
    loc_options_3:          YString absolute LOCATION_ADR + $118;
    loc_options_4:          YString absolute LOCATION_ADR + $140;
    loc_options_5:          YString absolute LOCATION_ADR + $168;
    loc_options_6:          YString absolute LOCATION_ADR + $190;
    loc_options_7:          YString absolute LOCATION_ADR + $1B8;
    loc_options_8:          YString absolute LOCATION_ADR + $1E0;
    loc_options_9:          YString absolute LOCATION_ADR + $208;
    loc_options_10:         YString absolute LOCATION_ADR + $230;

    loc_description_1:      YString absolute LOCATION_ADR + $258;
    loc_description_2:      YString absolute LOCATION_ADR + $280;
    // loc_bgcolor_dummy:            Byte absolute LOCATION_ADR + $2A8;
    loc_nOptions:           Byte absolute LOCATION_ADR + $2A9;
    loc_map_places:        array[0..3] of Byte absolute LOCATION_ADR + $2AA;
    // 2 bytes just there
    loc_string_1:           YString absolute LOCATION_ADR + $2B0;
    loc_string_2:           YString absolute LOCATION_ADR + $2B0 + 1  * $28;
    loc_string_3:           YString absolute LOCATION_ADR + $2B0 + 2  * $28;
    loc_string_4:           YString absolute LOCATION_ADR + $2B0 + 3  * $28;
    loc_string_5:           YString absolute LOCATION_ADR + $2B0 + 4  * $28;
    loc_string_6:           YString absolute LOCATION_ADR + $2B0 + 5  * $28;
    loc_string_7:           YString absolute LOCATION_ADR + $2B0 + 6  * $28;
    loc_string_8:           YString absolute LOCATION_ADR + $2B0 + 7  * $28;
    loc_string_9:           YString absolute LOCATION_ADR + $2B0 + 8  * $28;
    loc_string_10:          YString absolute LOCATION_ADR + $2B0 + 9  * $28;
    loc_string_11:          YString absolute LOCATION_ADR + $2B0 + 10 * $28;
    loc_string_12:          YString absolute LOCATION_ADR + $2B0 + 11 * $28;
    loc_string_13:          YString absolute LOCATION_ADR + $2B0 + 12 * $28;
    loc_string_14:          YString absolute LOCATION_ADR + $2B0 + 13 * $28;
    loc_string_15:          YString absolute LOCATION_ADR + $2B0 + 14 * $28;
    loc_string_16:          YString absolute LOCATION_ADR + $2B0 + 15 * $28;
    loc_string_17:          YString absolute LOCATION_ADR + $2B0 + 16 * $28;
    loc_string_18:          YString absolute LOCATION_ADR + $2B0 + 17 * $28;
    loc_string_19:          YString absolute LOCATION_ADR + $2B0 + 18 * $28;
    loc_string_20:          YString absolute LOCATION_ADR + $2B0 + 19 * $28;
    loc_string_21:          YString absolute LOCATION_ADR + $2B0 + 20 * $28;
    loc_string_22:          YString absolute LOCATION_ADR + $2B0 + 21 * $28;
    loc_string_23:          YString absolute LOCATION_ADR + $2B0 + 22 * $28;
    loc_string_24:          YString absolute LOCATION_ADR + $2B0 + 23 * $28;
    loc_string_25:          YString absolute LOCATION_ADR + $2B0 + 24 * $28;
    loc_string_26:          YString absolute LOCATION_ADR + $2B0 + 25 * $28;
    loc_string_27:          YString absolute LOCATION_ADR + $2B0 + 26 * $28;
    loc_string_28:          YString absolute LOCATION_ADR + $2B0 + 27 * $28;
    loc_string_29:          YString absolute LOCATION_ADR + $2B0 + 28 * $28;
    loc_string_30:          YString absolute LOCATION_ADR + $2B0 + 29 * $28;
    loc_string_31:          YString absolute LOCATION_ADR + $2B0 + 30 * $28;
    loc_string_32:          YString absolute LOCATION_ADR + $2B0 + 31 * $28;
    loc_string_33:          YString absolute LOCATION_ADR + $2B0 + 32 * $28;
    loc_string_34:          YString absolute LOCATION_ADR + $2B0 + 33 * $28;
    loc_string_35:          YString absolute LOCATION_ADR + $2B0 + 34 * $28;
    loc_string_36:          YString absolute LOCATION_ADR + $2B0 + 35 * $28;
    loc_string_37:          YString absolute LOCATION_ADR + $2B0 + 36 * $28;
    loc_string_38:          YString absolute LOCATION_ADR + $2B0 + 37 * $28;
    loc_string_39:          YString absolute LOCATION_ADR + $2B0 + 38 * $28;
    loc_string_40:          YString absolute LOCATION_ADR + $2B0 + 39 * $28;
    loc_string_41:          YString absolute LOCATION_ADR + $2B0 + 40 * $28;

    loccolbk:             Byte absolute LOCATION_ADR + $2B0 + 41 * $28; 
    loccolpf0:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 1;
    loccolpf1:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 2;
    loccolpf2:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 3; // $c91b

    loc_options: array[0..9] of ^YString = (@loc_options_1, @loc_options_2, @loc_options_3, @loc_options_4, @loc_options_5, 
                                                            @loc_options_6, @loc_options_7, @loc_options_8, @loc_options_9, @loc_options_10 );
    loc_sublocation_names:   array[0..3] of ^YString =   (@loc_sublocation_name_1, @loc_sublocation_name_2, @loc_sublocation_name_3, @loc_sublocation_name_4);

    //
