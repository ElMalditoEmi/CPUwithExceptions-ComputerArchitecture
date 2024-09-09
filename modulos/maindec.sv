module maindec(input logic [10:0]Op,
                output logic [0:1]ALUSrc,
                output logic Reg2Loc,
                                MemtoReg,
                                RegWrite,
                                MemRead,
                                MemWrite,
                                Branch,
                output logic [1:0]ALUOp);

    always_ff @(Op) begin // Sensible al cambio de Op

        // El caso default por si ningún if de abajo unifica
        Reg2Loc = 0;
        ALUSrc = 2'b0;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        ALUOp = 2'b00;

        if ((Op === 11'b100_0101_1000) || (Op === 11'b110_0101_1000) || (Op === 11'b100_0101_0000) || (Op === 11'b101_0101_0000)) begin // RFormat
            Reg2Loc = 0;
            ALUSrc = 2'b0;
            MemtoReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 2'b10;
        end
        if (Op === 11'b111_1100_0010) begin // LDUR
            Reg2Loc = 0;
            ALUSrc = 2'b1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 2'b00;
        end
        if (Op === 11'b111_1100_0000) begin // STUR
            Reg2Loc = 1;
            ALUSrc = 2'b1;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
            ALUOp = 2'b00;
        end
        if (Op[10:3] == 8'b101_1010_0) begin // CBZ
            Reg2Loc = 1;
            ALUSrc = 2'b0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            ALUOp = 2'b01;
        end
    end


endmodule