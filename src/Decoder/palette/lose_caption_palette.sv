module lose_caption_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hfefefe;
        color_map[2] = 24'hfefefe;
        color_map[3] = 24'hfcfcfc;
        color_map[4] = 24'hfbfbfb;
        color_map[5] = 24'hf2f2f2;
        color_map[6] = 24'hd8d8d8;
        color_map[7] = 24'hbbbbbb;
        color_map[8] = 24'h8b8b8b;
        color_map[9] = 24'h4c4c4c;
        color_map[10] = 24'h151515;
        color_map[11] = 24'h040404;
        color_map[12] = 24'h000000;
        color_map[13] = 24'h000000;
        color_map[14] = 24'h000000;
        color_map[15] = 24'h000000;
    end
endmodule