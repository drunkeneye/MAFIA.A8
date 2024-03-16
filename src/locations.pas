
const 
    BANK_: byte = 1;
    FORGERY_: byte = 2;
    MONEYTRANSPORT_: byte = 3;
    LOANSHARK_: byte = 4;
    POLICE_: byte = 5;
    CARDEALER_: byte = 6;
    PUB_: byte = 7;
    MAILTRAIN_: byte = 8;
    STORE_: byte = 9;
    HIDEOUT_: byte = 10;
    GAMBLING_: byte = 11;
    SUBWAY_: byte = 12;
    ARMSDEALER_: byte = 13;
    TITLE_: byte = 14;
    NONE_: byte = 15;
    STREET_: byte = 16;
    END_TURN_: byte = 17;
    LOSTFIGHT_: byte = 18;
    MAIN_: byte = 19;
    PUB2_: byte = 20;
    UPDATES_: byte = 21;
    JOB_: byte = 22;
    CENTRALSTATION_: byte = 23;
    MAJOR_: byte = 24;
    COURT_: byte = 25;
    CAUGHT_: byte = 26;
    ROADBLOCK_: byte = 27;
    SETUP_: byte = 28;

 var 
    currentLocation:   byte;
    currentSubLocation: byte;
    currentSubLocationName: YString;


procedure ShowLocationHeader;
var 
    idx:   byte;
    subLocation: YString;
begin;
    enableConsole();
    CRT_Clear;
    CRT_WriteCentered(1, loc_name);
    CRT_Invert(0, 1, CRT_screenWidth);

    currentSubLocationName := ' '~;
    for idx := 0 to 3 do
    begin 
        if loc_map_places[idx] = currentMap then
            currentSubLocationName := loc_sublocation_names[idx];
    end;
    CRT_WriteCentered(2, currentSubLocationName);
    CRT_GotoXY(0, 4);
end;


procedure loadLocation(L:byte);
var    locfname:   ^TString;
begin;
    if lastLocationStrings = L then exit;
    lastLocationStrings := L;
    case L of 
        BANK_:   locfname := LOCABANKfname;
        FORGERY_:   locfname := LOCAFORGfname;
        MONEYTRANSPORT_: locfname := LOCAMONYfname; 
        LOANSHARK_: locfname := LOCALOANfname;
        POLICE_: locfname := LOCAPOLIfname;
        CARDEALER_: locfname := LOCACARSfname;
        PUB_: locfname := LOCAPUBBfname;
        PUB2_: locfname := LOCAPUBCfname;
        STORE_: locfname := LOCASTORfname;
        HIDEOUT_: locfname := LOCAHIDEfname;
        GAMBLING_:locfname := LOCAGAMBfname;
        SUBWAY_: locfname := LOCASUBWfname;
        ARMSDEALER_:locfname := LOCAARMSfname;
        MAIN_:locfname := LOCAMAINfname;
        JOB_: locfname:= LOCAJOBBfname;
        MAJOR_: locfname := LOCAMONYfname; // same as moneytransport
        CENTRALSTATION_: locfname := LOCACENTfname;
        COURT_: locfname := LOCACOURfname;
        CAUGHT_: locfname := LOCACAUGfname;
        ROADBLOCK_: locfname := LOCAROADfname;
        UPDATES_: locfname := LOCAUPDTfname;
        SETUP_: locfname := LOCASETUfname;
    end;    
    xbunAPL (locfname, Pointer(baseAddress));
end;


function ShowLocation(L: byte):   byte;
var i, choice:   byte;
    tmps: YString;
    npos: array[0..6] of byte;
    j, nopt: byte;
    ch, tmpch: char;
begin
    //SystemOff($fe);
    loadLocation (L);
    currentSubLocation := 99;
    for i := 0 to 3 do 
        if loc_map_places[i] = currentMap then currentSubLocation := i;
    if currentSubLocation = 99 then repeat; until false; // should never happen!
    if loc_nOptions = 0 then
    begin;
        result := 99; // 0 would exit the location
        exit;
    end;

    ShowLocationHeader;


    CRT_GotoxY(0,4);
    CRT_Write(loc_description_1);
    CRT_GotoxY(0,5);
    CRT_Write(loc_description_2);

    CRT_Gotoxy(0,7);
    nopt := 0;
    j := 7;
    for i := 0 to 9 do
    begin;
        tmps := loc_options[i];
        if Length(tmps) = 0 then break;

        if tmps[1]= char(0) then  // is it space?
        begin 
            CRT_Writeln(tmps);
            j := j + 1;
        end
        else
        begin
            CRT_Newline();
            j := j + 1;
            npos[nopt] := j;
            CRT_Writeln(tmps);
            j := j + 1;
            nopt := nopt + 1;
        end;
    end;

    choice  := 0;
    repeat;
        for i := 0 to nopt-1 do
        begin;
            // first clear all
            CRT_Gotoxy(0,npos[i]);
            CRT_Write(' '~);
        end; 
        CRT_Gotoxy(0, npos[choice]);
        CRT_Write('>'~);

        ch := readKeyAndStick();
        repeat;
            tmpch := checkKeyAndStick ();
        until tmpch <> ch; // wait for key release or so..

        if byte(ch) = $0c then begin
            result := choice+1;
            exit;        
        end;

        if byte(ch) = 14 then 
        begin 
            if choice > 0 then choice := choice -1;
        end; 

        if byte(ch) = 15 then 
        begin 
            if choice < nopt-1 then choice := choice + 1;
        end; 

        case byte(ch) of 
            $1f: ch := #49; // 1
            $1e: ch := #50; //2;
            $1a: ch := #51;
            $18: ch := #52;
            $1d: ch := #53;
            $1b: ch := #54;
            $33: ch := #55;
            $35: ch := #56;
            $30: ch := #57;
            $32: ch := #58;
        end;

    //     'v', #$ff, 'c', #$ff, #$ff, 'b', 'x', 'z', '4', #$ff, '3', '6', CHAR_ESCAPE, '5', '2', '1',
    //     ',', ' ', '.', 'n', #$ff, 'm', '/', CHAR_INVERSE, 'r', #$ff, 'e', 'y', CHAR_TAB, 't', 'w', 'q',
    //     '9', #$ff, '0', '7', CHAR_BACKSPACE, '8', '>', #$ff, 'f', 'h', 'd', #$ff, CHAR_CAPS, 'g', 's', 'a',

        if (byte(ch) > 48) and (byte(ch) < 48+loc_nOptions+1) then 
        begin
            result := byte(ch) - 48;
            exit;
        end; 
    until ch = #$0c;
    // should never get here 
    result := choice+1; 

    // do not allow 0 here, just 1...NOptions
    // repeat;
    //     choice := CRT_ReadKey();
    //     i := byte(CRT_keycode[choice]);
    // until (i > 48) and (i < 48+loc_nOptions+1);
    // result := i - 48;
end;
 
