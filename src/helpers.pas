

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


// produce some sound effect or something while waiting
procedure effectWait ();
begin;
    WaitFrames(120);
end;



function CRT_ReadKeyOrJoystick():byte;
var z: char;
begin;
    result := kbcode;
    repeat until (not CRT_KeyPressed) or (result<>kbcode);
    repeat
      z := checkKeyAndStick();
    until CRT_KeyPressed or (z = #$0c) or (z = #14) or (z = #15) or (z = #06) or (z = #07);
    if byte(z) <> 0 then
      result := byte(z)
    else
      result := kbcode;
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


function getRandom(minp:word; maxp:word; steps:word):   word;
var prop:   word;
  x,y: byte;
begin;
    x := CRT_WhereX;
    y := CRT_WhereY;
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
    until checkKeyAndStick() <> #0;
    repeat;
      ch := byte(checkKeyAndStick()); // ensure we have read all there is
    until (ch = 0) and (not CRT_KeyPressed);
    result := prop;
end;



function getAnswerChar(Akey:byte; Bkey:byte; A:char; B:char): byte;
var x, y: byte;
  ch: byte;
  answer: char;
begin
  x := CRT_WhereX;
  y := CRT_WhereY;
  answer := A;
  repeat
    CRT_GotoXY(x, y);
    CRT_Write(answer);
    CRT_Write(' '~);
    ch := CRT_ReadKeyOrJoystick();
    if ch = $0c then break;
    if (ch = 14) or (ch = Akey) then answer := A;
    if (ch = 15) or (ch = Bkey) then answer := B;
  until false;
  if answer = A then result := 0 else result := 1;
end;


// 0 = N, 1 = Y
function getYesNo:   byte;
begin
    result := getAnswerChar(N_keycode, Y_keycode, N_charcode, Y_charcode);
end;


const
  FAST_ADJUST_DELAY: byte = 16;


function readValue(minValue: SMALLINT; maxValue: SMALLINT): SMALLINT; //overload;
var
  value: integer; // To ensure that +step does not overflow
  step: SMALLINT;
  x, y: byte;
  tmpch, ch: char;
  curDelay: byte;
  fastAdjustCounter: byte;
begin
  x := CRT_WhereX;
  y := CRT_WhereY;

  value := minValue;
  step := 1;
  fastAdjustCounter := 0;
  curDelay := FAST_ADJUST_DELAY;
  CRT_Write(value);
  CRT_Write('    '~);
  ch := char(CRT_ReadKeyOrJoystick()); //this will wait for release
  repeat
    ch := checkKeyAndStick();

    if byte(ch) = $0c then break;

    if byte(ch) = 14 then
    begin
      if fastAdjustCounter = 0 then
      begin
        value := value + step;
        if value > maxValue then
          value := maxValue;
        if curDelay > 2 then
          curDelay := curDelay - 1
        else
          step := 2;
        fastAdjustCounter := curDelay;
      end;
    end
    else if byte(ch) = 07 then
    begin
      value := value + 500;
      if value > maxValue then
        value := maxValue;
      // wait
      repeat;
          tmpch := checkKeyAndStick ();
      until tmpch <> ch; // wait for key release or so..
    end
    else if byte(ch) = 06 then
    begin
      value := value - 500;
      if value < minValue then
        value := minValue;
      // wait
      repeat;
          tmpch := checkKeyAndStick ();
      until tmpch <> ch; // wait for key release or so..
    end
    else if byte(ch) = 15 then
    begin
      if fastAdjustCounter = 0 then
      begin
        value := value - step;
        if value < minValue then
          value := minValue;
        if curDelay > 2 then
          curDelay := curDelay - 1
        else
          step := 2;
        fastAdjustCounter := curDelay;
      end;
    end
    else
    begin
      fastAdjustCounter := 0;
      curDelay := FAST_ADJUST_DELAY;
      step := 1;
    end;

    if fastAdjustCounter > 0 then
      fastAdjustCounter := fastAdjustCounter-1;

    CRT_GotoXY(x, y);
    CRT_Write(value);
    CRT_Write('    '~);
    WaitFrame;
  until false;

  result := value;
end;


procedure loadGangster(g: byte);
var b, k:   byte;
{$ifndef CART}
  p: cardinal; // save a few bytes..
{$endif}
begin;
    {$ifdef CART}
    xBiosOpenFile(gangsterFilename);
    // NO IDEA how to do this differently, loading with setlength did not work
    // p := g SHL 8;
    // xBiosSetFileOffset(p);
    // xBiosSetLength(255-17);
    // xBiosLoadData(Pointer(VARBLOCK1+$470));
    for b := 0 to g-1 do
    begin;
      for k := 0 to 255-17 do // $470-$55e incl.
        Poke(VARBLOCK1+$470+k, xBiosGetByte); // pointer to buf_gangsterText1
      for k := 0 to 17-1 do
        xBiosGetByte; // do not save anywhere
    end;

    {$else}

    xBiosOpenFile(gangsterFilename);
    p := g SHL 8;
    xBiosSetFileOffset(p);
    xBiosSetLength(255);
    for k := 0 to 255-17 do // $470-$55e incl.
        Poke(VARBLOCK1+$470+k, xBiosGetByte); // pointer to buf_gangsterText1
    {$endif}

    CRT_Writeln(buf_gangsterName);
    CRT_NewLine;
    CRT_Writeln(buf_gangsterText1);
    CRT_Writeln(buf_gangsterText2);
    CRT_Writeln(buf_gangsterText3);
    CRT_Writeln(buf_gangsterText4);
    CRT_Writeln(buf_gangsterText5);
end;



{$ifdef CART}

// these things taken from flob
// https://gitlab.com/bocianu/flob/


// these correspond to the end of the card
const
    SAVE_SECTOR = 7;
    SAVE_BASEBANK = SAVE_SECTOR * 8;
    SAVE_SIZE = $d000-$c920-1;
    SAVE_PAGES = 8;
    SAVE_SLOTS = 32;

// ALL THESE ROUTINES DO NOT USE 'LOCAL' VARIABLES
// THESE COULD BE IN MEMORY BANK SWITCH AREA
// SO WE FIX THEM TO BE AT SAY C700+... instead



// this can yield saveBank between 56 and 63,
// so end of card
procedure ResolveSaveAddress; //(save_slot: byte); stdcall;
begin
    saveBank := SAVE_BASEBANK + (save_slot shr 2);
    saveAddress := ($a0 + ((save_slot and $3) shl 3)) shl 8;
    // saveBank := SAVE_BASEBANK + (save_savenum shr 5);
    // saveAddress := ($a0 + (save_savenum and $1F)) shl 8;
end;


procedure checkForSavedGame();
begin
    save_gameFound := 0;
    save_lastSave := 0;
    CmdInit();
    for save_slot := 0 to SAVE_SLOTS-1 do
    begin;
        ResolveSaveAddress;
        bank_bank := saveBank;
        SetBank;
        bank_src := dpeek(saveAddress + $4A0);
        if bank_src = $abcd then 
        begin;
            save_gameFound := 1;
            save_lastSave := save_slot;
        end;
    end;
    CmdCleanup();
end;


procedure saveGame ();
begin;
    WaitFrame;

    // first check if we had a last game
    checkForSavedGame();
    if save_gameFound = 1 then 
    begin;
        save_lastSave := save_lastSave + 1;
        if save_lastSave = SAVE_SLOTS then 
        begin
            save_lastSave := 0;
            bank_sector := SAVE_SECTOR;
            EraseSector; // always the same sector
        end;
    end;

    save_slot := save_lastSave;
    ResolveSaveAddress;
    // WHYEVER THIS WILL DESTROY THE SAVEADRESS BYTES 
    // AND COPY VARBLOCK OVER. so maybe we save it first and then retrieve..
    tmp_55 := Peek($b555);
    tmp_aa := Peek($aaaa);
    // for now the save size is fixed, we do not have more than $800 bytes there anyway
    // Move(Pointer(saveAddress), Pointer(MAP_FNT_ADDRESS), $800); 
    // Cmdinit();
    
    bank_bank := saveBank;
    SetBank; 

    saveGameMagic := $abcd;
    asm sei end;
    bank_bank := saveBank;
    bank_src := VARBLOCK2;
    bank_dest := saveAddress;
    bank_size := SAVE_SIZE;
    BurnBlock;

    asm cli end;
    cmdCleanup();
    Poke($b555, tmp_55);
    Poke($aaaa, tmp_aa);
end;


procedure loadGame ();
begin;
    // loaded location will always be SETUP_
    CRT_Clear;
    CRT_WriteCentered_LocStr(1,17); // this will access say $A5A1, but its ok, we dont access banks yet
    // first check if its plausible
    checkForSavedGame();
    if save_gameFound = 0 then begin;
        CRT_WriteCentered_LocStr(3, 18);
        waitForKey;
        exit;
    end;
    // load game now
    save_slot := save_lastSave;
    ResolveSaveAddress;
    CmdInit();
    bank_bank := saveBank;
    SetBank;
    Move(pointer(saveAddress), pointer(VARBLOCK2), SAVE_SIZE);
    cmdCleanup;
end;


{$else}

const
  saveGameLength = $d000-$c920;


procedure saveGame ();
begin;
    // loaded location will always be SETUP_
    xBiosOpenFile(saveFname);
    xBiosSetLength(saveGameLength); // just dump all of it
    xBiosWriteData(Pointer(VARBLOCK2));
    xBiosFlushBuffer();
end;


procedure checkForSavedGame ();
var tmp:byte;
begin;
    xBiosOpenFile(saveFname);
    xBiosSetLength($1);
    xBiosLoadData(@tmp);
    if (tmp > 4) or (tmp = 0) then begin;
        save_gameFound := 0;  // invalid
        exit;
    end;
    save_gameFound := 1;
end;


procedure loadGame ();
begin;
    // loaded location will always be SETUP_
    CRT_Clear;
    CRT_WriteCentered_LocStr(1,17);
    // first check if its plausible
    checkForSavedGame();
    if save_gameFound = 0 then begin;
        CRT_WriteCentered_LocStr(3, 18);
        waitForKey;
        exit;
    end;

    // reopen
    xBiosOpenFile(saveFname);
    xBiosSetLength(saveGameLength); // just dump all of it
    xBiosLoadData(Pointer(VARBLOCK2));
    xBiosFlushBuffer();
    waitForKey();
end;


{$endif}
