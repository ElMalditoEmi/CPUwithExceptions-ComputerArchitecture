module imem_tb();
	logic clk;
	logic [5:0]addr;
	logic [5:0]error_count;
	logic [31:0]q;
	logic [32:0] expectedROM [0:46];
	
	imem dut(addr,q);
	
	
	initial
		begin
			error_count = 0;
			addr = 6'd0;
			expectedROM [0:46] ='{32'hf8000001,
								32'hf8008002,
								32'hf8000203,
								32'h8b050083,
								32'hf8018003,
								32'hcb050083,
								32'hf8020003,
								32'hcb0a03e4,
								32'hf8028004,
								32'h8b040064,
								32'hf8030004,
								32'hcb030025,
								32'hf8038005,
								32'h8a1f0145,
								32'hf8040005,
								32'h8a030145,
								32'hf8048005,
								32'h8a140294,
								32'hf8050014,
								32'haa1f0166,
								32'hf8058006,
								32'haa030166,
								32'hf8060006,
								32'hf840000c,
								32'h8b1f0187,
								32'hf8068007,
								32'hf807000c,
								32'h8b0e01bf,
								32'hf807801f,
								32'hb4000040,
								32'hf8080015,
								32'hf8088015,
								32'h8b0103e2,
								32'hcb010042,
								32'h8b0103f8,
								32'hf8090018,
								32'h8b080000,
								32'hb4ffff82,
								32'hf809001e,
								32'h8b1e03de,
								32'hcb1503f5,
								32'h8b1403de,
								32'hf85f83d9,
								32'h8b1e03de,
								32'h8b1003de,
								32'hf81f83d9,
								32'hb400001f};
		end
	
	always
		begin
			clk = 0; #10; clk = 1; #10;
		end
		
	always @(posedge clk)
		begin

			
			if ( addr === 6'd49) begin
				$display("Error count: %d",error_count);$stop;
			end
			
			if (addr < 6'd47) begin
				if (q !== expectedROM[addr]) begin
					$display("error, expected:%h, got:%h",expectedROM[addr],q);
					error_count = error_count + 1;
				end
			end else 
				if (q !== 0) begin 
					$display("error, expected:%h, got:%h",expectedROM[addr],q);
					error_count = error_count + 1;
				end
			
			addr = addr + 1;
		end

endmodule