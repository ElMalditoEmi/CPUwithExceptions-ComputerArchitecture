module alu_tb();
	logic clk;
	logic zero;
	logic zero_expected;
	logic [3:0]ALUControl;
	logic [31:0]testcase;
	logic [31:0]error_count;
	logic [63:0]a;
	logic [63:0]b;
	logic [63:0]result;
	logic [63:0]expected;
	
	logic [196:0] cases [0:11] = {
		// a,    b,     op,  expected_result , expected_zero_flag
		{64'b11,64'b10,4'b0000,64'b10,1'b0}, // AND
		{64'b10,64'b01,4'b0000,64'b00,1'b1},
		
		{64'b00,64'b11,4'b0001,64'b11,1'b0}, // OR
		{64'b10,64'b01,4'b0001,64'b11,1'b0},
		
		{64'd2,64'd2,4'b0010,64'd4,1'b0}, // ADD
		{64'd150,64'd27,4'b0010,64'd177,1'b0},
		
		{64'd2,64'd2,4'b0110,64'd0,1'b1}, // SUB
		{64'd10,64'd3,4'b0110,64'd7,1'b0},
		
		{64'd2,64'd2,4'b0111,64'd2,1'b0}, // PASS b
		{64'd100,64'd200,4'b0111,64'd200,1'b0},
		
		// Border cases
		{64'hffffffffffffffff,64'd2,4'b0010,64'b1,1'b0},  // ADD OVERFLOW (MAX_INT + 2)
		{64'd0,64'd1,4'b0110,64'hffffffffffffffff,1'b0}   // 0 - 1
		
		// Test for zero active
	};
	
	alu dut(a,b,ALUControl,result,zero);
	
	always     // no sensitivity list, so it always executes
		begin
			clk = 0; #10; clk = 1; #10;
		end
	initial 	
		begin
			error_count = 0;
			testcase = 0; // Inicializar el indice en 0
			zero_expected = cases[testcase][0];
			expected = cases[testcase][64:1];
			ALUControl = cases[testcase][68:65];
			b = cases[testcase][132:69];
			a = cases[testcase][196:133];
		end
		
	always @(posedge clk) begin
		// increment array index and read next testvector
			if (cases[testcase] === 'bx) begin 
			//  $finish;
				$display("Test bench ended with %d errors",error_count);
				$stop;
			end
			
			if ((result !== expected) || (zero_expected !== zero)) begin
				$display("error for case %d, got: val=%h|zero=%b , expected: val=%h|zero=%b ",testcase,result,zero,expected,zero_expected);
				error_count = error_count + 1;
			end
			if ((result === expected) && (zero_expected === zero)) $display("case %d checks :)",testcase);
			
			zero_expected = cases[testcase][0];
			expected = cases[testcase][64:1];
			ALUControl = cases[testcase][68:65];
			b = cases[testcase][132:69];
			a = cases[testcase][196:133];
			testcase = testcase + 1;
		end
endmodule