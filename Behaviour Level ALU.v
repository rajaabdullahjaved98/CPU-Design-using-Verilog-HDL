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