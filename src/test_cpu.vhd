library ieee;
library SequentielTools;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testCpu is
end entity;

architecture behavior of testCpu is 
    signal CLK_memInst : std_logic;
    signal CLK_CPU : std_logic;
    signal WE_memInst : std_logic;
    signal OE_memInst : std_logic;
    signal din_memInst : std_logic_vector(31 downto 0);
    signal CP_test :std_logic_vector(31 downto 0);
    signal TEST : std_logic;
begin
    cpu2 : entity WORK.cpu
    port map (CLK_CPU,CLK_memInst, WE_memInst, OE_memInst, din_memInst,CP_test,TEST);
    P_test: process
    begin
        CP_test <= (others => '0');
        --addi R1 R0 00000011|00000010
        din_memInst(31 downto 26) <= "001000";
        din_memInst(25 downto 21) <= "00000";
        din_memInst(20 downto 16) <= "00001";
        din_memInst(15 downto 0) <= "0000001100000010";
        TEST <= '1';
        WE_memInst <= '0';
        OE_memInst <= '1';
        wait for 3 ns;

        --sll R2,R1,16
        CP_test <= (2=>'1',others => '0');
        din_memInst(31 downto 26) <= "000000";
        din_memInst(25 downto 21) <= "00000";
        din_memInst(20 downto 16) <= "00001";
        din_memInst(15 downto 11) <= "00010";
        din_memInst(10 downto 6) <= "10000";
        din_memInst(5 downto 0) <= "000000";
        wait for 4 ns;

        --addi R2 R2 00000001|00000000
        CP_test <= (3 => '1',others => '0');
        din_memInst(31 downto 26) <= "001000";
        din_memInst(25 downto 21) <= "00010";
        din_memInst(20 downto 16) <= "00010";
        din_memInst(15 downto 0) <= "0000000100000000";
        wait for 4 ns;


        --xor R3 R2 R1
        --CP_test <= (3 =>'1', others => '0');
        --din_memInst(31 downto 26) <= "000000";
        --din_memInst(25 downto 21) <= "00001";
        --din_memInst(20 downto 16) <= "00010";
        --din_memInst(15 downto 11) <= "00011";
        --din_memInst(10 downto 6) <= "00000";
        --din_memInst(5 downto 0) <= "000110";

        --wait for 4 ns;

        --sb R2,R0+1
        CP_test <= (2 => '1', 3=>'1', others => '0');
        din_memInst(31 downto 26) <= "101000";
        din_memInst(25 downto 21) <= "00000";
        din_memInst(20 downto 16) <= "00010";
        din_memInst(15 downto 0) <= (0=>'1',others=>'0');

        wait for 4 ns;

        --TODO lb R3 R0+1
        CP_test <= (4=> '1', others => '0');
        din_memInst(31 downto 26) <= "100000";
        din_memInst(25 downto 21) <= "00000";
        din_memInst(20 downto 16) <= "00011";
        din_memInst(15 downto 0) <= (0=>'1',others=>'0');

        wait for  4 ns;
        

        --19ns


        CP_test <= (others => '0');
        WE_memInst <= '1';
        OE_memInst <= '0';
        wait for 4 ns;
        TEST<= '0';


        --23 ns

        wait for 18 ns;
        TEST<= '1';
        CP_test <= (others => '0');
        wait for 8 ns;

        assert FALSE report "FIN DE SIMULATION" severity FAILURE;
    end process;
    P_CLK : process
    begin
        --3*4 ns pour l'initialisation
        loop_init:for i in 0 to 4 loop
            CLK_memInst <= '0';
            wait for 2 ns;
            CLK_memInst <= '1';
            wait for 2 ns;
        end loop loop_init;

        loop_test:for j in 0 to 12 loop
            CLK_CPU <= '0';
            wait for 2 ns;
            CLK_CPU <= '1';
            wait for 2 ns;
        end loop loop_test;
    end process;

end architecture;
