LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_RAM_VHDL IS
END tb_RAM_VHDL;
 
ARCHITECTURE behavior OF tb_RAM_VHDL IS 
    
    COMPONENT MyRAM
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
    END COMPONENT;
    
    component Decoder is
    generic(SizeV: integer := 16);
        port (
            OutputVec : out std_logic_vector(SizeV-1 downto 0);
            InputVec : in std_logic_vector(3 downto 0)
            );
    end component Decoder;
    
    
    signal OutputVec : std_logic_vector(15 downto 0);
    signal InputVec : std_logic_vector(3 downto 0);

   signal RAM_ADDR : std_logic_vector(15 downto 0) := (others => '0');
   signal RAM_DATA_IN : std_logic_vector(15 downto 0) := (others => '0');
   signal RAM_WR : std_logic := '0';
   signal RAM_RST : std_logic := '0';
   signal RAM_EN : std_logic := '0';
   signal RAM_CLOCK : std_logic := '0';

   signal RAM_DATA_OUT : std_logic_vector(15 downto 0);

   constant RAM_CLOCK_period : time := 5 ns;
 
BEGIN
    dut: Decoder generic map(16) port map(OutputVec, InputVec);
 
   uut: MyRAM generic map(16) PORT MAP (
          RAM_ADDR => RAM_ADDR,
          RAM_DATA_IN => RAM_DATA_IN,
          RAM_WR => RAM_WR,
          RAM_RST => RAM_RST,
          RAM_EN => RAM_EN,
          RAM_CLOCK => RAM_CLOCK,
          RAM_DATA_OUT => RAM_DATA_OUT
        );

   process
   begin
      RAM_CLOCK <= '0';
      wait for RAM_CLOCK_period/2;
      RAM_CLOCK <= '1';
      wait for RAM_CLOCK_period/2;
   end process;
    
   process
          begin  
         
         RAM_EN <= '1';
         RAM_RST <= '0';
              
         InputVec <= "0000"; wait for 2 ns; 
         RAM_ADDR <= OutputVec;
         RAM_WR <= '1';         
         -- start writing to RAM
         wait for 10 ns; 
         for i in 0 to 6 loop
             InputVec <= InputVec + "0001";
             RAM_ADDR <= OutputVec; 
             RAM_DATA_IN <= RAM_DATA_IN-x"0001";
                 wait for RAM_CLOCK_period*5;
         end loop;  
         
         
          RAM_WR <= '0';           
          InputVec <= "0000"; wait for 2 ns; 
          RAM_ADDR <= OutputVec;
          RAM_DATA_IN <= x"FFFF"; wait for 10 ns;              
          -- start reading data from RAM 
          for i in 0 to 6 loop
              InputVec <= InputVec + "0001"; 
              RAM_ADDR <= OutputVec; wait for RAM_CLOCK_period*5;
          end loop;
   end process;

END;