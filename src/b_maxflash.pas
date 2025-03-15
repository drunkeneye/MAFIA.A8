const 
MF_ZPLOCATION = $D8; // starting location of reserved 4 bytes used by BurnPages routine


const 
CARTOP = $BFFF; // @nodoc 
CARBAS = $A000; // @nodoc 

var GINTLK: byte absolute $03FA;  // @nodoc 
    TRIG3: byte absolute $D013;   // @nodoc 
    zerobank: byte absolute $D500;  // @nodoc 
    cartoff: byte absolute $D580;  // @nodoc 
    carbase: byte absolute $A000;  // @nodoc 
    banks: array [0..0] of byte absolute $D500;  // @nodoc 
    copysrc: word absolute MF_ZPLOCATION;  // @nodoc 
    copydst: word absolute MF_ZPLOCATION + 2;  // @nodoc 
    workpages: byte absolute MF_ZPLOCATION + 3;  // @nodoc 
    curbank: byte absolute MF_ZPLOCATION + 4;  // @nodoc 
    cursec: byte absolute MF_ZPLOCATION + 5;  // @nodoc 



// ensure this is not in bank area, this is 'double usage' of the memory,
// but location_name will be loaded anyway after loading/saving game
const 
    SAVE_LOCATION_ADR = LOCATION_ADR + $200; // this is option 7... not be used in setup

var
    save_lastSave: byte absolute SAVE_LOCATION_ADR; 
    saveBank: byte absolute SAVE_LOCATION_ADR + $1; 
    // will be set when resolving save adr
    saveAddress: word  absolute SAVE_LOCATION_ADR + $2;
    save_slot: byte absolute SAVE_LOCATION_ADR + $4;
    save_gameFound: byte absolute SAVE_LOCATION_ADR + $5;
    save_savenum: byte absolute SAVE_LOCATION_ADR + $6;
    tmp_aa: byte  absolute SAVE_LOCATION_ADR + $7;
    tmp_55: byte  absolute SAVE_LOCATION_ADR + $8;
    bank_bank: byte  absolute SAVE_LOCATION_ADR + $9;
    bank_src: word  absolute SAVE_LOCATION_ADR + $a;
    bank_dest: word  absolute SAVE_LOCATION_ADR + $c;
    bank_size: word  absolute SAVE_LOCATION_ADR + $e;
    bank_val: byte  absolute SAVE_LOCATION_ADR + $10;
    bank_sector: byte absolute SAVE_LOCATION_ADR + $11;
    bank_write: byte  absolute SAVE_LOCATION_ADR + $12;



procedure SetBank; // take bank_bank
begin
    curbank := bank_bank;
    banks[curbank] := 0;
end;    


procedure SetSector;
begin
    cursec := bank_sector;
    bank_bank := bank_sector shl 3;
    SetBank;
end;    
  
  
procedure Wr5555;assembler;
asm {
        lda bank_write
.def :_wr5555
        bit curbank
        bvs _wr5c2
        sta $d502   
        sta $b555
        rts     
_wr5c2  
        sta $d542   
        sta $b555
};
end;

procedure Wr2AAA;assembler;
asm {
        lda bank_write
        bit curbank
        bvs _wr2c2
        sta $d501
        sta $aaaa
        rts 
_wr2c2      
        sta $d541       
        sta $aaaa       
};    
end;

procedure CmdUnlock;
begin
    bank_write := $aa;
    Wr5555;
    bank_write := $55;
    Wr2AAA;
end;

procedure CmdInit;assembler;
asm {
    lda #$00            
    sta nmien           
    sta wsync   
};
end;

procedure CmdCleanup();assembler;
asm {
    sta cartoff
    sta wsync           
    lda trig3           
    sta GINTLK  
    lda #$40
    sta nmien   
};
end;

procedure WaitToComplete;assembler;
asm {
poll_write  
        lda #$00        
        sta workpages       
_poll_again 
        lda carbase 
        cmp carbase         
        bne poll_write      
        cmp carbase         
        bne poll_write      
        inc workpages       
        bne _poll_again     
};
end;


procedure EraseSector;
begin
   CmdInit;
   SetSector; // will use bank_sector
   CmdUnlock;
   bank_write := $80;
   Wr5555;
   CmdUnlock;
   SetSector; // will use bank_sector
   carbase := $30; 
   WaitToComplete;
   CmdCleanup;
end;



procedure BurnByte;
begin
    CmdInit;
    CmdUnlock;
    bank_write := $a0;
    Wr5555;
    SetBank;
    Poke(bank_dest,bank_val);
    CmdCleanup;
end;



procedure BurnBlock;
begin
    CmdInit;
    repeat
        CmdUnlock;
        
        bank_write := $a0;
        Wr5555;

        SetBank;
        Poke(bank_dest,peek(bank_src));
        inc(bank_src);
        inc(bank_dest);
        if bank_dest = CARTOP + 1 then begin
            Inc(bank_bank);
            bank_dest := CARBAS;
        end;
        dec(bank_size);
    until bank_size = 0;
    CmdCleanup;
end;


