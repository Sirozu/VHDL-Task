library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Decoder is
  generic
    (
        DecBit: integer:=2
    );
  Port (
        InputVec : in std_logic_vector(7 downto 0);
        OutputVec : out std_logic_vector(7 downto 0)
   );
end Decoder;

architecture Behavioral of Decoder is

begin
    OutputVec <= InputVec - DecBit;
end Behavioral;
