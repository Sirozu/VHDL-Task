library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Led is
port(
    clk : in std_logic;
    led : out std_logic
); 
end Led;

architecture Behavioral of Led is
signal counter : std_logic_vector(27 downto 0):= (others => '0');
begin

    process(clk)
    begin
    if (rising_edge(clk)) then
    counter <= counter + 1;
    end if;
    end process;
    
    led <= counter(27);

end Behavioral;
