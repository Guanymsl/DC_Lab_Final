module player2_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hfefe00;
        color_map[2] = 24'haafe55;
        color_map[3] = 24'h7fff7f;
        color_map[4] = 24'h8aef42;
        color_map[5] = 24'h7efe00;
        color_map[6] = 24'h83e23e;
        color_map[7] = 24'h80df3e;
        color_map[8] = 24'h7fbf46;
        color_map[9] = 24'h6bc740;
        color_map[10] = 24'h96a275;
        color_map[11] = 24'h00fe00;
        color_map[12] = 24'hb877c3;
        color_map[13] = 24'hdf51fd;
        color_map[14] = 24'h51af45;
        color_map[15] = 24'h416f2c;
    end
endmodule