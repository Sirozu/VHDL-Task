--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
--Date        : Sun Nov 15 14:13:35 2020
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
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    UART_RXD : in STD_LOGIC;
    UART_TXD : out STD_LOGIC;
    Valid_out : out STD_LOGIC;
    storeBits : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    UART_RXD : in STD_LOGIC;
    UART_TXD : out STD_LOGIC;
    Valid_out : out STD_LOGIC;
    storeBits : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      CLK => CLK,
      RST => RST,
      UART_RXD => UART_RXD,
      UART_TXD => UART_TXD,
      Valid_out => Valid_out,
      storeBits(31 downto 0) => storeBits(31 downto 0)
    );
end STRUCTURE;
