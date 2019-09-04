library ieee;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbenchUal is
end entity testbenchUal;

architecture behavoir of testbenchUal is
    signal test_a : std_logic_vector(31 downto 0);
    signal test_b : std_logic_vector(31 downto 0);
    signal test_sel_mux : std_logic_vector (2 downto 0);
    signal test_sel_adder : std_logic;
    signal test_CLK : std_logic;
    signal test_ValDec : std_logic_vector(4 downto 0);
    signal test_Slt_Slti : std_logic;
    signal test_Enable_V : std_logic;

    signal out_C : std_logic;
    signal out_V : std_logic;
    signal out_N : std_logic;
    signal out_Z : std_logic;
    signal out_RES : std_logic_vector(31 downto 0);
begin
    ual : entity CombinatorialTools.ual_32b
    port map(
               a => test_a,
               b => test_b,
               sel_mux => test_sel_mux,
               sel_adder => test_sel_adder,
               CLK => test_CLK,
               ValDec => test_ValDec,
               Slt_Slti => test_Slt_Slti,
               Enable_V => test_Enable_V,

               C => out_c,
               V => out_V,
               N => out_N,
               Z => out_Z,
               RES => out_RES
           );

    process
    begin
        
        ----- test1 : 1 + 2  => PASSED -----
        
        --test_a <= std_logic_vector( to_unsigned (1, test_a'length));
        --test_b <= std_logic_vector( to_unsigned (2, test_a'length));
        --test_sel_mux <= (1 => '1', others => '0');
        --test_sel_adder <= '0';
        --test_ValDec <= (others => '0');
        --test_Slt_Slti <= '0';
        --test_Enable_V <= '0';

        ----- test2 : 32x'1' + 32x'1' => PASSSED -----
        --test_a <= (others => '1');
        --test_b <= (others => '1');
        --test_sel_mux <= (1 => '1', others => '0');
        --test_sel_adder <= '0';
        --test_ValDec <= (others => '0');
        --test_Slt_Slti <= '0';
        --test_Enable_V <= '1';
        --wait for 5 ns;

        ----- test2 : -2^31 - 2^31 => PASSSED -----
        test_a <= (31 => '1', others => '0');
        test_b <= (31 => '1', others => '0');
        test_sel_mux <= (1 => '1', others => '0');
        test_sel_adder <= '0';
        test_ValDec <= (others => '0');
        test_Slt_Slti <= '0';
        test_Enable_V <= '1';
        wait for 5 ns;

        ----- test3 : 3 - 1 => PASSED -----
        --test_a <= std_logic_vector( to_unsigned (3, test_a'length));
        --test_b <= std_logic_vector( to_unsigned (1, test_a'length));
        --test_sel_mux <= (1 => '1', others => '0');
        --test_sel_adder <= '1';
        --test_ValDec <= (others => '0');
        --test_Slt_Slti <= '0';
        --test_Enable_V <= '1';
        --wait for 5 ns;

        ----- test4 : 1 - 3 => PASSED -----
        --test_a <= std_logic_vector( to_unsigned (1, test_a'length));
        --test_b <= std_logic_vector( to_unsigned (3, test_a'length));
        --test_sel_mux <= (1 => '1', others => '0');
        --test_sel_adder <= '1';
        --test_ValDec <= (others => '0');
        --test_Slt_Slti <= '0';
        --test_Enable_V <= '1';
        --wait for 5 ns;

        ----- tet5 : 1 << 5 => PASSED -----
        test_Enable_V <= '0';
        test_b <= std_logic_vector( to_unsigned (1, test_a'length));
        test_ValDec <= std_logic_vector( to_unsigned (5, test_ValDec'length));
        test_sel_mux <= (0 => '0', others => '1');
        wait for 5 ns;
        ----- tet5 : 1 >> 5 => PASSED -----
        test_sel_mux <= (others => '1');
        wait for 5 ns;





        assert FALSE report "FIN DE SIMULATION" severity FAILURE;
    end process;

    P_CLK : process
    begin
        test_CLK <= '0';
        wait for 2 ns;
        test_CLK <= '1';
        wait for 2 ns;
    end process P_CLK;

end architecture behavoir;
