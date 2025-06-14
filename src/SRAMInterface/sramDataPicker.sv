import game_param::*;
import sram_param::*;

module SramDataPicker (
    input [sram_param::MAP_H_WIDTH+sram_param::MAP_V_WIDTH-1:0] i_object_pixel_index,
    input [sram_param::SRAM_DATA_WIDTH-1:0] i_sram_data,
    output [sram_param::COLOR_WIDTH-1:0] o_compressed_color
);
    wire [3:0] start_index;
    assign start_index[3:0] = i_object_pixel_index[1:0] << 2;
    assign o_compressed_color = i_sram_data[start_index +: sram_param::COLOR_WIDTH];
endmodule