{$DEFINE ROMOFF}    // http://mads.atari8.info/doc/en/syntax/#romoff
{$DEFINE NOROMFONT}

program autorun;


{$define basicoff}
{$librarypath '../../tools/Mad-Pascal/blibs/'}
{$librarypath '../../tools/Mad-Pascal/base/'}
{$librarypath '../../tools/Mad-Pascal/lib/'}

{$r ./resources_title.rc}


uses atari, xbios, crt, b_utils, rmt, b_pmg, sysutils, b_system, b_crt;


const
    baseAddress =   $BE80;
    e7adr =   $e700;

var  // for sprites
    stick :   byte absolute $278;
    PCOLR0:   byte absolute $D012;
    PCOLR1:   byte absolute $D013;
    PCOLR2:   byte absolute $D014;
    PCOLR3:   byte absolute $D015;
    playerPos_X:   byte absolute e7adr + 936+16;

    // not used
    loccolbk:            Byte absolute baseAddress + $2B0 + 41 * $28;
    loccolpf0:            Byte absolute baseAddress + $2B0 + 41 * $28 + 1;
    loccolpf1:            Byte absolute baseAddress + $2B0 + 41 * $28 + 2;
    loccolpf2:            Byte absolute baseAddress + $2B0 + 41 * $28 + 3;
    mapColorA: byte absolute $ea11;
    mapColorB: byte absolute $ea12;

    playMusic: byte absolute $e0a1;
	msx: TRMT;


const
{$i const.inc}




procedure musicproxy();
begin;
    msx.play();
end;



{$I interrupts.inc}
{$i console.pas}

{$I xbaplib.pas}

var
    D_LOGO: TString = 'LOGO    APL';
    D_TITLE: TString = 'TITLEPICAPL';
    D_MPLAY: TString = 'PLAYB000APL';
    D_MUS: TString = 'TMUSB800APL';
    locfname:   TString;

var
    e7fname: TString = 'E700PAGEAPL';

 const
    e7adrm6 = $e600-6;

const
    ADR_LOGO         =   $9036;
    // DL GR.8 $8036; GFX $8150
    ADR_LOGO_DL      =   ADR_LOGO;
    ADR_LOGO_GFX     =   $9150;

    L_COLOR1         =   $9c;
    L_COLOR2         =   $12;
    L_COLOR4         =   $12;


procedure show_logo;
begin
    xbunAPL(D_LOGO, pointer(ADR_LOGO));
    COLOR1 := L_COLOR1;
    COLOR2 := L_COLOR2;
    COLOR4 := L_COLOR4;
    SDLSTL := ADR_LOGO_DL;
    SAVMSC := ADR_LOGO_GFX;
end;


var
    cs:   word;
    finalfname:   String[16];
begin;
    playMusic := 0;
    // force inclusion of musciproxy, wont be executed here
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

    //SystemOff;

    // check xbios from StarVagrant
    cs := dPeek($0800);
    if (char(Lo(cs)) <> 'x') or (char(Hi(cs)) <> 'B') then
        // make it crash if no xbios is there
        repeat;
            CRT_Write('NO XBIOS!'~);
        until false;


    show_logo();
    xbunAPL(D_TITLE, pointer($3000-6));
    // waitframes somehow do not work whatever
    // just load logo again, fin.
    // Delay(3000);
    xbunAPL(D_MPLAY, pointer(SAP_PLAYER));
    xbunAPL(D_MUS, pointer($b800));
    // http://atariki.krap.pl/index.php/CMC_(format_pliku)
    // repeat; until false;
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

    // hopefully this will stop music again
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
    xBiosLoadFile (finalfname);
end.
