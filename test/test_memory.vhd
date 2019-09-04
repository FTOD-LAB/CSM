library ieee;
library SequentielTools;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_memory is
end entity;

architecture behavior of test_memory is 
    signal CLK_mem : std_logic;
    signal addresse : std_logic_vector(31 downto 0);
    signal din : std_logic_vector(31 downto 0);
    signal dout : std_logic_vector(31 downto 0);
    signal CS : std_logic;
    signal WE : std_logic;
    signal OE : std_logic;

    signal LireMem_W   : std_logic;
    signal LireMem_UB  : std_logic;
    signal LireMem_UH  : std_logic;
    signal LireMem_SB  : std_logic;
    signal LireMem_SH  : std_logic;
    signal EcrireMem_B : std_logic;
    signal EcrireMem_H : std_logic;
    signal EcrireMem_W : std_logic;


begin 
    LireMem_W   <= '0';
    LireMem_UB  <= '0';
    LireMem_UH  <= '0';
    LireMem_SB  <= '0';
    LireMem_SH  <= '0';
    EcrireMem_H <= '0';
    EcrireMem_W <= '0';
    EcrireMem_B <= '1';
    dataMem : entity SequentielTools.data_memory
    port map(addresse, din, dout, EcrireMem_B,EcrireMem_H,EcrireMem_W, LireMem_W, LireMem_UB, LireMem_UH, LireMem_SB, LireMem_SH, CS, WE, OE, CLK_mem);
    P_test:process
    begin
        CLK_mem <= '1';
        din <= "11111111111111000000000000000000";
        addresse <= (others => '0');
        CS <= '1';
        WE <= '1';
        OE <= '0';
        wait for 2 ns;
        CLK_mem <= '0';
        wait for 1 ns;
        CS <= '0';
        WE <= '0';
        OE <= '1';
        wait for 1 ns;
        CLK_mem<= '1';
        wait for 2 ns;
        CS <= '1';
        wait for 2 ns;
    assert false report "FIN DE SIMULATION!" severity FAILURE;
    end process;
end architecture;
