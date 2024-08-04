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
    [128, 128, 128], # Grey
    [240, 128, 0],   # Orange
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
    icon_size = 8  # Assuming each character is represented by an 8x8 pixel icon
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
    image = Image.new('RGB', (grid_width * icon_size, grid_height * icon_size), 'white')
    draw = ImageDraw.Draw(image)

    # Define the dot conditions mapping
    dot_conditions = {
        '1111': 'crossing_4.png',  # Dot has dots above, below, left, and right
        '1100': 'street_V.png',    # Dot has dots above and below
        '0011': 'street_H.png',    # Dot has dots left and right
        '1000': 'street_V.png',    # Dot has dots above and below
        '0001': 'street_H.png',    # Dot has dots left and right
        '0100': 'street_V.png',    # Dot has dots above and below
        '0010': 'street_H.png',    # Dot has dots left and right
        '1110': 'crossing_3E.png',  # Dot has dots above, below, left, and right
        '1101': 'crossing_3W.png',  # Dot has dots above, below, left, and right
        '1011': 'crossing_3S.png',  # Dot has dots above, below, left, and right
        '0111': 'crossing_3N.png',  # Dot has dots above, below, left, and right
        '1010': 'street_NW.png',  # Dot has dots above, below, left, and right
        '1001': 'street_NE.png',  # Dot has dots above, below, left, and right
        '0110': 'street_SW.png',  # Dot has dots above, below, left, and right
        '0101': 'street_SE.png',  # Dot has dots above, below, left, and right
    }

    for i in range(grid_height):
        for j in range(grid_width):
            char = grid[i][j]

            if char in icon_mapping:
                # Load the corresponding icon image
                icon_filename = icon_mapping[char]
                icon_path = icon_directory + icon_filename
                icon_image = Image.open(icon_path)

                # Calculate the position to paste the icon
                paste_position = (j * icon_size, i * icon_size)

                # Iterate over 8x8 pixel blocks in the icon image
                for block_i in range(0, icon_image.size[1], 8):
                    for block_j in range(0, icon_image.size[0], 8):
                        # Check if the character 'below the block' is the same
                        grid_i = i + block_i//8
                        grid_j = j + block_j//8
                        if grid_i < len(grid) and grid_j < len(grid[0]):
                            if grid[grid_i][grid_j] == char or grid[grid_i][grid_j] == ' ':
                                # Paste the 8x8 block onto the image
                                block = icon_image.crop((block_j, block_i, block_j + 8, block_i + 8))
                                image.paste(block, (paste_position[0] + block_j, paste_position[1] + block_i))

                                # Remove the corresponding grid block
                                grid = setspace(grid, grid_i, grid_j, ' ')

            elif char == '.':
                # Check conditions for dot icons
                above_dot = grid[i-1][j] == '.' if i > 0 else False
                below_dot = grid[i+1][j] == '.' if i < grid_height - 1 else False
                left_dot = grid[i][j-1] == '.' if j > 0 else False
                right_dot = grid[i][j+1] == '.' if j < grid_width - 1 else False

                dot_condition = f"{int(above_dot)}{int(below_dot)}{int(left_dot)}{int(right_dot)}"
                icon_filename = dot_conditions.get(dot_condition, 'grey.png')
                icon_path = icon_directory + icon_filename
                icon_image = Image.open(icon_path)

                # Calculate the position to paste the icon
                paste_position = (j * icon_size, i * icon_size)

                # Paste the icon onto the image
                image.paste(icon_image, paste_position)

            elif char == '<':
                # Check conditions for dot icons
                above_dot = grid[i-1][j] == '<' if i > 0 else False
                below_dot = grid[i+1][j] == '<' if i < grid_height - 1 else False
                left_dot = grid[i][j-1] == '<' if j > 0 else False
                right_dot = grid[i][j+1] == '<' if j < grid_width - 1 else False

                dot_condition = f"{int(above_dot)}{int(below_dot)}{int(left_dot)}{int(right_dot)}"
                icon_filename = dot_conditions.get(dot_condition, 'grey.png').replace('street', 'railway').replace('crossing', 'rcrossing')
                icon_path = icon_directory + icon_filename
                icon_image = Image.open(icon_path)

                # Calculate the position to paste the icon
                paste_position = (j * icon_size, i * icon_size)

                # Paste the icon onto the image
                image.paste(icon_image, paste_position)

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


