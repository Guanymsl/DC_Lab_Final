import game_pkg::*;
import sram_pkg::*;

module top (
    input i_clk,
    input i_rst_n,
    input i_start,
    input i_restart,

    // reserved for our GPIO inputs //
    input i_

    // SRAM interface
    output [sram_pkg::SRAM_ADDR_COUNT-1:0] o_SRAM_ADDR,
	inout  [sram_pkg::SRAM_DATA_WIDTH-1:0] io_SRAM_DQ,
	output o_SRAM_WE_N,

    // VGA interface
    output o_H_sync,
    output o_V_sync,
    output [23:0] o_RGB,
    output o_RGB_valid,
);

    wire render_clk;

    //// SRAM part, maybe don't have to change
    wire sram_writing;
    wire [23:0] decoded_color; // send to VGA cell

    reg [sram_pkg::SRAM_ADDR_COUNT-1:0] addr_encode, addr_decode;
    reg [sram_pkg::SRAM_DATA_WIDTH-1:0] data_encode, data_decode;

    assign o_SRAM_WE_N = !sram_writing;
    assign o_SRAM_ADDR = sram_writing ? addr_encode : addr_decode;
    assign io_SRAM_DQ  = sram_writing ? data_encode : 16'dz;
    assign data_decode = sram_writing ? 16'd0 : io_SRAM_DQ;
    
    /////

    //wire signed [game_pkg::ANG_WIDTH-1:0] car1_angle, car2_angle;

    wire signed [sram_pkg::MAP_H_WIDTH-1:0] player_x;
    wire signed [sram_pkg::MAP_V_WIDTH-1:0] player_y;
    
    //wire signed [sram_pkg::MAP_H_WIDTH-1:0] car1_x, car2_x;
    //wire signed [sram_pkg::MAP_V_WIDTH-1:0] car1_y, car2_y;

    wire [sram_pkg::MAP_H_WIDTH-1:0] H_to_be_rendered;
    wire [sram_pkg::MAP_V_WIDTH-1:0] V_to_be_rendered;

    game_pkg::ObjectID pixel_object_id;


    wire [2*sram_pkg::CAR_COOR_WIDTH-1:0] pixel_counter;
    wire [sram_pkg::CAR_COOR_WIDTH-1:0] H_frameEncoder_output, V_frameEncoder_output;
    assign H_frameEncoder_output = pixel_counter % sram_pkg::CAR_SIZE;
    assign V_frameEncoder_output = pixel_counter / sram_pkg::CAR_SIZE;

    wire pixel_opacity, pixel_opacity_valid, frameEncode_done;

    // opacity, optional?
    reg car1_opacity_mask_r [0:sram_pkg::CAR_SIZE-1][0:sram_pkg::CAR_SIZE-1];
    reg car1_opacity_mask_w [0:sram_pkg::CAR_SIZE-1][0:sram_pkg::CAR_SIZE-1];
    reg car2_opacity_mask_r [0:sram_pkg::CAR_SIZE-1][0:sram_pkg::CAR_SIZE-1];
    reg car2_opacity_mask_w [0:sram_pkg::CAR_SIZE-1][0:sram_pkg::CAR_SIZE-1];
    
    wire [game_pkg::VELOCITY_OUTPUT_WIDTH-1:0] player_v;
    // TODO: Haven't defined player_hp
    wire [game_pkg::HP_WIDTH-1:0] player_hp;

    //wire [game_pkg::VELOCITY_OUTPUT_WIDTH-1:0] car1_v_m, car2_v_m;
    assign o_car1_v_m = car1_v_m;
    assign o_car2_v_m = car2_v_m;

    //wire [game_pkg::CAR_MASS_LEVEL_NUM_WIDTH-1:0] car1_mass_level, car2_mass_level;

    //wire [game_pkg::SINGLE_DIGIT_WIDTH-1:0] car1_lap, car2_lap;

    // status of game, output of GameControl
    wire is_gaming;
    game_pkg::GameResult game_result;
    
    // TODO: block display
    wire qBlock0_display, qBlock1_display, qBlock2_display, qBlock3_display;


    GameControl u_GameControl (
        .i_clk              (i_clk),
        .i_render_clk       (render_clk),
        .i_rst_n            (i_rst_n),
        /*
            TODO: the control signals from GPIO
        */
        .i_car1_acc         (i_car1_acc),
        .i_car2_acc         (i_car2_acc),
        .i_car1_brake       (i_car1_brake),
        .i_car2_brake       (i_car2_brake),
        .i_car1_omega       (i_car1_omega),
        .i_car2_omega       (i_car2_omega),
        //.i_audio_init_done  (1'b1),
        
        .i_start            (i_start),
        .i_restart          (i_restart),
        // for debug
        .o_game_state       (o_game_state),
        
        // the player's current status
        .o_player_v(player_v),
        .o_player_x(player_x),
        .o_player_y(player_y),
        .o_player_hp(player_hp),
        //.o_car1_angle       (car1_angle),
        //.o_car2_angle       (car2_angle),
        //.o_car1_x           (car1_x),
        //.o_car1_y           (car1_y),
        //.o_car2_x           (car2_x),
        //.o_car2_y           (car2_y),
        //.o_car1_v_m         (car1_v_m),
        //.o_car2_v_m         (car2_v_m),
        //.o_car1_mass_level  (car1_mass_level),
        //.o_car2_mass_level  (car2_mass_level),
        //.o_car1_lap         (car1_lap),
        //.o_car2_lap         (car2_lap),
        
        // Gaming status
        .o_is_gaming        (is_gaming),
        .o_game_result      (game_result),
        
        //.o_car1_vibrate     (o_car1_vibrate),
        //.o_car2_vibrate     (o_car2_vibrate),
        
        // For blocks display
        .o_qBlock0_display  (qBlock0_display),
        .o_qBlock1_display  (qBlock1_display),
        .o_qBlock2_display  (qBlock2_display),
        .o_qBlock3_display  (qBlock3_display)
        
    );
    
    /*
    GameControl u_GameControl (
        .i_clk              (i_clk),
        .i_render_clk       (render_clk),
        .i_rst_n            (i_rst_n),
        .i_car1_acc         (i_car1_acc),
        .i_car2_acc         (i_car2_acc),
        .i_car1_brake       (i_car1_brake),
        .i_car2_brake       (i_car2_brake),
        .i_car1_omega       (i_car1_omega),
        .i_car2_omega       (i_car2_omega),
        .i_audio_init_done  (1'b1),
        .i_start            (i_start),
        .i_restart          (i_restart),
        .o_game_state       (o_game_state),
        .o_car1_angle       (car1_angle),
        .o_car2_angle       (car2_angle),
        .o_car1_x           (car1_x),
        .o_car1_y           (car1_y),
        .o_car2_x           (car2_x),
        .o_car2_y           (car2_y),
        .o_car1_v_m         (car1_v_m),
        .o_car2_v_m         (car2_v_m),
        .o_car1_mass_level  (car1_mass_level),
        .o_car2_mass_level  (car2_mass_level),
        .o_car1_lap         (car1_lap),
        .o_car2_lap         (car2_lap),
        .o_is_gaming        (is_gaming),
        .o_car1_vibrate     (o_car1_vibrate),
        .o_car2_vibrate     (o_car2_vibrate),
        .o_qBlock0_display  (qBlock0_display),
        .o_qBlock1_display  (qBlock1_display),
        .o_qBlock2_display  (qBlock2_display),
        .o_qBlock3_display  (qBlock3_display),
        .o_game_result      (game_result)
    );
    */
    
    // Haven't seen yet //////////////////////////////////////////////////////
    FrameEncoder u_FrameEncoder (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_start            (!render_clk),
        .i_car1_angle       (car1_angle),
        .i_car2_angle       (car2_angle),
        .o_sram_addr        (addr_encode),
        .o_sram_data        (data_encode),
        .o_sram_writing     (sram_writing),
        .o_object_id        (pixel_object_id), 
        .o_pixel_counter    (pixel_counter),
        .o_opacity          (pixel_opacity),
        .o_opacity_valid    (pixel_opacity_valid),
        .o_done             (frameEncode_done)
    );
    ////////////////////////////////////////////////////////////////////////////

    // FrameDecoder usage: get game and player's status and to be rendered place from VGA, output decoded color to VGA, output address to SRAM, receive data from SRAM
    FrameDecoder u_FrameDecoder (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_player_x(player_x),
        .i_player_y(player_y),
        // TODO: some additional blocks displayed or other elements?
        
        // Input from VGA:
        .i_VGA_H(H_to_be_rendered),
        .i_VGA_V(V_to_be_rendered),
        // Output for VGA:
        .o_decoded_color(decoded_color),
        
        // Input from SRAM:
        .i_sram_data(), // may be delayed 2 cycles?
        .o_sram_addr(), // i_sram_data isn't directly from o_sram_addr!?

        // game status
        .i_is_gaming(is_gaming),
        .i_game_result(game_result)
    );

    /*
    FrameDecoder u_FrameDecoder (
        .i_clk                  (i_clk),
        .i_rst_n                (i_rst_n),
        .i_car1_x               (car1_x),
        .i_car1_y               (car1_y),
        .i_car2_x               (car2_x),
        .i_car2_y               (car2_y),
        .i_car1_mass_level      (car1_mass_level),
        .i_car2_mass_level      (car2_mass_level),
        .i_car1_lap             (car1_lap),
        .i_car2_lap             (car2_lap),
        .i_car1_opacity_mask    (car1_opacity_mask_r),
        .i_car2_opacity_mask    (car2_opacity_mask_r),
        .i_car1_v_m             (car1_v_m),
        .i_car2_v_m             (car2_v_m),
        .i_qBlock0_display      (qBlock0_display),
        .i_qBlock1_display      (qBlock1_display),
        .i_qBlock2_display      (qBlock2_display),
        .i_qBlock3_display      (qBlock3_display),
        .i_VGA_H                (H_to_be_rendered),
        .i_VGA_V                (V_to_be_rendered),
        .i_is_gaming            (is_gaming),
        .i_game_result          (game_result),
        .o_sram_addr            (addr_decode),
        .i_sram_data            (data_decode),
        .o_decoded_color        (decoded_color)
    );
    */

    // VGA is very nice, but notice the 2 cycles delay
    VGA u_VGA (
        .i_clk                     (i_clk),
        .i_rst_n                   (i_rst_n),
        .i_color                   (decoded_color),
        .o_H_sync                  (o_H_sync),
        .o_V_sync                  (o_V_sync),
        .o_RGB                     (o_RGB),
        .o_RGB_valid               (o_RGB_valid),
        .o_frame_counter           (o_frame_counter),
        .o_H_to_be_rendered        (H_to_be_rendered),
        .o_V_to_be_rendered        (V_to_be_rendered),
        .o_render_clk              (render_clk)
    );

    // opacity map combinatorial logic
    genvar i, j;
    generate
        for (i = 0; i < sram_pkg::CAR_SIZE; i = i + 1) begin: opacity_mask_generate_i
            for (j = 0; j < sram_pkg::CAR_SIZE; j = j + 1) begin: opacity_mask_generate_j
                assign car1_opacity_mask_w[i][j] = ( V_frameEncoder_output == i &&
                                                    H_frameEncoder_output == j &&
                                                    pixel_object_id == game_pkg::OBJECT_CAR1 &&
                                                    pixel_opacity_valid ) ? 
                                                    pixel_opacity : car1_opacity_mask_r[i][j];
                assign car2_opacity_mask_w[i][j] = ( V_frameEncoder_output == i &&
                                                    H_frameEncoder_output == j &&
                                                    pixel_object_id == game_pkg::OBJECT_CAR2 &&
                                                    pixel_opacity_valid ) ? 
                                                    pixel_opacity : car2_opacity_mask_r[i][j];
            end
        end
    endgenerate

    // opacity map sequential logic
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            for (integer i = 0; i < sram_pkg::CAR_SIZE; i = i + 1) begin
                for (integer j = 0; j < sram_pkg::CAR_SIZE; j = j + 1) begin
                        car1_opacity_mask_r[i][j] <= 0;
                        car2_opacity_mask_r[i][j] <= 0;
                end
            end
        end
        else begin
            for (integer i = 0; i < sram_pkg::CAR_SIZE; i = i + 1) begin
                for (integer j = 0; j < sram_pkg::CAR_SIZE; j = j + 1) begin
                    car1_opacity_mask_r[i][j] <= car1_opacity_mask_w[i][j];
                    car2_opacity_mask_r[i][j] <= car2_opacity_mask_w[i][j];
                end
            end
        end
    end
endmodule