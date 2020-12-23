library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Test is
  generic (BusWidth : Integer := 16);
  Port ( 
    Q2 : in Std_Logic_Vector(BusWidth-1 downto 0);
    D2 : out Std_Logic_Vector(BusWidth-1 downto 0);
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    en : in STD_LOGIC
  );
end Test;

architecture Behavioral of Test is

begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '0') then
                 if (en = '1') then
                    D2 <= Q2;
                 end if;
            else
                D2 <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
