module map_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'h193343;
        color_map[2] = 24'h152f3f;
        color_map[3] = 24'h132a3b;
        color_map[4] = 24'h112738;
        color_map[5] = 24'h0f2334;
        color_map[6] = 24'h0e2030;
        color_map[7] = 24'h0c1e2e;
        color_map[8] = 24'h0b1b2b;
        color_map[9] = 24'h091827;
        color_map[10] = 24'h081523;
        color_map[11] = 24'h081320;
        color_map[12] = 24'h09111f;
        color_map[13] = 24'h07111f;
        color_map[14] = 24'h060e1b;
        color_map[15] = 24'h050c18;
    end
endmodule