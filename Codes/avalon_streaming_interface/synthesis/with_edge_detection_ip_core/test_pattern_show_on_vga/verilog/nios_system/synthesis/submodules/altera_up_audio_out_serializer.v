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

/******************************************************************************
 *                                                                            *
 * This module writes data to the Audio DAC on the Altera DE2 board.          *
 *                                                                            *
 ******************************************************************************/

module altera_up_audio_out_serializer (
	// Inputs
	clk,
	reset,
	
	bit_clk_rising_edge,
	bit_clk_falling_edge,
	left_right_clk_rising_edge,
	left_right_clk_falling_edge,
	
	left_channel_data,
	left_channel_data_en,

	right_channel_data,
	right_channel_data_en,
	
	// Bidirectionals

	// Outputs
	left_channel_fifo_write_space,
	right_channel_fifo_write_space,

	serial_audio_out_data
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

parameter DW = 15;

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;

input						bit_clk_rising_edge;
input						bit_clk_falling_edge;
input						left_right_clk_rising_edge;
input						left_right_clk_falling_edge;

input			[DW: 0]	left_channel_data;
input						left_channel_data_en;

input			[DW: 0]	right_channel_data;
input						right_channel_data_en;

// Bidirectionals

// Outputs
output reg	[ 7: 0]	left_channel_fifo_write_space;
output reg	[ 7: 0]	right_channel_fifo_write_space;

output reg				serial_audio_out_data;


/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/

 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire						read_left_channel;
wire						read_right_channel;

wire						left_channel_fifo_is_empty;
wire						right_channel_fifo_is_empty;

wire						left_channel_fifo_is_full;
wire						right_channel_fifo_is_full;

wire			[ 6: 0]	left_channel_fifo_used;
wire			[ 6: 0]	right_channel_fifo_used;

wire			[DW: 0]	left_channel_from_fifo;
wire			[DW: 0]	right_channel_from_fifo;

// Internal Registers
reg						left_channel_was_read;
reg			[DW: 0]	data_out_shift_reg;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge clk)
begin
	if (reset == 1'b1)
		left_channel_fifo_write_space <= 8'h00;
	else
		left_channel_fifo_write_space <= 8'h80 - {left_channel_fifo_is_full,left_channel_fifo_used};
end

always @(posedge clk)
begin
	if (reset == 1'b1)
		right_channel_fifo_write_space <= 8'h00;
	else
		right_channel_fifo_write_space <= 8'h80 - {right_channel_fifo_is_full,right_channel_fifo_used};
end


always @(posedge clk)
begin
	if (reset == 1'b1)
		serial_audio_out_data <= 1'b0;
	else
		serial_audio_out_data <= data_out_shift_reg[DW];
end


always @(posedge clk)
begin
	if (reset == 1'b1)
		left_channel_was_read <= 1'b0;
	else if (read_left_channel)
		left_channel_was_read <= 1'b1;
	else if (read_right_channel)
		left_channel_was_read <= 1'b0;
end


always @(posedge clk)
begin
	if (reset == 1'b1)
		data_out_shift_reg	<= 'h0;
	else if (read_left_channel)
		data_out_shift_reg	<= left_channel_from_fifo;
	else if (read_right_channel)
		data_out_shift_reg	<= right_channel_from_fifo;
	else if (left_right_clk_rising_edge | left_right_clk_falling_edge)
		data_out_shift_reg	<= 'h0;
	else if (bit_clk_falling_edge)
		data_out_shift_reg	<= 
			{data_out_shift_reg[(DW - 1):0], 1'b0};
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign read_left_channel	= left_right_clk_rising_edge &
										~left_channel_fifo_is_empty & 
										~right_channel_fifo_is_empty;
assign read_right_channel	= left_right_clk_falling_edge &
										left_channel_was_read;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

altera_up_sync_fifo Audio_Out_Left_Channel_FIFO(
	// Inputs
	.clk				(clk),
	.reset			(reset),

	.write_en		(left_channel_data_en & ~left_channel_fifo_is_full),
	.write_data		(left_channel_data),

	.read_en			(read_left_channel),
	
	// Bidirectionals

	// Outputs
	.fifo_is_empty	(left_channel_fifo_is_empty),
	.fifo_is_full	(left_channel_fifo_is_full),
	.words_used		(left_channel_fifo_used),

	.read_data		(left_channel_from_fifo)
);
defparam 
	Audio_Out_Left_Channel_FIFO.DW			= DW,
	Audio_Out_Left_Channel_FIFO.DATA_DEPTH	= 128,
	Audio_Out_Left_Channel_FIFO.AW			= 6;

altera_up_sync_fifo Audio_Out_Right_Channel_FIFO(
	// Inputs
	.clk				(clk),
	.reset			(reset),

	.write_en		(right_channel_data_en & ~right_channel_fifo_is_full),
	.write_data		(right_channel_data),

	.read_en			(read_right_channel),
	
	// Bidirectionals

	// Outputs
	.fifo_is_empty	(right_channel_fifo_is_empty),
	.fifo_is_full	(right_channel_fifo_is_full),
	.words_used		(right_channel_fifo_used),

	.read_data		(right_channel_from_fifo)
);
defparam 
	Audio_Out_Right_Channel_FIFO.DW				= DW,
	Audio_Out_Right_Channel_FIFO.DATA_DEPTH	= 128,
	Audio_Out_Right_Channel_FIFO.AW				= 6;

endmodule

