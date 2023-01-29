// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.0sp1/ip/merlin/altera_irq_mapper/altera_irq_mapper.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/03/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Altera IRQ Mapper
//
// Parameters
//   NUM_RCVRS        : 11
//   SENDER_IRW_WIDTH : 32
//   IRQ_MAP          : 0:8,1:0,2:10,3:1,4:11,5:12,6:7,7:6,8:9,9:3,10:2
//
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module nios_system_irq_mapper
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // IRQ Receivers
    // -------------------
    input                receiver0_irq,
    input                receiver1_irq,
    input                receiver2_irq,
    input                receiver3_irq,
    input                receiver4_irq,
    input                receiver5_irq,
    input                receiver6_irq,
    input                receiver7_irq,
    input                receiver8_irq,
    input                receiver9_irq,
    input                receiver10_irq,

    // -------------------
    // Command Source (Output)
    // -------------------
    output reg [31 : 0] sender_irq
);


    always @* begin
	sender_irq = 0;

        sender_irq[8] = receiver0_irq;
        sender_irq[0] = receiver1_irq;
        sender_irq[10] = receiver2_irq;
        sender_irq[1] = receiver3_irq;
        sender_irq[11] = receiver4_irq;
        sender_irq[12] = receiver5_irq;
        sender_irq[7] = receiver6_irq;
        sender_irq[6] = receiver7_irq;
        sender_irq[9] = receiver8_irq;
        sender_irq[3] = receiver9_irq;
        sender_irq[2] = receiver10_irq;
    end

endmodule


