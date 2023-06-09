module four_bit_alu
(
	// fba stands for 4-bit alu

	input [3:0] fba_num1,
	input [3:0] fba_num2,

	input fba_substract,
	input [1:0] fba_operation,

	output [3:0] fba_result,
	output fba_carry

);

assign { fba_carry , fba_result } = ( fba_operation == 0 ) ? ( fba_num1 & fba_num2 ):
										( fba_operation == 1 ) ? ( fba_num1 | fba_num2 ):
										( fba_operation == 2 ) ? ( ( fba_substract == 0 ) ? ( fba_num1 + fba_num2 ) : ( fba_num1 - fba_num2 ) ):
										( fba_num1 < fba_num2 );

endmodule