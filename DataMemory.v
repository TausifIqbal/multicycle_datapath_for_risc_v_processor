module DataMemory(
    //control pins
    input Mem_Write,
    input Mem_Read,
    input [2:0]sel,   //cycle number
    input clk,   //clock
        
    input [63:0] Address,
    input [63:0] Write_DataM,
    output reg [63:0] Read_Data,
    //Mux to control input
   
    input MemtoReg
  
    
    );
    reg[63:0] i=0;
    reg[63:0] j=0;
    reg [63:0] mem_array [63:0];
    integer outfile3; //two memory location
    integer outfile2;
//-----------------------------------------scanning text_file for reading ------------------------------------------------
    always @ (posedge clk ) begin
        if(sel==2)begin
            outfile2 = $fopen("mem.txt", "r");
        if (outfile2 == 0) begin
            $display("mem.txt handle was NULL");
            $finish;
        end
        else begin
        while (! $feof(outfile2)) begin
            $fscanf(outfile2,"%b\n",mem_array[i]);
            i=i+1;
            end
        end
        $fclose(outfile2);
        end
    end
                        //--------reading from memroy-----
    always @ (*) begin
        
        if(sel==3 )begin
            if(Mem_Read==1 && MemtoReg==1)begin
                Read_Data= mem_array[Address/8];
                $display(" reg_write_data %b",Read_Data);
            end
            if(MemtoReg==1'b0 )begin 
                Read_Data= Address;
                $display(" reg_write_data %b",Read_Data);
            end
        end
    end      
//-------------------------------------------writing-----------------------------------------
    always @ (* ) begin
        if(sel==3 && Mem_Write==1) begin
            mem_array[Address/8] = Write_DataM;
            $display("storing back into memory");
            $display(" store_data %b",Write_DataM);
            outfile3 = $fopen("mem.txt", "w");
            for (j = 0; j<=63; j=j+1)begin
                $fwrite(outfile3,"%b\n",mem_array[j]);
            end
        $fclose(outfile3);
        end
    end        
endmodule
