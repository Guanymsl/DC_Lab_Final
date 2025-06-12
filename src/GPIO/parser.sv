module parser (
    data,
    right,
    left,
    jump,
    squat,
    attack,
    defend,
    select
);
    input  logic [7:0] data;
    output logic       right;
    output logic       left;
    output logic       jump;
    output logic       squat;
    output logic       attack;
    output logic       defend;
    output logic       select;

    logic dummy;

    assign {right,
            left,
            jump,
            squat,
            attack,
            defend,
            select,
            dummy} = data;

endmodule
