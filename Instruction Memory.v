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

module test_im ();
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
