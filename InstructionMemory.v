module InstructionMemory(
    input clk,
    input sel,
    input [31:0] ReadAddress,
    output reg [31:0] instruction
    );
    integer i=0;
    integer data_file;
    wire [31:0] inst_array [31:0];
    //------------------opening instruction file and loading into inst-array
    initial begin 
            data_file=$fopen("data_file.txt", "r");
            i=0;
            if (data_file == 0) begin
            $display("data_file.txt handle was NULL");
            $finish;
            end
            else begin
                while (! $feof(data_file)) begin
                $fscanf(data_file,"%b\n",inst_array[i]);
                $display("inst %d- %b",i,inst_array[i]);
                i=i+1;
                end
           end
    end
    //--------------taking instruciton from InstrucitonMemory
    always@(posedge clk)
    
    begin
        if(sel==0)begin instruction = inst_array[ReadAddress/4];
                    end
    end
endmodule
