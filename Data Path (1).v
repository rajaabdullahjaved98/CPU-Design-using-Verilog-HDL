module pc(
input clk,reset,
output reg [3:0]out);
always @(posedge clk)
begin
if (reset==1)
   out <= 0;
else
 out <= out+1;
 end
 endmodule
 
 module four_bit_alu
(
	// fba stands for 4-bit alu

	input [3:0] fba_num1,
	input [3:0] fba_num2,

	input fba_substract,
	input [1:0] fba_operation,

	output [3:0] fba_result,
	output fba_carry

);

assign { fba_carry , fba_result } = ( fba_operation == 0 ) ? ( fba_num1 & fba_num2 ):( fba_operation == 1 ) ? ( fba_num1 | fba_num2 ):( fba_operation == 2 ) ? ( ( fba_substract == 0 ) ? ( fba_num1 + fba_num2 ) : ( fba_num1 - fba_num2 ) ):( fba_num1 < fba_num2 );

endmodule


module ins_file(
		input [3:0]address,
		input rst,
		output  [7:0]instruction);
reg [7:0]memory[15:0];
always @(*)
begin
	if(rst==1)
	begin
		memory[0]<=1;
		memory[1]<=2;
		memory[2]<=3;
		memory[3]<=4;
		memory[4]<=5;
		memory[5]<=6;
		memory[6]<=7;
		memory[7]<=8;
		memory[8]<=9;
		memory[9]<=10;
		memory[10]<=11;
		memory[11]<=12;
		memory[12]<=13;
		memory[13]<=14;
		memory[14]<=15;
		memory[15]<=16;
	    
		    
		end
	end
	assign instruction=memory[address];
endmodule

module mem_file(
input [3:0]write_data,
input [3:0]address,
input rw,
input rst,clk,
output reg [3:0]read_data);
reg [3:0]memory[15:0];
always@(posedge clk)
begin
if(rst)
begin
memory[0]<=1;
memory[1]<=2;
memory[2]<=3;
memory[3]<=4;
memory[4]<=5;
memory[5]<=6;
memory[6]<=7;
memory[7]<=8;
memory[8]<=9;
memory[9]<=10;
memory[10]<=11;
memory[11]<=12;
memory[12]<=13;
memory[13]<=14;
memory[14]<=15;
memory[15]<=16;
end
else
begin
if(rw==0)
begin
memory[address]<=write_data;
end
else
begin
read_data<=memory[address];
end
end
end
endmodule

 
 module reg_file(
		input [1:0]read_reg1,read_reg2,
		input [1:0]write_reg,
		input rw,
		input rst,clk,
		input [3:0]write_data,
		output reg [3:0]data_out1,data_out2);
reg [3:0]register[3:0];
always@(posedge clk)
begin
	if(rst)
	begin
		register[0]<=2;
		register[1]<=3;
		register[2]<=5;
		register[3]<=9;
	end
	else
	begin
		if(rw==0)
		begin
			register[write_reg]<=write_data;
		end
		else
		begin
			data_out1<=register[read_reg1];
			data_out2<=register[read_reg2];
		end
	end
end
endmodule



module data_path(
 input clk,rst,rw,
 input [15:0]instruction,
 input [1:0]operato,
 input subtract,
 output  [3:0]address,
 output [3:0]result,
 output carry
 );
 
 wire [3:0]read_data1;
 wire [3:0]read_data2;
 
 pc on1(clk,rst,address);
 reg_file on2(instruction[1:0],instruction[3:2],instruction[5:4],rw,rst,clk,result,read_data1,read_data2);
 four_bit_alu on3(read_data1,read_data2,subtract,operato,result,carry);
 
 endmodule
 
 module datap ();
 reg  clk,rst,rw;
 reg [15:0]instruction;
 reg [1:0]operato;
 reg subtract;
 wire [3:0]address;
 wire [3:0]result;
 wire carry;
 
 data_path dp(clk,rst,rw,instruction,operato,subtract,address,result,carry);
 always
 #3 clk=~clk;
 initial begin 
 rst=1; clk=0;
 #4 rst=0; 
 # 15 instruction=0; operato=2; subtract=0;  rw=1;
  # 15 instruction=1; operato=1; subtract=1;  rw=1;
 end 
 endmodule