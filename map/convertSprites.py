from PIL import Image
import numpy as np
import os

def create_bytestream(image_paths, output_path):
    bytestream = []
    for image_path in image_paths:
        img = Image.open(image_path)
        img_data = np.array(img)
        unique_colors = [color for color in np.unique(img_data.reshape(-1, img_data.shape[-1]), axis=0) if not np.array_equal(color, [128, 128, 128, 255])]
        print ("Converting", image_path, "with", len(unique_colors), "colors")

        for color in unique_colors:
            byte_array = bytearray()
            for row in img_data:
                byte = 0
                for pixel in row:
                    byte = byte << 1
                    if np.array_equal(pixel, color):
                        byte = byte | 1
                byte_array.append(byte)
            bytestream.append(byte_array)

    with open(output_path, 'wb') as f:
        for byte_array in bytestream:
            f.write(byte_array)


def create_back_sprites():
    sprites = ['icons/sprite_player_M.png', 'icons/sprite_player_M_2.png',
        'icons/sprite_player_F.png', 'icons/sprite_player_F_2.png']

    for sprite in sprites:
        img = Image.open(sprite)
        flipped_img = img.transpose(Image.FLIP_LEFT_RIGHT)
        base, ext = os.path.splitext(sprite)
        new_filename = f"{base}_R{ext}"
        flipped_img.save(new_filename)



if __name__ == '__main__':
    create_back_sprites()
    create_bytestream([ 'icons/sprite_player_M.png', 'icons/sprite_player_M_2.png',
                        'icons/sprite_player_F.png', 'icons/sprite_player_F_2.png',
                        'icons/sprite_player_M_R.png', 'icons/sprite_player_M_2_R.png',
                        'icons/sprite_player_F_R.png', 'icons/sprite_player_F_2_R.png'], '../assets/player.pmg')

#
