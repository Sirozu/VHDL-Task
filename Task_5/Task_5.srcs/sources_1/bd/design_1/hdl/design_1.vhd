--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
--Date        : Sat Nov 07 15:08:39 2020
--Host        : DESKTOP-VG390FO running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    UART_RXD : in STD_LOGIC;
    UART_TXD : out STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_UART_0_0 is
  port (
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    UART_TXD : out STD_LOGIC;
    UART_RXD : in STD_LOGIC;
    DIN : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DIN_VLD : in STD_LOGIC;
    DIN_RDY : out STD_LOGIC;
    DOUT : out STD_LOGIC_VECTOR ( 7 downto 0 );
    DOUT_VLD : out STD_LOGIC;
    FRAME_ERROR : out STD_LOGIC
  );
  end component design_1_UART_0_0;
  signal CLK_1 : STD_LOGIC;
  signal RST_1 : STD_LOGIC;
  signal UART_0_DOUT : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal UART_0_DOUT_VLD : STD_LOGIC;
  signal UART_0_UART_TXD : STD_LOGIC;
  signal UART_RXD_1 : STD_LOGIC;
  signal NLW_UART_0_DIN_RDY_UNCONNECTED : STD_LOGIC;
  signal NLW_UART_0_FRAME_ERROR_UNCONNECTED : STD_LOGIC;
begin
  CLK_1 <= CLK;
  RST_1 <= RST;
  UART_RXD_1 <= UART_RXD;
  UART_TXD <= UART_0_UART_TXD;
UART_0: component design_1_UART_0_0
     port map (
      CLK => CLK_1,
      DIN(7 downto 0) => UART_0_DOUT(7 downto 0),
      DIN_RDY => NLW_UART_0_DIN_RDY_UNCONNECTED,
      DIN_VLD => UART_0_DOUT_VLD,
      DOUT(7 downto 0) => UART_0_DOUT(7 downto 0),
      DOUT_VLD => UART_0_DOUT_VLD,
      FRAME_ERROR => NLW_UART_0_FRAME_ERROR_UNCONNECTED,
      RST => RST_1,
      UART_RXD => UART_RXD_1,
      UART_TXD => UART_0_UART_TXD
    );
end STRUCTURE;
