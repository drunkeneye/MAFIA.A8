{$DEFINE ROMOFF}    // http://mads.atari8.info/doc/en/syntax/#romoff
{$DEFINE NOROMFONT}

program autorun;


{$define basicoff}
{$librarypath '../../tools/Mad-Pascal-1.7.2/blibs/'}
{$librarypath '../../tools/Mad-Pascal-1.7.2/base/'}
{$librarypath '../../tools/Mad-Pascal-1.7.2/lib/'}

{$r ./resources_title.rc}


uses atari, pmg, xbios, crt, cio, aplib, b_utils, rmt, b_pmg, sysutils, b_system, b_crt;

const
{$i const_title.inc}

// these are mainly needed to allow inclusion of files
// that are part of the game. else we get undefined variables etc.

type
    XString =   String[15];
    YString =   String[40];

var
    stick :   byte absolute $278;
    PCOLR0:   byte absolute $D012;
    PCOLR1:   byte absolute $D013;
    PCOLR2:   byte absolute $D014;
    PCOLR3:   byte absolute $D015;
    playerPos_X:   byte;
    spriteMoveDir: shortint;
    joystickused: byte;

    mapColorA: byte;
    mapColorB: byte;
    acolpf0, acolpf1, acolpf2, acolpf3, acolbk: byte;

    playMusic: byte absolute $e0a1;
	msx: TRMT;


procedure musicproxy();
begin;
    if playMusic = 1 then
        msx.play();
end;


{$I interrupts.inc}
{$I xbaplib.pas}
{$i console.pas}
{$i helpers_input.pas}


var
    D_LOGO: TString = 'LOGO    APL';
    D_TITLE: TString = 'TITLEPICAPL';
    D_MPLAY: TString = 'PLAYB000APL';
    D_MUS: TString = 'TMUSB800APL';
    locfname:   TString;
    e7fname: TString = 'E700PAGEAPL';

const
    e7adrm6 = $e600-6;
    ADR_LOGO         =   $9036;
    // DL GR.8 $9036; GFX $9150
    ADR_LOGO_DL      =   ADR_LOGO;
    ADR_LOGO_GFX     =   $9150;
    DL_LOGO_ADR      =   $fc80;
    L_COLOR1         =   $9c;
    L_COLOR2         =   $12;


var
    loccolbk:             Byte absolute LOCATION_ADR + $2B0 + 41 * $28; 
    loccolpf0:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 1;
    loccolpf1:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 2;
    loccolpf2:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 3; // $c91b


procedure show_logo;
begin
    xbunAPL(D_LOGO, pointer(ADR_LOGO));
    EnableDLI(@dli_console);
    DLISTL := DL_LOGO_ADR;
    loccolbk := L_COLOR2;
    loccolpf0 := L_COLOR1;
    loccolpf1 := L_COLOR1;
    loccolpf2 := L_COLOR2;
end;


procedure dli_flags;assembler;interrupt;
asm {
dli:
    phr ; store registers

dlijmp:
    jmp dli1

dli1:
    lda #>MAP_FNT_ADDRESS
    sta $D409 ; CHBAS_real
    sta WSYNC
    // jsr $b006

    mva acolpf0 atari.colpf0 ; white
    mva acolpf1 atari.colpf1 ; red
    mva acolpf2 atari.colpf2 ; yellow
    mva acolpf3 atari.colpf3 ; blue
    mva acolbk atari.colbk  ; black

    lda #<dli1
    sta dlijmp+1
    lda #>dli1
    sta dlijmp+2

    plr
    rti

};
end;



procedure copyArrow ();
var ofs:word;
begin;
    ofs := 18*40;
    Move(Pointer(MAP_SCR_ADDRESS+ofs+9), Pointer(TXT_ADDRESS), 5);
    Move(Pointer(MAP_SCR_ADDRESS+ofs+40+9), Pointer(TXT_ADDRESS+40), 5);
    Move(Pointer(MAP_SCR_ADDRESS+ofs+26), Pointer(TXT_ADDRESS+80), 5);
    Move(Pointer(MAP_SCR_ADDRESS+ofs+40+26), Pointer(TXT_ADDRESS+120), 5);
end;

procedure delArrow (cpos:byte);
var ofs:word;
begin
    case cpos of
        0: ofs := 4*40;
        1: ofs := 11*40;
        2: ofs := 18*40;
    end;
    FillChar(Pointer(MAP_SCR_ADDRESS+ofs+9), 5, 0);
    FillChar(Pointer(MAP_SCR_ADDRESS+ofs+40+9), 5, 0);
    FillChar(Pointer(MAP_SCR_ADDRESS+ofs+26), 5, 0);
    FillChar(Pointer(MAP_SCR_ADDRESS+ofs+40+26), 5, 0);
end;

