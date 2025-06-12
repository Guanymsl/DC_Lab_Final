import game_pkg::*;
import sram_pkg::*;

module ColorDecoder (
    input game_pkg::ObjectID i_object_id,
    input [sram_pkg::COLOR_WIDTH-1:0] i_encoded_color,
    output [23:0] o_decoded_color
);
    wire [23:0] map_color [0:15];
    map_palette u_map_palette (
        .color_map    (map_color)
    );

    wire [23:0] player1_color [0:15];
    player1_palette u_player1_palette (
        .color_map    (player1_color),
    );

    wire [23:0] player1_shield_color [0:15];
    player1_shield_palette u_player1_shield_palette (
        .color_map    (player1_shield_color),
    );

    wire [23:0] player1_squat_color [0:15];
    player1_squat_palette u_player1_squat_palette (
        .color_map    (player1_squat_color),
    );

    wire [23:0] player2_color [0:15];
    player2_palette u_player2_palette (
        .color_map    (player2_color),
    );

    wire [23:0] player2_shield_color [0:15];
    player2_shield_palette u_player2_shield_palette (
        .color_map    (player2_shield_color),
    );

    wire [23:0] player2_squat_color [0:15];
    player2_squat_palette u_player2_squat_palette (
        .color_map    (player2_squat_color),
    );

    wire [23:0] bullet1_color [0:15];
    bullet1_palette u_bullet1_palette (
        .color_map    (bullet1_color),
    );  

    wire [23:0] bullet2_color [0:15];
    bullet2_palette u_bullet2_palette (
        .color_map    (bullet2_color),
    );

    wire [23:0] win_caption_color [0:15];
    win_caption_palette u_win_caption_palette (
        .color_map    (win_caption_color),
    );

    wire [23:0] lose_caption_color [0:15];
    lose_caption_palette u_lose_caption_palette (
        .color_map    (lose_caption_color),
    );

    wire [23:0] idle_bg_color [0:15];
    idle_bg_palette u_idle_bg_palette (
        .color_map    (idle_bg_color),
    );

    wire [23:0] start_caption_color [0:15];
    start_caption_palette u_start_caption_palette (
        .color_map    (start_caption_color),
    );

    wire [23:0] start_bg_color [0:15];
    start_bg_palette u_start_bg_palette (
        .color_map    (start_bg_color),
    );

    reg [23:0] decoded_color;
    assign o_decoded_color = decoded_color;

    always @(*) begin
        decoded_color = 24'hffffff;
        case(i_object_id)
            
            game_pkg::OBJECT_MAP            : decoded_color = map_color[i_encoded_color];
            game_pkg::OBJECT_PLAYER1        : decoded_color = player1_color[i_encoded_color];
            game_pkg::OBJECT_PLAYER1_SHIELD : decoded_color = player1_color[i_encoded_color];
            game_pkg::OBJECT_PLAYER1_SQUAT  : decoded_color = player1_squat_color[i_encoded_color];
            game_pkg::OBJECT_PLAYER2        : decoded_color = player2_color[i_encoded_color];
            game_pkg::OBJECT_PLAYER2_SHIELD : decoded_color = player2_shield_color[i_encoded_color];
            game_pkg::OBJECT_PLAYER2_SQUAT  : decoded_color = player2_squat_color[i_encoded_color];
            game_pkg::OBJECT_BULLET1        : decoded_color = bullet1_color[i_encoded_color];
            game_pkg::OBJECT_BULLET2        : decoded_color = bullet2_color[i_encoded_color];
            game_pkg::OBJECT_WIN_CAPTION    : decoded_color = win_caption_color[i_encoded_color];
            game_pkg::OBJECT_LOSE_CAPTION   : decoded_color = lose_caption_color[i_encoded_color];
            game_pkg::OBJECT_IDLE_BG        : decoded_color = idle_bg_color[i_encoded_color];
            game_pkg::OBJECT_START_CAPTION  : decoded_color = start_caption_color[i_encoded_color];
            game_pkg::OBJECT_START_BG       : decoded_color = start_bg_color[i_encoded_color];
            
        endcase
    end
endmodule
