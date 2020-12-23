//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
//Date        : Sat Nov 07 15:04:49 2020
//Host        : DESKTOP-VG390FO running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (CLK,
    RST,
    UART_RXD,
    UART_TXD);
  input CLK;
  input RST;
  input UART_RXD;
  output UART_TXD;

  wire CLK_1;
  wire RST_1;
  wire [7:0]UART_0_DOUT;
  wire UART_0_DOUT_VLD;
  wire UART_0_UART_TXD;
  wire UART_RXD_1;

  assign CLK_1 = CLK;
  assign RST_1 = RST;
  assign UART_RXD_1 = UART_RXD;
  assign UART_TXD = UART_0_UART_TXD;
  design_1_UART_0_0 UART_0
       (.CLK(CLK_1),
        .DIN(UART_0_DOUT),
        .DIN_VLD(UART_0_DOUT_VLD),
        .DOUT(UART_0_DOUT),
        .DOUT_VLD(UART_0_DOUT_VLD),
        .RST(RST_1),
        .UART_RXD(UART_RXD_1),
        .UART_TXD(UART_0_UART_TXD));
endmodule
