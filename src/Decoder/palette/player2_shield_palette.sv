module player2_shield_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'h83e13e;
        color_map[2] = 24'habbc36;
        color_map[3] = 24'hc48239;
        color_map[4] = 24'hc58039;
        color_map[5] = 24'hbd783b;
        color_map[6] = 24'hd66938;
        color_map[7] = 24'hd0625e;
        color_map[8] = 24'he64e7e;
        color_map[9] = 24'hca6b20;
        color_map[10] = 24'hb3713c;
        color_map[11] = 24'he75338;
        color_map[12] = 24'heb4b35;
        color_map[13] = 24'had6037;
        color_map[14] = 24'heb3b22;
        color_map[15] = 24'hf2280e;
    end
endmodule