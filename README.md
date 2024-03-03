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
Pre-compiled tools (for MacOS M1) can be found in ./bin.


## Generating stuff

Few things need to generated in Python.  For this, run ```run.sh```
in ```./generators```.  The map needs also to be converted,
for this start ```run.sh``` in ```./maps```.


## Localization

The localization strings are mainly in ./generators/loc_templates/
but a few strings are built-in, these can be found in strings.pas 

After localization, the binary files must be regenerated using
./generators/genLocations.py

To compile for another language, change LOCATION=EN in the
Makefile. 


## Compiling 

In ./src just execute make. If all tools and assets are in place,
this should produce then an ATR image in ./output/output.atr


## Gameplay

Straightforward. In many cases typing 0 will return/exit.
Using select/option game can be saved or loaded.

Control is done via [/;'] keys for now; joystick should
also work in port 0. TBD.

Use enter to shoot during fights.


## Remarks

- Graphics can be regarded as ugly. Someone should fix this.

- There is basically no sound. There should be some music during
the title, and also during the final. And some soundeffects, maybe
during map-moving and fighting. TBD.

- Source code, especially variables could be cleaned up. Also some
code are not 'optimized', e.g. in some places strings are copied
instead of changing the pointer to the string.


## BUGS or similar

- change control to arrow keys instead of PC/C64 like keys
- help KEY=overview during map implement it
- ask if human player wants to use ai for fight




