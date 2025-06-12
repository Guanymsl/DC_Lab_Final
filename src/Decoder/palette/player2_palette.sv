module player2_palette(output reg [23:0] color_map [0:15]);
    initial begin
        color_map[0] = 24'h000000; // Transparent
        color_map[1] = 24'hacf52a;
        color_map[2] = 24'h82eb4a;
        color_map[3] = 24'h83e23e;
        color_map[4] = 24'h83e13f;
        color_map[5] = 24'h82e13f;
        color_map[6] = 24'h81e03e;
        color_map[7] = 24'h7ddb3f;
        color_map[8] = 24'h78cb49;
        color_map[9] = 24'h63c045;
        color_map[10] = 24'haf7aba;
        color_map[11] = 24'hdf52ff;
        color_map[12] = 24'hde52fe;
        color_map[13] = 24'hd757f5;
        color_map[14] = 24'h49b245;
        color_map[15] = 24'h478438;
    end
endmodule