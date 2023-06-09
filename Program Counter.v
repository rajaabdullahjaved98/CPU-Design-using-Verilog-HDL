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

module testpc ();
	reg clk,rst;
	wire [3:0]out;
	
pc obj (clk,rst,out);

	always
	#3 clk = ~clk;
	
	initial
	begin
	clk = 0;rst = 1;
	#30 rst = 0;					
	end
endmodule	
