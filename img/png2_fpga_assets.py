#!/usr/bin/env python3
# png2_fpga_assets.py
#
# usage ── 例：產 200×200，模組名前綴 car1
#   python3 png2_fpga_assets.py car.png --size 200 --name car1 > car1.v
#
# 依賴：pip install pillow scikit-learn numpy

import argparse, sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageOps
from sklearn.cluster import MiniBatchKMeans

# ---------- 小工具 ---------- #
def sort_by_luma(rgb: np.ndarray) -> np.ndarray:
    y = 0.299*rgb[:,0] + 0.587*rgb[:,1] + 0.114*rgb[:,2]
    return rgb[np.argsort(-y)]

def write_palette(name, colors) -> str:
    out = [f"module {name}_palette(output reg [23:0] color_map [0:15]);",
           "    initial begin"]
    for i, (r, g, b) in enumerate(colors):
        note = " // Transparent" if i == 0 else ""
        out.append(f"        color_map[{i}] = 24'h{r:02x}{g:02x}{b:02x};{note}")
    out += ["    end", "endmodule"]
    return "\n".join(out)

def write_lut(name, idx_mat) -> str:
    h, w = idx_mat.shape
    out = [f"module {name}_lut(output reg [3:0] pixel_data [0:{h-1}][0:{w-1}]);",
           "    initial begin"]
    for y in range(h):
        for x in range(w):
            out.append(f"        pixel_data[{y}][{x}] = {int(idx_mat[y,x])};")
        out[-1] += f" // y={y}"
    out += ["    end", "endmodule"]
    return "\n".join(out)

def pack_4b(idx_mat: np.ndarray) -> bytes:
    flat = idx_mat.flatten()
    if flat.size & 1:                                  # 奇數像素補 0
        flat = np.append(flat, 0)
    packed = (flat[0::2] << 4) | flat[1::2]
    return packed.astype(np.uint8).tobytes()

def write_hex(fname, packed: bytes):
    with open(fname, "w") as f:
        for b in packed:
            f.write(f"{b:02x}\n")

def write_mif(fname, packed: bytes):
    depth = len(packed)
    with open(fname, "w") as f:
        f.write(f"WIDTH=8;\nDEPTH={depth};\n\n")
        f.write("ADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\nCONTENT BEGIN\n")
        for addr, b in enumerate(packed):
            f.write(f"{addr:04x} : {b:02x};\n")
        f.write("END;\n")

# ---------- 主流程 ---------- #
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("png", help="input png file")
    ap.add_argument("--size", type=int, default=40, help="square size (default 40)")
    ap.add_argument("--name", default="car", help="module / file base name")
    args = ap.parse_args()

    # 1. load & resize ----------------------------
    img = Image.open(args.png).convert("RGBA")
    img = ImageOps.fit(img, (args.size, args.size), Image.LANCZOS)
    arr   = np.array(img)
    mask  = arr[...,3] > 0            # True = 不透明
    rgb   = arr[..., :3]

    # 2. k-means (15 色) --------------------------
    data = rgb[mask].reshape(-1,3).astype(np.float32)
    km   = MiniBatchKMeans(n_clusters=15, random_state=0, batch_size=4096).fit(data)
    centers = sort_by_luma(km.cluster_centers_.astype(np.uint8))
    palette = np.vstack(([0,0,0], centers))           # index 0 = transparent

    # 3. build index map --------------------------
    idx = np.zeros((args.size, args.size), dtype=np.uint8)
    if data.size:
        px   = rgb[mask].reshape(-1,3).astype(np.int16)
        c16  = centers.astype(np.int16)
        d2   = np.sum((px[:,None,:] - c16[None,:,:])**2, axis=2)
        idx[mask] = 1 + np.argmin(d2, axis=1)         # shift by 1

    # 4. dump binary ------------------------------
    packed = pack_4b(idx)
    hex_path = Path(f"{args.name}.hex")
    mif_path = Path(f"{args.name}.mif")
    write_hex(hex_path, packed)
    write_mif(mif_path, packed)
    print(f"// HEX  saved → {hex_path}", file=sys.stderr)
    print(f"// MIF  saved → {mif_path}", file=sys.stderr)

    # 5. stdout verilog ---------------------------
    print(write_palette(args.name, palette))
    print()
    print(write_lut(args.name, idx))

if __name__ == "__main__":
    main()