`timescale 1ns / 10ps

module flopr_tb();
	logic clk, reset;
	logic [63:0]d;
	logic [63:0]q;
	logic [31:0] vectornum;    // bookkeeping variables 
	logic [3:0] testvectors [0:9] = '{ 64'b000,	// array of testvectors
												  64'b001,
												  64'b010,
												  64'b011,
												  64'b100,
												  64'b101,
												  64'b110,
												  64'b111,
												  64'b1000,
												  64'b1001
												  };
	flopr dut(clk,reset,d,q);
	
	// generate clock
	always     // no sensitivity list, so it always executes
		begin
			clk = 0; #10; clk = 1; #10;
		end
		
	// at start of test pulse reset
	initial 	
		begin
			vectornum = 0; // Inicializar el indice en 0
			#2ns; d = testvectors[vectornum]; // Poner el primer valor en d
			reset = 0; #43ns; reset = 1; #2ns ; reset = 0;
		end
	
	always @(negedge clk) begin
		// increment array index and read next testvector
			#2ns; d = testvectors[vectornum];
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 4'bx) begin 
			//  $finish;
				$stop;
			end
		end

endmodule