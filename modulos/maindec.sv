module maindec(input logic [10:0]Op,
					input logic reset,
                output logic [0:1]ALUSrc,
                output logic Reg2Loc,
                                MemtoReg,
                                RegWrite,
                                MemRead,
                                MemWrite,
                                Branch,
                output logic [1:0]ALUOp,
                output logic ERet
                );

    always_comb begin // Sensible al cambio de Op
		  
		  if (reset === 1'b1) begin
		  Reg2Loc = 0;
        ALUSrc = 2'b0;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        ALUOp = 2'b00;
        ERet = 0;
		  end

        else if ((Op === 11'b100_0101_1000) || (Op === 11'b110_0101_1000) || (Op === 11'b100_0101_0000) || (Op === 11'b101_0101_0000)) begin // RFormat
            Reg2Loc = 0;
            ALUSrc = 2'b0;
            MemtoReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 2'b10;
            ERet = 0;
        end
        else if (Op === 11'b111_1100_0010) begin // LDUR
            Reg2Loc = 0;
            ALUSrc = 2'b1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 2'b00;
            ERet = 0;
        end
        else if (Op === 11'b111_1100_0000) begin // STUR
            Reg2Loc = 1;
            ALUSrc = 2'b1;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
            ALUOp = 2'b00;
            ERet = 0;
        end
        else if (Op === 11'b1101_011_0100) begin // ERET
            Reg2Loc = 0;
            ALUSrc = 2'b0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 2'b00;
            
            ERet = 1; // No deberia suceder nada mas.
        end
        else if (Op[10:3] == 8'b101_1010_0) begin // CBZ
            Reg2Loc = 1;
            ALUSrc = 2'b0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            ALUOp = 2'b01;
            ERet = 0;
        end
		  else begin
		  // El caso default por si ningún if unifica		  
        Reg2Loc = 0;
        ALUSrc = 2'b0;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        ALUOp = 2'b00;
        ERet = 0;
		  end
    end


endmodule