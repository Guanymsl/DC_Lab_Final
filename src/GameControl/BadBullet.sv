module GoodBullet (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        attack,
    input  logic        defend,
    input  logic [10:0] xPlayer,
    input  logic [ 9:0] yPlayer,
    output logic [10:0] x,
    output logic [ 9:0] y,
    output logic        isE,
);
    localparam MAX_X
    localparam STEP_X

    logic [10:0] x_r, x_w;
    logic [ 9:0] y_r, y_w;
    logic        isE_r,  isE_w;

    assign x    = x_r;
    assign y    = y_r;
    assign isE  = isE_r;
    assign face = face_r;

    always_comb begin
        x_w    = x_r;
        y_w    = y_r;
        face_w = face_r;
        isE_w  = isE_r;

        if (isE_r) begin
            x_w = x_r - STEP_X;
            if (x_w > MAX_X || x_w < 0) begin
                isE_w = 0;
            end
        end else begin
            if (~defend && attack) begin
                isE_w  = 1;
                x_w    = xPlayer;
                y_w    = yPlayer;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_r    <= 0;
            y_r    <= 0;
            isE_r  <= 0;
        end else begin
            x_r    <= x_w;
            y_r    <= y_w;
            isE_r  <= isE_w;
        end
    end

endmodule