module bullet1_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hffffff;
        color_map[2] = 24'h7fffff;
        color_map[3] = 24'h8dfe8d;
        color_map[4] = 24'h77dbbd;
        color_map[5] = 24'h00ffff;
        color_map[6] = 24'h72ccbb;
        color_map[7] = 24'h71c6c2;
        color_map[8] = 24'h75c1c3;
        color_map[9] = 24'h72c0c8;
        color_map[10] = 24'h64c3bc;
        color_map[11] = 24'h5ebec0;
        color_map[12] = 24'h4db9be;
        color_map[13] = 24'h57aca9;
        color_map[14] = 24'h7f7f7f;
        color_map[15] = 24'h000000;
    end
endmodule