from PIL import Image, ImageDraw
import math

# Define exact colors (RGB)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
YELLOW = (255, 204, 0)  # German flag gold
WHITE = (255, 255, 255)
BLUE = (0, 51, 153)     # Union Jack blue

# Set dimensions with correct aspect ratios
FLAG_WIDTH = 300
FLAG_HEIGHT = int(FLAG_WIDTH * (3/5))  # Standard 3:5 aspect ratio for most flags
PADDING = int(FLAG_WIDTH * 0.15)  # 15% padding for better spacing
PADDING = 89
TOTAL_WIDTH = FLAG_WIDTH + (2 * PADDING)
TOTAL_HEIGHT = (3 * FLAG_HEIGHT) + (4 * PADDING)

# Create new image with black background
image = Image.new('RGB', (TOTAL_WIDTH, TOTAL_HEIGHT), BLACK)
draw = ImageDraw.Draw(image)

# Border width increased to 10
BORDER_WIDTH = 10

# German flag (black, red, yellow)
y_pos = 3 * PADDING + 2 * FLAG_HEIGHT
draw.rectangle([(PADDING, y_pos), 
                (PADDING + FLAG_WIDTH, y_pos + FLAG_HEIGHT/3)], fill=BLACK)
draw.rectangle([(PADDING, y_pos + FLAG_HEIGHT/3), 
                (PADDING + FLAG_WIDTH, y_pos + 2*FLAG_HEIGHT/3)], fill=RED)
draw.rectangle([(PADDING, y_pos + 2*FLAG_HEIGHT/3), 
                (PADDING + FLAG_WIDTH, y_pos + FLAG_HEIGHT)], fill=YELLOW)
# Thick white border for German flag
for i in range(BORDER_WIDTH):
    draw.rectangle([(PADDING-i-1, y_pos-i-1), 
                   (PADDING + FLAG_WIDTH+i+1, y_pos + FLAG_HEIGHT+i+1)], outline=WHITE)

# Polish flag (white, red)
y_pos = PADDING
draw.rectangle([(PADDING, y_pos), 
                (PADDING + FLAG_WIDTH, y_pos + FLAG_HEIGHT/2)], fill=WHITE)
draw.rectangle([(PADDING, y_pos + FLAG_HEIGHT/2), 
                (PADDING + FLAG_WIDTH, y_pos + FLAG_HEIGHT)], fill=RED)
# Thick white border for Polish flag
for i in range(BORDER_WIDTH):
    draw.rectangle([(PADDING-i-1, y_pos-i-1), 
                   (PADDING + FLAG_WIDTH+i+1, y_pos + FLAG_HEIGHT+i+1)], outline=WHITE)

# Load and paste Union Jack
y_pos = 2 * PADDING + FLAG_HEIGHT
union_jack = Image.open('union_jack.png')

# Resize Union Jack to match our flag dimensions
target_ratio = FLAG_WIDTH / FLAG_HEIGHT
current_ratio = union_jack.width / union_jack.height

if current_ratio > target_ratio:
    # Image is too wide, calculate new width
    new_width = int(union_jack.height * target_ratio)
    # Crop from center
    left = (union_jack.width - new_width) // 2
    union_jack = union_jack.crop((left, 0, left + new_width, union_jack.height))
else:
    # Image is too tall, calculate new height
    new_height = int(union_jack.width / target_ratio)
    # Crop from center
    top = (union_jack.height - new_height) // 2
    union_jack = union_jack.crop((0, top, union_jack.width, top + new_height))

# Resize to our flag dimensions
union_jack = union_jack.resize((FLAG_WIDTH, FLAG_HEIGHT), Image.Resampling.NEAREST)
image.paste(union_jack, (PADDING, y_pos))

# Thick white border for Union Jack
for i in range(BORDER_WIDTH):
    draw.rectangle([(PADDING-i-1, y_pos-i-1), 
                   (PADDING + FLAG_WIDTH+i+1, y_pos + FLAG_HEIGHT+i+1)], outline=WHITE)

# Calculate intermediate size to maintain aspect ratio
target_height = 200
intermediate_width = int((TOTAL_WIDTH / TOTAL_HEIGHT) * target_height)

# First resize maintaining aspect ratio using NEAREST to preserve exact colors
image = image.resize((intermediate_width, target_height), Image.Resampling.NEAREST)

# Create new black image with target dimensions
final_image = Image.new('RGB', (320, 200), BLACK)
# Calculate padding for centering
x_offset = (320 - intermediate_width) // 2

# Paste the resized image centered horizontally
final_image.paste(image, (x_offset, 0))

# Add arrows next to German flag with specified dimensions
draw_final = ImageDraw.Draw(final_image)
arrow_length = 26
arrow_height = 8
arrow_point = 8
arrow_y = 22  # Approximate y-position of German flag center
flag_padding = 77

# Left arrow (pointing right)
left_x = x_offset - flag_padding - arrow_length
draw_final.polygon([
    (left_x, arrow_y - arrow_height//2),
    (left_x + arrow_length, arrow_y - arrow_height//2),
    (left_x + arrow_length, arrow_y - arrow_height//2 - arrow_point),
    (left_x + arrow_length + arrow_point, arrow_y),
    (left_x + arrow_length, arrow_y + arrow_height//2 + arrow_point),
    (left_x + arrow_length, arrow_y + arrow_height//2),
    (left_x, arrow_y + arrow_height//2)
], fill=WHITE)

# Right arrow (pointing left)
right_x = x_offset + intermediate_width + flag_padding
draw_final.polygon([
    (right_x + arrow_length, arrow_y - arrow_height//2),
    (right_x, arrow_y - arrow_height//2),
    (right_x, arrow_y - arrow_height//2 - arrow_point),
    (right_x - arrow_point, arrow_y),
    (right_x, arrow_y + arrow_height//2 + arrow_point),
    (right_x, arrow_y + arrow_height//2),
    (right_x + arrow_length, arrow_y + arrow_height//2)
], fill=WHITE)

# First resize to 160x200 maintaining aspect ratio using NEAREST
final_image = final_image.resize((160, 200), Image.Resampling.NEAREST)
# Save the smaller image
final_image.save('flags_160.png')
# Resize to 320x200
final_image = final_image.resize((320, 200), Image.Resampling.NEAREST)
# Save the larger image
final_image.save('flags_320.png')