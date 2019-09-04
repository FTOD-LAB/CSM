library ieee;
library SequentielTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testReg is
end entity testReg;

architecture behavior of testReg is
    SIGNAL bitsIn : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL bitsOut : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL clk_test : STD_LOGIC;
begin
    twoWaysMux :entity SequentielTools.register_32b
    port map ( din => bitsIn,
               dout => bitsOut,
               clk => clk_test
           );
    process
    begin
        bitsIn <= std_logic_vector( to_unsigned (1,bitsIn'length));
        wait for 6 ns;
        bitsIn <= std_logic_vector( to_unsigned (2,bitsIn'length));
        wait for 5 ns;
        bitsIn <= std_logic_vector( to_unsigned (3,bitsIn'length));
        wait for 10 ns;
        for i in 0 to 31 loop
            bitsIn(i) <= 'Z';
        end loop;
        wait for 10 ns;

        assert FALSE report "FIN DE SIMULATION" severity FAILURE;
    end process;

    P_CLK: process
    begin 
        clk_test <= '1';
        wait for 2 ns;
        clk_test <= '0';
        wait for 2 ns;
    end process P_CLK;
end architecture;
