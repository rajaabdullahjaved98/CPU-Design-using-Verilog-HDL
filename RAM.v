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

module memory_test ();
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

