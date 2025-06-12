package GamePkg;
    localparam int STEP_X = 5;   // Step size for X movement
    localparam int STEP_Y = 5;   // Step size for Y movement

    localparam int BULLET_STEP_X = 11; // Width for position coordinates

    localparam int G = 1;        // Gravity constant
    localparam int V = 10;       // Initial jump velocity
    localparam int MAX_J = 20;   // Maximum jump count

    localparam int MAX_HP = 100; // Maximum health points
    localparam int LIMIT_X = 10;  // Limit for X coordinate
endpackage
