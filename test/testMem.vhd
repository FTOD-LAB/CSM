library ieee;
library SequentielTools;
library combinatorialtools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use CombinatorialTools.my_types.all;

entity test_ram is
end entity;

architecture behavior of test_ram is
    signal CS_test: std_logic;
    signal OE_test: std_logic;
    signal CLK_test: std_logic;
    signal WE_test: std_logic;
    signal din : std_logic_vector(31 downto 0);
    signal dout : std_logic_vector(31 downto 0);
    signal address_test : std_logic_vector(11 downto 0);
begin
    ram : entity SequentielTools.sram
            generic map (12)
            port map(address_test,din,dout,CS_test,WE_test,OE_test,CLK_test);

    P_TEST : process
    begin
        CS_test <= '0';
        OE_test <= '0';
        WE_test <= '0';
        address_test <= std_logic_vector(to_unsigned(4,address_test'length));
        din <= std_logic_vector(to_unsigned(1,din'length));
        wait for 5 ns;
        WE_test <= '1';
        wait for 4 ns;
        CS_test <= '1';
        wait for 4 ns;
        assert FALSE report "FIN DE SIMULATION" severity FAILURE;
    end process P_TEST;

    P_CLK : process
    begin
        CLK_test <= '0';
        wait for 2 ns;
        CLK_test <= '1';
        wait for 2 ns;
    end process P_CLK;
end architecture;
