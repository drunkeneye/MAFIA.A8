
Var 
//    msx          :   TRMT;
    //priorDefault :   byte;
    //old_vbl      :   pointer absolute $238;
    consoleState: byte;

 
Procedure WaitFrames(frames: byte);
Begin
    While frames>0 Do
        Begin
            WaitFrame;
            Dec(frames);
        End;
End;

 
// Procedure vblMusic;
// interrupt;
// Begin
//     msx.play;
// End;


Procedure blackConsole();
Begin;
    if consoleState = 0 then exit;
    EnableDLI(@dli_black_console);
    DLISTL := DL_BLACK_CONSOLE_ADR;
    consoleState := 0;
End;


Procedure enableConsole();
Begin;
    if consoleState =1 then exit;
    //  SystemOff($fe);
    EnableDLI(@dli_console);
    DLISTL := DL_CONSOLE_ADR;
    SetCharset (Hi(MAINFONT_ADR));
    // when system is off
    CRT_Init(TXT_ADDRESS, 40, 25);
    consoleState := 1;
End;


Procedure enableMapConsole();
Begin;
    if consoleState = 2 then exit;
    mapColorA := $88; // ensure this when enabling
    mapColorB := $06;
    EnableDLI(@dli_map);
    DLISTL := DL_MAP_ADR;
    SetCharset (Hi(MAP_FNT_ADDRESS));
    CRT_Init(MAP_SCR_ADDRESS, 40, 25);
    consoleState := 2;
End;

//
