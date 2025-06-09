`timescale 1ns/1ps

`include "uart_rx.sv"
`include "csv_parser.sv"

module top_fpga (
    input  logic        clk,          // 50 MHz
    input  logic        rst_n,
    input  logic        rx_from_esp,  // ESP32 TX → FPGA RX
    output logic [15:0] ax1, ay1, az1,
    output logic [15:0] ax2, ay2, az2,
    output logic [11:0] jx, jy,
    output logic        btn,
    output logic        new_frame
);

    logic [7:0] rx_byte;
    logic       rx_valid;

    // UART receiver instance
    uart_rx #(
        .CLK_FREQ(50_000_000),
        .BAUD(115200)
    ) uart_i (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx_from_esp),
        .data_out(rx_byte),
        .valid(rx_valid)
    );

    // CSV parser instance
    csv_parser parser_i (
        .clk(clk),
        .rst_n(rst_n),
        .char_in(rx_byte),
        .char_val(rx_valid),
        .ax1(ax1),
        .ay1(ay1),
        .az1(az1),
        .ax2(ax2),
        .ay2(ay2),
        .az2(az2),
        .jx(jx),
        .jy(jy),
        .btn(btn),
        .frame_done(new_frame)
    );

endmodule
