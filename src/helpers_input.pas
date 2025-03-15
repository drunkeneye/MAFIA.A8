


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
  ch := char(0);
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


