

procedure CRT_Write_LocStr(b: byte);
var z: word;
  tmpstr: ^String;
begin;
  z := (b-1)*$28;
  tmpstr := Pointer(loc_string_1) + z;
  CRT_Write(tmpstr);
end;


procedure CRT_Writeln_LocStr(b: byte);
begin;
  CRT_Write_LocStr(b);
  CRT_NewLine;
end;


procedure CRT_Writeln2_LocStr(b: byte);
begin;
  CRT_Writeln_LocStr(b);
  CRT_NewLine;
end;


procedure CRT_WriteCentered_LocStr(r: byte; b: byte);
var z: word;
  tmpstr: ^String;
begin; 
  z := (b-1)*$28;
  tmpstr := Pointer(loc_string_1) + z;
  CRT_WriteCentered(r, tmpstr);
end;


function getRandom(minp:word; maxp:word; steps:word; x:byte; y:byte):   word;
var prop:   word;
begin;
    prop := minp;
    repeat
    until not CRT_KeyPressed;

    repeat
        prop := prop + steps;
        if prop > maxp then
            prop := minp;
        CRT_GotoXY (x,y);
        Waitframe;
        CRT_Write (prop);
        CRT_Write('  '~);
        // ensure overwrite
    until CRT_KeyPressed;
    result := prop;
end;


// produce some sound effect or something while waiting
procedure effectWait ();
begin;
    WaitFrames(120);
end;




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


function readKeyAndStick():char;
var
    ch:char;
begin;
  asm;
        phr
        lda #$00
        sta joystickused
  loop:
        lda $d300
        and #$0f
        cmp #$0f 
        bne foundstick

        lda $d010 ; try stick button 
        cmp #$00
        bne nofire 
        lda #$0c
        sta joystickused
        jmp loopend

nofire:
        lda consol		; START
        cmp #$05
        beq foundsave
        cmp #$03
        beq foundload
        cmp #$06
        beq foundmsx

        lda skctl		; ANY KEY
        and #$04
        bne loop

        lda kbcode
        jmp loopend
  stickdata:
        // right, left, down, up --> 7= 0111=right;  11=1011=left, 13=1101=down, 14=1110=up
        dta 0,0,0,0,    0,0, 0, 07,   0, 0,0, 06, 0,     15, 14
  foundstick:
        tay
        lda stickdata,y
        sta joystickused
        jmp loopend
  foundsave:
        lda #$1f 
        jmp loopend
  foundmsx:
        lda #$20
        jmp loopend
  foundload:
        lda #$1e
        // check for key
  loopend:
        sta ch
        plr
  end;
  result := ch;
end;




function checkKeyAndStick():char;
var
    ch:char;
begin;
  ch := #$0;
  asm;
        phr

        lda $d300
        and #$0f
        cmp #$0f   
        bne foundstick

        lda $d010 ; try stick button 
        cmp #$00
        bne nofire 
        lda #$0c
        jmp loopend

  nofire:
        lda consol		; START
        and #1
        beq foundconsol

        lda skctl		; ANY KEY
        and #$04
        bne loopend_zero

        lda kbcode
        jmp loopend
  stickdata:
        dta 0,0,0,0,    0,0, 0, 07,   0, 0,0, 06, 0,     15, 14
  foundstick:
        tay
        lda stickdata,y
        jmp loopend
  foundconsol:
        // check for key
  loopend_zero:
        lda #$00
  loopend:
        sta ch
        plr
  end;
  result := ch;
end;



// just for return key for now
procedure waitForKeyRelease;
var ch, tmpch: char;
begin;
    // if joystickused > 0 then 
    // begin;
    //   joystickused := 0;
    //   exit;
    // end;
    ch := readKeyAndStick();
    repeat;
        tmpch := checkKeyAndStick ();
    until tmpch <> ch; // wait for key release or so..
    // // wait for return key to be released 
    // repeat;
    //     ch := checkKeyAndStick ();
    // until ch <> #$0c;
end;


