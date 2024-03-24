import os
import shutil
from pathlib import Path
from glob import glob

rastaconv_command = './rastaconv input.png /distance=yuv /init=smart /dither=chess /filter=box /dither_val=0.1 /dither_rand=4.0 /s=32768 /save=100000 /max_evals=256000000'
#rastaconv_command = './rastaconv input.png /h=200 /pal=laoo /filter=box /s=8192 /save=99999 /max_evals=200000'

def replace_ds_by_byte(file_path):
    with open(file_path, "r") as infile:
        lines = infile.readlines()

    # Modify the desired line
    for i, line in enumerate(lines):
        if ".ds $100" in line:
            lines[i] = ":256 .byte $fe\n"

    # Write the modified content to a new file
    with open(file_path, "w") as outfile:
        outfile.writelines(lines)



# Function to iterate over PNG files in pics/ directory
def process_png_files():
    outputs_dir = Path("outputs")
    outputs_dir.mkdir(exist_ok=True)
    pics_dir = Path("./images")

    for png_file in pics_dir.glob("*.png"):
        print ("Processing", png_file)
        # shutil.copy(png_file, "RastaConverter/input.png")
        # os.chdir("./RastaConverter")

        # # Run the rastaconv command
        # os.system(rastaconv_command)
        # os.chdir("..")
        
        # Create a directory in outputs/

        output_subdir = outputs_dir / ("output_" + png_file.name)
        output_subdir.mkdir(exist_ok=True)
 
        # Copy files from Generator/ to outputs/<name of the png file>/
        for generator_file in Path("Generator").glob("*"):
            shutil.copy(generator_file, output_subdir)

        # modify .ds to be .byte, else we get relocation blocks in .xex

        os.chdir(output_subdir)
        replace_ds_by_byte("output.png.pmg")
        os.system("make " + png_file.stem + ".xex")
        shutil.copy(png_file.stem + ".xex", f"../../../assets/{png_file.stem}.xex")
        os.chdir("../..")

if __name__ == "__main__":
    process_png_files()
    # f..k
    # special behandlung for finalmap.gfx, because xbiosloadfile doesnt work for me there
    shutil.copy("../assets/finalwap.xex", "../assets/finalwap.gfx")
    shutil.copy("../assets/finalmap.xex", "../assets/finalmap.gfx")
    shutil.copy("../assets/finalgap.xex", "../assets/finalgap.gfx")
#    shutil.copy("../assets/finalg.xex", "../assets/finalgap.gfx")
