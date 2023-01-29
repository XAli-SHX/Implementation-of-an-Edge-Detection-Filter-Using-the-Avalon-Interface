/******************************************************************************
 * License Agreement                                                          *
 *                                                                            *
 * Copyright (c) 1991-2013 Altera Corporation, San Jose, California, USA.     *
 * All rights reserved.                                                       *
 *                                                                            *
 * Any megafunction design, and related net list (encrypted or decrypted),    *
 *  support information, device programming or simulation file, and any other *
 *  associated documentation or information provided by Altera or a partner   *
 *  under Altera's Megafunction Partnership Program may be used only to       *
 *  program PLD devices (but not masked PLD devices) from Altera.  Any other  *
 *  use of such megafunction design, net list, support information, device    *
 *  programming or simulation file, or any other related documentation or     *
 *  information is prohibited for any other purpose, including, but not       *
 *  limited to modification, reverse engineering, de-compiling, or use with   *
 *  any other silicon devices, unless such use is explicitly licensed under   *
 *  a separate agreement with Altera or a megafunction partner.  Title to     *
 *  the intellectual property, including patents, copyrights, trademarks,     *
 *  trade secrets, or maskworks, embodied in any such megafunction design,    *
 *  net list, support information, device programming or simulation file, or  *
 *  any other related documentation or information provided by Altera or a    *
 *  megafunction partner, remains with Altera, the megafunction partner, or   *
 *  their respective licensors.  No other licenses, including any licenses    *
 *  needed under any third party's intellectual property, are provided herein.*
 *  Copying or modifying any file, or portion thereof, to which this notice   *
 *  is attached violates this copyright.                                      *
 *                                                                            *
 * THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *
 * FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS  *
 * IN THIS FILE.                                                              *
 *                                                                            *
 * This agreement shall be governed in all respects by the laws of the State  *
 *  of California and by the laws of the United States of America.            *
 *                                                                            *
 ******************************************************************************/


