--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use std.textio.all;

--entity readinstr is
--end entity;

--architecture foo of readinstr is

--    COMPONENT Single_port_RAM_VHDL
--    generic(SizeV: integer := 16);
--    port(
--     RAM_ADDR: in std_logic_vector(SizeV-1 downto 0);
--     RAM_DATA_IN: in std_logic_vector(SizeV-1 downto 0);
--     RAM_WR: in std_logic; 
--     RAM_RST: in std_logic; 
--     RAM_EN: in std_logic;
--     RAM_CLOCK: in std_logic; 
--     RAM_DATA_OUT: out std_logic_vector(SizeV-1 downto 0) 
--    );
--    END COMPONENT;
    
--    component Decoder is
--    generic(SizeV: integer := 16);
--        port (
--            OutputVec : out std_logic_vector(SizeV-1 downto 0);
--            InputVec : in std_logic_vector(3 downto 0)
--            );
--    end component Decoder;
    
    
--    signal OutputVec : std_logic_vector(15 downto 0);
--    signal InputVec : std_logic_vector(3 downto 0);

--   signal RAM_ADDR : std_logic_vector(15 downto 0) := (others => '0');
--   signal RAM_DATA_IN : std_logic_vector(15 downto 0) := (others => '0');
--   signal RAM_WR : std_logic := '0';
--   signal RAM_RST : std_logic := '0';
--   signal RAM_EN : std_logic := '0';
--   signal RAM_CLOCK : std_logic := '0';

--   signal RAM_DATA_OUT : std_logic_vector(15 downto 0);

--   constant RAM_CLOCK_period : time := 5 ns;
 

--    signal pc:      std_ulogic_vector (7 downto 0) := x"08";
--    signal clk:     std_ulogic := '0';
--    signal instr:   std_ulogic_vector (31 downto 0);

--begin

--    dut: Decoder generic map(16) port map(OutputVec, InputVec);
 
--   uut: Single_port_RAM_VHDL generic map(16) PORT MAP (
--          RAM_ADDR => RAM_ADDR,
--          RAM_DATA_IN => RAM_DATA_IN,
--          RAM_WR => RAM_WR,
--          RAM_RST => RAM_RST,
--          RAM_EN => RAM_EN,
--          RAM_CLOCK => RAM_CLOCK,
--          RAM_DATA_OUT => RAM_DATA_OUT
--        );
        
--        process
--           begin
--              RAM_CLOCK <= '0';
--              wait for RAM_CLOCK_period/2;
--              RAM_CLOCK <= '1';
--              wait for RAM_CLOCK_period/2;
--           end process;
           
--read_instruction_memory: 
--    process (clk)
--        file     mem:            text; 
--        variable mem_line:       line;
--        variable read_byte:      std_ulogic_vector(46 downto 0);     
--        variable line_counter:   integer := 96;              
--        variable target_line:    integer;                   
--    begin 
--        if clk'event and clk = '1' then 
--            file_open(mem, "example.tv", read_mode);
--            target_line := to_integer(unsigned(pc));    
--            while line_counter < target_line + 4 loop
--                if not endfile(mem) then                    
--                    readline(mem, mem_line);
--                    if line_counter >= target_line  then       
--                        read(mem_line, read_byte);
--                        instr(7+8*(line_counter - target_line) downto 8*(line_counter - target_line)) <= to_stdulogicvector(read_byte);
--                        RAM_ADDR <= read_byte(0 to 3);
--                        RAM_DATA_IN <= read_byte(5 to 20);
--                        RAM_WR <= read_byte(21 to 22);
--                        RAM_RST <= read_byte(23 to 24);
--                        RAM_EN <= read_byte(25 to 26);
--                        RAM_CLOCK <= read_byte(27 to 28);
--                        assert(RAM_DATA_OUT = read_byte(29 to 44));
--                        --RAM_DATA_OUT <= read_byte(29 to 44)
--                        report "read_byte = " & to_string(read_byte);
--                    end if;
--                end if;
--                line_counter := line_counter + 1;
--            end loop;
--            file_close(mem);
--        end if;
--    end process read_instruction_memory;

--MONITOR:
--    process (instr)
--    begin
--        if now > 0 ns then
--            report "instr = " & to_string(instr);
--        end if;
--    end process;

--CLOCK:
--    process
--    begin
--        wait for 10 ns;
--        clk <= not clk;
--        wait for 10 ns;
--        wait;
--    end process;
--end architecture;