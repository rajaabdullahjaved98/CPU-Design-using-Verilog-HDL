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


module test_rf();

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