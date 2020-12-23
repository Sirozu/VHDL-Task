
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;


--entity TB is
----  Port ( );
--end TB;

--architecture Behavioral of TB is
--component leddemo is
--	port(
--		clk_tx	  : in	std_logic;
--		data_in	  : in	std_logic_vector(3 downto 0);
--		rst_hw	  : in	std_logic;
--		rmii_tx	  : out std_logic_vector(1 downto 0);
--		rmii_txen : out std_logic;
--		mdc	  : out std_logic_vector(1 downto 0);
--		mdio	  : out std_logic_vector(1 downto 0)
--		);
--end component leddemo;


--signal clk: std_logic;
--signal rst: std_logic;
--signal data	  : 	std_logic_vector(3 downto 0) := "0001";
--begin
--    uut: leddemo port map(clk, data, rst);

--    process 
--    begin
--        clk <= '0'; wait for 5ns;
--        clk <= '1'; wait for 5ns;
--    end process;
--    rst <= '0';
--    rst <= '1';

--end Behavioral;
