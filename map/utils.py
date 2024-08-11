from PIL import Image, ImageDraw
import random
random.seed(571)
import numpy as np
from scipy.spatial.distance import cdist




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
                print (unique_colors)
                bitmap_array[i:i+block_height, j:j+block_width] = [255, 0, 0]
                nErrors += 1
            elif j == 0 or j + block_width == len(bitmap_array[0]):
                bitmap_array[i:i+block_height, j:j+block_width] = [255, 255, 0]

    return Image.fromarray(bitmap_array, 'RGB'), nErrors



# characters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K']

# def generate_grid(grid_size):
#     grid = []
#     for i in range(grid_size[0]):
#         row = ""
#         for j in range(grid_size[1]):
#             if i % 4 == 0 or j % 4 == 0:
#                 row += "."
#             else:
#                 row += " "
#         grid.append(row)
#     return grid



# def place_random_characters(grid):

#     all_available_spaces = [(i, j) for i in range(1, len(grid), 4) for j in range(1, len(grid[0]), 4)]
#     available_spaces = [
#         [z for z in all_available_spaces if z[0] in range(0, len(grid)//2)            and z[1] in range(0, len(grid[0])//2)],
#         [z for z in all_available_spaces if z[0] in range(len(grid)//2, len(grid)) and z[1] in range(0, len(grid[0])//2)],
#         [z for z in all_available_spaces if z[0] in range(0, len(grid)//2)            and z[1] in range(len(grid[0])//2, len(grid[0]))],
#         [z for z in all_available_spaces if z[0] in range(len(grid)//2, len(grid)) and z[1] in range(len(grid[0])//2, len(grid[0]))],
#     ]

#     for k, quadrant_list in enumerate(available_spaces):
#         counts = len(characters) * [0]

#         while quadrant_list and any(count < 1 for count in counts):
#             # Randomly select an available space
#             i, j = random.choice(quadrant_list)

#             # Randomly select a character
#             char = random.choice(characters)

#             # Check if the character can be placed in the selected space
#             char_index = characters.index(char)
#             if counts[char_index] < 1:
#                 # all empty?
#                 empty = 0
#                 if j > 4:
#                     empty += grid[i][j-4] != ' '
#                 if i > 4:
#                     empty += grid[i-4][j] != ' '
#                 if i+4 < len(grid):
#                     empty += grid[i+4][j] != ' '
#                 if j+4 < len(grid[0]):
#                     empty += grid[i][j+4] != ' '
#                 if empty == 0:
#                     grid[i] = grid[i][:j] + char + grid[i][j + 1:]
#                     counts[char_index] += 1

#                 # Remove the selected space from available spaces
#                 quadrant_list.remove((i, j))

#     # remove extra forgeries -- FIXME want that really?
#     c_positions = [(i, j) for i, row in enumerate(grid) for j, char in enumerate(row) if grid[i][j] == 'C']
#     random.shuffle(c_positions)

#     for (row, col) in c_positions[1:]:
#         grid[row] = grid[row][:col] + ' ' + grid[row][col + 1:]
#     return grid


# def totally_place_random_characters(grid):
#     counts = len(characters) * [0]

#     # Create a list of available spaces
#     available_spaces = [(i, j) for i in range(1, len(grid), 4) for j in range(1, len(grid[0]), 4)]

#     while available_spaces and any(count < 4 for count in counts):
#         # Randomly select an available space
#         i, j = random.choice(available_spaces)

#         # Randomly select a character
#         char = random.choice(characters)

#         # Check if the character can be placed in the selected space
#         char_index = characters.index(char)
#         if counts[char_index] < 4:
#             # all empty?
#             empty = 0
#             if j > 4:
#                 empty += grid[i][j-4] != ' '
#             if i > 4:
#                 empty += grid[i-4][j] != ' '
#             if i+4 < len(grid):
#                 empty += grid[i+4][j] != ' '
#             if j+4 < len(grid[0]):
#                 empty += grid[i][j+4] != ' '
#             if empty == 0:
#                 grid[i] = grid[i][:j] + char + grid[i][j + 1:]
#                 counts[char_index] += 1

#             # Remove the selected space from available spaces
#             available_spaces.remove((i, j))

