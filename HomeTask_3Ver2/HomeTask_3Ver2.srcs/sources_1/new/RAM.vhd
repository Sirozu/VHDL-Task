library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity MyRAM is
generic(SizeV: integer := 16);
port(
 RAM_ADDR: in std_logic_vector(SizeV-1 downto 0);
 RAM_DATA_IN: in std_logic_vector(SizeV-1 downto 0);
 RAM_WR: in std_logic; 
 RAM_RST: in std_logic; 
 RAM_EN: in std_logic;
 RAM_CLOCK: in std_logic; 
 RAM_DATA_OUT: out std_logic_vector(SizeV-1 downto 0) 
);
end MyRAM;

architecture Behavioral of MyRAM is
type RAM_ARRAY is array (0 to 127 ) of std_logic_vector (SizeV-1 downto 0);
signal RAM: RAM_ARRAY;
begin

     process (RAM_CLOCK, RAM_EN)  
       begin  
         if (RAM_EN = '1')  then  
             if (RAM_CLOCK'event and RAM_CLOCK = '1') then
             
              if (RAM_RST = '1') then
                    RAM(to_integer(unsigned(RAM_ADDR))) <= (others => '0'); 
              else
                 if (RAM_WR = '1') then
                         RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN; 
                         RAM_DATA_OUT <= (others => '0');
                     else 
                          RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));  
                  end if;  
               end if;    
             end if;        
         else
             RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));
         end if;  
       end process;  
     
end Behavioral;