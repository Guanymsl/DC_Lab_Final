module bullet2_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hfefe00;
        color_map[2] = 24'hffa600;
        color_map[3] = 24'hf1a60d;
        color_map[4] = 24'hf2930e;
        color_map[5] = 24'hea8c0a;
        color_map[6] = 24'hf1870d;
        color_map[7] = 24'hff7f00;
        color_map[8] = 24'hf1830d;
        color_map[9] = 24'hf17c0d;
        color_map[10] = 24'hf1720d;
        color_map[11] = 24'hf1660d;
        color_map[12] = 24'hf2590c;
        color_map[13] = 24'hf04b0d;
        color_map[14] = 24'h925a00;
        color_map[15] = 24'hfd0000;
    end
endmodule