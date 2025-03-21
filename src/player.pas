

procedure nextPlayer();
begin
    currentPlayer := currentPlayer + 1;
    if currentPlayer+1 > nPlayers then
    begin;
        currentPlayer := currentPlayer - nPlayers;
        currentMonth := currentMonth + 1;
        if currentMonth > 12 then begin;
            currentYear := currentYear + 1;
            currentMonth := 1;
        end;
    end;
end;


procedure initPlayers();
var k: byte;
begin
  // start position, in character coordinates
  // top left in real coordinates is 49, 36
  for k := 0 to 3 do
  begin;
    plMapPosX[k] := 3;
    plMapPosY[k] := 2;
    plCurrentMap[k] := 0;
  end;

  // start down below, where the major/moneytransporter is visible for debugging
  // for k := 0 to 3 do
  // begin;
  //   plMapPosX[k] := 7;
  //   plMapPosY[k] := 14;
  //   plCurrentMap[k] := 7;
  // end;
end;



// works with global vars
function playersTurn (): byte;
var ch:char;
  z:byte;
begin
  CRT_Clear;
  CRT_WriteCentered_LocStr(4, 1);
  z := currentPlayer SHL 3;
  CRT_WriteCentered(5, gangsterNames[z]);
  CRT_WriteCentered_LocStr(6, 2);

  {$ifdef CART}
  msx.init (0);
  msx.play();
  playMusic := 1;
  WaitFrames(120);
  msx.stop();
  playMusic := 0;
  {$else}
  msx.init (0);
  msx.play();
  playMusic := 1;
  WaitFrames(120);
  msx.stop();
  playMusic := 0;
  {$endif}


  result := 0;
  if currentPlayer = 0 then
  begin
    CRT_WriteCentered_LocStr(8, 40);
    CRT_WriteCentered_LocStr(9, 41);
    ch := readKeyAndStick();
    if byte(ch) = $1e then begin;
        loadLocation(SETUP_);
        loadGame();
        waitForKey();
        loadLocation(MAIN_);
        result := RESET_;
    end;
    if byte(ch) = $1f then begin;
        loadLocation(SETUP_);
        blackConsole();
        saveGame();
        enableConsole();
        CRT_Clear;
        CRT_WriteCentered_LocStr(1, 19);
        waitForKey();
        loadLocation(MAIN_);
    end;
  end
  else
  begin
    waitForKey();
  end;
  CRT_NewLine;
  CRT_Newline;
end;



procedure placeCurrentPlayer ();
begin
  mapPos_X := plMapPosX[currentPlayer];
  mapPos_Y := plMapPosY[currentPlayer];
  playerPos_X := 49+mapPos_X*8;
  playerPos_Y := 36+mapPos_Y*8;
  spriteMoveDir := 1;
  currentMap := plCurrentMap[currentPlayer];
  // loadMap();
end;
