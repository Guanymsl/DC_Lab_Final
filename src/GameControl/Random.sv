module random_LFSR(
	input enable,
	input i_rst_n,
	output [3:0] o_random_out
);
// ===== Registers & Wires =====
logic [3:0] rand_ff_w, rand_ff_r;

// ===== Output Assignments =====
assign o_random_out = rand_ff_r;

// ===== Combinational Circuits =====
always_comb begin
	// Default Values
	rand_ff_w = rand_ff_r;
end

// ===== Sequential Circuits =====
always_ff @(posedge enable or negedge i_rst_n) begin
	// reset
	if (!i_rst_n) begin
		rand_ff_r <= 4'd3;
	end

	else if(|rand_ff_r==0) begin
		rand_ff_r <= 4'd12;

	end

	else begin
		rand_ff_r[3] <= (rand_ff_w[0])^(rand_ff_w[3]);
		rand_ff_r[2] <= rand_ff_w[3];
		rand_ff_r[1] <= rand_ff_w[2];
		rand_ff_r[0] <= rand_ff_w[1];
	end
end

endmodule