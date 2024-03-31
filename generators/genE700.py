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

def dumpYString(byte_stream, p):
    byte_stream.append(len(p))
    tmp_sopt = convert_to_atascii(p)
    tmp_sopt = p
    byte_stream.extend(tmp_sopt.encode('utf-8').ljust(39, b'\x00'))
    return byte_stream

def dumpTStringATASCII(byte_stream, p):
    byte_stream.append(len(p))
    tmp_sopt = convert_to_atascii(p)
    byte_stream.extend(tmp_sopt.encode('utf-8').ljust(15, b'\x00'))
    return byte_stream

def dumpYStringATASCII(byte_stream, p):
    byte_stream.append(len(p))
    tmp_sopt = convert_to_atascii(p)
    byte_stream.extend(tmp_sopt.encode('utf-8').ljust(39, b'\x00'))
    return byte_stream


def dumpStrings_EN(byte_stream):
    # fight_str_1..6
    dumpTStringATASCII (byte_stream, 'You hit');
    dumpTStringATASCII (byte_stream, ' !');
    dumpTStringATASCII (byte_stream, 'Unfortunately,');
    dumpTStringATASCII (byte_stream, 'is now dead.');
    dumpTStringATASCII (byte_stream, 'You missed!');
    dumpTStringATASCII (byte_stream, 'Winner is ');

    dumpYStringATASCII (byte_stream, 'Press a key!');

    # map_str_1..9
    dumpTStringATASCII (byte_stream, 'Weapon:');
    dumpTStringATASCII (byte_stream, 'Gangster:');
    dumpTStringATASCII (byte_stream, 'Rent:');
    dumpTStringATASCII (byte_stream, 'Bribe:');
    dumpTStringATASCII (byte_stream, 'Car:');
    dumpTStringATASCII (byte_stream, 'Steps:');
    dumpTStringATASCII (byte_stream, 'Alcohol:');
    dumpTStringATASCII (byte_stream, 'Money:');
    dumpTStringATASCII (byte_stream, 'Credit:');

    # fight_police_1/2
    dumpTStringATASCII (byte_stream, 'The police');
    dumpTStringATASCII (byte_stream, 'Officer');

    # rest
    dumpYStringATASCII (byte_stream, 'You do not have enough money!');
    dumpTStringATASCII (byte_stream, 'Your choice? ');
    dumpYStringATASCII (byte_stream, 'The police await you outside the store!');

    byte_stream.append(5)  


def dumpStrings_DE(byte_stream):
    dumpTStringATASCII (byte_stream, 'Du hast');
    dumpTStringATASCII (byte_stream, ' getroffen!');
    dumpTStringATASCII (byte_stream, 'Leider ist');
    dumpTStringATASCII (byte_stream, 'jetzt tot.');
    dumpTStringATASCII (byte_stream, 'Verfehlt!');
    dumpTStringATASCII (byte_stream, 'Gewonnen hat ');

    dumpYStringATASCII (byte_stream, 'Taste druecken!');

    # map_str_1..9
    dumpTStringATASCII (byte_stream, 'Waffe:');
    dumpTStringATASCII (byte_stream, 'Gangster:');
    dumpTStringATASCII (byte_stream, 'Miete:');
    dumpTStringATASCII (byte_stream, 'Bestechung:');
    dumpTStringATASCII (byte_stream, 'Auto:');
    dumpTStringATASCII (byte_stream, 'Schritte:');
    dumpTStringATASCII (byte_stream, 'Alkohol:');
    dumpTStringATASCII (byte_stream, 'Geld:');
    dumpTStringATASCII (byte_stream, 'Kredit:');

    # fight_police_1/2
    dumpTStringATASCII (byte_stream, 'Die Polizei');
    dumpTStringATASCII (byte_stream, 'Polizist');

    # rest
    dumpYStringATASCII (byte_stream, 'Du hast nicht genug Geld!');
    dumpTStringATASCII (byte_stream, 'Deine Wahl? ');
    dumpYStringATASCII (byte_stream, 'Die Polizei erwartet dich schon!');

    byte_stream.append(10)
 
 
