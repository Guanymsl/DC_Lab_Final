module player2_squat_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'h87e750;
        color_map[2] = 24'h86e33d;
        color_map[3] = 24'h82e23f;
        color_map[4] = 24'h83e141;
        color_map[5] = 24'h82e13f;
        color_map[6] = 24'h82e13d;
        color_map[7] = 24'h7fde3f;
        color_map[8] = 24'h79d73f;
        color_map[9] = 24'h69c642;
        color_map[10] = 24'h7ea96e;
        color_map[11] = 24'hc566db;
        color_map[12] = 24'hdd53fc;
        color_map[13] = 24'hde52fe;
        color_map[14] = 24'h4bb344;
        color_map[15] = 24'h468338;
    end
endmodule