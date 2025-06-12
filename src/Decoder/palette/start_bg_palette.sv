module start_bg_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'h899c92;
        color_map[2] = 24'h66817d;
        color_map[3] = 24'h4e6e6e;
        color_map[4] = 24'h375a61;
        color_map[5] = 24'h2e515a;
        color_map[6] = 24'h294953;
        color_map[7] = 24'h24424c;
        color_map[8] = 24'h203c46;
        color_map[9] = 24'h1c3640;
        color_map[10] = 24'h19313a;
        color_map[11] = 24'h172c34;
        color_map[12] = 24'h14262d;
        color_map[13] = 24'h111f25;
        color_map[14] = 24'h0e181c;
        color_map[15] = 24'h0a1112;
    end
endmodule