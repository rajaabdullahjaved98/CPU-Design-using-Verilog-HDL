module new4b
(
	input[3:0]no1,
	input[3:0]no2,
	input sub,
	input[1:0]oper,
	output[3:0]res,
	output carry
);

	assign{carry,res}=(oper==0)?(no1&no2):(oper==1)?(no1|no2):(oper==2)?((sub==0)?(no1+no2):(no1-no2)):(no1<no2);
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
	input binv,
	input [15:0]instruction,
	output [3:0]data_address,
	output [3:0]address
);
	wire [3:0]w1,w2,w3;
	wire w4;
	assign w4=0;
	pc obj (clk,rst,address);
	reg_file obj1 (instruction[1:0],instruction[3:2],instruction[5:4],data_address,rw,rst,clk,w1,w2);
	new4b obj2 (w1,w2,binv,opcode,data_address,w4);
endmodule

module test_dp ();

	reg clk,rst,rw;
	reg [1:0]opcode;
	reg binv;
	reg [15:0]instruction;
	wire [3:0]data_address;
	wire [3:0]address;
	
datapath obj (clk,rst,rw,opcode,binv,instruction,data_address,address);
always
#3 clk =	~clk;

initial begin
rst=1; clk=0;
#3 rst =0;
#10 instruction=0;	opcode=0; binv=0;rw=1;
#10 instruction=1;rw=1;
#10 opcode=1;
#10 opcode=2;
#10 opcode=3;
end
endmodule

