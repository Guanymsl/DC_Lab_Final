# venv:
source .venv/bin/activate 

pip install --upgrade pillow scikit-learn numpy

# usage:
python3 png2_fpga_bin.py  <input files name>.png  --size 200  --name <output name>  > <output name>.v

(you can change 200->100 for 100 * 100 size)

and you will get "<output name>_palette" and "<output name>_lut"!