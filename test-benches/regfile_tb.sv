`timescale 10ns / 10ps
 
module regfile_tb();
	logic we3,clk;
	logic [4:0]ra1 = 0;
	logic [4:0]ra2 = 0;
	logic [4:0]wa3 = 'bx;
	logic [63:0] rd1, rd2, wd3, expectedrd1, expectedrd2;
	logic [207:0] testcase;
	int error_count = 0, test_n = 0;
	
	logic [207:0] testvectors [0:32] = '{
			   //ra1, ra2  , wa3  , wd3 ,   we3  , expectedrd1, expectedrd2
			// Check init
				{5'd0, 5'd0 , 5'dx , 64'bx , 1'b0 , 64'd0 , 64'd0 }, 
				{5'd1, 5'd1 , 5'dx , 64'bx , 1'b0 , 64'd1 , 64'd1 },
				{5'd2, 5'd2 , 5'dx , 64'bx , 1'b0 , 64'd2 , 64'd2 },
				{5'd3, 5'd3 , 5'dx , 64'bx , 1'b0 , 64'd3 , 64'd3 },
				{5'd4, 5'd4 , 5'dx , 64'bx , 1'b0 , 64'd4 , 64'd4 },
				{5'd5, 5'd5 , 5'dx , 64'bx , 1'b0 , 64'd5 , 64'd5 },
				{5'd6, 5'd6 , 5'dx , 64'bx , 1'b0 , 64'd6 , 64'd6 },
				{5'd7, 5'd7 , 5'dx , 64'bx , 1'b0 , 64'd7 , 64'd7 },
				{5'd8, 5'd8 , 5'dx , 64'bx , 1'b0 , 64'd8 , 64'd8 },
				{5'd9, 5'd9 , 5'dx , 64'bx , 1'b0 , 64'd9 , 64'd9 },
				{5'd10, 5'd10 , 5'dx , 64'bx , 1'b0 , 64'd10 , 64'd10 },
				{5'd11, 5'd11 , 5'dx , 64'bx , 1'b0 , 64'd11 , 64'd11 },
				{5'd12, 5'd12 , 5'dx , 64'bx , 1'b0 , 64'd12 , 64'd12 },
				{5'd13, 5'd13 , 5'dx , 64'bx , 1'b0 , 64'd13 , 64'd13 },
				{5'd14, 5'd14 , 5'dx , 64'bx , 1'b0 , 64'd14 , 64'd14 },
				{5'd15, 5'd15 , 5'dx , 64'bx , 1'b0 , 64'd15 , 64'd15 },
				{5'd16, 5'd16 , 5'dx , 64'bx , 1'b0 , 64'd16 , 64'd16 },
				{5'd17, 5'd17 , 5'dx , 64'bx , 1'b0 , 64'd17 , 64'd17 },
				{5'd18, 5'd18 , 5'dx , 64'bx , 1'b0 , 64'd18 , 64'd18 },
				{5'd19, 5'd19 , 5'dx , 64'bx , 1'b0 , 64'd19 , 64'd19 },
				{5'd20, 5'd20 , 5'dx , 64'bx , 1'b0 , 64'd20 , 64'd20 },
				{5'd21, 5'd21 , 5'dx , 64'bx , 1'b0 , 64'd21 , 64'd21 },
				{5'd22, 5'd22 , 5'dx , 64'bx , 1'b0 , 64'd22 , 64'd22 },
				{5'd23, 5'd23 , 5'dx , 64'bx , 1'b0 , 64'd23 , 64'd23 },
				{5'd24, 5'd24 , 5'dx , 64'bx , 1'b0 , 64'd24 , 64'd24 },
				{5'd25, 5'd25 , 5'dx , 64'bx , 1'b0 , 64'd25 , 64'd25 },
				{5'd26, 5'd26 , 5'dx , 64'bx , 1'b0 , 64'd26 , 64'd26 },
				{5'd27, 5'd27 , 5'dx , 64'bx , 1'b0 , 64'd27 , 64'd27 },
				{5'd28, 5'd28 , 5'dx , 64'bx , 1'b0 , 64'd28 , 64'd28 },
				{5'd29, 5'd29 , 5'dx , 64'bx , 1'b0 , 64'd29 , 64'd29 },
				{5'd30, 5'd30 , 5'dx , 64'bx , 1'b0 , 64'd30 , 64'd30 },
				{5'd1, 5'd0 , 5'd1 , 64'd2 , 1'b1 , 64'd2 , 64'd0 }, // Write 2 on x1, verifies x0 remains 0
				{5'd11, 5'd5 , 5'd11 , 64'd45 , 1'b1 , 64'd45 , 64'd5 } // Write 45 on x1
				//Terminar
	};
 
	always     // no sensitivity list, so it always executes
		begin
			clk = 0; #10; clk = 1; #10;
		end
 
	regfile dut(clk,we3,ra1, ra2, wa3, wd3, rd1, rd2);
	
	initial begin
		
	end
	
	always @(negedge clk) begin
		testcase = testvectors[test_n];
		expectedrd2 = testcase[63:0];
		expectedrd1 = testcase[127:64];
		we3 = testcase[128];
		wd3 = testcase[192:129];
		wa3 = testcase[197:193];
		ra2 = testcase[202:198];
		ra1 = testcase[207:203];
	end
	
	always @(posedge clk) begin
		#3;
		if( testvectors[test_n] === 'bx) begin
			$display("Error count: %d", error_count);
			$stop;
		end
		
		if ((expectedrd1 !== rd1) || (expectedrd2 !== rd2)) begin
			error_count = error_count + 1;
			$display("ERROR - got: rd1=%d | rd2=%d , expected: rd1=%d | rd2=%d", rd1,rd2,expectedrd1,expectedrd2);
		end
		test_n = 1 + test_n;
	end
 
endmodule