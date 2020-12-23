
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Logic is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           R : out STD_LOGIC
           );
           
    
end Logic;

architecture Behavioral of Logic is
    signal F : STD_LOGIC;
    signal S : STD_LOGIC;
begin
    F <= (not(A) and B);
    S <= (A and not(B));
    R <= (F or S);

end Behavioral;
