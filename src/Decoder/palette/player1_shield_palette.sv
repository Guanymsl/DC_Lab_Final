module player1_shield_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hf7d667;
        color_map[2] = 24'hcbbcd6;
        color_map[3] = 24'hcdb2a3;
        color_map[4] = 24'hccb1a2;
        color_map[5] = 24'hc8afa8;
        color_map[6] = 24'hab96cf;
        color_map[7] = 24'ha995ce;
        color_map[8] = 24'hb59a80;
        color_map[9] = 24'ha792c5;
        color_map[10] = 24'h99806b;
        color_map[11] = 24'h866e5d;
        color_map[12] = 24'h756131;
        color_map[13] = 24'h6d5e2e;
        color_map[14] = 24'h5d4888;
        color_map[15] = 24'h311b58;
    end
endmodule