procedure drawArrow (cpos:byte);
var ofs:word;
begin;
    delArrow (0);
    delArrow (1);
    delArrow (2);
    case cpos of
        0: ofs := 4*40;
        1: ofs := 11*40;
        2: ofs := 18*40;
    end;
    Move(Pointer(TXT_ADDRESS+0), Pointer(MAP_SCR_ADDRESS+ofs+9), 5);
    Move(Pointer(TXT_ADDRESS+40), Pointer(MAP_SCR_ADDRESS+ofs+40+9), 5);
    Move(Pointer(TXT_ADDRESS+80), Pointer(MAP_SCR_ADDRESS+ofs+26), 5);
    Move(Pointer(TXT_ADDRESS+120), Pointer(MAP_SCR_ADDRESS+ofs+40+26), 5);
end;


var
    cpos, tmpcol, tmpDMACTL: byte;
    cs:   word;
    finalfname:   String[16];
    flags_fname: TString = 'FLAGSBMPAPL';
    ch:char;
    tmpch:char;
begin;
    playMusic := 0;

    // force inclusion of musciproxy, wont be executed here, but needed for DLIs
    if playMusic = 99 then
        musicproxy();

    DMACTL := $22;
    asm;
        pha
        jsr xbios.xBIOS_SET_DEFAULT_DEVICE
        lda #$00
        sta xbios.xIRQEN
        pla
    end;

    // needed else__DLIVEC is not defined (and DLI wont work as well i think)
    SystemOff;

    // check xbios from StarVagrant
    cs := dPeek($0800);
    if (char(Lo(cs)) <> 'x') or (char(Hi(cs)) <> 'B') then
        // make it crash if no xbios is there
        repeat;
            CRT_Write('NO XBIOS!'~);
        until false;


    show_logo();
    xbunAPL(D_MPLAY, pointer(SAP_PLAYER));
    xbunAPL(D_MUS, pointer($b800));
    //blackConsole();
    xbunAPL(D_TITLE, pointer($3000-6));
    // http://atariki.krap.pl/index.php/CMC_(format_pliku)
    asm
        lda #$70
        ldx #$00  ; low byte of music
        ldy #$b8  ; high byte
        jsr SAP_PLAYER_3
        lda #$00
        ldx #$00
        jsr SAP_PLAYER_3
    end;

    asm
        jsr $6800
    end;

    // this will stop music again
    asm
        lda #$70
        ldx #$00  ; low byte of music
        ldy #$b8  ; high byte
        jsr SAP_PLAYER_3
        lda #$00
        ldx #$00
        jsr SAP_PLAYER_3
    end;


    {$ifdef CART}
    DMACTL := $22;
    SystemOff;
    blackConsole();

    FillChar(Pointer(MAP_SCR_ADDRESS), 40*24, 0);
    xbunAPL (flags_fname, Pointer(MAP_FNT_ADDRESS));

    consoleState := 0;
    acolpf0 := $0e; // white
    acolpf1 := $24; // red
    acolpf2 := $74; // yellow
    acolpf3 := $1e; // blue
    acolbk := $0; // black

    EnableDLI(@dli_flags);
    DLISTL := DL_MAP_ADR; // same adr
    cpos := 0;
    copyArrow();
    repeat;
        drawArrow (cpos);

        ch := readKeyAndStick();
        WaitFrames(10);
        repeat;
            tmpch := checkKeyAndStick ();
        until tmpch <> ch; // wait for key release or so..

        if byte(ch) = $0c then begin
            break;
        end;

        if byte(ch) = 14 then
        begin
            if cpos > 0 then cpos := cpos -1;
        end;

        if byte(ch) = 15 then
        begin
            if cpos + 1 < 3 then cpos := cpos + 1;
        end;
    until true=false;

    for tmpcol := 0 to 7 do
    begin
        if (acolpf0 and $0f > 1) then acolpf0 := acolpf0 - 2;
        if (acolpf1 and $0f > 1) then acolpf1 := acolpf1 - 2;
        if (acolpf2 and $0f > 1) then acolpf2 := acolpf2 - 2;
        if (acolpf3 and $0f > 1) then acolpf3 := acolpf3 - 2;
        Waitframes(3);
    end;

    acolpf0 := $00;
    acolpf1 := $00;
    acolpf2 := $00;
    acolpf3 := $00;

    consoleState := 2;
    blackConsole();
    PORTB := $FF;

    case cpos of
        0: finalfname := 'MAINPL  XEX';
        1: finalfname := 'MAINEN  XEX';
        2: finalfname := 'MAINDE  XEX';
    end;
    xBiosLoadFile (finalfname);
    {$endif}

    {$ifndef CART}
    finalfname := 'MAIN    XEX';
    xBiosLoadFile (finalfname);
    {$endif}
end.
