-- (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:user:UART:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_UART_0_0 IS
  PORT (
    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;
    UART_TXD : OUT STD_LOGIC;
    UART_RXD : IN STD_LOGIC;
    DIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    DIN_VLD : IN STD_LOGIC;
    DIN_RDY : OUT STD_LOGIC;
    DOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    DOUT_VLD : OUT STD_LOGIC;
    FRAME_ERROR : OUT STD_LOGIC
  );
END design_1_UART_0_0;

ARCHITECTURE design_1_UART_0_0_arch OF design_1_UART_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : string;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_UART_0_0_arch: ARCHITECTURE IS "yes";

  COMPONENT UART IS
    GENERIC (
      CLK_FREQ : INTEGER;
      BAUD_RATE : INTEGER;
      PARITY_BIT : STRING;
      USE_DEBOUNCER : BOOLEAN
    );
    PORT (
      CLK : IN STD_LOGIC;
      RST : IN STD_LOGIC;
      UART_TXD : OUT STD_LOGIC;
      UART_RXD : IN STD_LOGIC;
      DIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      DIN_VLD : IN STD_LOGIC;
      DIN_RDY : OUT STD_LOGIC;
      DOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      DOUT_VLD : OUT STD_LOGIC;
      FRAME_ERROR : OUT STD_LOGIC
    );
  END COMPONENT UART;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_UART_0_0_arch: ARCHITECTURE IS "UART,Vivado 2015.3";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_UART_0_0_arch : ARCHITECTURE IS "design_1_UART_0_0,UART,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF design_1_UART_0_0_arch: ARCHITECTURE IS "design_1_UART_0_0,UART,{x_ipProduct=Vivado 2015.3,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=UART,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,CLK_FREQ=200000000,BAUD_RATE=115200,PARITY_BIT=none,USE_DEBOUNCER=True}";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF CLK: SIGNAL IS "xilinx.com:signal:clock:1.0 CLK CLK";
  ATTRIBUTE X_INTERFACE_INFO OF RST: SIGNAL IS "xilinx.com:signal:reset:1.0 RST RST";
BEGIN
  U0 : UART
    GENERIC MAP (
      CLK_FREQ => 200000000,
      BAUD_RATE => 115200,
      PARITY_BIT => "none",
      USE_DEBOUNCER => true
    )
    PORT MAP (
      CLK => CLK,
      RST => RST,
      UART_TXD => UART_TXD,
      UART_RXD => UART_RXD,
      DIN => DIN,
      DIN_VLD => DIN_VLD,
      DIN_RDY => DIN_RDY,
      DOUT => DOUT,
      DOUT_VLD => DOUT_VLD,
      FRAME_ERROR => FRAME_ERROR
    );
END design_1_UART_0_0_arch;
