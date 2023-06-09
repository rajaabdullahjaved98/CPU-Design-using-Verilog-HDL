 module fba
 (
	input [3:0] num1,
	input [3:0] num2,

	input subtract,
	input [1:0] op,

	output [3:0] result,
	output carry

);

assign { carry , result } = ( op == 0 ) ? ( num1 & num2 ):( op == 1 ) ? ( num1 | num2 ):( op == 2 ) ? ( ( subtract == 0 ) ? ( num1 + num2 ) : ( num1 - num2 ) ):( num1 < num2 );

endmodule

module pc
(
	input clk,reset,
	output reg [3:0]out
);
	
	always @(posedge clk)
	begin
		if (reset==1)
   			out <= 0;
		else
 		out <= out+1;
 	end
 endmodule
 
 module control_unit
(
	input [15:0]instruction,
	input clk,
	output reg [1:0]op, //alu
	output reg binv, //alu
	output reg cin, //alu
	output reg wr //dm
);

always @ (*)
begin
	case (instruction[11:8])
	4'b0000:	//AND
	begin
		op<=0;
		binv<=0;
		cin<=0;
		wr<=1;
	end
	4'b0001:	//OR
	begin
		op<=1;
		binv<=0;
		cin<=0;
		wr<=1;
	end
	4'b0010:	//ADD
	begin
		op<=2;
		binv<=0;
		cin<=0;
		wr<=1;
	end
	4'b0101:	//SUB
	begin
		op<=2;
		binv<=1;
		cin<=1;
		wr<=1;
	end
	endcase
	end
endmodule

module reg_file
(
		input [1:0]read_reg1,read_reg2,
		input [1:0]write_reg,
		input [3:0]write_data,
		input rw,
		input rst,clk,
			
		output reg [3:0]data_out1,data_out2
);
reg [3:0]register[3:0];
always@(posedge clk)
begin
	if(rst)
	begin
		register[0]<=2;
		register[1]<=3;
		register[2]<=4;
		register[3]<=5;
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

module ins_mem
(
	input [3:0]address,
	input rst,
	output [15:0]instruction
);
	reg[7:0]memory[15:0];
	
	always @(*)
	begin
		if (rst)
			begin
	
				memory[0] <= 0;
				memory[1] <= 2;
				memory[2] <= 4;
				memory[3] <= 16;
				memory[4] <= 32;
				memory[5] <= 64;
				memory[6] <= 128;
				memory[7] <= 255;
				memory[8] <= 0;
				memory[9] <= 100;
				memory[10] <= 0;
				memory[11] <= 200;
				memory[12] <= 0;
				memory[13] <= 0;
				memory[14] <= 0;
				memory[15] <= 0;
			end
	end
	
	assign instruction = memory[address] ;
endmodule

module memory 
(
	input [3:0] write_data,
	input rw,reset,clk,
	input [3:0] address,
	output reg [3:0] read_data
);
	reg [3:0] mem [15:0];
	
	always @ (posedge clk)
	begin
	if (reset == 0)
	begin
	if (rw == 0)
	begin
	mem [address] <= write_data;
	end
	
	else
	begin
	read_data <= mem [address];
	end
	end
	
	else
	begin
	mem[0] <= 0;
	mem[1] <= 0;
	mem[2] <= 0;
	mem[3] <= 0;
	mem[4] <= 0;
	mem[5] <= 0;
	mem[6] <= 0;
	mem[7] <= 0;
	mem[8] <= 0;
	mem[9] <= 0;
	mem[10] <= 0;
	mem[11] <= 0;
	mem[12] <= 0;
	mem[13] <= 0;
	mem[14] <= 0;
	mem[15] <= 0;
	end
	end
endmodule

module data_path
(
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
 
 	pc ins(clk,rst,address);
 	reg_file ins(instruction[1:0],instruction[3:2],instruction[5:4],rw,rst,clk,result,read_data1,read_data2);
 	fba ins(read_data1,read_data2,subtract,operato,result,carry);
 
 endmodule
