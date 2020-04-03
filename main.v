module Risc_v( );
    reg clk;
    wire [31:0] instruction;
    reg [31:0] pc;
    wire [63:0] Read_Data1;
    wire [63:0] Read_Data2;
    wire [63:0]  ALU_result ;
    wire [63:0] Read_Data;
    wire [63:0] Write_Data;
    reg [63:0]Write_DataR;
    wire [63:0] Write_DataM;
    wire [63:0] inst_address;
    reg [2:0] counter;
    wire [6:0]opcode;
    wire [6:0]funct7;
    wire [2:0]funct3;
    
    
//register pins
    
    wire [4:0] Write_Register;
    wire [4:0] Read_Register1; 
    wire [4:0] Read_Register2;
   // wire [63:0] Read_Data1;
    //wire [63:0] Read_Data2;
    //wire [63:0] Write_Data;
//ALU pins
    //wire [63:0]  ALU_result ;
    wire [63:0] immediate;
        //wire [63:0] Read_Data1;
        //wire [63:0] Read_Data2;
    wire [3:0] ALU_control_lines;
    wire [1:0]ALUSrc;
    wire zero;
    
//memory pins
    wire Mem_Write;
    wire Mem_Read;
    wire [63:0] Address; 
    //wire [63:0] Write_DataM;
    //wire [63:0] Read_Data;
// alu control pins
    wire [2:0]ALUOp; 
    //wire [3:0] ALU_control_lines;
    //wire [6:0]funct7;
    //wire [2:0]funct3;
//control pins
    wire Reg_Write;
    wire MemtoReg;
    wire Branch;
    // wire [1:0]ALUOp; 
    //wire Mem_Write;
    //wire Mem_Read;
    // wire Reg_Write;
    //wire ALUSrc;
//_____________________decoder________________________________________
Decoder d
(
    .sel(counter),   
    .clk(clk),
    .instruction(instruction),
    .Read_Register1(Read_Register1),
    .Read_Register2(Read_Register2),
    .Write_Register(Write_Register),
    .opcode(opcode),
    .funct7(funct7),
    .funct3(funct3)
    );

//________________________instruction memory_____________________________
InstructionMemory inst
(   .sel(counter),   
    .clk(clk),  
    .ReadAddress(pc),
    .instruction(instruction)
    );
//_______________________immediata generate____________________________
ImmGen imm(
   .instruction(instruction),
   .immediate(immediate)
    );
//____________________________memory____________________________________
DataMemory mem
(  
    .Mem_Write(Mem_Write),
    .Mem_Read(Mem_Read),
    .sel(counter),   
    .clk(clk),       
    .Address(Address),
    .Read_Data(Read_Data),
    .Write_DataM(Write_DataM),
    .MemtoReg(MemtoReg)
    );
    always @(posedge clk) begin
        if(counter==3)
         Write_DataR<=Read_Data;
    end
    assign Write_Data=Read_Data;
    assign Write_DataM=Read_Data2;
    
//___________________________reg_____________________________________
Registers reg_file
( 
    .Reg_Write(Reg_Write),
    .clk(clk),
    .sel(counter),
    .Read_Register1(Read_Register1),
    .Read_Register2(Read_Register2),
    .Read_Data1(Read_Data1),
    .Read_Data2(Read_Data2),  //assign Write_Data=Read_Data;
    .Write_Data(Write_Data),
    .Write_Register(Write_Register) 
    );

//_________________________________ALU______________________________

ALU alu
(
    .inst_address(inst_address),
    .clk(clk),
    .sel(counter),
    .Read_data_1(Read_Data1),
    .Read_data_2(Read_Data2),
    .immediate(immediate),
    .ALU_control_lines(ALU_control_lines),
    .ALUSrc(ALUSrc),
    .zero(zero),
    .ALU_result(ALU_result)           
    );
    assign Address=ALU_result;
    assign inst_address=pc;
/////////////////////////////////////////////////////////////////////////////////////////
//____________________________control signal___________________________________________

//___________________________ALU control______________________________________________
ALUControl alucontrol(
    .clk(clk),
    .sel(counter),
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .ALU_control_lines(ALU_control_lines)
    );
//_____________________________________control____________________________________________
Control control(
    .sel(counter),
    .clk(clk),
    .opcode(opcode),
    .Branch(Branch),
    .Mem_Read(Mem_Read),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .Mem_Write(Mem_Write),
    .ALUSrc(ALUSrc),
    .Reg_Write(Reg_Write)
    //output Reg_Read
    );
////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------clock generation---------------------------------
always
begin
#1 clk=~clk;
end
//--------------------------------------- initializing variable ---------------------------
initial
    begin
    counter=0;
    pc=0;
    clk=0;
    #630;$finish;
end
//-----------------------------------------initializing counter ---------------------------
always @(posedge clk) begin
    if(counter!=4)
        counter<=counter+1;
    else begin
        counter<=0;  
    end

end
//merge counter with pc
//---------------------------------------pc--branch and jalr jal--------------------------------------------
always @(posedge clk)begin
        if(Branch==1 && counter ==4)begin
            if(opcode==7'b1100011)begin //branch case
            case(funct3)//donot do pipelined instruction remove counter<=0;
                3'b000: begin 
                            if(Read_Data2== Read_Data1)begin pc=pc+immediate;end 
                            else if(counter ==4)begin pc=pc+4;end
                        end //beq
                3'b001: begin 
                        if(Read_Data2 != Read_Data1) begin pc=pc+immediate; /*counter<=0;*/end 
                        else if(counter ==4)begin pc=pc+4;  end
                        end  //bne
                3'b100: begin 
                            if(Read_Data2 < Read_Data1) begin pc=pc+immediate;/*counter<=0;*/end 
                            else if(counter ==4)begin pc=pc+4;  end
                            end  //blt
                3'b101: begin if(Read_Data2 >= Read_Data1) begin pc=pc+immediate;/*counter<=0;*/end 
                              else if(counter ==4)begin pc=pc+4;  end      
                        end //bge
         
                endcase
            end
            
            else if(opcode==7'b1101111)begin//jal case
                pc=pc+immediate;
            end
            else if(opcode==7'b1100111 && funct3==3'b000)begin//jalr case
                
                pc=Read_Data1;
            end
       
            
        end
        else if(counter ==4) begin
                pc=pc+4;
            end
end
//---------------------------------------------steps--------------------------------------
always @(posedge clk) begin
    if(counter==1 )begin
    //instruction <= inst_array[pc];
//$fscanf(data_file, "%b\n ", instruction);
        $display("\nfetching");
        $display("pc %b",pc);
        $display("instruction %b",instruction);
    end
    if(counter==2)begin
        $display("decoding");
    end
    if(counter==3)begin
        $display("doing ALU operation");
    end
    if(counter==4)begin
        $display("excess memory");
    end
    if(counter==5)begin
        
        $display("writing back");
    end
end

endmodule
