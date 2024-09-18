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
    dumpTStringATASCII (byte_stream, 'You hit ');
    dumpTStringATASCII (byte_stream, '!');
    dumpTStringATASCII (byte_stream, 'Unfortunately,');
    dumpTStringATASCII (byte_stream, 'is done for.');
    dumpTStringATASCII (byte_stream, 'You missed!');
    dumpTStringATASCII (byte_stream, 'Winner is ');

    dumpYStringATASCII (byte_stream, 'Press a key!');

    # map_str_1..9
    dumpTStringATASCII (byte_stream, 'Weapon:');
    dumpTStringATASCII (byte_stream, 'Gangsters:');
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
    dumpTStringATASCII (byte_stream, 'They hit ');


def dumpStrings_DE(byte_stream):
    dumpTStringATASCII (byte_stream, 'Du hast ');
    dumpTStringATASCII (byte_stream, ' getroffen!');
    dumpTStringATASCII (byte_stream, 'Leider ist');
    dumpTStringATASCII (byte_stream, 'erledigt.');
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
    dumpTStringATASCII (byte_stream, 'Sie haben ');


def dumpStrings_PL(byte_stream):
    dumpTStringATASCII (byte_stream, 'Trafiony ');
    dumpTStringATASCII (byte_stream, '!');
    dumpTStringATASCII (byte_stream, 'Niestety,');
    dumpTStringATASCII (byte_stream, ' odpada z walki');
    dumpTStringATASCII (byte_stream, 'Pudlo!');
    dumpTStringATASCII (byte_stream, 'Kto wygral? ');

    dumpYStringATASCII (byte_stream, 'Nacisnij klawisz!');

    # map_str_1..9
    dumpTStringATASCII (byte_stream, 'Bron:');
    dumpTStringATASCII (byte_stream, 'Gangsterzy:');
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
    dumpYStringATASCII (byte_stream, 'Nie masz tyle pieniedzy!');
    dumpTStringATASCII (byte_stream, 'Twoj wybor? ');
    dumpYStringATASCII (byte_stream, 'Policja czeka na ciebie przed sklepem!');

    byte_stream.append(7)
    dumpTStringATASCII (byte_stream, 'Trafili ');



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
    dumpTString (byte_stream, wanted_m_fname)
    dumpTString (byte_stream, wanted_m_fname) # NOT NEEDED, so just copy for now
    dumpTString (byte_stream, wanted_f_fname)
    dumpTString (byte_stream, wanted_f_fname) # NOT NEEDED
    dumpTString (byte_stream, fight_map_fname)
    dumpTString (byte_stream, fight_map_fname) # NOT NEEDED
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
    print(len(byte_stream))
    assert(len(byte_stream) == 1487)



carPrices = [0, 3500, 4000, 6500, 7000, 7500]
carCargo = [50, 100, 120, 200, 150, 100]
carRange = [35, 45, 55, 60, 65, 50]  # add some more range to accommodate the larger map
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
wanted_m_fname = 'WANTMBMPAPL'
wanted_f_fname = 'WANTFBMPAPL'
fight_map_fname = 'AFMAPBMPAPL'
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
carNames_DE =  ['Fuesse', 'Talbot 90', 'Chevy Roadster', 'Buick Century', 'Auburn 120', 'Citroen t.a.']

weaponNames_DE  = ['Haende', 'Colt M1911', 'Savage 1907',
                                        'Remington 11', 'Winchester 97', 'Smith&Wesson 10',
                                        'Thompson SMG', 'Browning BAR', 'Handgranaten']
 
                   #  Colt,  Sav,  Rem,  Win,  S&W,  SMG,  BAR
weaponPrices   =  [0, 2000, 2500, 3000, 3000, 4000, 4500, 8000, 10000]
weaponReach    =  [1,    9,   10,   14,   11,   12,   15,   16,    20]
weaponPrecision = [2,    5,    4,    6,    3,    5,    5,    6,     7]
weaponEffect    = [2,    3,    3,    4,    9,   10,   12,   15,    18]
weaponSound     = [2,    2,    2,    2,    2,    2,    4,    4,     6]


# Colt M1911 (Pistol)

# Price: $20
# Range: 50 yards
# Accuracy: High
# Savage 1907 (Pistol)

# Price: $30
# Range: 50 yards
# Accuracy: Moderate
# Remington 11 (Shotgun)

# Price: $30
# Range: 100 yards (varies with load)
# Accuracy: Moderate
# Winchester 97 (Shotgun)

# Price: $25
# Range: 100 yards (varies with load)
# Accuracy: Moderate
# Luger P08 (Pistol) --> now Smith&Wesson 10

# Price: $50
# Range: 50-75 yards
# Accuracy: High
# Thompson SMG (Submachine Gun)

# Price: $200
# Range: 50-100 yards
# Accuracy: Moderate
# Browning BAR (Machine Gun)

# Price: $200
# Range: 100-600 yards
# Accuracy: Moderate to High

rankNames_EN = ['Rookie', 'Rowdy', 'Small Fry',
                                            'Snatch', 'Crook', 'Mafioso', 'Cop Fright', 'Assassin',
                                            'Gangster Boss', 'Right Hand', 'The Don']
weaponNames_EN  = ['Hands', 'Colt M1911', 'Savage 1907',
                                        'Remington 11', 'Winchester 97', 'Smith&Wesson 10',
                                        'Thompson SMG', 'Browning BAR', 'Grenades']



carNames_EN = ['Feet', 'Talbot 90', 'Chevy Roadster', 'Buick Century', 'Auburn 120', 'Citroen t.a.']

rankNames_PL = ['Poczatkujacy', 'Zbir', 'Pionek',
                             'Zlodziej', 'Oszust', 'Mafioso', 'Postrach glin', 'Morderca',
                            'Szef gangsterow', 'Prawa reka', 'Ojc. chrzestny']
weaponNames_PL  = ['Rece', 'Colt M1911', 'Savage 1907',
                                        'Remington 11', 'Winchester 97', 'Smith&Wesson 10',
                                        'Thompson SMG', 'Browning BAR', 'Granaty']
carNames_PL = ['Nogi', 'Talbot 90', 'Chevy Roadster', 'Buick Century', 'Auburn 120', 'Citroen t.a.']





if __name__ == '__main__':
    createE700(rankNames_DE, weaponNames_DE, carNames_DE, "DE")
    createE700(rankNames_EN, weaponNames_EN, carNames_EN, "EN")
    createE700(rankNames_PL, weaponNames_PL, carNames_PL, "PL")



#
