--library ieee;
--use ieee.std_logic_1164.all;
 
--entity tb is
--end tb;
 
--architecture behave of tb is
 
--  component Logic
--    port (
--       A : in STD_LOGIC;
--       B : in STD_LOGIC;
--       R : out STD_LOGIC
--      );
--  end component Logic;
 
 
--  signal A_Test : std_logic;
--  signal B_Test : std_logic;
--  signal R_Test : std_logic;
   
--begin
 
--  uut1 : Logic
--    port map (
--      A  => A_Test,
--      B  => B_Test,
--      R => R_Test
--      );
-- process begin
--	A_Test <= '0'; 
--	B_Test <= '1'; wait for 10 ns;
--	assert R_Test = '1' report "0 failed.";
  
--    A_Test <= '1'; 
--    B_Test <= '0'; wait for 10 ns;
--    assert R_Test = '1' report "0 failed.";
    
--    A_Test <= '1'; 
--    B_Test <= '1'; wait for 10 ns;
--    assert R_Test = '0' report "0 failed.";
    
--    A_Test <= '0'; 
--    B_Test <= '0'; wait for 10 ns;
--    assert R_Test = '0' report "0 failed.";
  
--	wait;
-- end process;
 
--end behave;