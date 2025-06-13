module player1_squat_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hffffff;
        color_map[2] = 24'hbaa2e5;
        color_map[3] = 24'hb39dda;
        color_map[4] = 24'had97d2;
        color_map[5] = 24'haa95cf;
        color_map[6] = 24'ha993cc;
        color_map[7] = 24'h9883bd;
        color_map[8] = 24'h8976b0;
        color_map[9] = 24'h766497;
        color_map[10] = 24'h52449b;
        color_map[11] = 24'h514666;
        color_map[12] = 24'h7e007e;
        color_map[13] = 24'h2d154b;
        color_map[14] = 24'h100a20;
        color_map[15] = 24'h000001;
    end
endmodule