#     return grid

# def join(grid, i, j, i_adj, j_adj):
#     if i == i_adj:
#         if j < j_adj:
#             grid = setspace(grid, i,j+3, " ")
#             grid = setspace(grid, i+1,j+3, " ")
#             grid = setspace(grid, i+2,j+3, " ")
#         else:
#             grid = setspace(grid, i,j-1, " ")
#             grid = setspace(grid, i+1,j-1, " ")
#             grid = setspace(grid, i+2,j-1, " ")
#     else:
#         if i < i_adj:
#             grid = setspace(grid, i+3,j, " ")
#             grid = setspace(grid, i+3,j+1, " ")
#             grid = setspace(grid, i+3,j+2, " ")
#         else:
#             grid = setspace(grid, i-1,j, " ")
#             grid = setspace(grid, i-1,j+1, " ")
#             grid = setspace(grid, i-1,j+2, " ")
#     return grid


# def setspace (grid, i,j, v):
#     try:
#         grid[i] = grid[i][:j] + v + grid[i][j + 1:]
#     except:
#         pass
#     return grid


# def join_empty_spaces(grid):
#     available_spaces = [(i, j) for i in range(1, len(grid), 4) for j in range(1, len(grid[0]), 4)]
#     available_spaces = available_spaces*2
#     while available_spaces:
#         i, j = random.choice(available_spaces)
#         if grid[i][j] == ' ':
#             # Randomly select a direction (above, below, right, or left)
#             direction = random.choice(['above', 'below', 'right', 'left'])

#             # Determine the coordinates of the adjacent space
#             if direction == 'above':
#                 i_adj, j_adj = i - 4, j
#             elif direction == 'below':
#                 i_adj, j_adj = i + 4, j
#             elif direction == 'right':
#                 i_adj, j_adj = i, j + 4
#             elif direction == 'left':
#                 i_adj, j_adj = i, j - 4

#             if i_adj < 0:
#                 continue
#             if i_adj >= len(grid):
#                 continue
#             if j_adj < 0 or j_adj >= len(grid[0]):
#                 continue

#             if grid[i_adj][j_adj] == ' ':
#                 grid = join(grid, i,j, i_adj, j_adj)
#                 # grid[i_adj] = grid[i_adj][:j_adj] + "J" + direction[0] + grid[i_adj][(j_adj + 2):]

#         available_spaces.remove((i, j))
#     return grid


# def fill_grid(grid):
#     characters = set('ABCDEFGHIJK')
#     available_spaces = [(i, j) for i in range(1, len(grid)-1, 4) for j in range(1, len(grid[0])-1, 4)]

#     for i, j in available_spaces:
#         char = grid[i][j]
#         # Fill the 3x3 block with the same character
#         for row_offset in range(3):
#             for col_offset in range(3):
#                 setspace(grid, i + row_offset, j + col_offset, char)

#     return grid


# def unfill_grid(grid):
#     for i in range(1, len(grid)-1, 4):
#         for j in range(1, len(grid[0])-1, 4):
#             top_left_char = grid[i][j]
#             # Check if all characters in the 3x3 block are the same and between 'A' and 'J'
#             if top_left_char in 'ABCDEFGHIJKPR' and all(
#                 grid[i + row_offset][j + col_offset] == top_left_char
#                 for row_offset in range(3)
#                 for col_offset in range(3)
#             ):
#                 # Remove all characters in the 3x3 block except the top-left one
#                 for row_offset in range(3):
#                     for col_offset in range(3):
#                         if row_offset != 0 or col_offset != 0:
#                             setspace(grid, i + row_offset, j + col_offset, ' ')
#                 # Set the top-left character back
#                 setspace(grid, i, j, top_left_char)

#     return grid


# def clean_dots(grid):
#     for i in range(2, len(grid)-2):
#         for j in range(2, len(grid[0])-2):
#             if grid[i][j] == '.':
#                 # Check if there are 2 spaces above, below, left, and right
#                 all_spaces = all(grid[x][y] == ' ' for x, y in [(i-2, j), (i-1, j), (i+1, j), (i+2, j), (i, j-2), (i, j-1), (i, j+1), (i, j+2)])

