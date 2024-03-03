import numpy as np

def reorder_blocks(input_file, atari_file, output_file, encoding_table):
    with open(input_file, 'rb') as file:
        data = file.read()

    with open(atari_file, 'rb') as file:
        atari_data = file.read()

    block_size = 8
    num_blocks = len(data) // block_size
    output_data = bytearray()

    for j, index in enumerate(encoding_table):
        if index != -1:
            start_byte = index * block_size
            end_byte = start_byte + block_size
            output_data.extend(data[start_byte:end_byte])
        else:
            start_byte = j * block_size
            end_byte = start_byte + block_size
            output_data.extend(atari_data[start_byte:end_byte])

    with open(output_file, 'wb') as file:
        file.write(output_data)

if __name__ == "__main__":
    # Specify your input and output file paths
    input_file_path = "./fonts/mf-zeichen"
    atari_file_path = "./fonts/Prince.fnt"
    output_file_path = "../assets/mafia.fnt"

    # Define the encoding table
    encoding_table = [32, 33, 34, 35, 36,  37, 38, 39, 40, 41,  42, 43, 44, 45, 46,   47,  # 0 -16
                      48, 49, 50, 51, 52,  53, 54, 55, 56, 57,  58, 59, 60, 61, 62,   63,  # 16-
                      0, 1, 2, 3, 4,   5, 6, 7, 8, 9,   10, 11, 12, 13, 14,   15,          # 32-
                      16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,   31]    # 48-
                      # 32, 32, 32, 32, 32,   32, 32, 32, 32, 32,   32, 32, 32, 32, 32,  32, # 64-
                      # 32, 32, 32, 32, 32,   32, 32, 32, 32, 32,   32, 32, 32, 32, 32,  32,
                      # 0, 1, 2, 3, 4,   5, 6, 7, 8, 9,   10, 11, 12, 13, 14,   15,
                      # 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,   31]
    encoding_table += [-1]*(128-len(encoding_table))

    # Perform the reordering
    reorder_blocks(input_file_path, atari_file_path, output_file_path, encoding_table)

    print("Reordering completed. Output file saved as 'mafia.fnt'.")

#
