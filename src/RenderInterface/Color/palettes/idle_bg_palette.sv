module idle_bg_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'h848884;
        color_map[2] = 24'h3e4b53;
        color_map[3] = 24'h313e49;
        color_map[4] = 24'h2b3943;
        color_map[5] = 24'h25323d;
        color_map[6] = 24'h23303b;
        color_map[7] = 24'h212e39;
        color_map[8] = 24'h1d2834;
        color_map[9] = 24'h1a2531;
        color_map[10] = 24'h17202c;
        color_map[11] = 24'h141c28;
        color_map[12] = 24'h121924;
        color_map[13] = 24'h0f151f;
        color_map[14] = 24'h0c1019;
        color_map[15] = 24'h080a12;
    end
endmodule