// megafunction wizard: %Shift register (RAM-based)%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTSHIFT_TAPS 

// ============================================================
// File Name: line_buffer.v
// Megafunction Name(s):
// 			ALTSHIFT_TAPS
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 17.1.1 Internal Build 593 12/11/2017 SJ Standard Edition
// ************************************************************


//Copyright (C) 2017  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module line_buffer (
	clken,
	clock,
	shiftin,
	shiftout,
	taps0x,
	taps1x,
	taps2x);

	input	  clken;
	input	  clock;
	input	[0:0]  shiftin;
	output	[0:0]  shiftout;
	output	[0:0]  taps0x;
	output	[0:0]  taps1x;
	output	[0:0]  taps2x;
	
buf0 l0 (
.D(shiftin),      // input wire [0 : 0] D
.CLK(clock),  // input wire CLK
.CE(clken),    // input wire CE
.Q(taps0x)      // output wire [0 : 0] Q
);

buf0 l1 (
.D(taps0x),      // input wire [0 : 0] D
.CLK(clock),  // input wire CLK
.CE(clken),    // input wire CE
.Q(taps1x)      // output wire [0 : 0] Q
);

buf0 l2 (
.D(taps1x),      // input wire [0 : 0] D
.CLK(clock),  // input wire CLK
.CE(clken),    // input wire CE
.Q(taps2x)      // output wire [0 : 0] Q
);
assign shiftout = taps2x;

endmodule
