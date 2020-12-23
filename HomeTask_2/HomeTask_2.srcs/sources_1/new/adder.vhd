library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity adder is
    generic (BusWidth : Integer := 16);
    port (
        CO : out std_logic;
        A, B : in std_logic_vector(BusWidth - 1 downto 0);
        C : out std_logic_vector(BusWidth - 1 downto 0)
        );
end entity;

architecture adder_arch of adder is
begin
process (A, B)
    variable Tmp : std_logic_vector(BusWidth downto 0);
begin

    Tmp:=('0' & A) + ('0' & B);
    C <= Tmp(BusWidth - 1 downto 0);
    CO <= Tmp(BusWidth);

end process;
end architecture;