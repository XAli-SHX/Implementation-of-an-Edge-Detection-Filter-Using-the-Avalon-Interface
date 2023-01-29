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
 * This module reads and writes data to USB chip on the DE2 Board.            *
 *                                                                            *
 ******************************************************************************/

module nios_system_USB (
	// Inputs
	clk,
	reset,

	address,
	chipselect,
	read,
	write,
	writedata,

	OTG_INT0,
	OTG_INT1,

	// Bidirectionals
	OTG_DATA,

	// Outputs
	readdata,

	irq,

	OTG_RST_N,
	OTG_ADDR,
	OTG_CS_N,
	OTG_RD_N,
	OTG_WR_N
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;

input			[ 1: 0]	address;
input						chipselect;
input						read;
input						write;
input			[15: 0]	writedata;

input						OTG_INT0;
input						OTG_INT1;

// Bidirectionals
inout			[15: 0]	OTG_DATA;

// Outputs
output reg	[15: 0]	readdata;

output reg				irq;

output reg				OTG_RST_N;
output reg	[ 1: 0]	OTG_ADDR;
output reg				OTG_CS_N;
output reg				OTG_RD_N;
output reg				OTG_WR_N;

/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires

// Internal Registers
reg			[15: 0]	data_to_usb_chip;

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
	begin
		readdata				<= 16'h0000;

		irq					<= 1'b0;

		data_to_usb_chip	<= 16'h0000;

		OTG_RST_N			<= 1'b0;
		OTG_ADDR				<= 2'h0;
		OTG_CS_N				<= 1'b1;
		OTG_RD_N				<= 1'b1;
		OTG_WR_N				<= 1'b1;
	end
	else
	begin
		readdata				<= OTG_DATA;

		irq					<= ~OTG_INT1 | ~OTG_INT0;
		
		data_to_usb_chip	<= writedata[15:0];

		OTG_RST_N			<= 1'b1;
		OTG_ADDR				<= address;
		OTG_CS_N				<= ~chipselect;
		OTG_RD_N				<= ~read;
		OTG_WR_N				<= ~write;
	end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign OTG_DATA	= OTG_WR_N ? 16'hzzzz : data_to_usb_chip;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/


endmodule

