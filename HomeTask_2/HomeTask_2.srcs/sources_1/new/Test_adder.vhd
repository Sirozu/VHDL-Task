library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
Use ieee.std_logic_arith.all;

entity Test_adder is
end Test_adder;

architecture Behavioral of Test_adder is

component adder is
    generic (BusWidth : Integer);
    port (
        CO : out std_logic;
        A, B : in std_logic_vector(BusWidth - 1 downto 0);
        C : out std_logic_vector(BusWidth - 1 downto 0)
        );
end component adder;

    signal CO_Test : STD_LOGIC;
    signal A_Test, B_Test : std_logic_vector(7 downto 0);
    signal C_Test : Std_Logic_Vector(7 downto 0);
begin
    dut: adder generic map(8) port map(CO_Test, A_Test, B_Test, C_Test);
    
    process begin
         A_Test <= (7 downto 6 => '1', others => '0'); wait for 15 ns;
         A_Test <= (7 downto 5 => '1', others => '0'); wait for 15 ns;
         A_Test <= (7 downto 4 => '1', others => '0'); wait for 15 ns;
         A_Test <= (7 downto 3 => '1', others => '0'); wait for 15 ns;
         A_Test <= (7 downto 2 => '1', others => '0'); wait for 15 ns;
         A_Test <= (7 downto 1 => '1', others => '0'); wait for 15 ns;
         A_Test <= (others => '1'); wait for 15 ns;
         A_Test <= (others => '0'); wait for 15 ns;
    end process;
    
    process begin
        B_Test <= (others => '1'); wait for 15 ns;
        B_Test <= (others => '0'); wait for 15 ns;
        B_Test <= (7 downto 6 => '1', others => '0'); wait for 15 ns;
        B_Test <= (7 downto 1 => '1', others => '0'); wait for 15 ns;
        B_Test <= (7 downto 5 => '1', others => '0'); wait for 15 ns;
        B_Test <= (7 downto 3 => '1', others => '0'); wait for 15 ns;
        B_Test <= (7 downto 2 => '1', others => '0'); wait for 15 ns;
        B_Test <= (7 downto 4 => '1', others => '0'); wait for 15 ns;
    end process;
    
end Behavioral;
