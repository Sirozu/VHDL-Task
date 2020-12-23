library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CheckSum is
    generic
    (
        DBIT: integer:=8
    );
    port
    (
        CheckBit : in std_logic;
        dout: in std_logic_vector(7 downto 0);
        result : out std_logic
    );
end CheckSum;

architecture Behavioral of CheckSum is
signal tmpcheck : std_logic := '0';
begin

    process
    begin
        for i in 0 to DBIT-1 loop
            tmpcheck <= tmpcheck xor dout(i);
        end loop;  
    
    end process;
    result <= '1' when tmpcheck=CheckBit else '0';
end Behavioral;
