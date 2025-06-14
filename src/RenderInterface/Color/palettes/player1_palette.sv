module player1_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hffffff;
        color_map[2] = 24'hb79bdc;
        color_map[3] = 24'haf9ad5;
        color_map[4] = 24'hab96d0;
        color_map[5] = 24'haa95cf;
        color_map[6] = 24'ha994ce;
        color_map[7] = 24'h9883be;
        color_map[8] = 24'h8e6dab;
        color_map[9] = 24'h705e92;
        color_map[10] = 24'h513c79;
        color_map[11] = 24'h3e2359;
        color_map[12] = 24'h180a4b;
        color_map[13] = 24'h10062f;
        color_map[14] = 24'h060514;
        color_map[15] = 24'h000000;
    end
endmodule