from PIL import Image, ImageDraw
import random
random.seed(571)
import numpy as np
from scipy.spatial.distance import cdist
from bitarray import bitarray
from glob import glob
from math import ceil


# maybe 26,72 on xl and 0, 04, 0e for grey scale
colormap = [
    [0, 0, 0],      # Black
    [255, 255, 255], # White
    [115, 68, 4], # Grey Brown now
    [157, 12, 12],   # Orange/red
    [0, 80, 160],   # CyanBlue
]



def setspace (grid, i,j, v):
    try:
        grid[i] = grid[i][:j] + v + grid[i][j + 1:]
    except:
        pass
    return grid



def visualize_grid(grid, icon_mapping):
    grid = grid.copy()
    icon_size_h = 8
    icon_size_w = 4
    icon_directory = './icons/'

    # check first all icons
    for z in glob(icon_directory + "*.png"):
        icon_image = Image.open(z)
        if icon_image.size[1] % 8 != 0:
            # this should only yield player
            if "player" not in z:
                print ("not correct height!", z)

    grid_height = len(grid)
    grid_width = len(grid[0])

    # Create a new image with white background
    image = Image.new('RGB', (grid_width * icon_size_w, grid_height * icon_size_h), 'white')
    draw = ImageDraw.Draw(image)

    for i in range(grid_height):
        for j in range(grid_width):
            char = grid[i][j]
            if char == ".":
                continue
            if char in icon_mapping:
                # Load the corresponding icon image
                icon_filename = icon_mapping[char]
                icon_path = icon_directory + icon_filename
                icon_image = Image.open(icon_path)

                # Calculate the position to paste the icon
                paste_position = (j * icon_size_w, i * icon_size_h)

                # Iterate over 8x8 pixel blocks in the icon image
                # size is widthxheight
                for block_i in range(0, icon_image.size[1], icon_size_h):
                    for block_j in range(0, icon_image.size[0], icon_size_w):
                        # Check if the character 'below the block' is the same
                        grid_i = i + block_i//icon_size_h
                        grid_j = j + block_j//icon_size_w
                        # if (icon_image.size[1] == 16):
                        #     if char != 'X' and char != ' ':
                        #         print (char, block_i, block_j, grid_i, grid_j)
                        #         print (icon_image.size)
                        if grid_i < len(grid) and grid_j < len(grid[0]):
                            if grid[grid_i][grid_j] == char or grid[grid_i][grid_j] == ' ':

                                # Paste the 8x8 block onto the image
                                block = icon_image.crop((block_j, block_i, block_j + icon_size_w, block_i + icon_size_h))
                                # TODO: this should be done differently
                                if char == 'Z':
                                    #157, 12, 12, 255), (115, 68, 4, 255
                                    block.putdata([(12, 12, 222, 255) if pixel == (157, 12, 12, 255) else pixel for pixel in block.getdata()])
                                image.paste(block, (paste_position[0] + block_j, paste_position[1] + block_i))

                                # Remove the corresponding grid block
                                grid = setspace(grid, grid_i, grid_j, '.')

    img_array = np.array(image)
    flattened_array = img_array.reshape((-1, 3))
    colormap_array = np.array(colormap)
    distances = cdist(flattened_array, colormap_array)
    nearest_color_indices = np.argmin(distances, axis=1)
    nearest_colors = colormap_array[nearest_color_indices]
    result_array = nearest_colors.reshape(img_array.shape)
    image = Image.fromarray(np.uint8(result_array))
    return image



def verify_colors(bitmap):
    bitmap_array = np.array(bitmap)

    block_width = 4
    block_height = 8

    nErrors = 0
    for i in range(0, len(bitmap_array), block_height):
        for j in range(len(bitmap_array[0]) - block_width + 1):
            block = bitmap_array[i:i+block_height, j:j+block_width]
            unique_colors = np.unique(block.reshape(-1, 3), axis=0)

            if len(unique_colors) > 4:
                bitmap_array[i:i+block_height, j:j+block_width] = [255, 0, 0]
                print ("Error at", i, j)
                nErrors += 1

    return Image.fromarray(bitmap_array, 'RGB'), nErrors



def save_grid(grid, filename):
    with open(filename, 'w') as file:
        for row in grid:
            file.write(''.join(row) + '\n')


def load_grid(filename):
    with open(filename, 'r') as file:
        grid = [line.strip() for line in file.readlines()]
    return grid


def create_charset_and_charmap(bitmap, charset = [], charsetidx = [], block_size=(4, 8)):
    charmap = []
    idx = 0
    print (bitmap.size)
    # Iterate over 4x8 blocks in the bitmap
    for i in range(0, bitmap.size[1], block_size[1]):
        row_indices = []
        for j in range(0, bitmap.size[0], block_size[0]):
            # Extract the current 4x8 block from the bitmap
            block = bitmap.crop((j, i, j + block_size[0], i + block_size[1]))
            block_array = np.array(block)
            block_hash = hash(block_array.tobytes())

            if block_hash not in charsetidx:
                idx = len(charsetidx)
                charsetidx.append(block_hash)
                charset.append(block_array)
            else:
                idx = charsetidx.index(block_hash)

            orange = np.any([(s == colormap[4]).all() for k in block_array for s in k])
            cyan = np.any([(s == colormap[3]).all() for k in block_array for s in k])
            if orange and cyan:
                print (i,j)
                print (block_array)
                raise Exception ("!!")

            if cyan:
                idx = idx + 128   # this will create values over 256 if we have too many characters, so good!

            row_indices.append(idx)
        charmap.append(row_indices)

    # Print the number of different indices in each row of the charmap
    for row in charmap:
        print(len(set(row)), end=' ')
    print()  # Move to the next line

    return charset, charsetidx, charmap


