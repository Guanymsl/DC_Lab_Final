package sram_param;
    localparam int MAP_X = VGA_H / 2;
    localparam int MAP_Y = VGA_V / 2;

    localparam int PLAYER_X = PLAYER_SIZE / 2;
    localparam int PLAYER_Y = PLAYER_SIZE / 2;
    localparam int SQUAT_PLAYER_Y = PLAYER_SIZE * 0.15;

    localparam int BULLET_X = BULLET_SIZE / 2;
    localparam int BULLET_Y = BULLET_SIZE / 4;

    // Display
    localparam int VGA_H = 1600;
    localparam int VGA_V = 900;
    localparam int VGA_FRAME_RATE = 60;

    // Image
    localparam int COLOR_WIDTH = 4;
    localparam int PLAYER_SIZE = 50;
    localparam int BULLET_SIZE = 25;

    // Map
    localparam int MAP_H = VGA_H;
    localparam int MAP_V = 900;
    localparam int MAP_H_WIDTH = 11;
    localparam int MAP_V_WIDTH = 10;

    // Start caption
    localparam int START_CAPTION_H = 664;
    localparam int START_CAPTION_V = 56;

    // Win/Lose caption
    localparam int WIN_LOSE_CAPTION_H = 200;
    localparam int WIN_LOSE_CAPTION_V = 60;

    // SRAM 總大小
    localparam int SRAM_ADDR_COUNT = 20;
    localparam int SRAM_TOTAL_ADDR = 2**SRAM_ADDR_COUNT; // 總共 1M 地址
    localparam int SRAM_DATA_WIDTH = 16;   // 每地址 16 bit

    // 每像素的位寬
    localparam int PIXEL_WIDTH_WIDTH = 4;

    // 每地址存的像素數量
    localparam int PIXELS_PER_ADDR = SRAM_DATA_WIDTH / PIXEL_WIDTH_WIDTH;

    // 地圖區域
    localparam int MAP_PIXEL_COUNT = MAP_H * MAP_V;
    localparam int MAP_ADDR_COUNT  = MAP_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int MAP_ADDR_START  = 20'h00000;
    localparam int MAP_ADDR_END    = MAP_ADDR_START + MAP_ADDR_COUNT - 1;

    // Player1 區域
    localparam int PLAYER1_PIXEL_COUNT = PLAYER_SIZE * PLAYER_SIZE;
    localparam int PLAYER1_ADDR_COUNT  = PLAYER1_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int PLAYER1_ADDR_START  = MAP_ADDR_END + 1;
    localparam int PLAYER1_ADDR_END    = PLAYER1_ADDR_START + PLAYER1_ADDR_COUNT - 1;

    // Player1 shield 區域
    localparam int PLAYER1_SHIELD_PIXEL_COUNT = PLAYER_SIZE * PLAYER_SIZE;
    localparam int PLAYER1_SHIELD_ADDR_COUNT  = PLAYER1_SHIELD_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int PLAYER1_SHIELD_ADDR_START  = PLAYER1_ADDR_END + 1;
    localparam int PLAYER1_SHIELD_ADDR_END    = PLAYER1_SHIELD_ADDR_START + PLAYER1_SHIELD_ADDR_COUNT - 1;

    // Player1 squat 區域
    localparam int PLAYER1_SQUAT_PIXEL_COUNT = PLAYER_SIZE * PLAYER_SIZE;
    localparam int PLAYER1_SQUAT_ADDR_COUNT  = PLAYER1_SQUAT_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int PLAYER1_SQUAT_ADDR_START  = PLAYER1_SHIELD_ADDR_END + 1;
    localparam int PLAYER1_SQUAT_ADDR_END    = PLAYER1_SQUAT_ADDR_START + PLAYER1_SQUAT_ADDR_COUNT - 1;

    // Player2 區域
    localparam int PLAYER2_PIXEL_COUNT = PLAYER_SIZE * PLAYER_SIZE;
    localparam int PLAYER2_ADDR_COUNT  = PLAYER2_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int PLAYER2_ADDR_START  = PLAYER1_SQUAT_ADDR_END + 1;
    localparam int PLAYER2_ADDR_END    = PLAYER2_ADDR_START + PLAYER2_ADDR_COUNT - 1;

    // Player2 shield 區域
    localparam int PLAYER2_SHIELD_PIXEL_COUNT = PLAYER_SIZE * PLAYER_SIZE;
    localparam int PLAYER2_SHIELD_ADDR_COUNT  = PLAYER2_SHIELD_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int PLAYER2_SHIELD_ADDR_START  = PLAYER2_ADDR_END + 1;
    localparam int PLAYER2_SHIELD_ADDR_END    = PLAYER2_SHIELD_ADDR_START + PLAYER2_SHIELD_ADDR_COUNT - 1;

    // Player2 squat 區域
    localparam int PLAYER2_SQUAT_PIXEL_COUNT = PLAYER_SIZE * PLAYER_SIZE;
    localparam int PLAYER2_SQUAT_ADDR_COUNT  = PLAYER2_SQUAT_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int PLAYER2_SQUAT_ADDR_START  = PLAYER2_SHIELD_ADDR_END + 1;
    localparam int PLAYER2_SQUAT_ADDR_END    = PLAYER2_SQUAT_ADDR_START + PLAYER2_SQUAT_ADDR_COUNT - 1;

    // Bullet1 區域
    localparam int BULLET1_PIXEL_COUNT = BULLET_SIZE * BULLET_SIZE;
    localparam int BULLET1_ADDR_COUNT  = BULLET1_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int BULLET1_ADDR_START  = PLAYER2_SQUAT_ADDR_END + 1;
    localparam int BULLET1_ADDR_END    = BULLET1_ADDR_START + BULLET1_ADDR_COUNT - 1;

    // Bullet2 區域
    localparam int BULLET2_PIXEL_COUNT = BULLET_SIZE * BULLET_SIZE;
    localparam int BULLET2_ADDR_COUNT  = BULLET2_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int BULLET2_ADDR_START  = BULLET1_ADDR_END + 1;
    localparam int BULLET2_ADDR_END    = BULLET2_ADDR_START + BULLET2_ADDR_COUNT - 1;

    // Win caption 區域
    localparam int WIN_CAPTION_PIXEL_COUNT = WIN_LOSE_CAPTION_H * WIN_LOSE_CAPTION_V;
    localparam int WIN_CAPTION_ADDR_COUNT  = WIN_CAPTION_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int WIN_CAPTION_ADDR_START  = BULLET2_ADDR_END + 1;
    localparam int WIN_CAPTION_ADDR_END    = WIN_CAPTION_ADDR_START + WIN_CAPTION_ADDR_COUNT - 1;

    // Lose caption 區域
    localparam int LOSE_CAPTION_PIXEL_COUNT = WIN_LOSE_CAPTION_H * WIN_LOSE_CAPTION_V;
    localparam int LOSE_CAPTION_ADDR_COUNT  = LOSE_CAPTION_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int LOSE_CAPTION_ADDR_START  = WIN_CAPTION_ADDR_END + 1;
    localparam int LOSE_CAPTION_ADDR_END    = LOSE_CAPTION_ADDR_START + LOSE_CAPTION_ADDR_COUNT - 1;

    // Idle background 區域
    localparam int IDLE_BG_PIXEL_COUNT = VGA_H * VGA_V;
    localparam int IDLE_BG_ADDR_COUNT  = IDLE_BG_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int IDLE_BG_ADDR_START  = LOSE_CAPTION_ADDR_END + 1;
    localparam int IDLE_BG_ADDR_END    = IDLE_BG_ADDR_START + IDLE_BG_ADDR_COUNT - 1;

    // Start caption 區域
    localparam int START_CAPTION_PIXEL_COUNT = START_CAPTION_H * START_CAPTION_V;
    localparam int START_CAPTION_ADDR_COUNT  = START_CAPTION_PIXEL_COUNT / PIXELS_PER_ADDR;
    localparam int START_CAPTION_ADDR_START  = IDLE_BG_ADDR_END + 1;
    localparam int START_CAPTION_ADDR_END    = START_CAPTION_ADDR_START + START_CAPTION_ADDR_COUNT - 1;

    // Start background 區域
    localparam int START_BG_PIXEL_COUNT = IDLE_BG_PIXEL_COUNT;
    localparam int START_BG_ADDR_COUNT  = IDLE_BG_ADDR_COUNT;
    localparam int START_BG_ADDR_START  = IDLE_BG_ADDR_START;
    localparam int START_BG_ADDR_END    = IDLE_BG_ADDR_END;
endpackage