library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_GET_DATA is
port(
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    UART_RXD : in STD_LOGIC;
    UART_TXD : out STD_LOGIC;
    outled : out STD_LOGIC_VECTOR ( 7 downto 0 )
);
end UART_GET_DATA;

architecture Behavioral of UART_GET_DATA is
    component design_1_wrapper is
    port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        UART_RXD : in STD_LOGIC;
        UART_TXD : out STD_LOGIC;
        Valid_out : out STD_LOGIC;
        storeBits : out STD_LOGIC_VECTOR ( 31 downto 0 )
      );
  end component design_1;
  
 component CheckSum is
    Port (
       firstBit : in STD_LOGIC_VECTOR ( 7 downto 0 );
       secondBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
       thridBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
       checkSumBit : in STD_LOGIC_VECTOR ( 7 downto 0 );
       valid : out std_logic
    );
  end component CheckSum;
  
  component Decoder is
      generic
      (
          DecBit: integer:=2
      );
      Port 
      (
           clk : in std_logic;
           firstBit : in STD_LOGIC_VECTOR ( 7 downto 0 );
           secondBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
           thridBit : in  STD_LOGIC_VECTOR ( 7 downto 0 );
           led : out STD_LOGIC_VECTOR ( 7 downto 0 )
       );
  end component Decoder;
  
    signal valid : std_logic := '0';
    signal led :  STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0');
  
    
    signal Valid_out :  STD_LOGIC := '0';
    signal storeBits :  STD_LOGIC_VECTOR ( 31 downto 0 );
    
    
    signal firstBit : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal secondBit : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal thridBit : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal checkSumBit : STD_LOGIC_VECTOR ( 7 downto 0 );
    
    signal firstBitd : STD_LOGIC_VECTOR ( 7 downto 0 ):= (others => '0');
    signal secondBitd : STD_LOGIC_VECTOR ( 7 downto 0 ):= (others => '0');
    signal thridBitd : STD_LOGIC_VECTOR ( 7 downto 0 ):= (others => '0');
    
    signal Myclk : std_logic;
begin

     uut: design_1_wrapper port map (
       CLK => CLK,
       RST => RST,
       UART_RXD => UART_RXD,
       UART_TXD => UART_TXD,
       Valid_out => Valid_out,
       storeBits(31 downto 0) => storeBits(31 downto 0)
      );

    uut1: CheckSum port map (
      firstBit,
      secondBit,
      thridBit,
      checkSumBit,
      valid
    );
    
    uut2: Decoder generic map(2) port map (
          Myclk,
          firstBitd,
          secondBitd,
          thridBitd,
          led
        );
    
    Myclk <= clk;
     
    process(CLK)
    begin
        if (rising_edge(clk)) then
            if (Valid_out = '1') then
                for i in 0 to 31 loop
                    if (i < 8) then
                        firstBit(i) <= storeBits(i);
                    elsif (i >= 8 and i < 16) then
                        secondBit(i - 8) <= storeBits(i);
                    elsif (i >= 16 and i < 24) then
                        thridBit(i - 16) <= storeBits(i);
                    elsif (i >= 24) then
                        checkSumBit(i - 24) <= storeBits(i);
                    end if;
                end loop;
            end if;
        
            if (valid = '1') then
                firstBitd <= firstBit;
                secondBitd <= secondBit;
                thridBitd <= thridBit;
                outled <= led;
--            else
--                outled <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
