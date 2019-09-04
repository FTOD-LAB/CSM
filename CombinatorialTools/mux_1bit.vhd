library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use work.my_types.all;

entity mux_1bit is
    port(din1: IN std_logic;
        din2: IN std_logic;
        dout : out std_logic;
        sel: IN std_logic
    );
end entity mux_1bit;

architecture behavior of mux_1bit is
begin
    dout <= din1 when (sel = '0') else
            din2 ;
end architecture behavior;
