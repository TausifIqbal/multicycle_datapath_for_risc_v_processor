module ALUControl(
    input clk,
    input[2:0] sel,
    input [2:0] ALUOp,
    
    input [2:0]funct3,
    input [6:0]funct7,
    output reg [3:0]ALU_control_lines
    );
    always @(sel==0)begin
        case(ALUOp)
            3'b000: begin ALU_control_lines=4'b0001; $display(" load / store, action ==add ");end
            3'b100: begin ALU_control_lines=4'bxxxx; $display(" jal, action "); end
            3'b001: begin ALU_control_lines=4'b0000; $display(" branch, action ==subtract "); end
            3'b010: begin
                        case(funct3)
                            3'b000: begin if(funct7==7'b0100000)
                                           begin ALU_control_lines=4'b0000;  $display(" r-type, action ==subtract ");end
                                           else if(funct7==7'b0000000) begin ALU_control_lines=4'b0001;  $display(" r-type, action ==add ");end
                                     end
                            3'b111:  begin ALU_control_lines=4'b0010;  $display(" r-type, action ==and ");end
                            3'b110: begin ALU_control_lines=4'b0011;  $display(" r-type, action ==or ");end 
                            3'b100: begin ALU_control_lines=4'b0100;  $display(" r-type, action ==xor ");end 
                        endcase
                       
                        
                    end
            3'b011: begin
                        case(funct3)
                            3'b000: begin ALU_control_lines=4'b1001;  $display(" i-type, action ==addi ");end
                            3'b111: begin ALU_control_lines=4'b1010;  $display(" i-type, action ==andi ");end
                            3'b110: begin ALU_control_lines=4'b1011;  $display(" i-type, action ==ori ");end 
                            3'b100: begin ALU_control_lines=4'b1100;  $display(" i-type, action ==xori ");end 
                            3'b001: begin if(funct7==7'b0000000) begin ALU_control_lines=4'b0101;  $display(" i-type, action ==slli ");end end
                            3'b101: begin if(funct7==7'b0000000) begin ALU_control_lines=4'b0110;  $display(" i-type, action ==srli ");end end
                            3'b101: begin if(funct7==7'b0100000) begin ALU_control_lines=4'b0111;  $display(" i-type, action ==srai ");end end
                        endcase
                    end
           
        endcase
    end
  
    
    
endmodule
