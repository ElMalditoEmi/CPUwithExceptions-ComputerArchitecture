
module fetch_tb();
	parameter clockrate=10ns;
	logic clk;
	logic reset;

	logic PCSrc_F;
	logic [63:0]PCBranch_F;
	logic [129:0] testcase;
	logic [63:0] expected_imem_addr_F;
	int test_n = 0;
	int error_count = 0;
	
	// Test vector
	logic [129:0] test_vector [0:11] = { // One per cycle
		// PCBranch_F, expected_imem_addr_F, PCSrc_F ,reset,
		{64'd2,     64'b0,               1'b0,      1'b1},
		{64'd2,     64'b0,               1'b0,      1'b1},
		{64'd2,     64'b0,               1'b0,      1'b1},
		{64'd2,     64'b0,               1'b0,      1'b1},
		{64'd2,     64'b0,               1'b0,      1'b1}, // 5 primeros ciclos, esta el reset levantado

		{64'b1,64'd4,1'b0,1'b0}, // Reset en 0
		{64'b1,64'd8,1'b0,1'b0}, // Incrementa en 4
		{64'b1,64'd12,1'b0,1'b0}, // Incrementa en 4
		{64'b1,64'd16,1'b0,1'b0}, // Incrementa en 4

		{64'hfe0,64'hfe0,1'b1,1'b0}, // Se setea con PCSrc_F
		{64'hfea,64'hfea,1'b1,1'b0}, // Se setea con PCSrc_F
		{64'hfea,64'b0,1'b1,1'b1} // Reset
	};

	// dut------------------------------
	logic [63:0]imem_addr_F;
	fetch dut(PCSrc_F,clk,reset,PCBranch_F,imem_addr_F);
	// ---------------------------------

	always begin
		clk = 0; #(clockrate/2) ; clk = 1; #(clockrate/2);
	end

	// Set test during negedge
	// Test values during posedge

	always @(negedge clk) begin
		testcase = test_vector[test_n];
		if (testcase === 130'bx) begin
			$display("Test bench ended with %d errors",error_count);
			$stop;
		end

		if (testcase == 'bx) begin
			$display("Test bench ended");
			$stop;
		end
		// Set value
		reset = testcase[0];
		PCSrc_F = testcase[1];
		expected_imem_addr_F = testcase[65:2];
		PCBranch_F = testcase[129:66];
		test_n++;
	end

	always @(posedge clk) begin
		// Checking 
		#1ns;
		if (imem_addr_F !== expected_imem_addr_F) begin
			$display("Test %d failed", test_n);
			$display("Expected: %b", expected_imem_addr_F);
			$display("Got: %b", imem_addr_F);
			error_count = error_count + 1;
		end

	end

endmodule
