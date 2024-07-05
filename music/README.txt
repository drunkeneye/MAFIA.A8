SAP format is usually data and a player.
The player starts usually at $0500, but we have xbios there.
Since we cannot relocate the code, we just take a .sap where
the player is already relocated to a suitable adresse.
This is Outer_1.sap. The player starts at $95a3.
Thus we use splitter.py to extract the player, and copy it 
as play95a3.gfx which then gets apl-packed and can be
loaded to this adresse in title.pas
For the music, we need to relocate the pattern table.
THere are bytes which refer to the absolute addresse.
We need the music at $a000, so we added this to splitter.py
This will relocate automatically to this addresse.
Finally, we need the RastaConverter assembler to call
out music routine-- we hard-coded this into no-name.asq.

So for a different song, use splitter.py to split off
the music data, copy it over, and actually that is all.
Ensure the player from Outer.sap will work with the .sap,
there are different versions somehow, and also there is
a CMC+ format, we ignore.


