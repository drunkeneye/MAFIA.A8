import random
from glob import glob 
from utils import * 
import struct

def dumpTString(byte_stream, p):
    byte_stream.append(len(p))
    tmp_sopt = convert_to_atascii(p)
    tmp_sopt = p
    byte_stream.extend(tmp_sopt.encode('utf-8').ljust(15, b'\x00'))
    return byte_stream

def dumpTStringATASCII(byte_stream, p):
    byte_stream.append(len(p))
    tmp_sopt = convert_to_atascii(p)
    byte_stream.extend(tmp_sopt.encode('utf-8').ljust(15, b'\x00'))
    return byte_stream


def createE700(rankNames, weaponNames, carNames, suffix):
    byte_stream = bytearray()

    for k in carPrices:
        byte_stream.append(k)

    for k in carCargo:
        byte_stream.append(k)

    for k in carRange:
        byte_stream.append(k)

    for k in weaponPrices:
        byte_stream.extend(struct.pack('<H', k))
        
    for k in weaponReach:
        byte_stream.append(k)

    for k in weaponPrecision:
        byte_stream.append(k)

    for k in weaponEffect:
        byte_stream.append(k)

    for k in weaponSound:
        byte_stream.append(k)


    dumpTString (byte_stream, fntname) # not needed anymore, but stays to keep pading intact
    dumpTString (byte_stream, wanted_m_mfname)
    dumpTString (byte_stream, wanted_m_msname)
    dumpTString (byte_stream, wanted_f_mfname)
    dumpTString (byte_stream, wanted_f_msname)
    dumpTString (byte_stream, fightscrname)
    dumpTString (byte_stream, fightfntname)
    dumpTString (byte_stream, gangsterFilename)

    for f in fstrings:
        dumpTString (byte_stream, f)

    for f in rankNames:
        dumpTStringATASCII (byte_stream, f)
    for f in weaponNames:
        dumpTStringATASCII (byte_stream, f)
    for f in carNames:
        dumpTStringATASCII (byte_stream, f)

    for k in range(8):
        byte_stream.append(0)  # player positions

    for k in fpPosStart:
        byte_stream.extend(struct.pack('<H', k))

    # too late to the party
    dumpTString (byte_stream, 'LOCACENTAPL')


    # Write the byte stream to the file
    filename = f"../assets/E700PAGE.gfx_{suffix}" 
    with open(filename, 'wb') as f:
        f.write(byte_stream)




carPrices = [0, 35, 40, 65, 70, 75]
carCargo = [50, 100, 120, 200, 150, 100]
carRange = [35, 45, 55, 55, 70, 50]  # add some more range to accommodate the larger map
weaponPrices = [0, 100, 200, 500, 3000, 4000, 4500, 8000, 10000]
weaponReach = [2, 2, 3, 4, 10, 15, 15, 20, 20]
weaponPrecision = [2, 3, 4, 4, 2, 5, 5, 6, 7]
weaponEffect = [2, 5, 3, 4, 7, 10, 12, 15, 18]
weaponSound = [1, 0, 1, 4, 0, 2, 2, 10, 3]
fpPosStart = [40*10+10,
                        40*8+8,  40*12+8,
                        40*6+6, 40*10+6, 40*12+6,
                        40*4+4, 40*8+4, 40*12+4, 40*16+4,
                        40*2+2, 40*6+2, 40*10+2, 40*14+2, 40*18+2, 0,

                        40*10+30,
                        40*8+32, 40*12+32,
                        40*6+34, 40*8+34, 40*10+34,
                        40*4+36, 40*8+36, 40*12+36, 40*16+36,
                        40*2+38, 40*6+38, 40*10+38, 40*14+38, 40*18+38, 0]

# Variables
#scrname = 'AAMAPSCRAPL'
fntname = 'ACOMBMAPAPL'
#locname = 'AAMAPLOCAPL'
wanted_m_mfname = 'WANTEMMFAPL'
wanted_m_msname = 'WANTEMMSAPL'
wanted_f_mfname = 'WANTEFMFAPL'
wanted_f_msname = 'WANTEFMSAPL'
fightscrname = 'AFMAPSCRAPL'
fightfntname = 'AFMAPFNTAPL'
gangsterFilename = 'GANGSTASDAT'


fstrings = [
    'LOCABANKAPL',
    'LOCAFORGAPL',
    'LOCAMONYAPL',
    'LOCALOANAPL',
    'LOCAPOLIAPL',
    'LOCACARSAPL',
    'LOCAPUBBAPL',
    'LOCAPUBCAPL',
    'LOCASTORAPL',
    'LOCAHIDEAPL',
    'LOCAGAMBAPL',
    'LOCASUBWAPL',
    'LOCAARMSAPL',
    'LOCAMAINAPL',
    'LOCAJOBBAPL',
    'LOCMAJOAPL',
    'LOCACOURAPL',
    'LOCACAUGAPL',
    'LOCAROADAPL',
    'LOCAUPDTAPL',
    'LOCASETUAPL'
]
rankNames_DE  =  ['Anfaenger', 'Schlaeger', 'Kleiner Fisch',
                                            'Langfinger', 'Ganove', 'Mafiosi', 'Bullenschreck', 'Meuchelmoerder',
                                            'Gangsterboss', 'Rechte Hand',  'Der Pate']
weaponNames_DE  = ['Haende', 'Messer', 'Knueppel',
                                                'Schlagkette', 'Wurfsterne', 'Revolver',
                                                'Gewehr', 'Maschinengewehr', 'Handgranaten']
carNames_DE =  ['Fuesse', 'Talbot 90', 'Chevy Roadster', 'Buick Century', 'Auburn 120', 'Citroen t.a.']


rankNames_EN = ['Beginner', 'Thug', 'Small Fry',
                                            'Pickpocket', 'Crook', 'Mafioso', 'Cop Fright', 'Assassin',
                                            'Gangster Boss', 'Right Hand', 'The Don']
weaponNames_EN = ['Hands', 'Knife', 'Club',
                                            'Brass Knuckles', 'Shuriken', 'Revolver',
                                            'Rifle', 'Machine Gun', 'Grenades']
carNames_EN = ['Feet', 'Talbot 90', 'Chevy Roadster', 'Buick Century', 'Auburn 120', 'Citroen t.a.']



if __name__ == '__main__':
    createE700(rankNames_EN, weaponNames_EN, carNames_EN, "EN")
    createE700(rankNames_DE, weaponNames_DE, carNames_DE, "DE")



#