#                 if all_spaces:
#                     grid[i] = grid[i][:j] + ' ' + grid[i][j + 1:]

#     return grid


# def connect_streets(grid):
#     for i in range(len(grid)):
#         for j in range(len(grid[0])-6):
#             pattern = grid[i][j:j+7]

#             if pattern == '..   ..':
#                 grid[i] = grid[i][:j+2] + '...' + grid[i][j+5:]

#     return grid


# def color_grid(grid):
#     # Define colormap for characters 'A' through 'J'
#     colormap = {
#         'A': (255, 0, 0),  # Red
#         'B': (0, 255, 0),  # Green
#         'C': (0, 0, 255),  # Blue
#         'D': (255, 255, 0),  # Yellow
#         'E': (255, 0, 255),  # Magenta
#         'F': (0, 255, 255),  # Cyan
#         'G': (128, 0, 0),  # Maroon
#         'H': (0, 128, 0),  # Green
#         'I': (0, 0, 128),  # Navy
#         'J': (128, 128, 0),  # Gray
#         'K': (128, 0, 128),  # Gray
#     }

#     # Define color for spaces and dots
#     space_color = (0, 0, 0)  # Black
#     dot_color = (255, 255, 255)  # White

#     # Create an image with the same dimensions as the grid
#     image = Image.new('RGB', (len(grid[0]), len(grid)), space_color)
#     draw = ImageDraw.Draw(image)

#     # Iterate over the grid and color the pixels based on characters
#     for i in range(len(grid)):
#         for j in range(len(grid[0])):
#             if grid[i][j] == '.':
#                 draw.point((j, i), dot_color)
#             if grid[i][j] == '<':
#                 draw.point((j, i), dot_color)
#             elif 'A' <= grid[i][j] <= 'K':
#                 #draw.point((j, i), colormap[grid[i][j]])
#                 draw.rectangle([j, i, j + 2, i + 2], fill=colormap[grid[i][j]])

#     return image


# def visualize_grid(grid, icon_mapping):
#     grid = grid.copy()
#     icon_size = 8  # Assuming each character is represented by an 8x8 pixel icon
#     icon_directory = './icons/'

#     grid_height = len(grid)
#     grid_width = len(grid[0])

#     # Create a new image with white background
#     image = Image.new('RGB', (grid_width * icon_size, grid_height * icon_size), 'white')
#     draw = ImageDraw.Draw(image)

#     # Define the dot conditions mapping
#     dot_conditions = {
#         '1111': 'crossing_4.png',  # Dot has dots above, below, left, and right
#         '1100': 'street_V.png',    # Dot has dots above and below
#         '0011': 'street_H.png',    # Dot has dots left and right
#         '1000': 'street_V.png',    # Dot has dots above and below
#         '0001': 'street_H.png',    # Dot has dots left and right
#         '0100': 'street_V.png',    # Dot has dots above and below
#         '0010': 'street_H.png',    # Dot has dots left and right
#         '1110': 'crossing_3E.png',  # Dot has dots above, below, left, and right
#         '1101': 'crossing_3W.png',  # Dot has dots above, below, left, and right
#         '1011': 'crossing_3S.png',  # Dot has dots above, below, left, and right
#         '0111': 'crossing_3N.png',  # Dot has dots above, below, left, and right
#         '1010': 'street_NW.png',  # Dot has dots above, below, left, and right
#         '1001': 'street_NE.png',  # Dot has dots above, below, left, and right
#         '0110': 'street_SW.png',  # Dot has dots above, below, left, and right
#         '0101': 'street_SE.png',  # Dot has dots above, below, left, and right
#     }

#     for i in range(grid_height):
#         for j in range(grid_width):
#             char = grid[i][j]

#             if char in icon_mapping:
#                 # Load the corresponding icon image
#                 icon_filename = icon_mapping[char]
#                 icon_path = icon_directory + icon_filename
#                 icon_image = Image.open(icon_path)

#                 # Calculate the position to paste the icon
#                 paste_position = (j * icon_size, i * icon_size)

