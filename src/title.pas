{$DEFINE ROMOFF}    // http://mads.atari8.info/doc/en/syntax/#romoff
{$DEFINE NOROMFONT}

program autorun;


{$define basicoff}
{$librarypath '../../tools/Mad-Pascal/blibs/'}
{$librarypath '../../tools/Mad-Pascal/base/'}
{$librarypath '../../tools/Mad-Pascal/lib/'}

{$r ./resources_title.rc}


uses atari, pmg, xbios, crt, cio, aplib, b_utils, rmt, b_pmg, sysutils, b_system, b_crt;

const
{$i const.inc}

// these are mainly needed to allow inclusion of files 
// that are part of the game. else we get undefined variables etc.
const
    e7adr =   $e700;

type 
    XString =   String[15];
    YString =   String[40];

var 
    stick :   byte absolute $278;
    PCOLR0:   byte absolute $D012;
    PCOLR1:   byte absolute $D013;
    PCOLR2:   byte absolute $D014;
    PCOLR3:   byte absolute $D015;
    playerPos_X:   byte absolute e7adr + 936+16;
    spriteMoveDir: shortint absolute $ea13;

{$i vars_be80_location.pas}

    mapColorA: byte absolute $ea11;
    mapColorB: byte absolute $ea12;

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


var
    cs:   word;
    finalfname:   String[16];
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

    finalfname := 'MAIN    XEX';
    blackConsole();
    xBiosLoadFile (finalfname);
end.
