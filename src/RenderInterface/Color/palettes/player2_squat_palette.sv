module player2_squat_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hffff00;
        color_map[2] = 24'h7efe7e;
        color_map[3] = 24'h90f545;
        color_map[4] = 24'h7efe00;
        color_map[5] = 24'h86e740;
        color_map[6] = 24'h81e13e;
        color_map[7] = 24'h93bf68;
        color_map[8] = 24'h6ec83d;
        color_map[9] = 24'h00ff00;
        color_map[10] = 24'hcf62e4;
        color_map[11] = 24'hab7cb5;
        color_map[12] = 24'he24efd;
        color_map[13] = 24'h779b77;
        color_map[14] = 24'h5aaf46;
        color_map[15] = 24'h7f7f00;
    end
endmodule