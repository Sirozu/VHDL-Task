library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.ALL;

entity rmii_tx is
   port (
      clk_i        : in  std_logic;
      rst_i        : in  std_logic;

      user_eof_i   : in  std_logic;
      user_empty_i : in  std_logic;
      user_rden_o  : out std_logic;
      
      user_data_i  : in  std_logic_vector(7 downto 0);
      eth_txd_o    : out std_logic_vector(1 downto 0);
      eth_txen_o   : out std_logic
   );
end rmii_tx;

architecture structural of rmii_tx is

   --https://en.wikipedia.org/wiki/Cyclic_redundancy_check
   constant CRC_POLYNOMIAL : std_logic_vector(31 downto 0) := X"04C11DB7";

   signal eth_txen   : std_logic := '0';
   signal rden       : std_logic := '0';

   
   type t_fsm_state is (IDLE_ST, PRE1_ST, PRE2_ST, PAYLOAD_ST, LAST_ST, CRC_ST, IFG_ST);
   signal fsm_state : t_fsm_state := IDLE_ST;

   signal byte_cnt   : integer range 0 to 12;
   signal cur_byte   : std_logic_vector(7 downto 0) := X"00";
   signal twobit_cnt : std_logic_vector(1 downto 0) := "00";

   signal crc        : std_logic_vector(31 downto 0);
   signal crc_reg    : std_logic_vector(31 downto 0);
   signal crc_enable : std_logic;

   
   function new_crc(old_crc : std_logic_vector(31 downto 0);
                     dibits : std_logic_vector( 1 downto 0))
   return std_logic_vector is
      variable res_v : std_logic_vector(31 downto 0);
   begin
      res_v := old_crc;
      for i in 0 to 1 loop 
         if dibits(i) = res_v(31) then
            res_v :=  res_v(30 downto 0) & '0';
         else
            res_v := (res_v(30 downto 0) & '0') xor CRC_POLYNOMIAL;
         end if;
      end loop;
      return res_v;
   end function new_crc;

begin

   
   proc_mac : process (clk_i)
      variable crc_v : std_logic_vector(31 downto 0);
   begin
      if falling_edge(clk_i) then

         
         if crc_enable = '1' then   
            crc_v := new_crc(crc, cur_byte(1 downto 0));       
            crc <= crc_v;
         else
            crc <= (others => '1');
         end if;

         rden       <= '0';
         twobit_cnt <= twobit_cnt + 1;
         cur_byte   <= "00" & cur_byte(7 downto 2);

         if twobit_cnt = 0 then        
            case fsm_state is
               when IDLE_ST    =>
                  eth_txen <= '0';
                  cur_byte <= X"00";
                  if user_empty_i = '0' then
                     byte_cnt  <= 7;
                     cur_byte  <= X"55";
                     fsm_state <= PRE1_ST;
                     eth_txen  <= '1';
                  end if;

               when PRE1_ST    =>
                  cur_byte  <= X"55";
                  if byte_cnt = 1 then
                     byte_cnt  <= 1;
                     cur_byte  <= X"D5";
                     fsm_state <= PRE2_ST;
                  else
                     byte_cnt <= byte_cnt - 1;
                  end if;

               when PRE2_ST    =>
                  crc_enable <= '1';
                  cur_byte  <= user_data_i;
                  rden      <= '1';
                  fsm_state <= PAYLOAD_ST;

                  
                  if user_empty_i = '1' then
                     report "Data not available" severity failure;
                     cur_byte  <= (others => '0');
                     byte_cnt  <= 11;
                     fsm_state <= IFG_ST;
                     eth_txen  <= '0';
                     rden      <= '0';
                  end if;

               when PAYLOAD_ST =>
                  cur_byte <= user_data_i;
                  rden     <= '1';
                  if user_eof_i = '1' then
                     fsm_state <= LAST_ST;
                  end if;

                  
                  if user_empty_i = '1' then
                     report "Data not available" severity failure;
                     cur_byte  <= (others => '0');
                     byte_cnt  <= 11;
                     fsm_state <= IFG_ST;
                     eth_txen  <= '0';
                     rden      <= '0';
                  end if;

               when LAST_ST => 
                  byte_cnt   <= 4;
                  
                  cur_byte   <= not (crc_v(24) & crc_v(25) & crc_v(26) & crc_v(27) &
                                     crc_v(28) & crc_v(29) & crc_v(30) & crc_v(31));
                  crc_reg    <= crc_v(23 downto 0) & X"00";
                  crc_enable <= '0';         
                  fsm_state  <= CRC_ST;

               when CRC_ST =>
                  
                  cur_byte <= not (crc_reg(24) & crc_reg(25) & crc_reg(26) & crc_reg(27) &
                                   crc_reg(28) & crc_reg(29) & crc_reg(30) & crc_reg(31));
                  crc_reg  <= crc_reg(23 downto 0) & X"00";
                  if byte_cnt = 1 then
                     
                     byte_cnt  <= 11;
                     cur_byte  <= (others => '0');
                     fsm_state <= IFG_ST;
                     eth_txen  <= '0';
                  else
                     byte_cnt <= byte_cnt - 1;
                  end if;

               when IFG_ST =>
                  if byte_cnt = 1 then
                     fsm_state <= IDLE_ST;
                  else
                     byte_cnt <= byte_cnt - 1;
                  end if;

            end case;
         end if;

         if rst_i = '1' then
            fsm_state  <= IDLE_ST;
            twobit_cnt <= (others => '0');
         end if;
      end if;
   end process proc_mac;

   
   eth_txd_o   <= cur_byte(1 downto 0);
   eth_txen_o  <= eth_txen;

   user_rden_o <= rden;

end structural;

