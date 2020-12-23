-------------------------------------------------------------------------------
-- Title      : SMI (MDIO)
-- Project    : PHY
-------------------------------------------------------------------------------
-- File	      : design/smi.vhd
-- Author     : Mario Hüttel 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: SMI/MDIO Implementation for Ethernet PHYs 
-------------------------------------------------------------------------------
-- Copyright (c) 2016
--
-- This code is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this code.  If not, see <http://www.gnu.org/licenses/>.
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Implementation of the SMI
entity smi is
	generic(
		clockdiv : integer := 64
		);
	port(
		clk_i	    : in    std_logic;
		rst_i	    : in    std_logic;
		mdio_io	    : inout std_logic;
		mdc_o	    : out   std_logic;
		busy_o	    : out   std_logic;
		data_o	    : out   std_logic_vector(15 downto 0);
		data_o_strb : out   std_logic;
		phyaddr_i   : in    std_logic_vector(4 downto 0);
		regaddr_i   : in    std_logic_vector(4 downto 0);
		data_i	    : in    std_logic_vector(15 downto 0);
		strb_i	    : in    std_logic;
		rw_i	    : in    std_logic  --Read/write. 0=write, 1=read
		);
end entity smi;

architecture RTL of smi is
	type smistate_t is (IDLE, PRE, SOF, OPC, PHYADDR, REGADDR, TURN, DATA, CONCL);
	signal state_s	    : smistate_t;
	signal fedge_strb_s : std_logic;
	signal datashift_s  : std_logic_vector(15 downto 0);
	signal regaddr_s    : std_logic_vector(4 downto 0);
	signal phyaddr_s    : std_logic_vector(4 downto 0);
	signal bitcounter_s : integer range 0 to 32;
	signal mdc_o_s	    : std_logic;
	signal rw_latched   : std_logic;
begin
	mdc_o <= mdc_o_s;

	div : process(clk_i, rst_i) is
		variable counter : integer := 0;
	begin
		if rst_i = '1' then
			fedge_strb_s <= '0';
			counter	     := 0;
			mdc_o_s	     <= '0';
		elsif rising_edge(clk_i) then
			fedge_strb_s <= '0';
			counter	     := counter + 1;
			if counter = clockdiv then
				mdc_o_s <= not mdc_o_s;
				counter := 0;
				if mdc_o_s = '1' then
					fedge_strb_s <= '1';
				end if;
			end if;
		end if;
	end process div;

	smishift : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			mdio_io	    <= '1';
			state_s	    <= IDLE;
			rw_latched  <= '0';
			phyaddr_s   <= (others => '0');
			regaddr_s   <= (others => '0');
			datashift_s <= (others => '0');
			busy_o	    <= '1';
			data_o_strb <= '0';
		elsif rising_edge(clk_i) then
			busy_o	    <= '1';
			data_o_strb <= '0';
			if state_s = IDLE then
				mdio_io	     <= '1';
				busy_o	     <= '0';
				bitcounter_s <= 0;
				if (strb_i = '1') then
					state_s	    <= PRE;
					busy_o	    <= '1';
					--Load data
					phyaddr_s   <= phyaddr_i;
					regaddr_s   <= regaddr_i;
					datashift_s <= data_i;
					rw_latched  <= rw_i;
				end if;
			elsif state_s = CONCL then  -- Wait for falling edge to
						    -- force output high after
						    -- read
				if fedge_strb_s = '1' then
					mdio_io	     <= '1';
					busy_o	     <= '0';
					state_s	     <= IDLE;
					bitcounter_s <= 0;
				end if;
			elsif fedge_strb_s = '1' then
				mdio_io	     <= '1';
				bitcounter_s <= bitcounter_s + 1;
				case state_s is
					when PRE =>
						if fedge_strb_s = '1' then
					--Mdio idle high for 32 cycles
							if (bitcounter_s = 31) then
								bitcounter_s <= 0;
								state_s	     <= SOF;
							end if;
						end if;
					when SOF =>
						if bitcounter_s = 0 then
							mdio_io <= '0';
						elsif bitcounter_s = 1 then
							bitcounter_s <= 0;
					--Mdio idle high
							state_s	     <= OPC;
						end if;
					when OPC =>    --Write OPCODE
						if bitcounter_s = 0 then
							if rw_latched = '1' then
								mdio_io <= '1';
							else
								mdio_io <= '0';
							end if;
						elsif bitcounter_s = 1 then
							bitcounter_s <= 0;
							if rw_latched = '1' then
								mdio_io <= '0';
							else
								mdio_io <= '1';
							end if;
							state_s <= PHYADDR;
						end if;
					when PHYADDR =>
						if bitcounter_s = 4 then
							bitcounter_s <= 0;
							state_s	     <= REGADDR;
						end if;
						mdio_io	  <= phyaddr_s(4);
						phyaddr_s <= phyaddr_s(3 downto 0) & '0';
					when REGADDR =>
						if bitcounter_s = 4 then
							bitcounter_s <= 0;
							state_s	     <= TURN;
						end if;
						mdio_io	  <= regaddr_s(4);
						regaddr_s <= regaddr_s(3 downto 0) & '0';
					when TURN =>   -- Turn MDIO to input
						if rw_latched = '1' then
							mdio_io <= 'Z';
						end if;
						if bitcounter_s = 1 then
							bitcounter_s <= 0;
							state_s	     <= DATA;
						end if;
					when DATA =>
						if bitcounter_s = 15 then
							bitcounter_s <= 0;
							state_s	     <= CONCL;
							if rw_latched = '1' then
								data_o_strb <= '1';
								data_o <= datashift_s(14 downto 0) & mdio_io;
							end if;
						end if;
						if rw_latched = '1' then  -- read data
							mdio_io	    <= 'Z';
							datashift_s <= datashift_s(14 downto 0) & mdio_io;
						else   -- write data
							mdio_io	    <= datashift_s(15);
							datashift_s <= datashift_s(14 downto 0) & '0';
						end if;
					when others =>
						null;  -- This should not happen
				end case;
			end if;
		end if;
	end process smishift;


end architecture RTL;
