library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inverser is
    port (
            din : IN std_logic_vector (31 downto 0);
            inverse : IN std_logic ;
            dout : OUT std_logic_vector(31 downto 0)
        );
end entity inverser;

architecture behavior of inverser is
begin
    MUXS:
    for i in 0 to 31 generate
        muxs_0 : entity work.mux_1bit
        port map (
            din1 => din(i),
            din2 => din(31-i),
            sel => inverse,
            dout => dout(i)
        );
    end generate MUXS;
end architecture behavior;
