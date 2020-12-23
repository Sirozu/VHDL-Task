library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Et_TX is
  Port (
        clk, reset : in std_logic;
--        preamble            : out std_logic_vector(6 downto 0);
--        startFrame          : out std_logic;
--        recipientAddress    : out std_logic_vector(5 downto 0);
--        senderAddress       : out std_logic_vector(5 downto 0);
--        size                : out std_logic_vector(1 downto 0);
--        data                : out std_logic_vector(49 downto 0);
--        CheckSum            : out std_logic_vector(3 downto 0)
        transmitt : out std_logic_vector(1 downto 0);
   );
end Et_TX;

architecture Behavioral of Et_TX is
component clock_div is
port(
  i_clk         : in  std_logic;
  i_rst         : in  std_logic;
  --o_clk_div2    : out std_logic;
  o_clk_div4    : out std_logic
);
end component clock_div;

    signal clkDiv4 : std_logic;
begin
    halfClk : clock_div port map(clk, reset, clkDiv4);


    process(halfCLK)
    type 
        signal number : integer ranga 1 to 7 := 1;
        signal two_bit_number : integer range 1 to 12001 := 1;
    begin
        if (rising_edge(clk)) then
            two_bit_number <= two_bit_number + 1;
            case number is 
                when 1 => 
                    transmitt <= "10"
                    if (two_bit_number = 56) then
                        number <= 2;
                        two_bit_number := 1;
                    end if;
                when 2 =>
                     --transmitt_data <= "10101011";
                     -- Разбить по два байта и передавать в трансмит 
                     -- если длина two_bit_number равна 8 следующий стейт 
                     number <= 2;
                when 3 => 
                        transmitt <= "10"
                        if (two_bit_number = 56) then
                            number <= 2;
                            two_bit_number := 1;
                        end if;
                
            end case;
        end if;
    end process;
end Behavioral;
