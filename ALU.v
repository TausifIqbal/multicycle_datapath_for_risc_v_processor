module ALU(
    input clk,
    input [2:0] sel,
    input [63:0] Read_data_1,
    input [63:0] Read_data_2,
    input [63:0] inst_address,
    input [63:0] immediate,
    input [3:0] ALU_control_lines,
    input [1:0]ALUSrc,
    output reg zero,
    output reg [63:0] ALU_result           
    );
    reg [63:0] data2;
    always@(*)
    
    begin
        if(sel==2)begin
            $display(" ALU ");
            if(ALUSrc==2'b11) data2[63:0]=immediate[63:0];
            else if(ALUSrc==2'b00) data2[63:0]=Read_data_2[63:0];
            if(ALUSrc==2'b10)begin ALU_result=inst_address+4;$display(" ALU jal %b",inst_address+4); end 
           
           
            case(ALU_control_lines)
            4'b0000: begin ALU_result=data2 - Read_data_1;//subtract
                            
                     end 
            4'b0001: ALU_result=data2 + Read_data_1; //add
            4'b0010: ALU_result=data2 & Read_data_1; //AND
            4'b0011: ALU_result=data2 | Read_data_1; //or
            4'b0100: ALU_result=data2 ^ Read_data_1; //xor
            4'b1001: ALU_result=data2 + Read_data_1; //addi
            4'b1010: ALU_result=data2 & Read_data_1; //ANDi
            4'b1011: ALU_result=data2 | Read_data_1; //ori
            4'b1100: ALU_result=data2 ^ Read_data_1; //xori
            4'b0101: ALU_result= Read_data_1<<data2; //slli
            4'b0100: ALU_result=Read_data_1>>data2; //srli
            4'b0100: ALU_result=$signed(Read_data_1)>>>data2; //srai
            
            endcase 
            
            
        end
    end
    
endmodule
