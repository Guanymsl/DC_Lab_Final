module player2_shield_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hfefe00;
        color_map[2] = 24'h90f64f;
        color_map[3] = 24'h7de13d;
        color_map[4] = 24'ha5b13c;
        color_map[5] = 24'hff7f00;
        color_map[6] = 24'hc48239;
        color_map[7] = 24'hc67d37;
        color_map[8] = 24'hd1625d;
        color_map[9] = 24'he64e7e;
        color_map[10] = 24'hb46e3a;
        color_map[11] = 24'he94d35;
        color_map[12] = 24'hed412d;
        color_map[13] = 24'hf12a0f;
        color_map[14] = 24'h814921;
        color_map[15] = 24'hfe0000;
    end
endmodule