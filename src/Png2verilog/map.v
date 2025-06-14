module map_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hf6cd47;
        color_map[2] = 24'hec8039;
        color_map[3] = 24'hed5d1a;
        color_map[4] = 24'hf03c13;
        color_map[5] = 24'hd03e23;
        color_map[6] = 24'hf20f03;
        color_map[7] = 24'hac2417;
        color_map[8] = 24'hc80b05;
        color_map[9] = 24'h980604;
        color_map[10] = 24'h760304;
        color_map[11] = 24'h590203;
        color_map[12] = 24'h3f0102;
        color_map[13] = 24'h270001;
        color_map[14] = 24'h150000;
        color_map[15] = 24'h030000;
    end
endmodule