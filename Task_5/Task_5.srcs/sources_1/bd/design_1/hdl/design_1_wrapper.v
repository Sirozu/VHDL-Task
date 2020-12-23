//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
//Date        : Sat Nov 07 15:04:49 2020
//Host        : DESKTOP-VG390FO running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (CLK,
    RST,
    UART_RXD,
    UART_TXD);
  input CLK;
  input RST;
  input UART_RXD;
  output UART_TXD;

  wire CLK;
  wire RST;
  wire UART_RXD;
  wire UART_TXD;

  design_1 design_1_i
       (.CLK(CLK),
        .RST(RST),
        .UART_RXD(UART_RXD),
        .UART_TXD(UART_TXD));
endmodule
