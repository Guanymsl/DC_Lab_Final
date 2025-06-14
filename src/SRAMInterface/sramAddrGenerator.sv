import game_param::*;
import sram_param::*;

module SramAddrGenerator (
    input i_clk,
    input i_rst_n,
    input game_param::ObjectID i_object_id,
    input [sram_param::MAP_H_WIDTH+sram_param::MAP_V_WIDTH-1:0] i_object_pixel_index,
    output [sram_param::SRAM_ADDR_COUNT-1:0] o_sram_addr
);
    assign o_sram_addr = sram_addr_r;
    reg [sram_param::SRAM_ADDR_COUNT-1:0] sram_addr_r, sram_addr_w;

    always @(*) begin
        case (i_object_id)
            game_param::OBJECT_MAP            : sram_addr_w = sram_param::MAP_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_PLAYER1        : sram_addr_w = sram_param::PLAYER1_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_PLAYER1_SHIELD : sram_addr_w = sram_param::PLAYER1_SHIELD_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_PLAYER1_SQUAT  : sram_addr_w = sram_param::PLAYER1_SQUAT_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_PLAYER2        : sram_addr_w = sram_param::PLAYER2_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_PLAYER2_SHIELD : sram_addr_w = sram_param::PLAYER2_SHIELD_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_PLAYER2_SQUAT  : sram_addr_w = sram_param::PLAYER2_SQUAT_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_BULLET1        : sram_addr_w = sram_param::BULLET1_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_BULLET2        : sram_addr_w = sram_param::BULLET2_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_WIN_CAPTION    : sram_addr_w = sram_param::WIN_CAPTION_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_LOSE_CAPTION   : sram_addr_w = sram_param::LOSE_CAPTION_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_IDLE_BG        : sram_addr_w = sram_param::IDLE_BG_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_START_CAPTION  : sram_addr_w = sram_param::START_CAPTION_ADDR_START + (i_object_pixel_index >> 2);
            game_param::OBJECT_START_BG       : sram_addr_w = sram_param::START_BG_ADDR_START + (i_object_pixel_index >> 2);
        endcase
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            sram_addr_r <= 0;
        end
        else begin
            sram_addr_r <= sram_addr_w;
        end
    end
endmodule