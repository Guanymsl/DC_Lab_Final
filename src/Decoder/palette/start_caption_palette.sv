module start_caption_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hfefefe;
        color_map[2] = 24'hfefefe;
        color_map[3] = 24'hfcfcfc;
        color_map[4] = 24'hf8f8f8;
        color_map[5] = 24'hf0f0f0;
        color_map[6] = 24'he2e2e2;
        color_map[7] = 24'hc9c9c9;
        color_map[8] = 24'ha5a5a5;
        color_map[9] = 24'h737373;
        color_map[10] = 24'h404040;
        color_map[11] = 24'h1b1b1b;
        color_map[12] = 24'h060606;
        color_map[13] = 24'h010101;
        color_map[14] = 24'h000000;
        color_map[15] = 24'h000000;
    end
endmodule