module Decoder(
input clk,
input sel,
input [31:0]instruction,
output  [4:0]Read_Register1,
output  [4:0]Read_Register2,
output  [4:0]Write_Register,
output  [6:0]opcode,
output  [6:0]funct7,
output  [2:0]funct3
);

        assign    Read_Register1=instruction[19:15];
        assign    Write_Register=instruction[11:7];
        assign    opcode=instruction[6:0];
        assign    funct7=instruction[31:25];
        assign    Read_Register2=instruction[24:20];
        assign    funct3=instruction[14:12];
endmodule

