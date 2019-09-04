library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_1b is
    port (
            a : IN std_logic;
            b : IN std_logic;
            S : OUT std_logic;
            BI : IN std_logic;
            Re : IN std_logic;
            Rs : OUT std_logic
    );
end entity full_adder_1b;

architecture behavoir of full_adder_1b is
begin
    S <= Re xor a xor b;
    Rs <= (a and b) or (Re and (a or b));
end architecture behavoir;
