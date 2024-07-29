import sys
import os

radr = 0xb800

def split_sap_file(filename):
    with open(filename, 'rb') as f:
        content = f.read()

    # Find the position of the first 0xff 0xff sequence
    header_end = content.find(b'\xff\xff')

    if header_end == -1:
        print("No valid blocks found in the file.")
        return

    block_start = header_end + 2
    block_number = 1
    info_lines = []

    while block_start < len(content):
        # Read the address range
        start_addr = content[block_start] + (content[block_start + 1] << 8)
        end_addr = content[block_start + 2] + (content[block_start + 3] << 8)
        block_start += 4

        # Calculate the length of the block
        block_length = end_addr - start_addr + 1

        # Extract the block data
        block_data = bytearray(content[block_start:block_start + block_length])

        # check for CMC header and fix for $a000
        if block_data[0:4] == b'\xa0\xe3\xed\xe3':
            print(f"CMC Music data, relocating to {radr:#04x}")
            print(f"Original start was  {start_addr:#04x}")

            # compute diff
            bdiff = radr - start_addr
            print (f"Difference is {bdiff:#04x}")
            high_diff = (bdiff >> 8) & 0xFF  # Shift right by 8 bits and apply bitmask
            low_diff = bdiff & 0xFF  # Apply bitmask

            print ("Low table")
            hex_values = ', '.join(f'{byte:02x}' for byte in block_data[0x14:0x53] if byte != 0xff)
            print (hex_values)

            print ("High table")
            hex_values = ', '.join(f'{byte:02x}' for byte in block_data[0x54:0x93] if byte != 0xff)
            print (hex_values)

            print ("Relocating...")

            # $14 - $53	Pattern address table - low bytes
            for k in range(0x14, 0x53):
                pb = block_data[k]
                if pb != 0xff:
                    block_data[k] = block_data[k]+low_diff

            #$54 - $93	Pattern address table - high bytes
            for k in range(0x54, 0x93):
                pb = block_data[k]
                if pb != 0xff:
                    block_data[k] = block_data[k]+high_diff

            print ("Low table")
            hex_values = ', '.join(f'{byte:02x}' for byte in block_data[0x14:0x53] if byte != 0xff)
            print (hex_values)

            print ("High table")
            hex_values = ', '.join(f'{byte:02x}' for byte in block_data[0x54:0x93] if byte != 0xff)
            print (hex_values)


        # Write the block data to a new file
        block_filename = f"{os.path.splitext(filename)[0]}_block_{block_number}.bin"
        with open(block_filename, 'wb') as block_file:
            block_file.write(block_data)

        # Add address range info
        info_lines.append(f"Block {block_number}: {hex(start_addr)} - {hex(end_addr)}")

        print(f"Block {block_number} saved to {block_filename}")
        block_start += block_length
        block_number += 1


    # Write the address ranges to SAP_info.txt
    info_filename = f"{os.path.splitext(filename)[0]}_info.txt"
    with open(info_filename, 'w') as info_file:
        info_file.write("\n".join(info_lines))

    print(f"Address ranges saved to {info_filename}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: splitter.py <filename.sap>")
    else:
        split_sap_file(sys.argv[1])


#
