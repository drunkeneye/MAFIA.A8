
// stupid delphi
procedure loadMap();forward;
procedure preloadMap();forward;


procedure nextPlayer();
begin
    currentPlayer := currentPlayer + 1;
    if currentPlayer > nPlayers-1 then
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
procedure playersTurn ();
begin
  CRT_Clear;
  CRT_WriteCentered(4, loc_string_1);
  CRT_WriteCentered(5, gangsterNames[currentPlayer SHL 3]);
  CRT_WriteCentered(6, loc_string_2);

  sound(0,100,10,15);
  WaitFrames(30);
  sound(0,96,10,15);
  WaitFrames(20);
  sound(0,121,10,15);
  WaitFrames(10);
  // sound(0,133,10,15);
  // WaitFrames(20);
  // sound(0,121,10,15);
  // WaitFrames(10);
  // sound(0,155,10,15);
  // WaitFrames(10);
  // sound(0,145,10,15);
  // WaitFrames(10);
  // sound(0,155,10,15);
  // WaitFrames(10);
  // sound(0,145,10,15);
  // WaitFrames(10);
  NoSound;
  waitForKey();
  CRT_NewLine;
  CRT_Newline;
end;



procedure placeCurrentPlayer ();
begin
  mapPos_X := plMapPosX[currentPlayer];
  mapPos_Y := plMapPosY[currentPlayer];
  playerPos_X := 49+mapPos_X*8;
  playerPos_Y := 36+mapPos_Y*8;
  currentMap := plCurrentMap[currentPlayer];
  // loadMap();
end;


// // works with global vars
// procedure showPlayerStatus;
//   var S:String;
// begin
//   // status thing
//   CRT_Clear;
//   CRT_NewLine();
//   CRT_Write(' Miete:'~);
//   CRT_Write(plRentMonths[currentPlayer]);
//   CRT_NewLine();

//   CRT_Write(' Auto:'~); // actually steps should be shown
//   CRT_Write(carNames[plCar[currentPlayer]]);
//   CRT_NewLine();

//   CRT_Write(' Bestechung:'~);
//   CRT_Write(plBribe[currentPlayer]);
//   CRT_NewLine();

//   CRT_Write(' Cargo:'~);
//   CRT_Write(carCargo[plCar[currentPlayer]]);
//   CRT_NewLine();

//   CRT_Write(' Rang:'~);
//   CRT_Write(rankNames[plRank[currentPlayer]]);
//   CRT_NewLine();

//   CRT_Write(' Waffe:'~);
//   CRT_Write(weaponNames[gangsterWeapon[currentPlayer SHL 3]]);
//   CRT_NewLine();

//   CRT_Write(' Gangster:'~);
//   CRT_Write(plNGangsters[currentPlayer]);
//   CRT_NewLine();

//   CRT_Write(' Kredit:'~);
//   CRT_Write(plLoan[currentPlayer]);
//   CRT_NewLine();

//   CRT_Write('('~);
//   CRT_Write(plLoanTime[currentPlayer]);
//   CRT_Write(' Monate)'~);
//   CRT_NewLine();

//   CRT_ReadKey();
// end;