#                 # Iterate over 8x8 pixel blocks in the icon image
#                 for block_i in range(0, icon_image.size[1], 8):
#                     for block_j in range(0, icon_image.size[0], 8):
#                         # Check if the character 'below the block' is the same
#                         grid_i = i + block_i//8
#                         grid_j = j + block_j//8
#                         if grid_i < len(grid) and grid_j < len(grid[0]):
#                             if grid[grid_i][grid_j] == char or grid[grid_i][grid_j] == ' ':
#                                 # Paste the 8x8 block onto the image
#                                 block = icon_image.crop((block_j, block_i, block_j + 8, block_i + 8))
#                                 image.paste(block, (paste_position[0] + block_j, paste_position[1] + block_i))

#                                 # Remove the corresponding grid block
#                                 grid = setspace(grid, grid_i, grid_j, ' ')

#             elif char == '.':
#                 # Check conditions for dot icons
#                 above_dot = grid[i-1][j] == '.' if i > 0 else False
#                 below_dot = grid[i+1][j] == '.' if i < grid_height - 1 else False
#                 left_dot = grid[i][j-1] == '.' if j > 0 else False
#                 right_dot = grid[i][j+1] == '.' if j < grid_width - 1 else False

#                 dot_condition = f"{int(above_dot)}{int(below_dot)}{int(left_dot)}{int(right_dot)}"
#                 icon_filename = dot_conditions.get(dot_condition, 'grey.png')
#                 icon_path = icon_directory + icon_filename
#                 icon_image = Image.open(icon_path)

#                 # Calculate the position to paste the icon
#                 paste_position = (j * icon_size, i * icon_size)

#                 # Paste the icon onto the image
#                 image.paste(icon_image, paste_position)
#             elif char == '<':
#                 # Check conditions for dot icons
#                 above_dot = grid[i-1][j] == '<' if i > 0 else False
#                 below_dot = grid[i+1][j] == '<' if i < grid_height - 1 else False
#                 left_dot = grid[i][j-1] == '<' if j > 0 else False
#                 right_dot = grid[i][j+1] == '<' if j < grid_width - 1 else False

#                 dot_condition = f"{int(above_dot)}{int(below_dot)}{int(left_dot)}{int(right_dot)}"
#                 icon_filename = dot_conditions.get(dot_condition, 'grey.png').replace('street', 'railway').replace('crossing', 'rcrossing')
#                 icon_path = icon_directory + icon_filename
#                 icon_image = Image.open(icon_path)

#                 # Calculate the position to paste the icon
#                 paste_position = (j * icon_size, i * icon_size)

#                 # Paste the icon onto the image
#                 image.paste(icon_image, paste_position)

#     # maybe 26,72 on xl and 0, 04, 0e for grey scale
#     colormap = [
#         [0, 0, 0],      # Black
#         [255, 255, 255], # White
#         [240, 128, 0],   # Orange
#         [128, 128, 128], # Grey
#         [0, 80, 160],   # CyanBlue
#     ]

#     img_array = np.array(image)
#     flattened_array = img_array.reshape((-1, 3))
#     colormap_array = np.array(colormap)
#     distances = cdist(flattened_array, colormap_array)
#     nearest_color_indices = np.argmin(distances, axis=1)
#     nearest_colors = colormap_array[nearest_color_indices]
#     result_array = nearest_colors.reshape(img_array.shape)
#     image = Image.fromarray(np.uint8(result_array))
#     return image


# def setspace(grid, i, j, v):
#     try:
#         grid[i] = grid[i][:j] + v + grid[i][j + 1:]
#     except:
#         pass
#     return grid

# def flood_fill_count(grid, start_row, start_col, target_char, replacement_char):
#     if (
#         start_row < 0 or start_row >= len(grid) or
#         start_col < 0 or start_col >= len(grid[0]) or
#         grid[start_row][start_col] != target_char
#     ):
#         return 0

#     count = 1
#     grid[start_row] = grid[start_row][:start_col] + replacement_char + grid[start_row][start_col + 1:]

#     # Recursively perform flood-fill in all four directions
#     count += flood_fill_count(grid, start_row + 1, start_col, target_char, replacement_char)  # Down
#     count += flood_fill_count(grid, start_row - 1, start_col, target_char, replacement_char)  # Up
#     count += flood_fill_count(grid, start_row, start_col + 1, target_char, replacement_char)  # Right
#     count += flood_fill_count(grid, start_row, start_col - 1, target_char, replacement_char)  # Left

