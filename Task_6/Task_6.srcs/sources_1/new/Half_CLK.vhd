LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity CLOCK_DIVIDER is
    port(
        reset   :   in std_logic;
        clk :   in std_logic;
        half_clk    :   out std_logic
        );
end CLOCK_DIVIDER;


architecture CLOCK_DIVIDER of CLOCK_DIVIDER is
type statetype is (ONE, ZERO);
signal CURRENT_STATE : statetype;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            half_clk <= '0';
            CURRENT_STATE <= ZERO;
        elsif clk = '1' and clk'EVENT then
            if CURRENT_STATE = ZERO then
                half_clk <= '0';
                CURRENT_STATE <= ONE;
            elsif CURRENT_STATE = ONE then
                half_clk <= '1';
                CURRENT_STATE <= ZERO;
            end if;
        end if;
    end process;
end CLOCK_DIVIDER;