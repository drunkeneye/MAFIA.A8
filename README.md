# MAFIA

A game originally by Igelsoft, ported to Atari 8-bit by drunkeneye, +Adam+ and Miker.



## Requirements

Atari 8-bit with 64 kB of RAM.


## Tools

Developed using MAD Assembler and MAD Pascal.
An several other tools like atari-tools (https://github.com/jhallen/atari-tools).

Currently, the code only compiles well on MAD Pascal v1.7.0.



## Generating stuff

Few things need to generated in Python.  For this, run ```run.sh```
in ```./generators```.  The map needs also to be converted,
for this start ```run.sh``` in ```./maps```.


## Localization

The localization strings are mainly in ./generators/loc_templates/
but a few strings are built-in, these can be found in vars_ea00_strings.pas 

After localization, the binary files must be regenerated using
./generators/genLocations.py


## Compiling 

In ./src just execute make. If all tools and assets are in place,
this should produce then an ATR image in ./release.
The game language must be specified via the make command,
e.g. to compile for english, use ```make LOCATION=EN```.
Available languages are DE=german, EN=english, PL=polish.


## Gameplay

Straightforward. In many cases typing 0 will return/exit.
Using select/option game can be saved or loaded.

Control is done via cursor keys, but joystick in port 0 should
also work. 

You can press ESC during the map to get an overview of
the health/properties/weapons of every gangster of you
gang (including you).


## Fight 

Moving gangsters is done via cursor keys or joystick.
If one presses enter (or fire) one can shoot. 
The gangster will blink faster and with the cursor keys,
one can shoot in that direction. 
To skip moving the player, press Space.
To quit fighting (and loose), press Q .
To set to AI mode press I. The AI will then take over after
the current move, and cannot be turned off again!





