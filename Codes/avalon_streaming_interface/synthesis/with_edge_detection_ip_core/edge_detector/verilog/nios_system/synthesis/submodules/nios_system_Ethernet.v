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
 * This module reads and writes data to Ethernet chip on the DE2 Board.       *
 *                                                                            *
 ******************************************************************************/

module nios_system_Ethernet (
	// Inputs
	clk,
	reset,

	address,
	chipselect,
	read,
	write,
	writedata,

//	ethernet_clk_25MHz,

	ENET_INT,

	// Bidirectionals
	ENET_DATA,

	// Outputs
	irq,
	readdata,

//	ENET_CLK,
	ENET_RST_N,
	ENET_CS_N,
	ENET_CMD,
	ENET_RD_N,
	ENET_WR_N
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

input						address;
input						chipselect;
input						read;
input						write;
input			[15:0]	writedata;

//input					ethernet_clk_25MHz;

input						ENET_INT;

// Bidirectionals
inout			[15:0]	ENET_DATA;

// Outputs
output reg				irq;
output reg	[15:0]	readdata;

//output					ENET_CLK;
output reg				ENET_RST_N;
output reg				ENET_CS_N;
output reg				ENET_CMD;
output reg				ENET_RD_N;
output reg				ENET_WR_N;

/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires

// Internal Registers
reg			[15:0]	data_to_ethernet_chip;

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
		irq							<= 1'b0;
		readdata						<= 16'h0000; // 32'h00000000;

		data_to_ethernet_chip	<= 16'h0000;

		ENET_RST_N					<= 1'b0;
		ENET_CS_N					<= 1'b1;
		ENET_CMD						<= 1'b0;
		ENET_RD_N					<= 1'b1;
		ENET_WR_N					<= 1'b1;
	end
	else
	begin
		irq							<= ENET_INT;
		readdata						<= ENET_DATA; // {16'h0000,ENET_DATA};

		data_to_ethernet_chip	<= writedata[15:0];

		ENET_RST_N					<= 1'b1;
		ENET_CS_N					<= ~(chipselect & ~(read & ~address));
		ENET_CMD						<= address;
		ENET_RD_N					<= ~read;
		ENET_WR_N					<= ~write;
	end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// assign ENET_CLK		= ethernet_clk_25MHz;

assign ENET_DATA	= ENET_WR_N ? 16'hzzzz : data_to_ethernet_chip;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/


endmodule

