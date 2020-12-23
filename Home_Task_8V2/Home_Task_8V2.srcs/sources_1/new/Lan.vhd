library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lan is
	port(
		clk_tx	  : in	std_logic;
		rst_hw	  : in	std_logic;
		rmii_tx	  : out std_logic_vector(1 downto 0);
		rmii_txen : out std_logic;
		mdc	  : out std_logic;
		mdio	  : out std_logic
		);
end entity Lan;

architecture RTL of Lan is

	type smisend_t is (IDLE, STROBE);
	type tx_state_t is (TXWAIT, TXSEND);
	type smiinit_t is (RESET, INIT, DELAY, INIT_COMPLETE);
	signal tx_state	    : tx_state_t;
	signal sendstate    : smisend_t;
	signal delaycounter : unsigned(19 downto 0);
	signal regaddr_s    : std_logic_vector(4 downto 0);
	signal smi_data_s   : std_logic_vector(15 downto 0);
	signal smi_strb_s   : std_logic;
	signal rst	    : std_logic;
	signal smi_busy_s   : std_logic;
	signal initstate    : smiinit_t;
	signal mdio_s	    : std_logic;
	signal mdc_s	    : std_logic;
	signal tx_ack	    : std_logic;
	signal tx_data	    : std_logic_vector(7 downto 0);
	signal tx_eof	    : std_logic;
	signal tx_sof	    : std_logic;
	signal ok	    : std_logic;
	
	
	signal dummycnt : integer range 0 to 511 := 0;
	signal clkdiv4 : std_logic;
	signal data_in	: std_logic_vector(3 downto 0) := "0001";
begin

    rst <= not rst_hw;
    clock_div : entity work.clock_div
        port map(
            i_clk => clk_tx,
            i_rst => rst,
            o_clk_div4 => clkdiv4
        );
        
	

	mdc  <= mdc_s;
	mdio <= mdio_s;

	smi_inst : entity work.smi
            generic map(
                clockdiv => 2    
                )
            port map(
                clk_i        => clkdiv4,   
                rst_i        => rst,
                mdio_io        => mdio_s,
                mdc_o        => mdc_s,
                busy_o        => smi_busy_s,
                data_o        => open,  
                data_o_strb => open,  
                phyaddr_i   => "10011",  
                regaddr_i   => regaddr_s, 
                data_i        => smi_data_s,
                strb_i        => smi_strb_s,
                rw_i        => '0'  
                );
    
        initphy : process(clkdiv4, rst) is
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
            elsif rising_edge(clkdiv4) then
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

	ethmac_tx_inst : entity work.ethmac_tx
		port map(
			clk	       => clkdiv4,
			rst	       => rst,
			tx_ready       => open,
			start_of_frame => tx_sof,
			end_of_frame   => tx_eof,
			data_in	       => tx_data,
			data_ack       => tx_ack,
			abort	       => '0',
			rmii_tx	       => rmii_tx,
			rmii_txen      => rmii_txen
			);
    
    
	sender : process(clkdiv4, ok)
	begin
		if not ok = '1' then
			tx_state <= TXWAIT;
			tx_sof	 <= '0';
			tx_eof	 <= '0';
			tx_data	 <= x"00";
			dummycnt <= 0;
		elsif rising_edge(clkdiv4) then
			case tx_state is
				when TXWAIT =>
					tx_sof	 <= '1';
					tx_state <= TXSEND;
					tx_data	 <= "0000" & data_in;
					dummycnt <= 0;
				when TXSEND =>
					if tx_ack = '1' then
						tx_sof	 <= '0';
						dummycnt <= dummycnt + 1;
						if dummycnt = 500 then
							tx_eof <= '1';
						end if;
						if dummycnt = 501 then
							tx_eof	 <= '0';
							tx_state <= TXWAIT;
						end if;
					end if;
			end case;
		end if;
	end process sender;

end architecture RTL;
