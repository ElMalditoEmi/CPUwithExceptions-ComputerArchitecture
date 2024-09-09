`timescale 1ns/1ps
module maindec_tb();
    logic [19:0]testvectors[0:8] = {
        // {Op,  Expecteds: Reg2loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp}: vector format
        // RFormat
        {11'b100_0101_1000, 1'b0,    1'b0,   1'b0,     1'b1,     1'b0,    1'b0,     1'b0,   2'b10}, // ADD
        {11'b110_0101_1000, 1'b0,    1'b0,   1'b0,     1'b1,     1'b0,    1'b0,     1'b0,   2'b10}, // SUB
        {11'b100_0101_0000, 1'b0,    1'b0,   1'b0,     1'b1,     1'b0,    1'b0,     1'b0,   2'b10}, // AND
        {11'b101_0101_0000, 1'b0,    1'b0,   1'b0,     1'b1,     1'b0,    1'b0,     1'b0,   2'b10}, // ORR

        {11'b111_1100_0010, 1'b0,    1'b1,   1'b1,     1'b1,     1'b1,    1'b0,     1'b0,   2'b00}, // LDUR
        {11'b111_1100_0000, 1'b1,    1'b1,   1'b0,     1'b0,     1'b0,    1'b1,     1'b0,   2'b00}, // STUR

                     //???
        {11'b101_1010_0111, 1'b1,    1'b0,   1'b0,     1'b0,     1'b0,    1'b0,     1'b1,   2'b01}, // CBZ

        {11'bxxx_xxxx_xxxx, 1'b0,    1'b0,   1'b0,     1'b0,     1'b0,    1'b0,     1'b0,   2'b00}, // default 1 (noise)
        {11'b111_1111_1111, 1'b0,    1'b0,   1'b0,     1'b0,     1'b0,    1'b0,     1'b0,   2'b00} // default 2  (not a valid instruction)
    };

    logic clk;

    logic [10:0]Op;
    logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp;
    logic expReg2Loc, expALUSrc, expMemtoReg, expRegWrite, expMemRead, expMemWrite, expBranch, expALUOp; // Expected values

    maindec dut(Op,Reg2Loc,ALUSrc,MemtoReg,RegWrite, MemRead, MemWrite, Branch, ALUOp);

    logic [19:0]testcase;
    int test_n = 0;

    always begin
        clk = 0; #10; clk = 1; #10;
    end

    always @(posedge clk) begin
        testcase = testvectors[test_n];
        if (testcase === 20'bx) $stop;

        Op = testcase[19:9]; //Setear Op
        expReg2Loc = testcase[8];
        expALUSrc = testcase[7];
        expMemtoReg = testcase[6];
        expRegWrite <= testcase[5];
        expMemRead = testcase[4];
        expMemWrite = testcase[3];
        expBranch = testcase[2];
        expALUOp = testcase[1:0];
        #2; // Esperar que se estabilice
        if (Reg2Loc != expReg2Loc || ALUSrc != expALUSrc || MemtoReg != expMemtoReg || RegWrite != expRegWrite || MemRead != expMemRead || MemWrite != expMemWrite || Branch != expBranch || ALUOp != expALUOp) begin
            $display("Test %d failed", test_n);
            $display("Expected: %b %b %b %b %b %b %b %b", expReg2Loc, expALUSrc, expMemtoReg, expRegWrite, expMemRead, expMemWrite, expBranch, expALUOp);
            $display("Got: %b %b %b %b %b %b %b %b", Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);
        end
        // else begin
        //     $display("Test %d passed", test_n);
        // end

        #16; // Para que sea mas fácil mirar la gráfica
        test_n = test_n + 1;
    end


endmodule