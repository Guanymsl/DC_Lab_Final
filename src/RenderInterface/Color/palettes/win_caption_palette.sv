module win_caption_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hfefefe;
        color_map[2] = 24'hfdfdfd;
        color_map[3] = 24'hfcfcfc;
        color_map[4] = 24'hf7f7f7;
        color_map[5] = 24'hf0f0f0;
        color_map[6] = 24'he8e8e8;
        color_map[7] = 24'hdfdfdf;
        color_map[8] = 24'hcccccc;
        color_map[9] = 24'ha6a6a6;
        color_map[10] = 24'h747474;
        color_map[11] = 24'h343434;
        color_map[12] = 24'h040404;
        color_map[13] = 24'h000000;
        color_map[14] = 24'h000000;
        color_map[15] = 24'h000000;
    end
endmodule