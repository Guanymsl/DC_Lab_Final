module player1_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hab96d0;
        color_map[2] = 24'hab96cf;
        color_map[3] = 24'haa96cf;
        color_map[4] = 24'haa96cf;
        color_map[5] = 24'ha995cf;
        color_map[6] = 24'ha894ce;
        color_map[7] = 24'ha38ec8;
        color_map[8] = 24'h6c5890;
        color_map[9] = 24'h49356d;
        color_map[10] = 24'h2f293a;
        color_map[11] = 24'h2f1754;
        color_map[12] = 24'h2a1853;
        color_map[13] = 24'h09070b;
        color_map[14] = 24'h000000;
        color_map[15] = 24'h000000;
    end
endmodule