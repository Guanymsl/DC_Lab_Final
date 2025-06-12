# venv:
source .venv/bin/activate 

pip install --upgrade pillow scikit-learn numpy

# usage:
python3 png2_fpga_palette_bin.py map.png --name map

(you can change 200->100 for 100 * 100 size)

and you will get "<output name>_palette" and "<output name>_lut"!