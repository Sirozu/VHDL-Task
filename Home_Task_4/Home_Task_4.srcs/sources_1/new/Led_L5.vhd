library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- L5 L4 M4 M2 M1 N3 N2 N1
-- N4 R2 R1 R3 

--l3 l2 k3 k2 p1 p4 p3 m5
entity Led is
port(
    clk : in std_logic;
    button : in std_logic_vector(3 downto 0);
    switch : in std_logic_vector(7 downto 0);
    led : out std_logic_vector(7 downto 0) := (others => '0')
); 
end Led;

architecture Behavioral of Led is


component Button_Debounce is
port(
	clk: in std_logic;
	reset: in std_logic; 
	input: in std_logic;
	debounce: out std_logic
);
end component Button_Debounce;

signal reset: std_logic;
signal input: std_logic;
signal debounce: std_logic;


signal counter : std_logic_vector(27 downto 0):= (others => '0');
signal slow_clk_enable : std_logic_vector(3 downto 0);

begin
    uut: Button_Debounce port map(clk, reset, input, debounce);
    
    reset <= '0';
    process(clk, button, debounce)
    begin
        for i in 0 to 3 loop
             input <= button(i);
             slow_clk_enable(i) <= debounce;
         end loop;
    end process;
    
    
    process(clk, button, switch, slow_clk_enable, counter)
    begin
        if (rising_edge(clk)) then
            counter <= counter + 1;
        
        
            if (button(0) = '1' or switch(0) = '1') then
                led(0) <= counter(27);
                counter <= counter + 1;
            elsif (button(1) = '1' or switch(1) = '1') then
                led(1) <= counter(27);
                counter <= counter + 1;
            elsif (button(2) = '1' or switch(2) = '1') then
                led(2) <= counter(27);
                counter <= counter + 1;
            elsif (button(3) = '1' or switch(3) = '1') then
                led(3) <= counter(27);
                counter <= counter + 1;
            elsif (switch(4) = '1') then
                led(4) <= counter(27);
                counter <= counter + 1;
            elsif (switch(5) = '1') then
                led(5) <= counter(27);
                counter <= counter + 1;
            elsif (switch(6) = '1') then
                led(6) <= counter(27);
                counter <= counter + 1;
            elsif (switch(7) = '1') then
                led(7) <= counter(27);
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
end Behavioral;
