library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity Decoder is
    generic
    (
        DecBit: integer:=2
    );
    Port (
         clk : in std_logic;
         firstBit : in STD_LOGIC_VECTOR ( 7 downto 0 );
         secondBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
         thridBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
         led : out STD_LOGIC_VECTOR ( 7 downto 0 )
     );
end Decoder;

architecture Behavioral of Decoder is
    signal firstdec : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal seconddec : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal thriddec : STD_LOGIC_VECTOR ( 7 downto 0 );
    
    constant char : character := 'L';
    constant ASCIIFirst : STD_LOGIC_VECTOR(7 downto 0) := CONV_STD_LOGIC_VECTOR(character'pos(char),8);
    constant char1 : character := 'e';
    constant ASCIISecond : STD_LOGIC_VECTOR(7 downto 0) := CONV_STD_LOGIC_VECTOR(character'pos(char1),8);
    constant char2 : character := '1';
    constant ASCIIThrid : STD_LOGIC_VECTOR(7 downto 0) := CONV_STD_LOGIC_VECTOR(character'pos(char2),8);
begin
    firstdec <= firstBit - DecBit;
    seconddec <= secondBit - DecBit;
    thriddec <= thridBit - DecBit;

    process(clk, firstdec, seconddec, thriddec)
    begin
        if (seconddec = 76) then
--           led <= (others => '0');
--           led(to_integer(unsigned(thriddec - 48))) <= '1';
           
        
            if (thriddec = 49) then
                led <= (others => '0');
                led(0) <= '1';
            elsif (thriddec = 50) then
                led <= (others => '0');
                led(1) <= '1';
            elsif (thriddec = 51) then
                led <= (others => '0');
                led(2) <= '1';
            elsif (thriddec = 52) then
                led <= (others => '0');
                led(3) <= '1';
            elsif (thriddec = 53) then
                led <= (others => '0');
                led(4) <= '1';
            elsif (thriddec = 54) then
                led <= (others => '0');
                led(5) <= '1';
            elsif (thriddec = 55) then
                led <= (others => '0');
                led(6) <= '1';
            elsif (thriddec = 56) then
                led <= (others => '0');
                led(7) <= '1';
            else
                led <= (others => '0');
           end if;
        else
          led <= seconddec; 
        end if;
        
        --led <= firstdec;
         --led(0) <= '1';--firstdec;--thriddec;     
    end process;
end Behavioral;
