module player1_shield_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hf9e746;
        color_map[2] = 24'hcfc2da;
        color_map[3] = 24'hceb4a6;
        color_map[4] = 24'hccb1a2;
        color_map[5] = 24'hc5aeb9;
        color_map[6] = 24'hc6aca0;
        color_map[7] = 24'he79681;
        color_map[8] = 24'hab94cf;
        color_map[9] = 24'hb49a84;
        color_map[10] = 24'ha08661;
        color_map[11] = 24'h7a6a8e;
        color_map[12] = 24'h705d30;
        color_map[13] = 24'h4b3376;
        color_map[14] = 24'h170950;
        color_map[15] = 24'h000008;
    end
endmodule