module altera_up_edge_detection_sobel_operator (
	// Inputs
	clk,
	reset,

	data_in,
	data_en,

	// Bidirectionals

	// Outputs
	data_out
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

parameter WIDTH	= 640; // Image width in pixels

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;

input			[ 8: 0]	data_in;
input						data_en;

// Bidirectionals

// Outputs
output		[ 9: 0]	data_out;

/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire			[ 8: 0]	shift_reg_out[ 1: 0];

// Internal Registers
reg			[ 8: 0]	original_line_1[ 2: 0];
reg			[ 8: 0]	original_line_2[ 2: 0];
reg			[ 8: 0]	original_line_3[ 2: 0];

reg			[11: 0]	gx_level_1[ 3: 0];
reg			[11: 0]	gx_level_2[ 1: 0];
reg			[11: 0]	gx_level_3;

reg			[11: 0]	gy_level_1[ 3: 0];
reg			[11: 0]	gy_level_2[ 1: 0];
reg			[11: 0]	gy_level_3;

reg			[11: 0]	gx_magnitude;
reg			[11: 0]	gy_magnitude;

reg			[ 1: 0]	gx_sign;
reg			[ 1: 0]	gy_sign;

reg			[11: 0]	g_magnitude;
reg						gy_over_gx;

reg			[ 9: 0]	result;

// State Machine Registers

// Integers
integer					i;

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

// Sobel Operator
// 
//      [ -1  0  1 ]           [  1  2  1 ]
// Gx   [ -2  0  2 ]      Gy   [  0  0  0 ]
//      [ -1  0  1 ]           [ -1 -2 -1 ]
//
// |G| = |Gx| + |Gy|

always @(posedge clk)
begin
	if (reset == 1'b1)
	begin
		for (i = 2; i >= 0; i = i-1)
		begin
			original_line_1[i] <= 9'h000;
			original_line_2[i] <= 9'h000;
			original_line_3[i] <= 9'h000;
		end

		gx_level_1[0] <= 12'h000;
		gx_level_1[1] <= 12'h000;
		gx_level_1[2] <= 12'h000;
		gx_level_1[3] <= 12'h000;
		gx_level_2[0] <= 12'h000;
		gx_level_2[1] <= 12'h000;
		gx_level_3	  <= 12'h000;

		gy_level_1[0] <= 12'h000;
		gy_level_1[1] <= 12'h000;
		gy_level_1[2] <= 12'h000;
		gy_level_1[3] <= 12'h000;
		gy_level_2[0] <= 12'h000;
		gy_level_2[1] <= 12'h000;
		gy_level_3	  <= 12'h000;

		gx_magnitude  <= 12'h000;
		gy_magnitude  <= 12'h000;

		gx_sign		  <= 2'h0;
		gy_sign		  <= 2'h0;

		g_magnitude	  <= 12'h000;
		gy_over_gx	  <= 1'b0;

		result		  <= 9'h000;
	end
	else if (data_en == 1'b1)
	begin	
		for (i = 2; i > 0; i = i-1)
		begin
			original_line_1[i] <= original_line_1[i-1];
			original_line_2[i] <= original_line_2[i-1];
			original_line_3[i] <= original_line_3[i-1];
		end
		original_line_1[0] <= data_in;
		original_line_2[0] <= shift_reg_out[0];
		original_line_3[0] <= shift_reg_out[1];

		// Calculate Gx
		gx_level_1[0] <= {3'h0,original_line_1[0]} + {3'h0,original_line_3[0]};
		gx_level_1[1] <= {2'h0,original_line_2[0], 1'b0};
		gx_level_1[2] <= {3'h0,original_line_1[2]} + {3'h0,original_line_3[2]};
		gx_level_1[3] <= {2'h0,original_line_2[2], 1'b0};

		gx_level_2[0] <= gx_level_1[0] + gx_level_1[1];
		gx_level_2[1] <= gx_level_1[2] + gx_level_1[3];

		gx_level_3    <= gx_level_2[0] - gx_level_2[1];

		// Calculate Gy
		gy_level_1[0] <= {3'h0,original_line_1[0]} + {3'h0,original_line_1[2]};
		gy_level_1[1] <= {2'h0,original_line_1[1], 1'b0};
		gy_level_1[2] <= {3'h0,original_line_3[0]} + {3'h0,original_line_3[2]};
		gy_level_1[3] <= {2'h0,original_line_3[1], 1'b0};

		gy_level_2[0] <= gy_level_1[0] + gy_level_1[1];
		gy_level_2[1] <= gy_level_1[2] + gy_level_1[3];

		gy_level_3    <= gy_level_2[0] - gy_level_2[1];
		
		// Calculate the magnitude and sign of Gx and Gy
		gx_magnitude  <= (gx_level_3[11]) ? (~gx_level_3) + 12'h001 : gx_level_3; 
		gy_magnitude  <= (gy_level_3[11]) ? (~gy_level_3) + 12'h001 : gy_level_3; 

		gx_sign		  <= {gx_sign[0], gx_level_3[11]};
		gy_sign		  <= {gy_sign[0], gy_level_3[11]};

		// Calculate the magnitude G
		g_magnitude	  <= gx_magnitude + gy_magnitude;
		gy_over_gx	  <= (gx_magnitude >= gy_magnitude) ? 1'b0 : 1'b1;

		// Calculate the final result
		result[9]	  <= gx_sign[1] ^ gy_sign[1];
		result[8]	  <= gx_sign[1] ^ gy_sign[1] ^ gy_over_gx;
		result[7:0]	  <= (g_magnitude[11:10] == 2'h0) ? g_magnitude[9:2] : 8'hFF;
	end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign data_out = result; 

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

altera_up_edge_detection_data_shift_register shift_register_1 (
	// Inputs
	.clock		(clk),
	.clken		(data_en),
	.shiftin		(data_in),

	// Bidirectionals

	// Outputs
	.shiftout	(shift_reg_out[0]),
	.taps			()
);
defparam 
	shift_register_1.DW		= 9,
	shift_register_1.SIZE	= WIDTH;

altera_up_edge_detection_data_shift_register shift_register_2 (
	// Inputs
	.clock		(clk),
	.clken		(data_en),
	.shiftin		(shift_reg_out[0]),

	// Bidirectionals

	// Outputs
	.shiftout	(shift_reg_out[1]),
	.taps			()
);
defparam
	shift_register_2.DW		= 9,
	shift_register_2.SIZE	= WIDTH;

endmodule

