import game_pkg::*;
import sram_pkg::*;

module PixelDecoder (
    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_player1_x,
    input signed [sram_pkg::MAP_V_WIDTH-1:0] i_player1_y,
    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_player2_x,
    input signed [sram_pkg::MAP_V_WIDTH-1:0] i_player2_y,

    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet1_x,
    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet1_y,
    input i_bullet1_valid,

    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet2_x,
    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_bullet2_y,
    input i_bullet2_valid,

    input i_player1_opacity_mask [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1],
    input i_player2_opacity_mask [0:sram_pkg::PLAYER_SIZE-1][0:sram_pkg::PLAYER_SIZE-1],
    input i_bullet1_opacity_mask [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1],
    input i_bullet2_opacity_mask [0:sram_pkg::BULLET_SIZE-1][0:sram_pkg::BULLET_SIZE-1],

    input [sram_pkg::MAP_H_WIDTH-1:0] i_VGA_H, 
    input [sram_pkg::MAP_V_WIDTH-1:0] i_VGA_V, 

    input [game_pkg::HP_WIDTH-1:0] i_player1_hp,
    input i_player1_shield,
    input i_player1_squat,

    input [game_pkg::HP_WIDTH-1:0] i_player2_hp,
    input i_player2_shield,
    input i_player2_squat,

    // game status
    input i_is_gaming,
    input [1:0] i_game_state // output state

    output game_pkg::ObjectID o_object_id,
    output reg [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] o_object_pixel_index
);  
    wire IDLE,WIN,LOSE;
    assign IDLE = (i_game_state == 2'b00);
    assign WIN = (i_game_state == 2'b10);
    assign LOSE = (i_game_state == 2'b11);

    /*---------------------------------------------------- map render ----------------------------------------------------*/
    wire [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] render_map_index;
    assign render_map_index = (i_VGA_V - 1) * sram_pkg::MAP_H + i_VGA_H - 1;

    /*------------------------------------------------------ player render ------------------------------------------------------*/
    wire [sram_pkg::MAP_H_WIDTH-1:0] player1_H_min, player1_H_max;
    wire [sram_pkg::MAP_V_WIDTH-1:0] player1_V_min, player1_V_max;
    XYtoBoundaries_Player xy_2_hv_player1 (
        .i_x        (i_player1_x),
        .i_y        (i_player1_y),
        .o_H_min    (player1_H_min),
        .o_H_max    (player1_H_max),
        .o_V_min    (player1_V_min),
        .o_V_max    (player1_V_max)
    );

    wire [sram_pkg::MAP_H_WIDTH-1:0] player2_H_min, player2_H_max;
    wire [sram_pkg::MAP_V_WIDTH-1:0] player2_V_min, player2_V_max;
    XYtoBoundaries_Player xy_2_hv_player2 (
        .i_x        (i_player2_x),
        .i_y        (i_player2_y),
        .o_H_min    (player2_H_min),
        .o_H_max    (player2_H_max),
        .o_V_min    (player2_V_min),
        .o_V_max    (player2_V_max)
    );

    wire render_player1, render_player2;
    assign render_player1 = i_VGA_H >= player1_H_min
                        & i_VGA_H <= player1_H_max
                        & i_VGA_V >= player1_V_min
                        & i_VGA_V <= player1_V_max;
    assign render_player2 = i_VGA_H >= player2_H_min 
                        & i_VGA_H <= player2_H_max
                        & i_VGA_V >= player2_V_min 
                        & i_VGA_V <= player2_V_max;

    wire [sram_pkg::MAP_H_WIDTH-1:0] player1_rel_H, player2_rel_H;
    wire [sram_pkg::MAP_V_WIDTH-1:0] player1_rel_V, player2_rel_V;
    assign player1_rel_H = i_VGA_H - player1_H_min;
    assign player1_rel_V = i_VGA_V - player1_V_min;
    assign player2_rel_H = i_VGA_H - player2_H_min;
    assign player2_rel_V = i_VGA_V - player2_V_min;

    wire [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] render_player1_index, render_player2_index;
    assign render_player1_index = player1_rel_V * sram_pkg::PLAYER_SIZE + player1_rel_H;
    assign render_player2_index = player2_rel_V * sram_pkg::PLAYER_SIZE + player2_rel_H;

    /*------------------------------------------------------ bullet render ------------------------------------------------------*/
    wire [sram_pkg::MAP_H_WIDTH-1:0] bullet1_H_min, bullet1_H_max;
    wire [sram_pkg::MAP_V_WIDTH-1:0] bullet1_V_min, bullet1_V_max;
    XYtoBoundaries_Bullet xy_2_hv_bullet1 (
        .i_x        (i_bullet1_x),
        .i_y        (i_bullet1_y),
        .o_H_min    (bullet1_H_min),
        .o_H_max    (bullet1_H_max),
        .o_V_min    (bullet1_V_min),
        .o_V_max    (bullet1_V_max)
    );

    wire [sram_pkg::MAP_H_WIDTH-1:0] bullet2_H_min, bullet2_H_max;
    wire [sram_pkg::MAP_V_WIDTH-1:0] bullet2_V_min, bullet2_V_max;
    XYtoBoundaries_Bullet xy_2_hv_player2 (
        .i_x        (i_bullet2_x),
        .i_y        (i_bullet2_y),
        .o_H_min    (bullet2_H_min),
        .o_H_max    (bullet2_H_max),
        .o_V_min    (bullet2_V_min),
        .o_V_max    (bullet2_V_max)
    );

    wire render_bullet1, render_bullet2;
    assign render_bullet1 = (i_bullet1_valid)
                        & i_VGA_H >= bullet1_H_min
                        & i_VGA_H <= bullet1_H_max
                        & i_VGA_V >= bullet1_V_min
                        & i_VGA_V <= bullet1_V_max;
    assign render_bullet2 = (i_bullet2_valid)
                        & i_VGA_H >= bullet2_H_min 
                        & i_VGA_H <= bullet2_H_max
                        & i_VGA_V >= bullet2_V_min 
                        & i_VGA_V <= bullet2_V_max;

    wire [sram_pkg::MAP_H_WIDTH-1:0] bullet1_rel_H, bullet2_rel_H;
    wire [sram_pkg::MAP_V_WIDTH-1:0] bullet1_rel_V, bullet2_rel_V;
    assign bullet1_rel_H = i_VGA_H - bullet1_H_min;
    assign bullet1_rel_V = i_VGA_V - bullet1_V_min;
    assign bullet2_rel_H = i_VGA_H - bullet2_H_min;
    assign bullet2_rel_V = i_VGA_V - bullet2_V_min;

    wire [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] render_bullet1_index, render_bullet2_index;
    assign render_bullet1_index = bullet1_rel_V * sram_pkg::BULLET_SIZE + bullet1_rel_H;
    assign render_bullet2_index = bullet2_rel_V * sram_pkg::BULLET_SIZE + bullet2_rel_H;

    /*----------------------------------------------------- HP render -----------------------------------------------------*/
    /*
    wire render_car1_level, render_car2_level;
    wire [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] render_car1_level_index, render_car2_level_index;
    SingleDigitDisplayDecoder u_SingleDigitDisplayDecoder_car1_level (
        .i_value                 (i_car1_mass_level),
        .i_H_render              (i_VGA_H),
        .i_V_render              (i_VGA_V),
        .i_H_POS_MIN             (game_pkg::CAR1_LEVEL_DISPLAY_H_POS_MIN),
        .i_H_POS_MAX             (game_pkg::CAR1_LEVEL_DISPLAY_H_POS_MAX),
        .i_V_POS_MIN             (game_pkg::VELOCITY_DISPLAY_V_POS_MIN),
        .i_V_POS_MAX             (game_pkg::VELOCITY_DISPLAY_V_POS_MAX),
        .o_render                (render_car1_level),
        .o_object_pixel_index    (render_car1_level_index)
    );

    SingleDigitDisplayDecoder u_SingleDigitDisplayDecoder_car2_level (
        .i_value                 (i_car2_mass_level),
        .i_H_render              (i_VGA_H),
        .i_V_render              (i_VGA_V),
        .i_H_POS_MIN             (game_pkg::CAR2_LEVEL_DISPLAY_H_POS_MIN),
        .i_H_POS_MAX             (game_pkg::CAR2_LEVEL_DISPLAY_H_POS_MAX),
        .i_V_POS_MIN             (game_pkg::VELOCITY_DISPLAY_V_POS_MIN),
        .i_V_POS_MAX             (game_pkg::VELOCITY_DISPLAY_V_POS_MAX),
        .o_render                (render_car2_level),
        .o_object_pixel_index    (render_car2_level_index)
    );
    */
    /*------------------------------------------------- start caption render -------------------------------------------------*/
    wire render_start_caption;
    wire [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] render_start_caption_index;
    assign render_start_caption = (IDLE)
                                & i_VGA_H >= game_pkg::START_CAPTION_H_POS_MIN 
                                & i_VGA_H <= game_pkg::START_CAPTION_H_POS_MAX 
                                & i_VGA_V >= game_pkg::START_CAPTION_V_POS_MIN 
                                & i_VGA_V <= game_pkg::START_CAPTION_V_POS_MAX;
    assign render_start_caption_index = (i_VGA_V - game_pkg::START_CAPTION_V_POS_MIN) * sram_pkg::START_CAPTION_H + i_VGA_H - game_pkg::START_CAPTION_H_POS_MIN;

    /*-------------------------------------------------- win/lose caption render --------------------------------------------------*/
    wire render_win_caption, render_lose_caption;
    wire [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] render_win_caption_index, render_lose_caption_index;
    assign render_win_caption = (WIN)
                                & i_VGA_H >= game_pkg::WIN_CAPTION_H_POS_MIN
                                & i_VGA_H <= game_pkg::WIN_CAPTION_H_POS_MAX
                                & i_VGA_V >= game_pkg::WIN_CAPTION_V_POS_MIN
                                & i_VGA_V <= game_pkg::WIN_CAPTION_V_POS_MAX;
    assign render_loss_caption = (LOSE)
                                & i_VGA_H >= game_pkg::LOSE_CAPTION_H_POS_MIN
                                & i_VGA_H <= game_pkg::LOSE_CAPTION_H_POS_MAX
                                & i_VGA_V >= game_pkg::LOSE_CAPTION_V_POS_MIN
                                & i_VGA_V <= game_pkg::LOSE_CAPTION_V_POS_MAX;
    assign render_win_caption_index = (i_VGA_V - game_pkg::WIN_LOSE_CAPTION_V_POS_MIN) * sram_pkg::WIN_LOSE_CAPTION_H + i_VGA_H - game_pkg::WIN_CAPTION_H_POS_MIN;
    assign render_lose_caption_index = (i_VGA_V - game_pkg::WIN_LOSE_CAPTION_V_POS_MIN) * sram_pkg::WIN_LOSE_CAPTION_H + i_VGA_H - game_pkg::LOSE_CAPTION_H_POS_MIN;

    /*----------------------------------------------------- render logic -----------------------------------------------------*/
    always @(*) begin
        if (i_is_gaming) begin
            if (i_VGA_V <= sram_pkg::MAP_V) begin
                if (render_player1) begin
                    if (i_player1_opacity_mask[player1_rel_V][player1_rel_H]) begin
                        o_object_id = game_pkg::OBJECT_PLAYER1;
                        o_object_pixel_index = render_player1_index;
                    end
                    else if (i_player1_shield) begin
                        o_object_id = game_pkg::OBJECT_PLAYER1_SHIELD;
                        o_object_pixel_index = render_player1_index;
                    end
                    else if (i_player1_squat) begin
                        o_object_id = game_pkg::OBJECT_PLAYER1_SQUAT;
                        o_object_pixel_index = render_player1_index;
                    end

                    else begin
                        o_object_id = game_pkg::OBJECT_MAP;
                        o_object_pixel_index = render_map_index; 
                    end
                end
                else if (render_player2) begin
                    if (i_player2_opacity_mask[player2_rel_V][player2_rel_H]) begin
                        o_object_id = game_pkg::OBJECT_PLAYER2;
                        o_object_pixel_index = render_player2_index
                    end
                    else if (i_player2_shield) begin
                        o_object_id = game_pkg::OBJECT_PLAYER2_SHIELD;
                        o_object_pixel_index = render_player2_index;
                    end
                    else if (i_player2_squat) begin
                        o_object_id = game_pkg::OBJECT_PLAYER2_SQUAT;
                        o_object_pixel_index = render_player2_index;
                    end

                    else begin
                        o_object_id = game_pkg::OBJECT_MAP;
                        o_object_pixel_index = render_map_index; 
                    end
                end
                else if (render_bullet1) begin
                    if (i_bullet1_opacity_mask[bullet1_rel_V][bullet1_rel_H]) begin
                        o_object_id = game_pkg::OBJECT_BULLET1;
                        o_object_pixel_index = render_bullet1_index;
                    end
                    else begin
                        o_object_id = game_pkg::OBJECT_MAP;
                        o_object_pixel_index = render_map_index; 
                    end
                end

                else if (render_bullet2) begin
                    if (i_bullet2_opacity_mask[bullet2_rel_V][bullet2_rel_H]) begin
                        o_object_id = game_pkg::OBJECT_BULLET2;
                        o_object_pixel_index = render_bullet2_index;
                    end
                    else begin
                        o_object_id = game_pkg::OBJECT_MAP;
                        o_object_pixel_index = render_map_index; 
                    end
                end

                else begin
                    o_object_id = game_pkg::OBJECT_MAP;
                    o_object_pixel_index = render_map_index; 
                end
            end
        end

        else begin
            if (WIN) begin
                if (render_win_caption) begin
                    o_object_id = game_pkg::OBJECT_WIN_CAPTION;
                    o_object_pixel_index = render_win_caption_index; 
                end
                else begin
                    o_object_id = game_pkg::OBJECT_IDLE_BG;
                    o_object_pixel_index = render_map_index; 
                end
            end

            else if (LOSE) begin
                if (render_loss_caption) begin
                    o_object_id = game_pkg::OBJECT_LOSE_CAPTION;
                    o_object_pixel_index = render_lose_caption_index; 
                end
                else begin
                    o_object_id = game_pkg::OBJECT_IDLE_BG;
                    o_object_pixel_index = render_map_index; 
                end
            end

            else begin
                if (render_start_caption) begin
                    o_object_id = game_pkg::OBJECT_START_CAPTION;
                    o_object_pixel_index = render_start_caption_index; 
                end
                else begin
                    o_object_id = game_pkg::OBJECT_START_BG;
                    o_object_pixel_index = render_map_index; 
                end
            end
        end
    end
endmodule


module XYtoBoundaries_Player (
    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_x,
    input signed [sram_pkg::MAP_V_WIDTH-1:0] i_y,
    output [sram_pkg::MAP_H_WIDTH-1:0] o_H_min,
    output [sram_pkg::MAP_H_WIDTH-1:0] o_H_max,
    output [sram_pkg::MAP_V_WIDTH-1:0] o_V_min,
    output [sram_pkg::MAP_V_WIDTH-1:0] o_V_max
);

    assign o_H_min = i_x + ((sram_pkg::MAP_H - sram_pkg::PLAYER_SIZE) >> 1) + 1;
    assign o_H_max = i_x + ((sram_pkg::MAP_H + sram_pkg::PLAYER_SIZE) >> 1);
    assign o_V_min = -i_y + ((sram_pkg::MAP_V - sram_pkg::PLAYER_SIZE) >> 1) + 1;
    assign o_V_max = -i_y + ((sram_pkg::MAP_V + sram_pkg::PLAYER_SIZE) >> 1);
endmodule

module XYtoBoundaries_Bullet (
    input signed [sram_pkg::MAP_H_WIDTH-1:0] i_x,
    input signed [sram_pkg::MAP_V_WIDTH-1:0] i_y,
    output [sram_pkg::MAP_H_WIDTH-1:0] o_H_min,
    output [sram_pkg::MAP_H_WIDTH-1:0] o_H_max,
    output [sram_pkg::MAP_V_WIDTH-1:0] o_V_min,
    output [sram_pkg::MAP_V_WIDTH-1:0] o_V_max
);

    assign o_H_min = i_x + ((sram_pkg::MAP_H - sram_pkg::BULLET_SIZE) >> 1) + 1;
    assign o_H_max = i_x + ((sram_pkg::MAP_H + sram_pkg::BULLET_SIZE) >> 1);
    assign o_V_min = -i_y + ((sram_pkg::MAP_V - sram_pkg::BULLET_SIZE) >> 1) + 1;
    assign o_V_max = -i_y + ((sram_pkg::MAP_V + sram_pkg::BULLET_SIZE) >> 1);
endmodule






/*

module SingleDigitDisplayDecoder (
    input [game_pkg::SINGLE_DIGIT_WIDTH-1:0] i_value,
    input [sram_pkg::MAP_H_WIDTH-1:0] i_H_render,
    input [sram_pkg::MAP_V_WIDTH-1:0] i_V_render,

    input [sram_pkg::MAP_H_WIDTH-1:0] i_H_POS_MIN,
    input [sram_pkg::MAP_H_WIDTH-1:0] i_H_POS_MAX,

    input [sram_pkg::MAP_V_WIDTH-1:0] i_V_POS_MIN,
    input [sram_pkg::MAP_V_WIDTH-1:0] i_V_POS_MAX,

    output o_render,
    output [sram_pkg::MAP_H_WIDTH+sram_pkg::MAP_V_WIDTH-1:0] o_object_pixel_index
);
    assign render = i_H_render >= i_H_POS_MIN
                    & i_H_render <= i_H_POS_MAX
                    & i_V_render >= i_V_POS_MIN
                    & i_V_render <= i_V_POS_MAX;
    assign o_render = render;

    always @(*) begin
        if (render) begin
            o_object_pixel_index = (i_V_render - i_V_POS_MIN + i_value * sram_pkg::BAR_DIGIT_V) * sram_pkg::BAR_DIGIT_H + (i_H_render - i_H_POS_MIN);
        end
        else begin
            o_object_pixel_index = 0; // not important, just set to 0
        end
    end
endmodule

*/