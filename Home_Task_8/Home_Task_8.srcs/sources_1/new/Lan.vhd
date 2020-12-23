library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_unsigned.ALL;


entity Lan is
   port (
      clk_i        : in    std_logic;  
      rst_i        : in    std_logic;  

      
      tx_empty_i   : in    std_logic;
      tx_rden_o    : out   std_logic;
      --tx_data_i    : in    std_logic_vector(7 downto 0); -- покка будем юзать сигнал
      tx_eof_i     : in    std_logic;

      
      eth_txd_o    : out   std_logic_vector(1 downto 0);
      eth_txen_o   : out   std_logic;
      eth_mdio_io  : inout std_logic;
      eth_mdc_o    : out   std_logic;
      eth_rstn_o   : out   std_logic;
      eth_refclk_o : out   std_logic
   );
end Lan;

architecture structural of Lan is

    signal clkdiv4 : std_logic;
    signal tx_data_i : std_logic_vector(7 downto 0):= "00000001";
    
    type smisend_t is (IDLE, STROBE);
    type smiinit_t is (RESET, INIT, DELAY, INIT_COMPLETE);  
begin
    clock_div : entity work.clock_div
        port map(
            i_clk => clk_i,
            i_rst => rst_i,
            o_clk_div4 => clkdiv4
        );
    
        smi_inst : entity work.smi
            generic map(
                clockdiv => 2    -- 25 MGz is maximum for SMI
                )
            port map(
                clk_i        => clkdiv4,    -- 50 MGz 
                rst_i        => rst_i,
                mdio_io        => eth_mdio_io,
                mdc_o        => eth_mdc_o,
                busy_o        => smi_busy_s,
                data_o        => open,  -- ignore read outputs
                data_o_strb => open,  -- ignore read outputs 
                phyaddr_i   => "10011",  -- phy addr 0x13
                regaddr_i   => regaddr_s, -- register
                data_i        => tx_data_i,
                strb_i        => smi_strb_s,
                rw_i        => '0'  
                );
    
        initphy : process(clk_tx, rst) is
            procedure sendsmi(regaddr   : in std_logic_vector(4 downto 0);
                      data        : in std_logic_vector(15 downto 0);
                      nextstate : in smiinit_t) is
            begin
                case sendstate is
                    when IDLE =>
                        regaddr_s  <= regaddr;
                        smi_data_s <= data;
                        if smi_busy_s = '0' then
                            smi_strb_s <= '1';
                            sendstate  <= STROBE;
                        end if;
                    when STROBE =>
                        initstate <= nextstate;
                        sendstate <= IDLE;
                end case;
            end procedure sendsmi;
        
        begin
            if rst = '1' then
                ok          <= '0';
                regaddr_s    <= (others => '0');
                smi_data_s   <= (others => '0');
                smi_strb_s   <= '0';
                initstate    <= RESET;
                sendstate    <= IDLE;
                delaycounter <= (others => '0');
            elsif rising_edge(clk_tx) then
                ok        <= '0';
                smi_strb_s <= '0';
                case initstate is
                    when RESET =>
                        sendsmi((others => '0'), "1000000000000000", DELAY);
                    when DELAY =>
                        delaycounter <= delaycounter + 1;
                        if delaycounter = 100000 then 
                            initstate <= INIT;
                        end if;
                    when INIT =>
                        sendsmi((others => '0'), "0001000000000000", INIT_COMPLETE);
                    when INIT_COMPLETE =>
                        initstate <= INIT_COMPLETE;        
                        ok        <= '1';
                end case;
            end if;
        end process initphy;

--   inst_rmii_tx : entity work.rmii_tx
--      port map (
--         clk_i        => clkdiv4,
--         rst_i        => rst_i,
--         user_empty_i => tx_empty_i,
--         user_rden_o  => tx_rden_o,
--         user_data_i  => tx_data_i,
--         user_eof_i   => tx_eof_i,
--         eth_txd_o    => eth_txd_o,
--         eth_txen_o   => eth_txen_o 
--      );
      
   

end structural;