#     return count

# def fill_residential_water_parks(grid):
#     for i in range(len(grid)):
#         for j in range(len(grid[0])):
#             if grid[i][j] == ' ':
#                 # Check the area using flood-fill
#                 area_count = flood_fill_count(grid, i, j, ' ', 'X')

#                 if area_count > 3:
#                     # Randomly choose 'P' or 'R' based on probabilities
#                     chosen_char = random.choices(['P', 'R', 'W'], weights=[0.40, 0.40, 0.20])[0]

#                     # Perform flood-fill with the chosen character
#                     flood_fill_count(grid, i, j, 'X', chosen_char)
#     return grid



# def save_grid(grid, filename):
#     with open(filename, 'w') as file:
#         for row in grid:
#             file.write(''.join(row) + '\n')

# def load_grid(filename):
#     with open(filename, 'r') as file:
#         grid = [line.strip() for line in file.readlines()]
#     return grid



# def create_charset_and_charmap(bitmap, block_size=(4, 8)):
#     charset = []
#     charsetidx = [] # maybe stupid i dont care
#     charmap = []
#     idx = 0
#     print (bitmap.size)
#     # Iterate over 4x8 blocks in the bitmap
#     for i in range(0, bitmap.size[1], block_size[1]):
#         row_indices = []
#         for j in range(0, bitmap.size[0], block_size[0]):
#             # Extract the current 4x8 block from the bitmap
#             block = bitmap.crop((j, i, j + block_size[0], i + block_size[1]))

#             # Convert the block to a numpy array for comparison
#             block_array = np.array(block)

#             # Calculate a hash for the block (you can choose a suitable method)
#             block_hash = hash(block_array.tobytes())

#             # Check if the block is in the charset
#             if block_hash not in charsetidx:
#                 idx = len(charsetidx)
#                 charsetidx.append(block_hash)
#                 charset.append(block_array.tobytes())
#             else:
#                 idx = charsetidx.index(block_hash)

#             # Add the index of the block in the charset to the charmap
#             row_indices.append(idx)

#         # Add the row_indices to the charmap
#         charmap.append(row_indices)

#     # Print the number of different indices in each row of the charmap
#     for row in charmap:
#         print(len(set(row)), end=' ')
#     print()  # Move to the next line

#     return charset, charmap


# if __name__ == '__main__':
#     grid_size = (49, 101)
#     #grid_size = (17, 101)
#     grid = generate_grid(grid_size)
#     result_grid = place_random_characters(grid)
#     result_grid = join_empty_spaces (result_grid)
#     result_grid = fill_grid (result_grid)
#     result_grid = clean_dots (result_grid)
#     result_grid = connect_streets (result_grid)

#     result_grid = fill_residential_water_parks(result_grid)

#     save_grid(result_grid, 'output/grid_auto.txt')
#     result_grid = unfill_grid (result_grid)

#     for row in result_grid:
#         print(row)

#     # right now: 24x24= 6x3 = 18 chars per tile

#     icon_mapping = {
#         'A': 'armsdealer.png',
#         'B': 'cardealer.png',
#         'C': 'forgery.png',
#         'D': 'loanshark.png',
#         'E': 'pub.png',
#         'F': 'subway.png',
#         'G': 'bank.png',
#         'H': 'gambling.png',
#         'I': 'hideout.png',
#         'J': 'police.png',
#         'K': 'store.png',
#         'L': 'railway.png',
#         'M': 'major.png',
#         'N': 'transport.png',
        
#         'P': 'park.png',
#         'R': 'house.png',
#         'W': 'water.png',
#         'X': 'grey.png',
#     }

#     bitmap_result = visualize_grid(result_grid, icon_mapping)
#     bitmap_result.save('map_visualized.png')

#     verification_result, nErrors = verify_colors(bitmap_result)
#     verification_result.save('map_color_verification.png')

#     colored_image = color_grid(result_grid)
#     colored_image.save('map_scheme.png')


#     if nErrors > 0:
#         raise Exception ("Color error. Fix it")

#     charset, charmap = create_charset_and_charmap(bitmap_result)
#     print (len(charset))
#     print (charmap)
# #
