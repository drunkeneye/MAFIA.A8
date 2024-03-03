
def atascii_to_antic(atascii_char):
    c = ord(atascii_char)
    result = 0

    if c < 2 * 0x60:
        if c >= 2 * 0x20:
            result = c - (2 * 0x20 - 1)
        else:
            result = c + 2 * 0x60

    result = ((result << 1) & 0xFF) | ((result >> 7) & 1)
    return result

def convert_to_antic(input_string):
    antic_string = ""
    for char in input_string:
        if char.isalnum() or char in ",.()=^/%$! ":
            antic_code = atascii_to_antic(char)
            antic_string += chr(antic_code)
    return antic_string


def convert_to_atascii(input_string):
    atascii_map = {
        ' ': 0,  '#': 3, ',': 12, '.': 14, '(': 8, ')': 9, '?': 31,
        '=': 29,  '/': 15, '%': 5, '$': 4,
        '0': 16, '1': 17, '2': 18, '3': 19, '4': 20,
        '5': 21, '6': 22, '7': 23, '8': 24, '9': 25,
        'A': 33, 'B': 34, 'C': 35, 'D': 36, 'E': 37,
        'F': 38, 'G': 39, 'H': 40, 'I': 41, 'J': 42,
        'K': 43, 'L': 44, 'M': 45, 'N': 46, 'O': 47,
        'P': 48, 'Q': 49, 'R': 50, 'S': 51, 'T': 52,
        'U': 53, 'V': 54, 'W': 55, 'X': 56, 'Y': 57,
        'Z': 58, "'": 7, '"': 7, ":": 26, "-": 13,
        '\n': 0,
        '!': 1, 'a': 97, 'b': 98, 'c': 99, 'd': 100,
        'e': 101, 'f': 102, 'g': 103, 'h': 104, 'i': 105,
        'j': 106, 'k': 107, 'l': 108, 'm': 109, 'n': 110,
        'o': 111, 'p': 112, 'q': 113, 'r': 114, 's': 115,
        't': 116, 'u': 117, 'v': 118, 'w': 119, 'x': 120,
        'y': 121, 'z': 122
    }
    
    atascii_string = ""
    for char in input_string:
        if char in atascii_map:
            atascii_string += chr(atascii_map[char])
        else:
            raise Exception ('Take care of >>' + char +'<<')
    return atascii_string


