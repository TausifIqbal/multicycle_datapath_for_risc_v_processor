module Registers(
    //control pins
    input Reg_Write,
    input clk,
    input [2:0] sel,

    //reading pins in registers
    input [4:0]Read_Register1,
    input [4:0]Read_Register2,
    output reg [63:0]Read_Data1,
    output reg [63:0]Read_Data2,
    //writing pins in registers
    input [63:0]Write_Data,
    input [4:0]Write_Register 
    );
    
    reg[63:0] i=0;
    reg[63:0] j=0;
    reg [63:0] reg_array [63:0];
    integer outfile;
    integer outfile1;
    
 //-----------------------------------------scanning text_file for reading -----------------------------------------------
    always @ (posedge clk ) begin
        if(sel==1 )begin
            outfile = $fopen("reg.txt", "r");
            if (outfile == 0) begin
            $display("reg.txt handle was NULL");
            $finish;
            end
            else begin
            while (! $feof(outfile)) begin
                $fscanf(outfile,"%b\n",reg_array[i]);
                i=i+1;
            end
        end
        $fclose(outfile);
        end
    end
        //-----------reading-----------
    always@(*) begin
        if(sel==1)begin
        Read_Data2= reg_array[Read_Register2];
        Read_Data1 = reg_array[Read_Register1];
        end

    end
//-------------------------------------------writing-----------------------------------------
    always @ (posedge clk) begin
        if(sel==4 && Reg_Write==1) begin
            reg_array[Write_Register] =Write_Data;
            $display(" storing into reg file after doing operation");
            $display("Reg_write_dest %b and reg_write_data in reg file %b\n\n",Write_Data,Write_Register);
            outfile1 = $fopen("reg.txt", "w");
            for (j = 0; j<=63; j=j+1)begin
                $fwrite(outfile1,"%b\n",reg_array[j]);
            end
            $fclose(outfile1);
        end
    end
endmodule
