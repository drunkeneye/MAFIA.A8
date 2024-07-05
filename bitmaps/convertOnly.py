import os
import shutil
from pathlib import Path
from glob import glob



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
def process_png_files(pdir):
    outputs_dir = Path("outputs")
    outputs_dir.mkdir(exist_ok=True)

    output_subdir = outputs_dir / ("output_" + pdir)
    output_subdir.mkdir(exist_ok=True)
 
    # Copy files from Generator/ to outputs/<name of the png file>/
    for generator_file in Path("Generator").glob("*"):
        shutil.copy(generator_file, output_subdir)

    for generator_file in glob(f"{pdir}/*"):
        shutil.copy(generator_file, output_subdir)

    # modify .ds to be .byte, else we get relocation blocks in .xex

    os.chdir(output_subdir)
    replace_ds_by_byte("output.png.pmg")
    os.system("make " + pdir + ".xex")
    shutil.copy(pdir + ".xex", f"../../../assets/{pdir}.xex")
    os.chdir("../..")

if __name__ == "__main__":
    # find folders 
    images = glob("*/output.png.mic")
    for i in images:
        pdir = os.path.dirname(i)
        process_png_files(pdir)

        # f..k
        # special behandlung for finalmap.gfx, because xbiosloadfile doesnt work for me there
        shutil.copy(f"../assets/{pdir}.xex", f"../assets/{pdir}pic.gfx")

#