def get_color_index(color, colormap):
    color_array = np.array(color)
    for i, c in enumerate(colormap):
        if np.array_equal(color_array, np.array(c)):
            return i
    return None


def cutGrid(grid, t, b, l, r):
    # remove stupid boundary
    result_grid = grid[t:b]
    for row in range(len(result_grid)):
        result_grid[row] = result_grid[row][l:r]
    return result_grid


def printGrid (result_grid):
    sz = 0
    for row in result_grid:
        print(row)
        sz += len(row)
    print (f"{len(result_grid)} rows, {len(row)} columns, {sz} bytes")


def convert_charset_to_bytestream(charset, colormap):
    bytes_stream = b''
    for char in charset:
        byte = bitarray()
        for z in char:
            for k in z:
                color_index = get_color_index(k, colormap)
                # map cyan and orange to the same bits
                if color_index == 4:
                    color_index = 3
                byte.extend(format(color_index, '02b'))
        bytes_stream += byte.tobytes()
    return bytes_stream


def save_byte_stream(byte_stream, filename):
    with open(filename, 'wb') as file:
        file.write(byte_stream)



def render_used_characters(charset, border=0):
    # assume 4x8
    num_chars = len(charset)
    chars_per_row = 10
    num_rows = ceil(num_chars / chars_per_row)
    width, height = chars_per_row * (4 + border), num_rows * (8 + border)
    image = Image.new('RGB', (width, height), color='blue')  # 'L' mode for grayscale image

    for j, char in enumerate(charset):
        row = j // chars_per_row
        col = j % chars_per_row
        grey_img = Image.fromarray(char).convert('L')
        red_img = Image.merge('RGB', (grey_img, grey_img, grey_img))
        image.paste(red_img, (col*(4+border), row*(8+border)))

    return image


def render_used_characters_old(charset, border = 0):
    # assume 4x8
    num_chars = len(charset)
    width, height = num_chars * (4 + border), 8
    image = Image.new('RGB', (width, height), color='red')  # 'L' mode for grayscale image

    for j, char in enumerate(charset):
        grey_img = Image.fromarray(char).convert('L')
        red_img = Image.merge('RGB', (grey_img, grey_img, grey_img))
        image.paste(red_img, (j*(4+border), 0))

    return image



icon_mapping = {
    'A': 'armsdealer.png',
    'C': 'forgery.png',
    'D': 'loanshark.png',
    'E': 'pub.png',
    'F': 'subway.png',
    'G': 'bank.png',
    'H': 'gambling.png',
    'I': 'hideout.png',
    'J': 'police.png',
    'K': 'store.png',
    'P': 'park.png',
    'R': 'house.png',
    'W': 'water.png',


    'B': 'fbullet.png',
    'C': 'fbullet_v.png',
    'V': 'player16_f.png',
    'W': 'player16_f_m.png',
    'X': 'fwall.png',
    'Y': 'player16_m.png',
    'Z': 'player16_m_m.png',
    ' ': 'empty.png'
}



if __name__ == '__main__':
    for fm in ["a"]:
        # first prime the map with ' '=0/1, and player, missile whatever.
        prime_grid = ['  XX  YY  ZZ  VV  WW    ', '  XX  YY  ZZ  VV  WW B C']

        full_bitmap = visualize_grid(prime_grid, icon_mapping)
        full_bitmap.save(f'output/fightmap_prime.png')
        charset, charsetidx, _ = create_charset_and_charmap(full_bitmap)
        print (f"Prime has altogether {len(charset)} chars.")
        img_charset = render_used_characters(charset)
        img_charset.save(f'output/fightmap_prime_chars.png')

        # then load fight map
        result_grid = load_grid(f'grid_fightmap_{fm}.txt')
        full_bitmap = visualize_grid(result_grid, icon_mapping)
        full_bitmap.save(f'output/fightmap_{fm}.png')

        # now create fight map
        charset, _, charmap = create_charset_and_charmap(full_bitmap, charset, charsetidx)
        print (f"Whole map has altogether {len(charset)} chars.")
        img_charset = render_used_characters(charset)
        img_charset.save(f'output/fightmap_charset_{fm}.png')

        if len(charset) > 127:
            raise Exception ("diz not goen.")
        byte_stream = convert_charset_to_bytestream(charset, colormap)
        byte_stream = byte_stream.ljust(0x400, b'\x00')
        #save_byte_stream(byte_stream, f'../assets/{fm}fmapfnt.gfx')

        # convert charmap
        flat_charmap = bytes([byte for sublist in charmap for byte in sublist])
        final_bytestream = byte_stream + flat_charmap
        save_byte_stream(final_bytestream, f'../assets/{fm}fmapbmp.gfx')



#
