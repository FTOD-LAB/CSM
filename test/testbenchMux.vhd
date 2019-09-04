library ieee;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use CombinatorialTools.my_types.all;


entity testMux is
end entity testMux;

architecture behavior of testMux is
    SIGNAL bitsIn : nWays(3 downto 0);
    SIGNAL bitsSelect : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL bitsOut : STD_LOGIC_VECTOR(31 downto 0);
begin
    twoWaysMux :entity CombinatorialTools.mux
    generic map ( n => 2) -- , bus_width => 1 )
    port map ( SEL => bitsSelect, 
               din => bitsIn,
               dout => bitsOut );
    process
    begin
        bitsIn(0) <= std_logic_vector( to_unsigned(0,bitsIn(1)'length ));
        bitsIn(1) <= std_logic_vector( to_unsigned(1,bitsIn(1)'length ));
        bitsIn(2) <= std_logic_vector( to_unsigned(2,bitsIn(1)'length ));
        bitsIn(3) <= std_logic_vector( to_unsigned(3,bitsIn(1)'length ));


        bitsSelect(0) <= '0';
        bitsSelect(1) <= '1';
        wait for 5 ns;
        bitsSelect(0) <= '1';
        bitsSelect(1) <= '1';
        wait for 5 ns;
        wait;
    end process;
end architecture;
