#!/usr/bin/env python3
# png2_fpga_bin.py
#
# usage (產 200×200，模組前綴 car1)：
#   python3 png2_fpga_bin.py car.png --size 200 --name car1 > car1.v
#
# 產物：
#   • car1.v   ：palette + LUT  (stdout)
#   • car1.bin ：packed-4-bit   (binary file)
#
# 依賴：pip install pillow scikit-learn numpy

import argparse, sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageOps
from sklearn.cluster import MiniBatchKMeans

# ------------------------------------------------------------
def sort_by_luma(rgb):
    y = 0.299*rgb[:,0] + 0.587*rgb[:,1] + 0.114*rgb[:,2]
    return rgb[np.argsort(-y)]

def verilog_palette(name, colors):
    out = [f"module {name}_palette(output reg [23:0] color_map [0:15]);",
           "    initial begin"]
    for i, (r,g,b) in enumerate(colors):
        note = " // Transparent" if i==0 else ""
        out.append(f"        color_map[{i}] = 24'h{r:02x}{g:02x}{b:02x};{note}")
    out += ["    end", "endmodule"]
    return "\n".join(out)

def verilog_lut(name, mat):
    h,w = mat.shape
    out = [f"module {name}_lut(output reg [3:0] pixel_data [0:{h-1}][0:{w-1}]);",
           "    initial begin"]
    for y in range(h):
        for x in range(w):
            out.append(f"        pixel_data[{y}][{x}] = {int(mat[y,x])};")
        out[-1] += f" // y={y}"
    out += ["    end", "endmodule"]
    return "\n".join(out)

def pack_4bit(mat):
    flat = mat.flatten()
    if flat.size & 1:                      # odd ⇒ pad one nibble
        flat = np.append(flat, 0)
    return ((flat[0::2] << 4) | flat[1::2]).astype(np.uint8).tobytes()

# ------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("png")
    ap.add_argument("--size", type=int, default=40)
    ap.add_argument("--name", default="car")
    args = ap.parse_args()

    # 1. load & resize
    img = Image.open(args.png).convert("RGBA")
    img = ImageOps.fit(img, (args.size, args.size), Image.LANCZOS)
    arr   = np.array(img)
    mask  = arr[...,3] > 0
    rgb   = arr[..., :3]

    # 2. k-means 15 colours
    data = rgb[mask].reshape(-1,3).astype(np.float32)
    km = MiniBatchKMeans(n_clusters=15, random_state=0, batch_size=4096).fit(data)
    centers = sort_by_luma(km.cluster_centers_.astype(np.uint8))
    palette = np.vstack(([0,0,0], centers))   # idx0 = transparent

    # 3. make index map
    idx = np.zeros((args.size,args.size), dtype=np.uint8)
    if data.size:
        px  = rgb[mask].reshape(-1,3).astype(np.int16)
        c16 = centers.astype(np.int16)
        d2  = np.sum((px[:,None,:] - c16[None,:,:])**2, axis=2)
        idx[mask] = 1 + np.argmin(d2, axis=1)

    # 4. write .bin
    bin_path = Path(f"{args.name}.bin")
    bin_path.write_bytes(pack_4bit(idx))
    print(f"// BIN saved → {bin_path}", file=sys.stderr)

    # 5. print verilog
    print(verilog_palette(args.name, palette))
    print()
    print(verilog_lut(args.name, idx))

if __name__ == "__main__":
    main()