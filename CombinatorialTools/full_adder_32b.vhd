library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_32b is
    port (
            a : IN std_logic_vector(31 downto 0);
            b : IN std_logic_vector(31 downto 0);
            S : OUT std_logic_vector(31 downto 0);
            add_sub : IN std_logic;
            C30 : OUT std_logic;
            C31 : OUT std_logic
        );
end entity full_adder_32b;

architecture behavoir of full_adder_32b is
    signal Rs_out : std_logic_vector(31 downto 0);
begin
    adder_1 : entity work.full_adder_1b
    port map (
            a => a(0),
            b => b(0),
            S => S(0),
            BI => add_sub,
            Re => add_sub,
            Rs => Rs_out(0)
        );
    GEN_ADDERS:
    for i in 1 to 31 generate
        adders : entity work.full_adder_1b
        port map (
            a => a(i),
            b => b(i),
            S => S(i),
            BI => add_sub,
            Re => Rs_out(i-1),
            Rs => Rs_out(i)
        );
    end generate GEN_ADDERS;
    C30 <= Rs_out(30);
    C31 <= Rs_out(31);
end architecture behavoir;
            
            
