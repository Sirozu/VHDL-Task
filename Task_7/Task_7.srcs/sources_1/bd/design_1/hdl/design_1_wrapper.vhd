--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
--Date        : Sat Nov 21 14:50:48 2020
--Host        : DESKTOP-VG390FO running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    clk_in1 : in STD_LOGIC;
    dip_switches1_4bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    clk_in1 : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC;
    dip_switches1_4bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      clk_in1 => clk_in1,
      dip_switches1_4bits_tri_o(7 downto 0) => dip_switches1_4bits_tri_o(7 downto 0),
      usb_uart_rxd => usb_uart_rxd,
      usb_uart_txd => usb_uart_txd
    );
end STRUCTURE;
