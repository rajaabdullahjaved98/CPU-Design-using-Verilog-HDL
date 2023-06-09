module control_unit
(
	input [15:0]instruction,
	input clk,
	output reg [1:0]op,
	output reg binv,
	output reg cin,
	output reg mrd,
	output reg mwr,
	output reg wr
);

always @ (*)
begin
	case (instruction[11:8])
	4'b0000:	//AND
	begin
		op<=0;
		binv<=0;
		cin<=0;
		mrd<=1;
		mwr<=0;
		wr<=1;
	end
	4'b0001:	//OR
	begin
		op<=1;
		binv<=0;
		cin<=0;
		mrd<=0;
		mwr<=1;
		wr<=1;
	end
	4'b0010:	//ADD
	begin
		op<=2;
		binv<=0;
		cin<=0;
		mrd<=1;
		mwr<=0;
		wr<=1;
	end
	4'b0101:	//SUB
	begin
		op<=2;
		binv<=1;
		cin<=1;
		mrd<=0;
		mwr<=1;
		wr<=1;
	end
	endcase
	end
endmodule

	
module test_control_unit ();
	
	reg[15:0]instruction;
	reg clk;
	wire[1:0]op;
	wire binv;
	wire cin;
	wire mrd;
	wire mwr;
	wire wr;
	
control_unit obj (instruction,clk,op,binv,cin,mrd,mwr,wr);
initial
begin
#30 instruction=16'b0000000000000000;
#30 instruction=16'b0000000100000000;
#30 instruction=16'b0000001000000000;
#30 instruction=16'b0000010100000000;
end
endmodule
