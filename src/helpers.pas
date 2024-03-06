// helpers

// did not work for YesNo, test later again
// const
//   answerY:char = 'J';
//   answerN:char = 'N';


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



function readKeyAndStick():char;
var
    ch:char;
begin;
  asm;
        phr
  loop:
        lda $d300
        and #$0f
        cmp #$0f 
        bne foundstick

        lda consol		; START
        cmp #$05
        beq foundsave
        cmp #$03
        beq foundload

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
        jmp loopend
  foundsave:
        lda #$1f 
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



procedure waitForKey_new();
var k, m:byte;
begin
  k := CRT_WhereY();
  m := (40 - Length(waitKey_String)) SHR 1;
  CRT_Gotoxy(k+2, m);
  CRT_Write(waitKey_String);
  CRT_ReadKey();
end;


procedure waitForKey();
var k:byte;
begin
  k := CRT_WhereY();
  k := k + 2;
  CRT_WriteCentered(k, waitKey_String);
  CRT_ReadKey();
end;


procedure CRT_Writeln2 (S: String);
begin
  CRT_Write(S);
  CRT_NewLine();
  CRT_NewLine();
end;


procedure CRT_Writeln (S: String);
begin
  CRT_Write(S);
  CRT_NewLine();
end;


// 0 = A, 1 = B
// WILL NOT WORK BECAUSE OF KEYBOARD CODE --> CHAR CONVERSION
function getAnswer(A:byte; B:byte):   byte;
begin
    repeat;
        result := byte(CRT_ReadKey());
    until (A = result) or (B = result);
   result := byte(result = B);
end;

// FIXME: localize
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
  // CRT_Writeln('You selected '~);
  // CRT_Write(ivalue);
  // waitForKey;
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
    if (xBiosIOresult <> 0) then
    begin;
        CRT_Write('Unable to load GANGSTERS!'~);
        waitForKey();
    end;
    p := g SHL 8;
    xBiosSetFileOffset(p);
    xBiosSetLength(255);
    for k := 0 to 255 do
    begin
        b := xBiosGetByte;
        Poke($e600+k, b);
    end;
    // no close file?

    // if g < 10 then
    //     gangsterFilename[8] := char($30+g)
    // else 
    //     gangsterFilename[8] := char($37+g);
    // xbunAPL (gangsterFilename, Pointer($e600));
    CRT_Writeln(buf_gangsterText1);
    CRT_Writeln(buf_gangsterText2);
    CRT_Writeln(buf_gangsterText3);
    CRT_Writeln(buf_gangsterText4);
    CRT_Writeln(buf_gangsterText5);
end;

