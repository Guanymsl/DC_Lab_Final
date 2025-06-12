module bullet1_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hedffff;
        color_map[2] = 24'h77d9d5;
        color_map[3] = 24'h01fefe;
        color_map[4] = 24'h83c5bd;
        color_map[5] = 24'h73cdba;
        color_map[6] = 24'h72cabd;
        color_map[7] = 24'h73c6c3;
        color_map[8] = 24'h71c2c6;
        color_map[9] = 24'h73c0c9;
        color_map[10] = 24'h68c5bb;
        color_map[11] = 24'h65c1c3;
        color_map[12] = 24'h5abdbf;
        color_map[13] = 24'h51b8be;
        color_map[14] = 24'h41b4bd;
        color_map[15] = 24'h4c5d4c;
    end
endmodule