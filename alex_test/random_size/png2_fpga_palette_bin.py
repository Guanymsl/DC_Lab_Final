#!/usr/bin/env python3
# png2_fpga_palette_bin.py
#
# 依賴：pip install pillow scikit-learn numpy
# 使用範例：
#   原尺寸
#     python3 png2_fpga_palette_bin.py pic.png --name pic
#   指定 256×256 方形
#     python3 png2_fpga_palette_bin.py pic.png --name pic --size 256
#   指定 1600×900
#     python3 png2_fpga_palette_bin.py pic.png --name pic --size 1600x900

import argparse, sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageOps
from sklearn.cluster import MiniBatchKMeans

# ---------- 工具 -------------------------------------------------------------
def sort_by_luma(rgb):
    y = 0.299*rgb[:,0] + 0.587*rgb[:,1] + 0.114*rgb[:,2]
    return rgb[np.argsort(-y)]

def verilog_palette(name, colors):
    lines = [f"module {name}_palette(output reg [23:0] color_map [0:15]);",
             "    initial begin"]
    for i, (r, g, b) in enumerate(colors):
        note = " // Transparent" if i == 0 else ""
        lines.append(f"        color_map[{i}] = 24'h{r:02x}{g:02x}{b:02x};{note}")
    lines += ["    end", "endmodule"]
    return "\n".join(lines)

def pack_4bit(mat):
    flat = mat.flatten()
    if flat.size & 1:                     # 若為奇數，補一個 0
        flat = np.append(flat, 0)
    return ((flat[0::2] << 4) | flat[1::2]).astype(np.uint8).tobytes()

# ---------- 主流程 -----------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("png", help="輸入 PNG 圖檔")
    ap.add_argument("--name", default="img", help="輸出檔名前綴")
    ap.add_argument("--size", help="目標解析度：單一 N 代表 N×N；或 WxH，如 1600x900")
    args = ap.parse_args()

    # 1) 讀圖 & 依需求 resize
    img = Image.open(args.png).convert("RGBA")
    if args.size:
        # 解析 --size
        try:
            if "x" in args.size.lower():
                w_new, h_new = map(int, args.size.lower().split("x"))
            else:
                w_new = h_new = int(args.size)
        except ValueError:
            sys.exit("size 格式錯誤！請用 N 或 WxH，例如 256 或 1600x900")
        img = ImageOps.fit(img, (w_new, h_new), Image.LANCZOS)

    h, w = img.size[1], img.size[0]
    arr   = np.array(img)
    mask  = arr[..., 3] > 0               # alpha > 0 為有效像素
    rgb   = arr[..., :3]

    # 2) 取非透明像素做 k-means → 15 色
    data = rgb[mask].reshape(-1, 3).astype(np.float32)
    if data.size == 0:
        sys.exit("輸入圖片完全透明，無法產生 palette！")
    km = MiniBatchKMeans(n_clusters=15, random_state=0, batch_size=4096).fit(data)
    centers = sort_by_luma(km.cluster_centers_.astype(np.uint8))
    palette = np.vstack(([0, 0, 0], centers))  # palette[0] = transparent

    # 3) 生成 index map（0=透明，1~15=色）
    idx = np.zeros((h, w), dtype=np.uint8)
    px  = rgb[mask].reshape(-1, 3).astype(np.int16)
    c16 = centers.astype(np.int16)
    d2  = np.sum((px[:, None, :] - c16[None, :, :]) ** 2, axis=2)
    idx[mask] = 1 + np.argmin(d2, axis=1)

    # 4) 輸出 .bin
    bin_path = Path(f"{args.name}.bin")
    bin_path.write_bytes(pack_4bit(idx))
    print(f"// BIN saved → {bin_path}", file=sys.stderr)

    # 5) 印出 palette Verilog (stdout)
    print(verilog_palette(args.name, palette))

if __name__ == "__main__":
    main()