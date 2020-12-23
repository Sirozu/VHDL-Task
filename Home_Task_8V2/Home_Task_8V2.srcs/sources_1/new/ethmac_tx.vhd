library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ethmac_tx is
	generic(
		IFACE_WIDTH : natural := 2);
	port(
		clk	       : in  std_logic;
		rst	       : in  std_logic;
		tx_ready       : out std_logic;
		start_of_frame : in  std_logic;
		end_of_frame   : in  std_logic;
		data_in	       : in  std_logic_vector(7 downto 0);
		data_ack       : out std_logic;
		abort	       : in  std_logic;
		--- RMII Interface
		rmii_tx	       : out std_logic_vector(IFACE_WIDTH -1 downto 0);
		rmii_txen      : out std_logic
		);
end entity ethmac_tx;

architecture RTL of ethmac_tx is

	constant DIBIT_COUNT   : natural		      := 8 / IFACE_WIDTH;
	constant PREAMBLE_BYTE : std_logic_vector(7 downto 0) := x"55";
	constant PREAMBLE_SFD  : std_logic_vector(7 downto 0) := x"D5";

	type eth_tx_state_t is (INIT, PREAMBLE, DATA, CRC, IPG);

	signal crc_data_in    : std_logic_vector(7 downto 0);
	signal crc_init	      : std_logic;
	signal crc_data_out   : std_logic_vector(7 downto 0);
	signal crc_data_valid : std_logic;
	signal crc_calc	      : std_logic;
	signal dibit_counter  : integer range 0 to DIBIT_COUNT - 1 := 0;
	signal byte_counter   : integer range 0 to 15		   := 0;
	signal tx_state	      : eth_tx_state_t;

	signal data_reg		    : std_logic_vector(7 downto 0);
	signal eof_reg		    : std_logic;
	signal byte_counter_disable : std_logic;

begin
	ethfcs_inst : entity work.ethfcs
		port map(
			CLOCK	  => clk,
			RESET	  => rst,
			DATA	  => crc_data_in,
			LOAD_INIT => crc_init,
			CALC	  => crc_calc,
			D_VALID	  => crc_data_valid,
			CRC	  => crc_data_out,
			CRC_REG	  => open,
			CRC_VALID => open
			);

	eth_tx_fsm : process(clk, rst) is
	begin
		if rst = '1' then
			crc_data_in    <= (others => '0');
			crc_data_valid <= '0';
			crc_calc       <= '0';
			crc_init       <= '0';
			dibit_counter  <= 0;
			byte_counter   <= 0;
			rmii_txen      <= '0';
			rmii_tx	       <= (others => '0');
			tx_state       <= INIT;
			data_reg       <= (others => '0');
			data_ack       <= '0';
		elsif rising_edge(clk) then
			crc_init       <= '0';
			crc_calc       <= '0';
			rmii_txen      <= '0';
			data_ack       <= '0';
			crc_data_valid <= '0';

			data_reg <= std_logic_vector(to_unsigned(0, IFACE_WIDTH)) & data_reg(7 downto IFACE_WIDTH);

			if dibit_counter = DIBIT_COUNT - 1 then
				dibit_counter <= 0;
				if byte_counter_disable /= '1' then
					if byte_counter = 15 then
						-- error надо как-то вызвать exception
					end if;
					byte_counter <= byte_counter + 1;
				end if;
			else
				dibit_counter <= dibit_counter + 1;
			end if;

			if abort = '1' then
				tx_state <= INIT; --error
			else
				case tx_state is
					when INIT =>
						byte_counter_disable <= '1';
						if start_of_frame = '1' then
							crc_init	     <= '1';
							tx_state	     <= PREAMBLE;
							byte_counter_disable <= '0';
							dibit_counter	     <= 0;
							byte_counter	     <= 0;
							eof_reg		     <= '0';
						end if;
					when PREAMBLE =>
						rmii_txen	     <= '1';
						byte_counter_disable <= '0';
						if (byte_counter = 7 and dibit_counter = DIBIT_COUNT -1) then 

							rmii_tx	       <= PREAMBLE_SFD(7 downto 8 - IFACE_WIDTH);
							data_reg       <= data_in;
							data_ack       <= '1';
							tx_state       <= DATA;
							eof_reg	       <= end_of_frame;
							crc_data_valid <= '1';
							crc_calc       <= '1';
							crc_data_in    <= data_in;
						else
							rmii_tx <= PREAMBLE_BYTE(IFACE_WIDTH -1 downto 0);
						end if;
					when DATA =>
						rmii_txen	     <= '1';
						crc_calc	     <= '1';
						byte_counter_disable <= '1';
						rmii_tx		     <= data_reg(IFACE_WIDTH - 1 downto 0);

						if dibit_counter = DIBIT_COUNT - 1 and eof_reg = '0' then 
							data_reg       <= data_in;
							data_ack       <= '1';
							eof_reg	       <= end_of_frame;
							crc_data_valid <= '1';
							crc_data_in    <= data_in;
						elsif dibit_counter = DIBIT_COUNT - 1 and eof_reg = '1' then 
							tx_state	     <= CRC;
							data_reg	     <= crc_data_out;
							crc_data_valid	     <= '1';
							byte_counter	     <= 0;
							byte_counter_disable <= '0';
							crc_calc	     <= '0';
						end if;
					when CRC =>
						byte_counter_disable <= '0';
						rmii_txen	     <= '1';
						rmii_tx		     <= data_reg(IFACE_WIDTH - 1 downto 0);
						if dibit_counter = DIBIT_COUNT - 1 then	
							if byte_counter = 3 then
								byte_counter <= 0;
								tx_state     <= IPG;
							else
								data_reg       <= crc_data_out;
								crc_data_valid <= '1';
							end if;
						end if;

					when IPG =>
						rmii_txen	     <= '0';
						byte_counter_disable <= '0';
						if byte_counter = 11 and dibit_counter = DIBIT_COUNT - 1 then
							tx_state <= INIT;
						end if;
				end case;
			end if;	 
		end if;	 
	end process eth_tx_fsm;

	tx_ready <= '1' when tx_state = INIT else '0';

end architecture RTL;