function CRT_ReadKeyOrFire():byte;
begin;
    result := kbcode;
    repeat until (not CRT_KeyPressed) or (result<>kbcode);
    repeat until CRT_KeyPressed or (checkKeyAndStick = #$0c);
    result := kbcode;
end; 


procedure waitForKey();
var k:byte;
begin
    k := CRT_WhereY();
    k := k + 2;
    CRT_WriteCentered(k, waitKey_String);
    CRT_ReadKeyOrFire();
end;



procedure CRT_NewLine2();
begin
  CRT_NewLine();
  CRT_NewLine();
end;

procedure CRT_Writeln2 (S: String);
begin
  CRT_Write(S);
  CRT_NewLine2();
end;


procedure CRT_Writeln (S: String);
begin
  CRT_Write(S);
  CRT_NewLine();
end;


// 0 = A, 1 = B
function getAnswer(A:byte; B:byte):   byte;
begin
    repeat;
        result := byte(CRT_ReadKeyOrFire());
    until (A = result) or (B = result);
   result := byte(result = B);
end;


// 0 = N, 1 = Y
function getYesNo:   byte;
begin
    result := getAnswer(N_keycode, Y_keycode);
end;


function readValue(minValue:SMALLINT; maxValue:SMALLINT): SMALLINT;
var
  ivalue: SMALLINT;
  x, y: byte;
  k: String;
begin;
  x := CRT_WhereX;
  y := CRT_WhereY;
  repeat
    //CRT_ClearRow(y);
    CRT_GotoXY (x, y);
    CRT_Write('      '~);
    CRT_GotoXY (x, y);
    //ivalue := StrToInt(CRT_ReadString(5));
    k := CRT_ReadStringI(5);
    k := Antic2Atascii(k);
    ivalue := StrToInt(k);
  until ((minValue <= ivalue) and (ivalue <= maxValue)) or (ivalue = 0);
  result := ivalue;
end;




function readValueNoZero(minValue:SMALLINT; maxValue:SMALLINT): SMALLINT;
var
  ivalue: SMALLINT;
  x, y: byte;
  k: String;
begin;
  x := CRT_WhereX;
  y := CRT_WhereY;
  repeat
    //CRT_ClearRow(y);
    CRT_GotoXY (x, y);
    CRT_Write('      '~);
    CRT_GotoXY (x, y);
    //ivalue := StrToInt(CRT_ReadString(5));
    k := CRT_ReadStringI(5);
    k := Antic2Atascii(k);
    ivalue := StrToInt(k);
  until ((minValue <= ivalue) and (ivalue <= maxValue));
  result := ivalue;
end;


procedure loadGangster(g: byte);
var b, k:   byte;
  p: cardinal;
begin;
    xBiosOpenFile(gangsterFilename);
    // if (xBiosIOresult <> 0) then
    // begin;
    //     CRT_Write('Unable to load GANGSTERS!'~);
    //     waitForKey();
    // end;
    p := g SHL 8;
    xBiosSetFileOffset(p);
    xBiosSetLength(255);
    for k := 0 to 255 do
    begin
        b := xBiosGetByte;
        Poke($e500+k, b);
    end;

    CRT_Writeln(buf_gangsterName);
    CRT_NewLine;
    CRT_Writeln(buf_gangsterText1);
    CRT_Writeln(buf_gangsterText2);
    CRT_Writeln(buf_gangsterText3);
    CRT_Writeln(buf_gangsterText4);
    CRT_Writeln(buf_gangsterText5);
end;




procedure saveGame ();
begin;
    // loaded location will always be SETUP_
    CRT_Clear;
    CRT_WriteCentered_LocStr(1, 19);
    xBiosOpenFile(saveFname);
    xBiosSetLength($0a1f); // just dump all of it 
    xBiosWriteData(Pointer($e000));
        // we pray instead.
        // if (xBiosIOresult = 0) then
        //     CRT_WriteCentered(3,'Successful!'~)
        // else
        //     CRT_WriteCentered(3,'ERROR!'~);
    xBiosFlushBuffer();
    waitForKey();
end;


function checkSavedGame (): byte;
var tmp:byte;
begin; 
    xBiosOpenFile(saveFname);
    xBiosSetLength($1);
    xBiosLoadData(@tmp);
    if (tmp > 4) or (tmp = 0) then begin;
        result := 0;  // invalid
        exit;
    end;
    result := 1;
end; 


procedure loadGame ();
begin;
    // loaded location will always be SETUP_
    CRT_Clear;
    CRT_WriteCentered_LocStr(1,17);
    // first check if its plausible
    if checkSavedGame() = 0 then begin;
        CRT_WriteCentered_LocStr(3, 18);
        waitForKey;
        exit;
    end;

    // reopen 
    xBiosOpenFile(saveFname);
    xBiosSetLength($0a1f); // just dump all of it 
    xBiosLoadData(Pointer($e000));
    xBiosFlushBuffer();
    waitForKey();    
end; 

