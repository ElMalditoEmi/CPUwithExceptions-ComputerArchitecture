// INSTRUCTION MEMORY

module imem #(parameter N=32)
			 (input logic [6:0] addr,
			  output logic [N-1:0] q);

	logic [N-1:0] ROM [0:127];
	
	initial
	begin	
ROM [0:2] ='{32'h8b010001,
32'hd61f0020,
32'hb400001f};

	end
	
	assign q = ROM[addr];
endmodule
