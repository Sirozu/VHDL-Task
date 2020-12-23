library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TestHandler is
--  Port ( );
end TestHandler;

architecture Behavioral of TestHandler is

component Test is
  generic (BusWidth : Integer);
  Port ( 
    Q2 : in Std_Logic_Vector(BusWidth-1 downto 0);
    D2 : out Std_Logic_Vector(BusWidth-1 downto 0);
      clk : in STD_LOGIC;
      reset : in STD_LOGIC;
      en : in STD_LOGIC
  );
end component Test;

    signal Q : Std_Logic_Vector(3 downto 0);
    signal D : Std_Logic_Vector(3 downto 0);
    signal clk_T : STD_LOGIC;
    signal reset_T : STD_LOGIC;
    signal en_T : STD_LOGIC;
begin
    dut: Test generic map(4) port map(Q, D, clk_T, reset_T,en_T);
    
     process begin
        clk_T <= '0'; wait for 5 ns;
        clk_T <= '1'; wait for 5 ns;
     end process;
     
     process begin
      Q <= (others => '0'); wait for 15 ns;
      Q <= (others => '1'); wait for 15 ns;
     end process;

     process begin
      reset_T <= '1'; wait for 20 ns;
      reset_T <= '0'; wait;
     end process;
     
     
     process begin
         en_T <= '0';  wait for 30 ns;
         en_T <= '1';  wait for 40 ns;
     end process;
    
end Behavioral;
