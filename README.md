# MAFIA

A game originally by Igelsoft, ported to Atari 8-bit by drunkeneye.

## Status

Beta. Graphics are suboptimal, sound is not existing.
There will be many bugs.


## Requirements

Atari 8-bit with 64 kB of RAM.


## Tools

Developed using MAD Assembler and MAD Pascal.
An several other tools like atari-tools (https://github.com/jhallen/atari-tools).

Currently, the code only compiles well on MAD Pascal v1.7.0.

Also, be aware that the code has been developed on a MacOS with
case-insensitive filesystem. Depending on that, files might not be
found when using case-sensitive filesystem like on Linux.



## Generating stuff

Few things need to generated in Python.  For this, run ```run.sh```
in ```./generators```.  The map needs also to be converted,
for this start ```run.sh``` in ```./maps```.


## Localization

The localization strings are mainly in ./generators/loc_templates/
but a few strings are built-in, these can be found in strings.pas 

After localization, the binary files must be regenerated using
./generators/genLocations.py


## Compiling 

In ./src just execute make. If all tools and assets are in place,
this should produce then an ATR image in ./release.
The game language must be specified via the make command,
e.g. to compile for english, use ```make LOCATION=EN```.


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



## Remarks

- Graphics can be regarded as ugly. Someone should fix this.

- There is basically no sound. There should be some music during
the title, and also during the final. And some soundeffects, maybe
during map-moving and fighting. TBD.

- Source code, especially variables could be cleaned up. Also some
code are not 'optimized', e.g. in some places strings are copied
instead of changing the pointer to the string.


## TODO 

- Maybe different fight maps, but then the AI might need a fix or two.


## BUGS or similar

- Balance maybe walking costs/car range
- Even out rank requirements for bank/pub/gangsters
- Fix English/Polish localizations
- subway station name is not correct when stealing at central station



