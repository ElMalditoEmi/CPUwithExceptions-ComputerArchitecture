// CONTROLLER

module controller(input logic [10:0] instr,
						output logic [3:0] AluControl,
						output logic [1:0]AluSrc,						
						output logic reg2loc, regWrite, Branch,
											memtoReg, memRead, memWrite,
						// Agregados en tp3:
						// - input
						input logic reset,
						input logic ExtIRQ,

						// - Hacia DP
						output logic [3:0] EStatus,
						output logic Exc, ERet,
						input logic ExcAck,

						// - Hacia afuera
						output logic ExtIAck


						);
						
	logic [1:0] AluOp_s;
											
	maindec 	decPpal 	(.Op(instr), 
							.Reg2Loc(reg2loc), 
							.ALUSrc(AluSrc), 
							.MemtoReg(memtoReg), 
							.RegWrite(regWrite), 
							.MemRead(memRead), 
							.MemWrite(memWrite), 
							.Branch(Branch), 
							.ALUOp(AluOp_s),
							.ERet(ERet));
					
								
	aludec 	decAlu 	(.funct(instr), 
							.aluop(AluOp_s), 
							.alucontrol(AluControl));
			
endmodule
