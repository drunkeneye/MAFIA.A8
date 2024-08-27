from PIL import Image, ImageDraw
import random
random.seed(571)
import numpy as np
from scipy.spatial.distance import cdist
import math
import os
import shutil

from utils import verify_colors
from convertMap import convert_charset_to_bytestream, save_byte_stream, save_byte_stream_padded, create_charset_and_charmap, render_used_characters_padded


def pad_image(img, output_size):
    width, height = img.size
    new_img = Image.new("RGB", output_size)
    new_img.paste(img, ((output_size[0]-width)//2,
                        (output_size[1]-height)//2))

    return new_img
 


def process_bitmap(image_path, output_prefix):
    bitmap_result = Image.open(image_path).convert('RGB')
    if bitmap_result.size != (50, 100):
        bitmap_result = bitmap_result.resize((50, 100))
        # warn maybe?
        print (f"### this image {image_path} is not 50x100. why?")

    bitmap_result = pad_image(bitmap_result, (160, 152))

    # Replace specific colors
    pixels = bitmap_result.load()
    for x in range(bitmap_result.width):
        for y in range(bitmap_result.height):
            if pixels[x, y] in [(15, 15, 26), (14, 14, 26)]:
                pixels[x, y] = (0, 0, 0)

    # Verify colors and handle errors
    verification_result, nErrors = verify_colors(np.array(bitmap_result))
    if nErrors > 0:
        verification_result.save(f"bitmaps/error_{output_prefix}.png")
        raise Exception("Color error. Fix it")

    # Create charset and charmap
    charset, charmap = create_charset_and_charmap(bitmap_result)
    print(len(charset))
    if len(charset) > 127:
        img_charset = render_used_characters_padded(charset)
        img_charset.save(f'output/charset_{output_prefix}.png')
        raise Exception("diz not goen.")

    # Convert charset to byte stream and pad
    byte_stream = convert_charset_to_bytestream(charset, colormap)
    byte_stream = byte_stream.ljust(0x400, b'\x00')

    # Flatten charmap and concatenate to byte stream
    flat_charmap = bytes([byte for sublist in charmap for byte in sublist])
    final_bytestream = byte_stream + flat_charmap

    # img_charset = render_used_characters(charset)
    # img_charset.save(f'output/safecl_charset.png')

    # Save the final byte stream
    if "BOCA" in output_prefix:
        save_byte_stream(final_bytestream, f'../assets/{output_prefix}.gfx')
    else:
        save_byte_stream(final_bytestream, f'../assets/{output_prefix}bmp.gfx')



if __name__ == '__main__':
    colormap = [
        [0, 0, 0],      # Black
        [255, 255, 255], # White
        [169, 169, 169], # Grey
        [91, 91, 91],   # CyanBlue
        [128, 128, 0],   # CyanBlue
    ]

    process_bitmap("./locations/subway.png", "BOCASUBW")
    process_bitmap("./locations/store.png", "BOCASTOR")
    process_bitmap("./locations/police.png", "BOCAPOLI")
    process_bitmap("./locations/moneytransporter.png", "BOCAMONY")
    process_bitmap("./locations/loanshark.png", "BOCALOAN")

    process_bitmap("./locations/hideout.png", "BOCAHIDE")
    process_bitmap("./locations/forgery.png", "BOCAFORG")
    process_bitmap("./locations/cardealer.png", "BOCACARS")
    process_bitmap("./locations/armsdealer.png", "BOCAARMS")
    process_bitmap("./locations/bank.png", "BOCABANK")
    
    process_bitmap("./locations/pub.png", "BOCAPUBB")
    process_bitmap("./locations/gambling.png", "BOCAGAMB")
    process_bitmap("./locations/major.png", "BOCAMAJO")
#    process_bitmap("./bitmaps/centralstation.png", "BOCASUBW")

    process_bitmap("./bitmaps/wanted_m_final.png", "wantm")
    process_bitmap("./bitmaps/wanted_f_final.png", "wantf")

    process_bitmap("./bitmaps/safeC_final.png", "safec")

 


#
