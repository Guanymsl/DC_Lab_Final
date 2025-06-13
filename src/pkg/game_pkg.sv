package game_pkg;
    import sram_pkg::*;
    localparam int STEP_X = 6;

    localparam int BULLET_STEP_X = 12;

    localparam int V = 20;
    localparam int MAX_J = 4 * V;

    localparam int LIMIT_X = VGA_H * 3 / 8;

    localparam int OBJECT_OPACITY_NUM = 2; // no map and bar and ?blocks
    localparam int OBJECT_OPACITY_NUM_WIDTH = 2;

    localparam int HP_WIDTH = 3;

    typedef enum logic [3:0] {
        OBJECT_MAP  = 4'd0,
        OBJECT_PLAYER1  = 4'd1,
        OBJECT_PLAYER1_SHIELD = 4'd2,
        OBJECT_PLAYER1_SQUAT = 4'd3,
        OBJECT_PLAYER2 = 4'd4,
        OBJECT_PLAYER2_SHIELD = 4'd5,
        OBJECT_PLAYER2_SQUAT = 4'd6,
        OBJECT_BULLET1 = 4'd7,
        OBJECT_BULLET2 = 4'd8,
        OBJECT_WIN_CAPTION = 4'd9,
        OBJECT_LOSE_CAPTION = 4'd10,
        OBJECT_IDLE_BG = 4'd11,
        OBJECT_START_CAPTION = 4'd12,
        OBJECT_START_BG = 4'd13
    } ObjectID;

    /*
    localparam int CAR1_INIT_X = -500;
    localparam int CAR1_INIT_Y = -250 - (sram_pkg::CAR_SIZE>>1) - 10;
    localparam int CAR2_INIT_X = -500;
    localparam int CAR2_INIT_Y = -365 + (sram_pkg::CAR_SIZE>>1) + 10;
    */

    localparam int START_CAPTION_H_POS_MIN = 470;
    localparam int START_CAPTION_H_POS_MAX = START_CAPTION_H_POS_MIN + sram_pkg::START_CAPTION_H - 1;
    localparam int START_CAPTION_V_POS_MIN = 569;
    localparam int START_CAPTION_V_POS_MAX = START_CAPTION_V_POS_MIN + sram_pkg::START_CAPTION_V - 1;

    localparam int WIN_CAPTION_H_POS_MIN = 470;
    localparam int WIN_CAPTION_H_POS_MAX = WIN_CAPTION_H_POS_MIN + sram_pkg::WIN_LOSE_CAPTION_H - 1;
    localparam int LOSE_CAPTION_H_POS_MIN = 470;
    localparam int LOSE_CAPTION_H_POS_MAX = LOSE_CAPTION_H_POS_MIN + sram_pkg::WIN_LOSE_CAPTION_H - 1;
    localparam int WIN_LOSE_CAPTION_V_POS_MIN = 569;
    localparam int WIN_LOSE_CAPTION_V_POS_MAX = WIN_LOSE_CAPTION_V_POS_MIN + sram_pkg::WIN_LOSE_CAPTION_V - 1;

endpackage

