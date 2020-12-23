library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
    generic
    (
        -- Default setting:
        -- 19,200 baud, 8 data bis, 1 stop its
        DBIT: integer:=8;       -- # data bits
        SB_TICK: integer:=16;   -- # ticks for stop bits, 16/24/32 for 1/1.5/2 stop bits
        DVSR: integer:= 326;    -- baud rate divisor DVSR = 100M/(16*baud rate)
        DVSR_BIT: integer:=9;   -- # bits of DVSR
        DecBit: integer:=2      -- shift sibol to decoder
    );
    port
    (
        clk, reset: in std_logic;
        rx: in std_logic;
        led: out std_logic_vector(7 downto 0)
    );
end uart;

architecture str_arch of uart is
    signal tick: std_logic;
    signal rx_done_tick: std_logic;
    signal rx_data_out: std_logic_vector(7 downto 0);
    signal decode_rx_data_out: std_logic_vector(7 downto 0);
    
    signal checkBit : std_logic;
    signal checkRes : std_logic;
begin

    baud_gen_unit: entity work.mod_m_counter(arch)
        generic map
        (
            M => DVSR,
            N => DVSR_BIT
        )
        port map
        (
            clk => clk,
            reset => reset,
            q => open,
            max_tick => tick
        );
        
    uart_rx_unit: entity work.uart_rx(arch)
        generic map
        (
            DBIT => DBIT,
            SB_TICK => SB_TICK
        )
        port map
        (
            clk => clk,
            reset => reset,
            rx => rx,
            s_tick => tick,
            rx_done_tick => rx_done_tick,
            dout => rx_data_out
        );
        
    Decoder: entity work.Decoder(Behavioral)
        generic map
        (
            DecBit => DecBit
        )
        port map
        (
            InputVec => rx_data_out,
            OutputVec => decode_rx_data_out
        );   
        
    --CheckSum: entity work.CheckSum(Behavioral)
      --      generic map
        --    (
          --      DBIT => DBIT
           -- )
           -- port map
            --(
             --   CheckBit => checkBit,
              --  dout => decode_rx_data_out,
               -- result => checkRes
         --   );     
                

    process(rx_done_tick, decode_rx_data_out)--, checkRes)
    begin
        if(rx_done_tick = '1') then -- and checkRes = '1') then
            led <= decode_rx_data_out;
        end if;
    end process;
end str_arch;