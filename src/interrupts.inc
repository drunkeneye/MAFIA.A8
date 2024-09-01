
procedure dli_map;assembler;interrupt;
asm {
dli:
    phr ; store registers

dlijmp:
    jmp dli1

dli1:
    lda #>MAP_FNT_ADDRESS
    sta $D409 ; CHBAS_real
    sta WSYNC

    mva #$0e atari.colpf0 ; white 

    mva mapColorB atari.colpf1
    ; mva #$06 atari.colpf1 ; lightgrey
    
    mva mapColorA atari.colpf2
    ; mva #$88 atari.colpf2 ; bluish
    
    
    mva #$2a atari.colpf3 ; orangish
    mva #$00 atari.colbk  ; black

    ; move PMG to current position
    lda spriteMoveDir
    cmp #$01
    beq dli1_X
    lda PLAYERPOS_X
    sec 
    sbc #$01
    jmp dli1_X2
dli1_X:
    lda PLAYERPOS_X
    ; clc
    ; adc #$01
dli1_X2:
    sta HPOSP0
    sta HPOSP1
    sta HPOSP2
    sta HPOSP3

    lda #<dli2
    sta dlijmp+1
    lda #>dli2
    sta dlijmp+2

    plr
    rti

dli2:
    nop
    nop
    nop
    nop
    mva #$00 atari.colpf2 ; hue
    mva #$ff atari.colpf1 ; lum

    lda #>MAINFONT_ADR
    sta $D409 ; CHBAS_real

    ; deactivate PMG by moving it out of screen
    lda #$0
    sta HPOSP0
    sta HPOSP1
    sta HPOSP2
    sta HPOSP3
    sta WSYNC

    ; next
    lda #<dli3
    sta dlijmp+1
    lda #>dli3
    sta dlijmp+2

    plr
    rti

dli3:
    sta WSYNC
    mva #$ff atari.colpf1 ; lum
    mva #$00 atari.colpf2 ; hue

    lda #<dli4
    sta dlijmp+1
    lda #>dli4
    sta dlijmp+2

    plr
    rti

dli4:
    jsr main.musicproxy

    lda #<dli1
    sta dlijmp+1
    lda #>dli1
    sta dlijmp+2

    plr
    rti

};
end;



procedure dli_black_console;assembler;interrupt;
asm {
    phr 
    mva #$0 atari.colpf0 
    mva #$0 atari.colpf1 
    mva #$0 atari.colpf2 
    mva #$0 atari.colbk 
    jsr main.musicproxy
    plr  
};
end;



procedure dli_console;assembler;interrupt;
asm {
    phr  
    mva loccolbk atari.colbk
    mva loccolpf0 atari.colpf0 
    mva loccolpf1 atari.colpf1 
    mva loccolpf2 atari.colpf2  

    jsr main.musicproxy

    plr 
};
end;



 