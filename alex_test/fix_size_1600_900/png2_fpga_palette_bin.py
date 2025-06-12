#!/usr/bin/env python3
# png2_fpga_palette_bin.py
#
# usage:
#   python3 png2_fpga_palette_bin.py input.png --name img1
#
# output:
#   img1_palette.v  // verilog palette (stdout)
#   img1.bin        // packed 4-bit index

import argparse, sys
from pathlib import Path
import numpy as np
from PIL import Image
from sklearn.cluster import MiniBatchKMeans

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

def pack_4bit(mat):
    flat = mat.flatten()
    if flat.size & 1:
        flat = np.append(flat, 0)
    return ((flat[0::2] << 4) | flat[1::2]).astype(np.uint8).tobytes()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("png")
    ap.add_argument("--name", default="img")
    args = ap.parse_args()

    # 1. load image (RGBA, keep original size)
    img = Image.open(args.png).convert("RGBA")
    h, w = img.size[1], img.size[0]
    arr = np.array(img)
    mask = arr[...,3] > 0
    rgb = arr[...,:3]

    # 2. k-means (15 colors, only on non-transparent pixels)
    data = rgb[mask].reshape(-1,3).astype(np.float32)
    if len(data) == 0:
        raise RuntimeError("Image is fully transparent?")
    km = MiniBatchKMeans(n_clusters=15, random_state=0, batch_size=4096).fit(data)
    centers = sort_by_luma(km.cluster_centers_.astype(np.uint8))
    palette = np.vstack(([0,0,0], centers))   # idx0 = transparent

    # 3. make index map (idx=0 for transparent, 1~15 for colors)
    idx = np.zeros((h, w), dtype=np.uint8)
    if data.size:
        px  = rgb[mask].reshape(-1,3).astype(np.int16)
        c16 = centers.astype(np.int16)
        d2  = np.sum((px[:,None,:] - c16[None,:,:])**2, axis=2)
        idx[mask] = 1 + np.argmin(d2, axis=1)

    # 4. write .bin (packed 4-bit index)
    bin_path = Path(f"{args.name}.bin")
    bin_path.write_bytes(pack_4bit(idx))
    print(f"// BIN saved → {bin_path}", file=sys.stderr)

    # 5. print palette Verilog only (stdout)
    print(verilog_palette(args.name, palette))

if __name__ == "__main__":
    main()