def dumpStrings_PL(byte_stream):
    dumpTStringATASCII (byte_stream, 'Uderzenie');
    dumpTStringATASCII (byte_stream, '!!');
    dumpTStringATASCII (byte_stream, 'Niestety,');
    dumpTStringATASCII (byte_stream, ' nie zyje!');
    dumpTStringATASCII (byte_stream, 'Przegapiles!');
    dumpTStringATASCII (byte_stream, 'Wygral ');

    dumpYStringATASCII (byte_stream, 'Nacisnij klawisz!');

    # map_str_1..9
    dumpTStringATASCII (byte_stream, 'Bron:');
    dumpTStringATASCII (byte_stream, 'Gangster:');
    dumpTStringATASCII (byte_stream, 'Czynsz:');
    dumpTStringATASCII (byte_stream, 'Lapowka:');
    dumpTStringATASCII (byte_stream, 'Auto:');
    dumpTStringATASCII (byte_stream, 'Kroki:');
    dumpTStringATASCII (byte_stream, 'Alkohol:');
    dumpTStringATASCII (byte_stream, 'Pieniadze:');
    dumpTStringATASCII (byte_stream, 'Kredyt:');

    # fight_police_1/2
    dumpTStringATASCII (byte_stream, 'Policja');
    dumpTStringATASCII (byte_stream, 'Policjant');

    # rest
    dumpYStringATASCII (byte_stream, 'Nie masz wystarczaajco pieniedzy!');
    dumpTStringATASCII (byte_stream, 'Twoj wybor? ');
    dumpYStringATASCII (byte_stream, 'Policja czeka na ciebie przed sklepem!');

    byte_stream.append(7)



def createE700(rankNames, weaponNames, carNames, suffix):
    byte_stream = bytearray()

    for k in carPrices:
        byte_stream.extend(struct.pack('<H', k))

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
    dumpTString (byte_stream, 'LOCACREDAPL')


    if suffix == "DE":
        dumpStrings_DE(byte_stream)

    if suffix == "EN":
        dumpStrings_EN(byte_stream)

    if suffix == "PL":
        dumpStrings_PL(byte_stream)



    # Write the byte stream to the file
    filename = f"../assets/E700PAGE.gfx_{suffix}" 
    with open(filename, 'wb') as f:
        f.write(byte_stream)




carPrices = [0, 3500, 4000, 6500, 7000, 7500]
carCargo = [50, 100, 120, 200, 150, 100]
carRange = [35, 45, 55, 60, 65, 50]  # add some more range to accommodate the larger map
weaponPrices = [0, 100, 200, 500, 3000, 4000, 4500, 8000, 10000]
weaponReach = [2, 2, 3, 4, 8, 12, 16, 14, 20] 
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
    'LOCAMAJOAPL',
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


rankNames_EN = ['Rookie', 'Rowdy', 'Small Fry',
                                            'Snatch', 'Crook', 'Mafioso', 'Cop Fright', 'Assassin',
                                            'Gangster Boss', 'Right Hand', 'The Don']
weaponNames_EN = ['Hands', 'Knife', 'Club',
                                            'Brass Knuckles', 'Shuriken', 'Revolver',
                                            'Rifle', 'Machine Gun', 'Grenades']
carNames_EN = ['Feet', 'Talbot 90', 'Chevy Roadster', 'Buick Century', 'Auburn 120', 'Citroen t.a.']

rankNames_PL = ['Poczatkujacy', 'Zbir', 'Mala ryba',
                             'Zlodziej', 'Gauner', 'Mafiosi', 'StrachPol', 'Morderca',
                            'Szef gangsterow', 'Prawa reka', 'Chrzestny']
weaponNames_PL = ['Rece', 'Noz', 'Palka',
                        'Kajdany', 'Gwiazdy', 'Rewolwer',
                        'Karabin', 'KM', 'Granaty']
carNames_PL = ['Stopy', 'Talbot 90', 'Chevy Roadster', 'Buick Century', 'Auburn 120', 'Citroen t.a.']



if __name__ == '__main__':
    createE700(rankNames_DE, weaponNames_DE, carNames_DE, "DE")
    createE700(rankNames_EN, weaponNames_EN, carNames_EN, "EN")
    createE700(rankNames_PL, weaponNames_PL, carNames_PL, "PL")



#
