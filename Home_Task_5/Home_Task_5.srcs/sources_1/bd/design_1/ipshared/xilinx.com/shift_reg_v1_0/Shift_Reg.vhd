library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shift_Reg is
    Port ( 
        clk : in std_logic;
        Q : in std_logic_vector(7 downto 0);
        ce : in std_logic;
        storeBits : out std_logic_vector(31 downto 0);
        RST : in std_logic;
        Valid_out : out std_logic
    );
end Shift_Reg;

architecture Behavioral of Shift_Reg is
    type RegArray is array (0 to 3 ) of std_logic_vector (7 downto 0);
    signal message: RegArray;   
    signal addres : integer range 0 to 3 := 0;
    
    signal state : integer range -1 to 3 := -1;
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            if (RST = '1') then
                message(0) <= (others => '0');
                message(1) <= (others => '0');
                message(2) <= (others => '0');
                message(3) <= (others => '0');
                state <= -1;
            elsif (ce = '1') then
                message(addres) <= Q;
                state <= addres;
                addres <= (addres + 1) mod 4;                
            end if;
        end if;
    end process;
    
        
    storeBits <= message(0) & message(1) & message(2) & message(3);
    Valid_out <= '1' when state = 3 else '0';
end Behavioral;
