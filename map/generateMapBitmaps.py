from PIL import Image, ImageDraw
import random
random.seed(571)
import numpy as np
from scipy.spatial.distance import cdist
from scipy.spatial import KDTree
import math
import os
import shutil
import json 

from utils import verify_colors
from convertMap import export_as_atrview, convert_charset_to_bytestream, save_byte_stream, save_byte_stream_padded, create_charset_and_charmap, render_used_characters_padded



def pad_image(img, output_size):
    width, height = img.size
    new_img = Image.new("RGB", output_size)
    new_img.paste(img, ((output_size[0]-width)//2,
                        (output_size[1]-height)//2))

    return new_img
 

def closest_gray_color(color):
    gray_value = int(round(np.mean(color)))  # Get average to convert to grayscale
    if gray_value < (91 + 0) // 2:
        return (0, 0, 0)
    elif gray_value < (169 + 91) // 2:
        return (91, 91, 91)
    elif gray_value < (255 + 169) // 2:
        return (169, 169, 169)
    else:
        return (255, 255, 255)


def process_bitmap(image_path, output_prefix, remap = False, resize = True, pad = True, colormap = None):
    bitmap_result = Image.open(image_path).convert('RGB')

    if resize == True:
        if bitmap_result.size != (50, 100):
            bitmap_result = bitmap_result.resize((50, 100), Image.NEAREST)
            print (f"### this image {image_path} is not 50x100. why?")
            # these images will eb converted to the 4 color greys we had.
            # so nothing to do

    if remap == True:
        image_np = np.array(bitmap_result)
        remapped_image_np = np.apply_along_axis(closest_gray_color, 2, image_np)
        bitmap_result = Image.fromarray(np.uint8(remapped_image_np))
    else:
        image_np = np.array(bitmap_result)
        unique_colors = np.unique(image_np.reshape(-1, image_np.shape[2]), axis=0)
        print("Unique colors in RGB format:")
        for color in unique_colors:
            print(tuple(color))

    if pad == True:
        bitmap_result = pad_image(bitmap_result, (160, 152))

    # Replace specific colors
    pixels = bitmap_result.load()

    # Verify colors and handle errors
    verification_result, nErrors = verify_colors(np.array(bitmap_result))
    if nErrors > 0:
        verification_result.save(f"bitmaps/error_{output_prefix}.png")
        raise Exception("Color error. Fix it")

    # Create charset and charmap
    charset, charmap = create_charset_and_charmap(bitmap_result, colormap)
    print(len(charset))
    # save it anyway
    img_charset = render_used_characters_padded(charset)
    img_charset.save(f'output/charset_{output_prefix}.png')
    if len(charset) > 127:
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
    export_as_atrview (byte_stream, flat_charmap, f'./output/{output_prefix}.atrview')




def process_bitmap_dual(image_path, output_prefix, remap = True, pad = True, colormap = None):
    bitmap_result = Image.open(image_path).convert('RGB')

    if remap == True:
        image_np = np.array(bitmap_result)
        remapped_image_np = np.apply_along_axis(closest_gray_color, 2, image_np)
        bitmap_result = Image.fromarray(np.uint8(remapped_image_np))
    else:
        image_np = np.array(bitmap_result)
        unique_colors = np.unique(image_np.reshape(-1, image_np.shape[2]), axis=0)
        print("Unique colors in RGB format:")
        for color in unique_colors:
            print(tuple(color))

    if pad == True:
        bitmap_result = pad_image(bitmap_result, (160, 152))

    # Replace specific colors
    pixels = bitmap_result.load()

    # Verify colors and handle errors
    verification_result, nErrors = verify_colors(np.array(bitmap_result))
    if nErrors > 0:
        verification_result.save(f"bitmaps/error_{output_prefix}.png")
        raise Exception("Color error. Fix it")

    # Create charset and charmap
    width, height = bitmap_result.size
    # ASSUME 152 HERE
    assert height == 152

    upper_half = bitmap_result.crop((0, 0, width, 80))  # Upper half of the image
    lower_half = bitmap_result.crop((0, 80, width, height))  # Lower half of the image

    # Create charset and charmap for the upper half
    charset_upper, charmap_upper = create_charset_and_charmap(upper_half, colormap)
    charset_lower, charmap_lower = create_charset_and_charmap(lower_half, colormap)

    print ("Charset length:")
    print(len(charset_upper))
    print(len(charset_lower))

    # save it anyway
    img_charset_upper = render_used_characters_padded(charset_upper)
    img_charset_upper.save(f'output/charset_{output_prefix}_upper.png')
    if len(charset_upper) > 127:
        raise Exception("diz not goen. upper is broken.")

    img_charset_lower = render_used_characters_padded(charset_lower)
    img_charset_lower.save(f'output/charset_{output_prefix}_lower.png')
    if len(charset_lower) > 127:
        raise Exception("diz not goen. lower is broken.")

    # Convert charset to byte stream and pad
    byte_stream_upper = convert_charset_to_bytestream(charset_upper, colormap)
    byte_stream_upper = byte_stream_upper.ljust(0x400, b'\x00')

    byte_stream_lower = convert_charset_to_bytestream(charset_lower, colormap)
    byte_stream_lower = byte_stream_lower.ljust(0x400, b'\x00')

    # Flatten charmap and concatenate to byte stream
    flat_charmap_upper = bytes([byte for sublist in charmap_upper for byte in sublist])
    flat_charmap_lower = bytes([byte for sublist in charmap_lower for byte in sublist])
    print ("BYTESTREAM LENGTH:")
    print (len(flat_charmap_upper)) # upper are 10 lines, so 40*10=400 bytes, checks out
    print (len(flat_charmap_lower))
    # but overall it must be 0x400 length, so pad

    flat_charmap = flat_charmap_upper + flat_charmap_lower
    flat_charmap = flat_charmap.ljust(0x400, b'\x00')

    # more complex: first upper, then charmap for both, then lower
    final_bytestream = byte_stream_upper + flat_charmap + byte_stream_lower

    # img_charset = render_used_characters(charset)
    # img_charset.save(f'output/safecl_charset.png')

    # Save the final byte stream
    if "BOCA" in output_prefix:
        save_byte_stream(final_bytestream, f'../assets/{output_prefix}.gfx')
    else:
        save_byte_stream(final_bytestream, f'../assets/{output_prefix}bmp.gfx')



def create_german_flag(width, height):
    """Create German flag without border"""
    # Colors
    BLACK = (0, 0, 0)
    RED = (200, 16, 46)
    YELLOW = (255, 204, 0)
    
    # Create base image
    image = Image.new('RGB', (width, height), BLACK)
    draw = ImageDraw.Draw(image)
    
    # Draw stripes
    stripe_height = height // 3
    # Black stripe (already there)
    # Red stripe
    draw.rectangle([
        (0, stripe_height),
        (width, 2 * stripe_height)
    ], fill=RED)
    # Yellow stripe
    draw.rectangle([
        (0, 2 * stripe_height),
        (width, height)
    ], fill=YELLOW)
    
    return image

def create_polish_flag(width, height):
    """Create Polish flag without border"""
    WHITE = (255, 255, 255)
    RED = (200, 16, 46)
    
    # Create base image
    image = Image.new('RGB', (width, height), WHITE)
    draw = ImageDraw.Draw(image)
    
    # Draw red bottom stripe
    draw.rectangle([
        (0, height // 2),
        (width, height)
    ], fill=RED)
    
    return image

def create_uk_flag(width, height):
    """Create UK flag without border"""
    # Load and resize the UK flag
    uk_flag = Image.open('./bitmaps/union_jack.png')
    uk_flag = uk_flag.resize((width, height), Image.Resampling.NEAREST)
    return uk_flag

def create_arrow(draw, x, y, pointing_right=True, color=(255, 255, 255)):
    """Create an arrow with specific dimensions"""
    arrow_length = 14
    arrow_height = 5
    arrow_point = 5
    
    if pointing_right:
        points = [
            (x, y - arrow_height//2),
            (x + arrow_length, y - arrow_height//2),
            (x + arrow_length, y - arrow_height//2 - arrow_point),
            (x + arrow_length + arrow_point, y),
            (x + arrow_length, y + arrow_height//2 + arrow_point),
            (x + arrow_length, y + arrow_height//2),
            (x, y + arrow_height//2)
        ]
    else:
        points = [
            (x + arrow_length, y - arrow_height//2),
            (x, y - arrow_height//2),
            (x, y - arrow_height//2 - arrow_point),
            (x - arrow_point, y),
            (x, y + arrow_height//2 + arrow_point),
            (x, y + arrow_height//2),
            (x + arrow_length, y + arrow_height//2)
        ]
    
    draw.polygon(points, fill=color)

def add_border(image, horizontal_border, vertical_border, color=(255, 255, 255)):
    """Add border with different horizontal and vertical widths"""
    width, height = image.size
    new_width = width + (2 * horizontal_border)
    new_height = height + (2 * vertical_border)
    
    bordered = Image.new('RGB', (new_width, new_height), color)
    bordered.paste(image, (horizontal_border, vertical_border))
    
    return bordered

def generateFlagBitmap():
    # Define colors for color mapping
    flag_colormap = np.array([
        [0, 0, 0],        # Black
        [200, 16, 46],    # Red
        [255, 204, 0],    # Yellow
        [255, 255, 255],  # White
        [1, 33, 105]      # Blue
    ], dtype=np.uint8)
    
    # Final image dimensions
    FINAL_WIDTH = 160
    FINAL_HEIGHT = 200
    
    # Flag dimensions (34x46 pixels without border -> 36x48 with border)
    INNER_FLAG_WIDTH = (10 * 4) - 2  # 34 pixels
    INNER_FLAG_HEIGHT = (6 * 8) - 2  # 46 pixels
    H_BORDER = 1  # horizontal border
    V_BORDER = 1  # vertical border
    
    # Create base image
    base_image = Image.new('RGB', (FINAL_WIDTH, FINAL_HEIGHT), (0, 0, 0))
    draw = ImageDraw.Draw(base_image)
    
    # Calculate y positions (all divisible by 4)
    polish_y = 16
    uk_y = polish_y + INNER_FLAG_HEIGHT + (2 * V_BORDER) + 8
    german_y = uk_y + INNER_FLAG_HEIGHT + (2 * V_BORDER) + 8
    
    # Create flags without borders
    polish_flag = create_polish_flag(INNER_FLAG_WIDTH, INNER_FLAG_HEIGHT)
    uk_flag = create_uk_flag(INNER_FLAG_WIDTH, INNER_FLAG_HEIGHT)
    german_flag = create_german_flag(INNER_FLAG_WIDTH, INNER_FLAG_HEIGHT)
    
    # Add borders to flags
    polish_flag = add_border(polish_flag, H_BORDER, V_BORDER)
    uk_flag = add_border(uk_flag, H_BORDER, V_BORDER)
    german_flag = add_border(german_flag, H_BORDER, V_BORDER)
    
    # Paste flags
    FLAGS_OFS = 64-4
    base_image.paste(polish_flag, (FLAGS_OFS, polish_y))
    base_image.paste(uk_flag, (FLAGS_OFS, uk_y))
    base_image.paste(german_flag, (FLAGS_OFS, german_y))
    
    # Add arrows next to German flag
    arrow_y = german_y + ((INNER_FLAG_HEIGHT + 2 * V_BORDER) // 2)-1
    create_arrow(draw, FLAGS_OFS+49, arrow_y, pointing_right=False)  # Left arrow
    create_arrow(draw, 4 + INNER_FLAG_WIDTH + (2 * H_BORDER) + 10-18, arrow_y, pointing_right=True)  # Right arrow
    
    # Apply color mapping using KDTree
    colormap = np.array(flag_colormap, dtype=np.uint8)
    tree = KDTree(colormap)
    
    image_np = np.array(base_image)
    flat_image = image_np.reshape(-1, 3)
    _, indices = tree.query(flat_image)
    mapped_image = colormap[indices].reshape(image_np.shape)
    
    final_image = Image.fromarray(mapped_image)
    
    # Save both sizes
    final_image.save('./bitmaps/flags_160.png')
    
    # Create 320x200 version
    large_image = final_image.resize((320, 200), Image.Resampling.NEAREST)
    large_image.save('./bitmaps/flags_320.png')
    
    return final_image
    


import numpy as np
from PIL import Image
from collections import Counter

def find_most_similar_chars(charset):
    """Find the single pair of characters that has the smallest difference."""
    min_diff = float('inf')
    best_pair = None

    for i in range(len(charset)):
        for j in range(i + 1, len(charset)):
            # Calculate difference between two character arrays
            diff = np.sum(charset[i] != charset[j])
            if diff < min_diff:
                min_diff = diff
                best_pair = (i, j)

    if best_pair is not None:
        print(f"Found most similar pair {best_pair} with difference {min_diff}")
        return [best_pair]  # Return as list to maintain compatibility with existing code
    return []  # Return empty list if no pairs found


def count_char_usage(charmap):
    """Count how many times each character is used in the charmap."""
    # Flatten the 2D charmap into 1D array and count occurrences
    return Counter([char for row in charmap for char in row])


def replace_char_in_image(image, charmap, old_char, new_char, charset):
    """Replace a character in the image by modifying the pixels."""
    width, height = image.size
    pixels = np.array(image)

    # Find the differing pixel between the two characters
    diff_mask = charset[old_char] != charset[new_char]
    diff_pos = np.where(diff_mask)

    diff_y, diff_x = diff_pos[0][0], diff_pos[1][0]
    new_color = charset[new_char][diff_y, diff_x]

    # For each occurrence of old_char in charmap, update the corresponding pixel
    for i in range(len(charmap)):
        for j in range(len(charmap[0])):
            if charmap[i][j] == old_char:
                # Calculate pixel position in the full image
                pixel_x = j * 4 + diff_x
                pixel_y = i * 8 + diff_y
                if pixel_y < height and pixel_x < width:
                    pixels[pixel_y, pixel_x] = new_color

    return Image.fromarray(pixels)


def process_bitmap_optimized(image_path, output_prefix, colormap, max_chars=127):
    # First try normal processing
    bitmap_result = Image.open(image_path).convert('RGB')
    charset, charmap = create_charset_and_charmap(bitmap_result, colormap)

    if len(charset) <= max_chars:
        # If already within limits, use normal processing
        return process_bitmap(image_path, output_prefix, remap = False, pad = True, resize  = False, colormap=colormap)

    current_image = bitmap_result
    iterations = 0
    max_iterations = 1000  # Prevent infinite loops

    while len(charset) > max_chars and iterations < max_iterations:
        similar_pairs = find_most_similar_chars (charset)
        if not similar_pairs:
            print(f"Warning: No more similar pairs found but still have {len(charset)} chars")
            break

        char_usage = count_char_usage(charmap)

        # Find the pair where one character is used less frequently
        best_pair = None
        min_usage = float('inf')
        for old_char, new_char in similar_pairs:
            usage_old = char_usage[old_char]
            usage_new = char_usage[new_char]
            min_of_pair = min(usage_old, usage_new)
            if min_of_pair < min_usage:
                min_usage = min_of_pair
                best_pair = (old_char, new_char) if usage_old < usage_new else (new_char, old_char)

        if best_pair is None:
            print("Warning: Could not find a suitable pair to merge")
            break

        # Replace the less frequently used character in the image
        old_char, new_char = best_pair
        current_image = replace_char_in_image(current_image, charmap, old_char, new_char, charset)

        # Reprocess the modified image
        charset, charmap = create_charset_and_charmap(current_image, colormap)
        iterations += 1

        if iterations % 10 == 0:
            print(f"Iteration {iterations}: {len(charset)} chars remaining")

    if len(charset) <= max_chars:
        print(f"Successfully optimized charset from >127 to {len(charset)} chars in {iterations} iterations")
        # Save the optimized image and process it normally
        current_image.save(f'output/optimized_{output_prefix}.png')
        return process_bitmap(f'output/optimized_{output_prefix}.png', output_prefix, remap = False, pad = True, resize  = False, colormap=colormap)
    else:
        raise Exception(f"Could not reduce charset below {len(charset)} chars after {iterations} iterations")



    
    
if __name__ == '__main__':
    colormap = [
        [0, 0, 0],      # Black
        [255, 255, 255], # White
        [169, 169, 169], # Grey
        [91, 91, 91],   # CyanBlue
        [128, 128, 0],   # CyanBlue
    ]

    flag_colormap = [
        [0, 0, 0],      # Black
        [255, 255, 255], # White
        [200, 16, 46], # RED
        [1, 33, 105],   # BLUE ?!
        [255, 204, 0],   # yellow
    ]


    if 1 == 0:
        process_bitmap("./bitmaps/wanted_m_final.png", "wantm", True, colormap = colormap)
        process_bitmap("./bitmaps/wanted_f_final.png", "wantf", True, colormap = colormap)
        process_bitmap("./bitmaps/safeC_final.png", "safec", True, False, colormap = colormap)

        generateFlagBitmap()
        process_bitmap("./bitmaps/flags_160.png", "flags", remap = False, pad = False, resize  = False, colormap = flag_colormap)
 

    pngPath = "/home/aydin/ebooks/png"
    locationGFX = True
    if locationGFX == True:
        process_bitmap_dual(pngPath+"/subway.png", "SUBWBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/bank.png", "BANKBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/cardealer.png", "CARSBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/hideout.png", "HIDEBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/forgery.png", "FORGBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/major.png", "MAJOBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/store.png", "STORBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/police.png", "POLIBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/moneytransporter.png", "MONYBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/loanshark.png", "LOANBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/armsdealer.png", "ARMSBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/pub.png", "PUBBBOCA", colormap=colormap)
        process_bitmap_dual(pngPath+"/gambling.png", "GAMBBOCA", colormap=colormap)

        process_bitmap_dual(pngPath+"/police.png", "POLIBOCA", colormap=colormap)

#
