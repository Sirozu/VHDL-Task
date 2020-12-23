
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Decoder is
    generic(SizeV: integer := 16);
    port (
        OutputVec : out std_logic_vector(SizeV-1 downto 0);
        InputVec : in std_logic_vector(3 downto 0)
        );
end Decoder;

architecture Behavioral of Decoder is
begin

    process(InputVec)
    begin
        case InputVec is
            when "0000" => OutputVec <= "0000000000000001";
            when "0001" => OutputVec <= "0000000000000010";
            when "0010" => OutputVec <= "0000000000000100";
            when "0011" => OutputVec <= "0000000000001000";
            when "0100" => OutputVec <= "0000000000010000";
            when "0101" => OutputVec <= "0000000000100000";
            when "0110" => OutputVec <= "0000000001000000";
            when "0111" => OutputVec <= "0000000010000000";
            when "1000" => OutputVec <= "0000000100000000";
            when "1001" => OutputVec <= "0000001000000000";
            when "1010" => OutputVec <= "0000010000000000";
            when "1011" => OutputVec <= "0000100000000000";
            when "1100" => OutputVec <= "0001000000000000";
            when "1101" => OutputVec <= "0010000000000000";
            when "1110" => OutputVec <= "0100000000000000";
            when "1111" => OutputVec <= "1000000000000000";
            when others => OutputVec <= "XXXXXXXXXXXXXXXX";
        end case;
    end process;
    
end Behavioral;
