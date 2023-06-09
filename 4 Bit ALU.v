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

module alu4btest	();
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


