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


module pc 
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

module reg_file(
		input [1:0]read_reg1,read_reg2,
		input [1:0]write_reg,
		input [3:0]write_data,
		input rw,
		input rst,clk,
			
		output reg [3:0]data_out1,data_out2);
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

module datapath
(
	input clk,rst,rw,
	input [1:0]opcode,
	input binv,cin,
	input [15:0]instruction,
	output [3:0]data_address,
	output [3:0]address
);
	wire [3:0]w1,w2,w3;
	wire w4;
	assign w4=0;
	pc obj (clk,rst,address);
	reg_file obj1 (instruction[1:0],instruction[3:2],instruction[5:4],w3,rw,rst,clk,w1,w2);
	alu4b obj2 (w1,w2,binv,cin,opcode,w3,w4);
endmodule

module test_dp ();

	reg clk,rst,rw;
	reg [1:0]opcode;
	reg binv,cin;
	reg [15:0]instruction;
	wire [3:0]data_address;
	wire [3:0]address;
	
datapath obj (clk,rst,rw,opcode,binv,cin,instruction,data_address,address);
always
#3 clk =	~clk;

initial begin
rst=1; clk=0;
#3 rst =0;
#10 instruction=0;	opcode=0; binv=0; cin=0;rw=1;
#10 instruction=1;rw=1;
#10 opcode=1;
#10 opcode=2;
#10 opcode=3;
end
endmodule

