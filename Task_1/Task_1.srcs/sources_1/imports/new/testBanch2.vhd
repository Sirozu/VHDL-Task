library IEEE; use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_TEXTIO.ALL; use STD.TEXTIO.all;
use STD.TEXTIO.all;

entity testBanch2 is -- no inputs or outputs
end;

architecture sim of testBanch2 is

  component Logic
    port (
       A : in STD_LOGIC;
       B : in STD_LOGIC;
       R : out STD_LOGIC
      );
  end component Logic;
 
 
 signal A, B, R : STD_LOGIC;
 
  signal R_expected: STD_LOGIC;
  signal clk, reset: STD_LOGIC;
  signal fio : STD_LOGIC;
 begin
  -- instantiate device under test
  dut: Logic port map(A, B, R);
  -- generate clock
  process begin
  clk <= '1'; wait for 5 ns;
  clk <= '0'; wait for 5 ns;
  end process;
  -- at start of test, pulse reset
  process begin
  reset <= '1'; wait for 27 ns; reset <= '0';
  wait;
  end process;
  -- run tests
  Verify_data_process : 
      process
          file l_file: text;
       variable L: line;
       variable vector_in: std_logic_vector(1 downto 0);
       variable dummy: character;
       variable vector_out: std_logic;
       variable vectornum: integer := 0;
       variable errors: integer := 0;
          variable file_is_open:  boolean;
          constant header:    string := "  R   G   B";
                  variable filestatus:    file_open_status;
      begin -- process
          if not file_is_open then
              file_open (filestatus, l_file, "D:/Users/Siroz/Task_1/Task_1.srcs/sources_1/imports/new/example.txt", read_mode); 
              file_is_open := true;
              fio <= '1';
              report "file_open_status = " & 
                                  file_open_status'image(filestatus);           
              -- print(l_file, "R G B" );
          end if;
          wait until rising_edge(clk); --  wait until clk128_tb = '1';
                     
                     while not endfile(l_file) loop
                     -- change vectors on rising edge
                         wait until rising_edge(clk);
                         -- read the next line of testvectors and split into pieces
                         readline(l_file, L);
                         --report line'image(L);
                         --writeline(output, L);
                         read(L, vector_in);
                         read(L, dummy); -- skip over underscore
                         read(L, vector_out);
                         report "LINE " & std_logic'image(vector_in(0)) & std_logic'image(vector_in(1)) & " " & std_logic'image(vector_out);
                         (a, b) <= vector_in(1 downto 0) after 1 ns;
                         r_expected <= vector_out after 1 ns;
                         -- -- check results on falling edge
                         wait until falling_edge(clk);
                         if r /= r_expected then
                         report "Error: y = " & std_logic'image(r);
                         errors := errors + 1;
                         end if;
                         vectornum := vectornum + 1;
                     end loop;
                     -- summarize results at end of simulation
  
          -- file_close(l_file);
      end process;

  end;