module player1_squat_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'haa96d0;
        color_map[2] = 24'haa96cf;
        color_map[3] = 24'haa96cf;
        color_map[4] = 24'ha995ce;
        color_map[5] = 24'ha591ca;
        color_map[6] = 24'h917db6;
        color_map[7] = 24'h766299;
        color_map[8] = 24'h503d79;
        color_map[9] = 24'h453169;
        color_map[10] = 24'h2d2a45;
        color_map[11] = 24'h2c1656;
        color_map[12] = 24'h0d0c10;
        color_map[13] = 24'h000000;
        color_map[14] = 24'h000000;
        color_map[15] = 24'h000000;
    end
endmodule