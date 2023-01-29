//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on

module fpoint_wrapper (
		clk,
		clk_en,
		dataa,
		datab,
		n,
		reset,
		start,
		
		done,
		result
);

	output           done;
	output  [ 31: 0] result;
	input            clk;
	input            clk_en;
	input   [ 31: 0] dataa;
	input   [ 31: 0] datab;
	input   [  1: 0] n;
	input            reset;
	input            start;

	wire		done;
	wire	[ 31: 0] result;

	parameter useDivider = 0;

	generate
		if (useDivider)
			begin
				fpoint_hw_qsys fpoint_instance (
					.clk(clk),
					.clk_en(clk_en),
					.dataa(dataa),
					.datab(datab),
					.n(n),
					.reset(reset),
					.start(start),
					.done(done),
					.result(result)
				);
			end
		else
			begin
				fpoint_qsys fpoint_instance (
					.clk(clk),
					.clk_en(clk_en),
					.dataa(dataa),
					.datab(datab),
					.n(n),
					.reset(reset),
					.start(start),
					.done(done),
					.result(result)
				);	
			end
	
	endgenerate


endmodule

