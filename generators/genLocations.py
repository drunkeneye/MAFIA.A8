import random
import re
from glob import glob 
from utils import *

def split_description(description, current_opt, maxn = 2):
    words = description.split()
    description_parts = []
    if current_opt is not None:
        current_part = str(current_opt) + " " + str(current_opt) + "-"   # first must not be space, else this will be understood as extra-text
    else:
        current_part = ''
    for word in words:
        if len(current_part) + len(word) < 40: # leave some space for numbers of options and + sign
            current_part += word + " "
        else:
            # remove  trailing " "
            current_part = current_part[:-1]
            description_parts.append(current_part)
            if current_opt is not None:
                current_part = "    " + word + " "
            else:
                current_part = word + " "
    if current_part:
        current_part = current_part[:-1]
        description_parts.append(current_part)
    
    print (description_parts)
    if len(description_parts) > maxn:
        raise ValueError("Too many description parts (maximum 5 allowed)")
    return description_parts


def dumpYString(byte_stream, p):
    byte_stream.append(len(p))
    tmp_sopt = convert_to_atascii(p)
    byte_stream.extend(tmp_sopt.encode('utf-8').ljust(39, b'\x00'))
    return byte_stream


def create_location_data(txtfile, suffix):
    with open(txtfile, 'r') as file:
        outfilename = file.readline().strip()  # First line is filename
        place = file.readline().strip()  # Second line is place description
        # bgcolor = int(file.readline().strip())  # Third line is a number
        bgcolor = file.readline().strip().split(",")
        bgcolor = [k.strip() for k in bgcolor]
        sublocations = [file.readline().strip() for _ in range(4)]  # Next lines are options
        maplocations = file.readline().strip().split(",")
        place_description = file.readline().strip()  # Second line is place description
        num_options = int(file.readline().strip())
        options = [file.readline().strip() for _ in range(num_options)]  # Next lines are options
        num_strings = int(file.readline().strip())
        strings = [file.readline() for _ in range(num_strings)]

    print("\n\n\n")
    print("Filename:", outfilename)
    print("Place:", place)
    print("Place Description:", place_description)
    print("Background color:", bgcolor)
    print("sublocations:", sublocations)
    print("maplocations:", maplocations)
    print("noptions:", num_options)
    print("Options:", options)
    print("noptions:", num_strings)
    print("Strings:", strings)

    byte_stream = bytearray()

    # loc_name:               YString absolute +0
    dumpYString (byte_stream, place)

    # loc_sublocation_name_1..4
    for k in range(4):
        byte_stream = dumpYString (byte_stream, sublocations[k])
    
    # loc_options_1...10
    pz = []
    for j, op in enumerate(options):
        z = split_description(op, j+1, 2)
        pz.extend(z)

    while len(pz) < 10:
        pz.append(' ')
    assert(len(pz) == 10)
    for p in pz:
        byte_stream = dumpYString (byte_stream, p)


    # loc_description_1..2
    pz = split_description(place_description, None, 3)
    while len(pz) < 2:
        pz.append(' ')

    assert(len(pz) == 2)
    for p in pz:
        byte_stream = dumpYString (byte_stream, p)


    #     loc_bgcolor -- dummy right now
    byte_stream.append(0)

    # loc_nOptions:    
    byte_stream.append(num_options)

    # loc_map_places:        
    assert (len(maplocations) == 4)
    maplocations = [int(k) for k in maplocations]
    for k in range(4):
        byte_stream.append(maplocations[k])

    # right now: empty space here, 2 bytes
    for k in range(2):
        byte_stream.append(0)

    # each string save it 
    print("Strings:", strings)
    for k in range(41):
        try:
            description_parts = split_description(strings[k], None, 1)
        except:
            dumpYString(byte_stream, '  ')
        # if len(description_parts) == 0:
        #     break
        assert(len(strings[k]) < 40)
        dumpYString(byte_stream, strings[k])

    assert (len(bgcolor) == 4)
    for color in bgcolor:
        assert re.match(r'\$[0-9a-fA-F]+$', color), f"{color} is not a valid hexadecimal number"    
    bgcolor = [int(k[1:], 16) for k in bgcolor]  # Skip the $ and convert from hex to int
    for k in range(4):
        byte_stream.append(bgcolor[k])


    # Write the byte stream to the file
    print ("SAVING NOW")            
    filename = f"../assets/{outfilename}_{suffix}" 
    with open(filename, 'wb') as f:
        f.write(byte_stream)


if __name__ == "__main__":
    for loc in ["DE", "EN", "PL"]:
        for g in glob(f"./loc_templates/*_{loc}.txt"):
            create_location_data(g, loc)



#
