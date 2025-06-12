module Player (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        right,
    input  logic        left,
    input  logic        jump,
    input  logic        squat,
    input  logic        defend,
    output logic [10:0] x,
    output logic [ 9:0] y,
    output logic        isD,
    output logic        isQ,
    output logic        isJ,
);

    localparam MAX_X
    localparam STEP_X
    localparam MAX_Y
    localparam MAX_J
    localparam G
    localparam V

    logic [10:0] x_r, x_w;
    logic [ 9:0] y_r, y_w;
    logic        isJ_r, isJ_w;
    logic [ 3:0] Jcnt_r, Jcnt_w;
    logic [ 9:0] yInit_r, yInit_w;

    assign x    = x_r;
    assign y    = y_r;
    assign isD  = defend;
    assign isQ  = (isJ) ? 0 : squat;
    assign isJ  = isJ_r;

    always_comb begin
        x_w = x_r;
        if (right) begin
            x_w = x_r + STEP_X;
        end else if (left) begin
            x_w = x_r - STEP_X;
        end

        if (x_w > MAX_X) begin
            x_w = MAX_X;
        end else if (x_w < 0) begin
            x_w = 0;
        end
    end

    always_comb begin
        y_w      = y_r;
        isJ_w    = isJ_r;
        Jcnt_w   = Jcnt_r;
        yInit_w  = yInit_r;

        if (isJ_r) begin
            if (Jcnt_r >= MAX_J) begin
                isJ_w  = 0;
                Jcnt_w = 0;
            end else begin
                Jcnt_w = Jcnt_r + 1;
            end
            y_w = yInit_r + V * Jcnt_r - (G * Jcnt_r * Jcnt_r) / 2;
        end else begin
            if (jump) begin
                isJ_w   = 1;
                Jcnt_w  = 0;
                yInit_w = y_r;
            end
        end

        if (y_w > MAX_Y) begin
            y_w = MAX_Y;
        end else if (y_w < 0) begin
            y_w = 0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_r     <= 0;
            y_r     <= 0;
            isJ_r   <= 0;
            Jcnt_r  <= 0;
            yInit_r <= 0;
        end else begin
            x_r     <= x_w;
            y_r     <= y_w;
            isJ_r   <= isJ_w;
            Jcnt_r  <= Jcnt_w;
            yInit_r <= yInit_w;
        end
    end

endmodule