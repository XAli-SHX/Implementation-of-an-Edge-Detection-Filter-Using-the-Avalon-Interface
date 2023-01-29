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
 * This module writes data to the IrDA UART Port.                             *
 *                                                                            *
 ******************************************************************************/

module altera_up_irda_out_serializer (
	// Inputs
	clk,
	reset,
	
	transmit_data,
	transmit_data_en,

	// Bidirectionals

	// Outputs
	fifo_write_space,

	serial_data_out
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

parameter CW							= 9;			// Baud counter width
parameter BAUD_TICK_COUNT			= 433;
parameter BAUD_3_16_TICK_COUNT	= 81;
parameter CAPTURE_IN_TICK_COUNT	= 60;
parameter HALF_BAUD_TICK_COUNT	= 216;

parameter TDW							= 11;			// Total data width
parameter DW							= 9;			// Data width

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;

input			[DW: 0]	transmit_data;
input						transmit_data_en;

// Bidirectionals

// Outputs
output reg	[ 7: 0]	fifo_write_space;

output reg				serial_data_out;


/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire						shift_data_reg_en;
wire						transmitting_bit;
wire						all_bits_transmitted;

wire						read_fifo_en;

wire						fifo_is_empty;
wire						fifo_is_full;
wire			[ 6: 0]	fifo_used;

wire			[DW: 0]	data_from_fifo;

// Internal Registers
reg						transmitting_data;

reg			[DW+1:0]	data_out_shift_reg;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge clk)
begin
	if (reset)
		fifo_write_space <= 8'h00;
	else
		fifo_write_space <= 8'h80 - {fifo_is_full, fifo_used};
end


always @(posedge clk)
begin
	if (reset)
		serial_data_out <= 1'b0;
	else if (transmitting_bit)
		serial_data_out <= ~data_out_shift_reg[0];
	else
		serial_data_out <= 1'b0;
end

always @(posedge clk)
begin
	if (reset)
		transmitting_data <= 1'b0;
	else if (all_bits_transmitted)
		transmitting_data <= 1'b0;
	else if (read_fifo_en)
		transmitting_data <= 1'b1;
end

always @(posedge clk)
begin
	if (reset)
		data_out_shift_reg	<= {(DW + 2){1'b1}};
	else if (read_fifo_en)
		data_out_shift_reg	<= {data_from_fifo, 1'b0};
	else if (shift_data_reg_en)
		data_out_shift_reg	<= 
			{1'b1, data_out_shift_reg[DW+1:1]};
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign read_fifo_en = 
			~transmitting_data & ~fifo_is_empty & ~all_bits_transmitted & 
			~shift_data_reg_en;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

altera_up_irda_counters IrDA_Out_Counters (
	// Inputs
	.clk								(clk),
	.reset							(reset),
	
	.reset_counters				(~transmitting_data),

	// Bidirectionals

	// Outputs
	.baud_clock_rising_edge		(shift_data_reg_en),
	.baud_clock_falling_edge	(),
	.capture_in_bit				(),
	.transmitting_bit				(transmitting_bit),
	.all_bits_transmitted		(all_bits_transmitted)
);
defparam 
	IrDA_Out_Counters.CW								= CW,
	IrDA_Out_Counters.BAUD_TICK_COUNT			= BAUD_TICK_COUNT,
	IrDA_Out_Counters.BAUD_3_16_TICK_COUNT		= BAUD_3_16_TICK_COUNT,
	IrDA_Out_Counters.CAPTURE_IN_TICK_COUNT	= CAPTURE_IN_TICK_COUNT,
	IrDA_Out_Counters.HALF_BAUD_TICK_COUNT		= HALF_BAUD_TICK_COUNT,
	IrDA_Out_Counters.TDW							= TDW;

altera_up_sync_fifo IrDA_Out_FIFO (
	// Inputs
	.clk								(clk),
	.reset							(reset),

	.write_en						(transmit_data_en & ~fifo_is_full),
	.write_data						(transmit_data),

	.read_en							(read_fifo_en),
	
	// Bidirectionals

	// Outputs
	.fifo_is_empty					(fifo_is_empty),
	.fifo_is_full					(fifo_is_full),
	.words_used						(fifo_used),

	.read_data						(data_from_fifo)
);
defparam 
	IrDA_Out_FIFO.DW									= DW,
	IrDA_Out_FIFO.DATA_DEPTH						= 128,
	IrDA_Out_FIFO.AW									= 6;

endmodule

