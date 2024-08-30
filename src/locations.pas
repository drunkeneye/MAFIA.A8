// stupid delphi
procedure loadMap();forward;
procedure preloadMap();forward;


const 
    // last_Forgery: byte = 1;
    last_Train: byte = 2;
    // last_Bribe: byte = 3;

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
    RESET_: byte = 29;
    CREDITS_: byte = 30;

 var 
    currentSubLocation: byte;
    currentSubLocationName: YString;


procedure ShowLocationHeader;
var 
    idx:   byte;
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
 

{$ifdef LOCATIONSGFX} 
procedure loadLocation(L:byte);
var    locfname:   TString;
    displayBMP: byte;
begin;
    displayBMP := 0;
    if lastLocationStrings = L then exit;
    lastLocationStrings := L;
    case L of 
        BANK_: begin; locfname := LOCABANKfname;  displayBMP := 1; end;
        FORGERY_:  begin; locfname := LOCAFORGfname;  displayBMP := 1; end;
        MONEYTRANSPORT_: begin; locfname := LOCAMONYfname;  displayBMP := 1; end;
        LOANSHARK_: begin; locfname := LOCALOANfname;  displayBMP := 1; end;
        POLICE_: begin;  locfname := LOCAPOLIfname;  displayBMP := 1; end;
        CARDEALER_: begin; locfname := LOCACARSfname;  displayBMP := 1; end;
        PUB_: begin; locfname := LOCAPUBBfname;  displayBMP := 1; end;
        PUB2_: locfname := LOCAPUBCfname;
        STORE_: begin; locfname := LOCASTORfname;  displayBMP := 1; end;
        HIDEOUT_: begin; locfname := LOCAHIDEfname;  displayBMP := 1; end;
        GAMBLING_: begin; locfname := LOCAGAMBfname; displayBMP := 1; end;
        SUBWAY_: begin; locfname := LOCASUBWfname; displayBMP := 1; end;
        ARMSDEALER_: begin; locfname := LOCAARMSfname;  displayBMP := 1; end;
        MAIN_:locfname := LOCAMAINfname;
        JOB_: locfname:= LOCAJOBBfname;
        MAJOR_: begin; locfname := LOCAMAJOfname;  displayBMP := 1; end;
        CENTRALSTATION_: locfname := LOCACENTfname; //  displayBMP := 1; end;
        COURT_: locfname := LOCACOURfname;
        CAUGHT_: locfname := LOCACAUGfname;
        ROADBLOCK_: locfname := LOCAROADfname;
        UPDATES_: locfname := LOCAUPDTfname;
        SETUP_: locfname := LOCASETUfname;
        CREDITS_: locfname := LOCACREDfname;
    end;    
    loadxAPL (locfname, Pointer(baseAddress));

    if showBitmaps = 0 then exit;

    if displayBMP = 1 then 
    begin;
        enableMapConsole;
        mapColorA := $04;
        FillChar(Pointer(MAP_SCR_ADDRESS), 40*24, 0);
        locfname[1] := 'B';
        loadxAPL (locfname, Pointer(MAP_FNT_ADDRESS));
        locfname[1] := 'L';
        CRT_ReadKey();
        FillChar(Pointer(MAP_SCR_ADDRESS+40*15), 40*9, 0);
        preloadMap(); // stupid, but true, need to reload the map now
        mapColorA := $88;
        enableConsole;
    end; 
end;
{$else}
procedure loadLocation(L:byte);
var    locfname:   TString;
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
        MAJOR_: locfname := LOCAMAJOfname; 
        CENTRALSTATION_: locfname := LOCACENTfname;
        COURT_: locfname := LOCACOURfname;
        CAUGHT_: locfname := LOCACAUGfname;
        ROADBLOCK_: locfname := LOCAROADfname;
        UPDATES_: locfname := LOCAUPDTfname;
        SETUP_: locfname := LOCASETUfname;
        CREDITS_: locfname := LOCACREDfname;
    end;    
    loadxAPL (locfname, Pointer(baseAddress));
end;
{$endif}




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
            if choice + 1 < nopt then choice := choice + 1;
        end; 

        // if byte(ch) < $18 then continue;
        // if byte(ch) > $35 then continue;
        
        case byte(ch) of 
            $1f: ch := #49; // 1
            $1e: ch := #50; // 2
            $1a: ch := #51;
            $18: ch := #52;
            $1d: ch := #53;
            $1b: ch := #54;
            $33: ch := #55;
            $35: ch := #56;
            $30: ch := #57;
            $32: ch := #58; // 0
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
end;
 
