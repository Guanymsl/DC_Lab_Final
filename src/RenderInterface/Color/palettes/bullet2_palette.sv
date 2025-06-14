module bullet2_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hffff00;
        color_map[2] = 24'hf7b405;
        color_map[3] = 24'hf2990d;
        color_map[4] = 24'hf1880d;
        color_map[5] = 24'hf3830c;
        color_map[6] = 24'hfe7e00;
        color_map[7] = 24'hf07a0c;
        color_map[8] = 24'hf1740d;
        color_map[9] = 24'hf06e0c;
        color_map[10] = 24'hf0680d;
        color_map[11] = 24'hf25a0b;
        color_map[12] = 24'ha87e00;
        color_map[13] = 24'hf04c0d;
        color_map[14] = 24'hff0000;
        color_map[15] = 24'h000000;
    end
endmodule