def create_charset_and_charmap(bitmap, block_size=(4, 8)):
    charset = []
    charsetidx = [] # maybe stupid i dont care
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

    return charset, charmap


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
                try:
                    byte.extend(format(color_index, '02b'))
                except:
                    raise Exception (f"Unknown color! {k}")
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
    image = Image.new('RGB', (width, height), color='red')  # 'L' mode for grayscale image

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
    'B': 'cardealer.png',
    'C': 'forgery.png',
    'D': 'loanshark.png',
    'E': 'pub.png',
    'F': 'subway.png',
    'G': 'bank.png',
    'H': 'gambling.png',
    'I': 'hideout.png',
    'J': 'police.png',
    'K': 'store.png',
    'L': 'centralstation.png',
    'M': 'moneytransporter.png',
    'N': 'major.png',
    'P': 'park.png',
    'R': 'house.png',
    'W': 'water.png',
    'X': 'grey.png',
}


def cutGrid(grid, t, b, l, r):
    # remove stupid boundary
    result_grid = grid[t:b]
    for row in range(len(result_grid)):
        result_grid[row] = result_grid[row][l:r]
    return result_grid


def pad_and_save_streams(streams, pad_length, output_file):
    with open(output_file, 'wb') as f:
        for i, stream in enumerate(streams):
            # Write the byte stream
            f.write(stream)

            # Add padding (except for the last stream)
            if i != len(streams) - 1:
                padding = b'\x00' * (pad_length - len(stream))
                f.write(padding)




if __name__ == '__main__':
    result_grid = load_grid('grid_final.txt')

    # remove all - used for ease
    new_grid = []
    for r in result_grid:
        z = r.replace('-', '')
        if len(z) > 1:
            new_grid.append(z)
    result_grid = new_grid

    #result_grid = cutGrid (result_grid, 0, 24, 0, 20)
    #printGrid (result_grid)

    full_bitmap = visualize_grid(result_grid, icon_mapping)
    full_bitmap.save('output/map_visualized.png')

    # test full grid first
    charset, charmap = create_charset_and_charmap(full_bitmap)
    print (f"Whole map has altogether {len(charset)} chars.")
    img_charset = render_used_characters(charset)
    img_charset.save('output/charset_all.png')

    #cut the bitmap into sizes
    #for now simulate first 40x20 data
    #bitmap size is then 160x96
    print ("Overall grid size", len(result_grid), "x", len(result_grid[0]))
    for M, cx in enumerate(range(0,len(result_grid),19)):
        for N, cy in enumerate(range(0,len(result_grid[0]),20)):
            print (cx, cy)
            cut_grid = cutGrid (result_grid, cx, cx+19, cy, cy+20)
            bitmap_result = visualize_grid(cut_grid, icon_mapping)

            verification_result, nErrors = verify_colors(bitmap_result)
            if nErrors > 0:
                verification_result.save('output/map_errors.png')
                print (f"{nErrors} color errors found.")
                raise Exception ("Fix it")

            charset, charmap = create_charset_and_charmap(bitmap_result)
            cut_map = [''.join([char*2 for char in string]) for string in cut_grid]
            mapping = {num: char for sublist, string in zip(charmap, cut_map) for num, char in zip(sublist, string)}
            char_array = [mapping.get(i, '-') for i in range(max(mapping.keys()) + 1)]
            locmap = ''.join(char_array)
            img_charset = render_used_characters(charset, border = 1)

            id = N+M*5 # FIXME if the number of screens change
            id = chr(ord('a') + id)
            print (f"Have in map at", cx, cy, f"with id {id} now {len(charset)} chars.")

            img_charset.save(f'/tmp/charset_{id}.png')
            bitmap_result.save(f"/tmp/current_crop_{id}.png") # __{len(charset)}

            if len(charset) > 127:
                raise Exception ("diz not goen.")
            
            byte_stream = convert_charset_to_bytestream(charset, colormap)
            flat_charmap = bytes([byte for sublist in charmap for byte in sublist])
            flat_cutmap = bytes([ord(byte) for sublist in cut_map for byte in sublist])

            oneFile = True 
            if oneFile == False:
                save_byte_stream(byte_stream, f'../assets/{id}amapfnt.gfx')
                save_byte_stream(flat_charmap, f'../assets/{id}amapscr.gfx')
                save_byte_stream(flat_cutmap, f'../assets/{id}amaploc.gfx')
            else:
                streams = [byte_stream, flat_charmap, flat_cutmap]
                output_file = f'../assets/{id}combmap.gfx'
                pad_and_save_streams(streams, 0x0400, output_file)

#
