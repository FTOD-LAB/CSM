library ieee;
library combinatorialtools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end entity;
architecture behavior of test is
    SIGNAL bitsIn : STD_LOGIC_VECTOR(5 downto 0);
    SIGNAL bitsOut : STD_LOGIC_VECTOR(63 downto 0);
begin
    twoBitsDecoder :entity combinatorialtools.nBitsDecoder
            generic map ( n => 6 )
            port map (  din => bitsIn,
            dout => bitsOut );
    process
    begin
        din <= "111111";
        wait for 1 ns;
        din <= "000000";
        wait for 1 ns;
        din <= "000000";
    end process;
end architecture;

