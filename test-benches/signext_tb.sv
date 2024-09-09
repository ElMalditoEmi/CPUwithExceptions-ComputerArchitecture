`timescale 1ns / 10ps

module signext_tb();
	logic clk;
	logic [31:0]a;
	logic [63:0]y;
	logic [63:0]yexpected;
	logic [31:0] vectornum;
	logic [31:0] testvectors [0:11] = '{
			  //LDUR opcode    //Imm         //x
		 {11'b111_1100_0010,9'b1_0000_0000,12'b0}, // LDUR 1
		 {11'b111_1100_0010,9'b0_0000_0001,12'b0}, // LDUR 2
		 {11'b111_1100_0010,9'b1_0000_0001,12'b0}, // LDUR 3
		     //STUR opcode    //Imm         //x
		 {11'b111_1100_0000,9'b1_0000_0000,12'b0}, // STUR 1
		 {11'b111_1100_0000,9'b0_0000_0001,12'b0}, // STUR 2
		 {11'b111_1100_0000,9'b1_0000_0001,12'b0}, // STUR 3
		 
		     //CBZ opcode    //Imm         //x
		 {8'b101_1010_0,19'b111_1111_1111_0000_0000,5'hff}, // CBZ 1
		 {8'b101_1010_0,19'b000_0000_0000_0000_0001,5'hff}, // CBZ 1
		 {8'b101_1010_0,19'b111_1111_1111_0000_0001,5'hff}, // CBZ 1
		 
		 {11'b100_1100_0000,9'b0_0000_0001,12'b0}, // Non-valid 1
		 {11'b111_1101_0000,9'b0_0000_0001,12'b0}, // Non-valid 2
		 {8'b101_1011_0,24'b1_0000_0001,12'b0} // Non-valid 3
	};
	logic [63:0] expected [0:11] = '{
		 {{55{1'b1}},9'b1_0000_0000}, // expected LDUR 1
		 64'b1, 							   // expected LDUR 2
		 {{55{1'b1}},9'b1_0000_0001}, // expected LDUR 3
		 
		 {{55{1'b1}},9'b1_0000_0000}, // expected STUR 1
		 64'b1,                       // expected STUR 2
		 {{55{1'b1}},9'b1_0000_0001}, // expected STUR 3
		 
		 {{55{1'b1}},9'b1_0000_0000}*4, // expected CBZ 1
		 (64'b1)*4,                       // expected CBZ 2
		 {{55{1'b1}},9'b1_0000_0001}*4, // expected CBZ 3
		 
		 64'b0, // Non-valid 1
		 64'b0, // Non-valid 2
		 64'b0 // Non-valid 3
	};
	

	signext dut(a,y);
	
	// generate clock
	always     // no sensitivity list, so it always executes
		begin
			clk = 0; #10; clk = 1; #10;
		end
		
	// at start of test pulse reset
	initial 	
		begin
			vectornum = 0; // Inicializar el indice en 0
			a = testvectors[vectornum]; // Poner el primer valor en d
			yexpected = expected[vectornum];
		end
	
	always @(posedge clk) begin
		// increment array index and read next testvector
			if (testvectors[vectornum] === 'bx) begin 
			//  $finish;
				$stop;
			end
			
			if (y !== yexpected) $display("error for case %d, got: %h , expected: %h",vectornum,y,yexpected);
			if (y === yexpected) $display("case %d checks :)",vectornum);
			
			a = testvectors[vectornum]; yexpected = expected[vectornum];
			vectornum = vectornum + 1;
		end

endmodule