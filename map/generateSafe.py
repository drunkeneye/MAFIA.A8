from PIL import Image, ImageDraw
import random
random.seed(571)
import numpy as np
from scipy.spatial.distance import cdist
import math
import os
import shutil

from utils import verify_colors
from convertMap import convert_charset_to_bytestream, save_byte_stream, create_charset_and_charmap, render_used_characters


def pad_image(img, output_size):
    width, height = img.size
    new_img = Image.new("RGB", output_size)
    new_img.paste(img, ((output_size[0]-width)//2,
                        (output_size[1]-height)//2))

    return new_img



if __name__ == '__main__':
    colormap = [
        [0, 0, 0],      # Black
        [255, 255, 255], # White
        [164, 164, 164], # Grey
        [80, 80, 80],   # CyanBlue
        [128, 128, 0],   # CyanBlue
    ]


    # reaload optimized
    bitmap_result = Image.open("./bitmaps/safeC_final.png").convert('RGB')
    bitmap_result = pad_image(bitmap_result, (160, 152))

    verification_result, nErrors = verify_colors(np.array(bitmap_result))
    if nErrors > 0:
        verification_result.save(f"output/error_safeC.png")
        raise Exception ("Color error. Fix it")

    charset, charmap = create_charset_and_charmap(bitmap_result)
    print (len(charset))
    if len(charset) > 127:
        raise Exception ("diz not goen.")
    byte_stream = convert_charset_to_bytestream(charset, colormap)
    save_byte_stream(byte_stream, f'../assets/safeclmf.gfx')
    img_charset = render_used_characters(charset)
    img_charset.save(f'output/safecl_charset.png')

    # convert charmap
    flat_charmap = bytes([byte for sublist in charmap for byte in sublist])
    save_byte_stream(flat_charmap, f'../assets/safeclms.gfx')

#
