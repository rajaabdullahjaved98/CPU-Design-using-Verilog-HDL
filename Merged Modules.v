module program_counter 
(
	input clk,rst,
	output reg [3:0]out
);
	always @(posedge clk)
	begin
	if (rst == 1)
		out <= 0;
	else
		out <= out + 1;
	end
endmodule

module mux4_2
(
	input [1:0]s,
	input a,b,c,d,
	output out
);
	assign out = (s==0)?a:(s==1)?b:(s==2)?c:d;
endmodule

module mux2_1
(
	input s,
	input a,b,
	output out
);
	assign out = (s==0)?a:b;
endmodule

module fa
(
	input a,b, cin,
	output s,cout
);
	assign {cout,s} = a+b+cin;
endmodule

module alu1b
(
	input a,b,binv,cin,
	input [1:0]op,
	input less,
	output s,cout
);
	wire w1,w2,w3,w4,w5;
	not b1(w1,b);
	mux2_1 i(binv,a,w1,w2);
	fa j(a,w2,binv,w3,cout);
	and a1(w4,a,b);
	or o1(w5,a,b);
	mux4_2 k(op,w4,w5,w3,less,s);
endmodule

module alu_msb
(
	input a,b,binv,cin,
	input [1:0]op,
	input less,
	output out,cout,
	output set
);
	wire w6,w1,w2,w3,w4,w5;
	not b1(w1,b);
	mux2_1 i1(binv,b,w1,w2);
	fa j1(a,w2,cin,set,cout);
	and a11(w4,a,b);
	or o11(w5,a,b);
	mux4_2 k1(op,w4,w5,set,less,out);
endmodule	

module alu4b
(
	input [3:0]a,
	input [3:0]b,
	input binv,cin,
	input [1:0]operation,
	output [3:0]res,
	output cout
);
	wire w1,w2,w3,w4,w5;
	assign w5=0;
	alu1b obj1 (a[0],b[0],binv,cin,operation,w4,res[0],w1);
	alu1b obj2 (a[1],b[1],binv,w1,operation,w5,res[1],w2);
	alu1b obj3 (a[2],b[2],binv,w2,operation,w5,res[2],w3);
	alu_msb obj (a[3],b[3],binv,w3,operation,w5,res[3],cout,w4);
endmodule

module ins_mem
(
	input [3:0]address,
	input rst,
	output [7:0]instruction
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
		register[0]<=0;
		register[1]<=0;
		register[2]<=0;
		register[3]<=0;
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


module merge_test_program_counter ();
	reg clk,rst;
	wire [3:0]out;
	
program_counter obj (clk,rst,out);

	always
	#3 clk = ~clk;
	
	initial
	begin
	clk = 0;rst = 1;
	#30 rst = 0;					
	end
endmodule	

module merge_alu_4b_test	();
	reg[3:0]a;
	reg[3:0]b;
	reg binv,cin;
	reg [1:0] operation;
	wire [3:0]res;
	wire cout;

alu4b obj (a,b,binv,cin,operation,res,cout);
initial
begin
	a=5;b=3;operation=2;binv=0;cin=0;
	#30 operation=2;binv=1;cin=1;
	#30 operation=3;
	#30 a=5;b=6;
end
endmodule	

module merge_test_im ();
reg [3:0]address;
reg rst;
wire [7:0]instruction;

ins_mem obj(address,rst,instruction);
initial
begin
#30 rst = 1;address = 5;
#30 address = 6;
end
endmodule

module merge_memory_test ();
	reg[3:0] write_data;
	reg rw,reset,clk;
	reg [3:0] address;
	wire [3:0] read_data;

memory mem (write_data,rw,reset,clk,address,read_data);
	always
	#3 clk = ~clk;
	initial
	begin
	reset = 1;
	#30 reset = 0; clk = 0;
	#30 rw = 0; write_data = 5; address = 4;
	#30 rw = 1; address = 4;
	end
endmodule	

module merge_test_rf();

reg [1:0]read_reg1,read_reg2;
reg [1:0]write_reg;
reg rw;
reg rst,clk;
reg [3:0]write_data;
wire [3:0]data_out1,data_out2; 

reg_file rf(read_reg1,read_reg2,write_reg,rw,rst,clk,write_data,data_out1,data_out2);

always
#1 clk=~clk;

initial begin
rst=1; clk=0;
#10 rst=0;
#10 rw=1; read_reg1=1; read_reg2=3;
#10 rw=0; write_reg=1; write_data=5;
#10 rw=0; write_reg=3; write_data=15;
#10 rw=1; read_reg1=1; read_reg2=3;
end
endmodule   
