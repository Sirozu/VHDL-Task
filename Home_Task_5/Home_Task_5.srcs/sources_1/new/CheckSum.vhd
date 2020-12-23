library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CheckSum is
  Port (
     firstBit : in STD_LOGIC_VECTOR ( 7 downto 0 );
     secondBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
     thridBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
     checkSumBit : in STD_LOGIC_VECTOR ( 7 downto 0 );
     valid : out std_logic
  );
end CheckSum;

architecture Behavioral of CheckSum is
signal tmpcheck : STD_LOGIC_VECTOR( 7 downto 0) := (others => '0');
begin

   tmpcheck <= firstBit xor secondBit xor thridBit;
   valid <= '1' when tmpcheck=checkSumBit else '0';

end Behavioral;
