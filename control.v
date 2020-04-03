
module Control(
    input [2:0]sel,
    input clk,
    input [6:0] opcode,
    output reg Branch,
    output reg Mem_Read,
    output reg MemtoReg,
    output reg [2:0]ALUOp,
    output reg Mem_Write,
    output reg [1:0] ALUSrc,
    output reg Reg_Write
    //output Reg_Read
    );
    always @(*)begin
    begin
    case(opcode)
    //R_Type instruction
    7'b0110011:begin 
            Reg_Write=1;
            Mem_Write=1'bX;//disable memory part
            Mem_Read=1'bX;//disable memory part
            MemtoReg=0;//take output from alu not memory
            ALUOp=3'b010;//
            ALUSrc=2'b00;//take 2nd input of alu form register not form imm_gen 
            Branch=0;//disable branch
            
        end
     //I_Type instruction
     7'b0010011:begin 
            Reg_Write=1;
            Mem_Write=1'bX;//disable memory part
            Mem_Read=1'bX;//disable memory part
            MemtoReg=0;//take output from alu not memory
            ALUOp=3'b011;//doubt
            ALUSrc=2'b11;//take 2nd input of alu form imm_gen not form register 
            Branch=0;
            
        end
      //load instruction
      7'b0000011:begin 
            Reg_Write=1'bX;
            Mem_Write=1'bX;//disable write  memory part
            Mem_Read=1;//enable read memory part
            MemtoReg=1;//disable MUX3
            ALUOp=3'b000;//given in book
            ALUSrc=2'b11;//take 2nd input of alu form imm_gen not form register 
            Branch=0;
            
        end
        //store instruction
        7'b0100011:begin 
            Reg_Write=1'bX;
            Mem_Write=1;//enable write memory part
            Mem_Read=1'bX;//disablered  memory part
            MemtoReg=1'bX;//disable MX3
            ALUOp=3'b000;//doubt
            ALUSrc=2'b11;//take 2nd input of alu form imm_gen not form register 
            Branch=0;
            
        end
        //branch instruction //jal instruction
        7'b1100011:begin 
            Reg_Write=1'bX;
            Mem_Write=1'bX;//disable memory part
            Mem_Read=1'bX;//disable memory part
            MemtoReg=1'bX;//disable MUX3
            ALUOp=3'b001;//doubt
            ALUSrc=2'b00;//take 2nd input of alu form register not form imm_gen MUX2
            Branch=1;
            
        end
        //JAL instruction UJ-type
        7'b1101111:begin 
            Reg_Write=1;
            Mem_Write=1'bX;//disable memory part
            Mem_Read=1'bX;//disable memory part
            MemtoReg=1'b0;//enable MUX3
            ALUOp=3'b100;//doubt
            ALUSrc=2'b10;//take 3rd input of alu form imm_gen not form register MUX2
            Branch=1;
            
        end
        //JALR instruction UJ-type
        7'b1100111:begin 
            Reg_Write=1'bX;
            Mem_Write=1'bX;//disable memory part
            Mem_Read=1'bX;//disable memory part
            MemtoReg=1'bX;//disable MUX3
            ALUOp=3'bXXX;//doubt
            ALUSrc=1'bX;//take 2nd input of alu form imm_gen not form register 
            Branch=1;
        end
        default: begin 
            Reg_Write=1'bX;
            Mem_Write=1'bX;//disable memory part
            Mem_Read=1'bX;//disable memory part
            MemtoReg=1'bX;//disable MUX3
            ALUOp=3'bXXX;//doubt
            ALUSrc=1'bX;//take 2nd input of alu form imm_gen not form register 
            Branch=1'bX;
        end
        endcase
    end
        
    end
    
endmodule
