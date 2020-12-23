library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



-- ������ ���������� ����� � ������� ������ �� ���������� �������
entity ethfcs is
    Port (  CLOCK               :   in  std_logic;
            RESET               :   in  std_logic;
            DATA                :   in  std_logic_vector(7 downto 0);
            LOAD_INIT           :   in  std_logic;
            CALC                :   in  std_logic;
            D_VALID             :   in  std_logic;
            CRC                 :   out std_logic_vector(7 downto 0);
            CRC_REG             :   out std_logic_vector(31 downto 0);
            CRC_VALID           :   out std_logic
         );
end ethfcs;

architecture RTL of ethfcs is
   
    function comb_crc_gen
    (
        data_in :   std_logic_vector(7 downto 0);
        crc_in  :   std_logic_vector(31 downto 0)
    )
    return std_logic_vector is

    variable d:      std_logic_vector(7 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

    begin
        d := data_in;
        c := crc_in;
        newcrc(0) := d(6) xor d(0) xor c(24) xor c(30);
        newcrc(1) := d(7) xor d(6) xor d(1) xor d(0) xor c(24) xor c(25) xor c(30) xor c(31);
        newcrc(2) := d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(24) xor c(25) xor c(26) xor c(30) xor c(31);
        newcrc(3) := d(7) xor d(3) xor d(2) xor d(1) xor c(25) xor c(26) xor c(27) xor c(31);
        newcrc(4) := d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(24) xor c(26) xor c(27) xor c(28) xor c(30);
        newcrc(5) := d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor c(30) xor c(31);
        newcrc(6) := d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30) xor c(31);
        newcrc(7) := d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(24) xor c(26) xor c(27) xor c(29) xor c(31);
        newcrc(8) := d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(24) xor c(25) xor c(27) xor c(28);
        newcrc(9) := d(5) xor d(4) xor d(2) xor d(1) xor c(1) xor c(25) xor c(26) xor c(28) xor c(29);
        newcrc(10) := d(5) xor d(3) xor d(2) xor d(0) xor c(2) xor c(24) xor c(26) xor c(27) xor c(29);
        newcrc(11) := d(4) xor d(3) xor d(1) xor d(0) xor c(3) xor c(24) xor c(25) xor c(27) xor c(28);
        newcrc(12) := d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(4) xor c(24) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30);
        newcrc(13) := d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(5) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30) xor c(31);
        newcrc(14) := d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(6) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
        newcrc(15) := d(7) xor d(5) xor d(4) xor d(3) xor c(7) xor c(27) xor c(28) xor c(29) xor c(31);
        newcrc(16) := d(5) xor d(4) xor d(0) xor c(8) xor c(24) xor c(28) xor c(29);
        newcrc(17) := d(6) xor d(5) xor d(1) xor c(9) xor c(25) xor c(29) xor c(30);
        newcrc(18) := d(7) xor d(6) xor d(2) xor c(10) xor c(26) xor c(30) xor c(31);
        newcrc(19) := d(7) xor d(3) xor c(11) xor c(27) xor c(31);
        newcrc(20) := d(4) xor c(12) xor c(28);
        newcrc(21) := d(5) xor c(13) xor c(29);
        newcrc(22) := d(0) xor c(14) xor c(24);
        newcrc(23) := d(6) xor d(1) xor d(0) xor c(15) xor c(24) xor c(25) xor c(30);
        newcrc(24) := d(7) xor d(2) xor d(1) xor c(16) xor c(25) xor c(26) xor c(31);
        newcrc(25) := d(3) xor d(2) xor c(17) xor c(26) xor c(27);
        newcrc(26) := d(6) xor d(4) xor d(3) xor d(0) xor c(18) xor c(24) xor c(27) xor c(28) xor c(30);
        newcrc(27) := d(7) xor d(5) xor d(4) xor d(1) xor c(19) xor c(25) xor c(28) xor c(29) xor c(31);
        newcrc(28) := d(6) xor d(5) xor d(2) xor c(20) xor c(26) xor c(29) xor c(30);
        newcrc(29) := d(7) xor d(6) xor d(3) xor c(21) xor c(27) xor c(30) xor c(31);
        newcrc(30) := d(7) xor d(4) xor c(22) xor c(28) xor c(31);
        newcrc(31) := d(5) xor c(23) xor c(29);
        return newcrc;
    end comb_crc_gen;
    
    function reversed(slv: std_logic_vector) return std_logic_vector is
        variable result: std_logic_vector(slv'reverse_range);
    begin
        for i in slv'range loop
            result(i) := slv(i);
        end loop;
        return result;
    end reversed;
    
    
    constant c_crc_residue  : std_logic_vector(31 downto 0) := x"C704DD7B";
    signal s_next_crc       : std_logic_vector(31 downto 0) := (others => '0');
    signal s_crc_reg        : std_logic_vector(31 downto 0) := (others => '0');
    signal s_crc            : std_logic_vector(7 downto 0)  := (others => '0');
    signal s_reversed_byte  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_crc_valid      : std_logic := '0';
    
    begin

    CRC         <= s_crc;
    CRC_REG     <= s_crc_reg;
    CRC_VALID   <= s_crc_valid;
    
    BYTE_REVERSE : process (DATA)
	begin
         s_reversed_byte <= reversed(DATA);
	end process;

    COMB_NEXT_CRC_GEN : process (s_reversed_byte, s_crc_reg)
    begin
        s_next_crc    <= comb_crc_gen(s_reversed_byte, s_crc_reg);
    end process COMB_NEXT_CRC_GEN;
        
    CRC_GEN : process (CLOCK)
        variable state : std_logic_vector(2 downto 0);
    begin
        if rising_edge(CLOCK) then
            if RESET = '1' then
                s_crc_reg    <= (others => '0');
                s_crc        <= (others => '0');
                s_crc_valid  <= '0';
                state        := (others => '0');
            else
                state        := LOAD_INIT & CALC & D_VALID;
                case state is
                    when "000" =>
                        -- ������� ��������� �� ����
                    when "001" =>
                        s_crc_reg   <= s_crc_reg(23 downto 0) & x"FF";
                        s_crc       <= not reversed(s_crc_reg(23 downto 16));    
                    when "010" =>
                       -- ������� ��������� �� ����                       
                    when "011" =>
                        s_crc_reg   <= s_next_crc;
                        s_crc       <= not reversed(s_next_crc(31 downto 24));   
                    when "100" =>
                        s_crc_reg   <= x"FFFFFFFF";
                    when "101" =>
                        s_crc_reg   <= x"FFFFFFFF";
                        s_crc       <= not reversed(s_crc_reg(23 downto 16));
                    when "110" =>
                        s_crc_reg   <= x"FFFFFFFF";
                    when "111" =>
                        s_crc_reg   <= x"FFFFFFFF";
                        s_crc       <= not reversed(s_next_crc(31 downto 24));
                    when others =>
                        null;
                end case;
                if c_crc_residue = s_crc_reg then
                    s_crc_valid <= '1';
                else
                    s_crc_valid <= '0'; 
                end if;
            end if;
        end if;
    end process CRC_GEN;
end RTL;
