library ieee;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbenchShifter is
end entity testbenchShifter;

architecture behavior of testbenchShifter is
    SIGNAL test_din : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL test_dout : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL test_shift_amount : STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL test_left_right : STD_LOGIC;
    SIGNAL shift_rotate : STD_LOGIC;
    SIGNAL logic_arith : STD_LOGIC;
begin
    shifter : entity CombinatorialTools.barrel_shifter
    port map(
            din => test_din,
            dout => test_dout,
            shift_amount => test_shift_amount,
            left_right => test_left_right,
            LogicArith => logic_arith,
            ShiftRotate => shift_rotate
           );

    process 
    begin
        wait for 2 ns;
        test_din <= std_logic_vector ( to_unsigned (33, test_din'length));
        test_shift_amount <= std_logic_vector ( to_unsigned (3, test_shift_amount'length));
        test_left_right <= '0';
        logic_arith <= '0';
        shift_rotate <= '0';
        test_left_right <= '0';
        wait for 2 ns;
        test_din <= std_logic_vector ( to_unsigned (1, test_din'length));
        test_shift_amount <= std_logic_vector ( to_unsigned (3, test_shift_amount'length));
        test_left_right <= '0';
        logic_arith <= '1';
        shift_rotate <= '0';
        test_left_right <= '0';
        wait for 2 ns;
        test_din <= std_logic_vector ( to_unsigned (1, test_din'length));
        test_shift_amount <= std_logic_vector ( to_unsigned (3, test_shift_amount'length));
        test_left_right <= '0';
        logic_arith <= '0';
        shift_rotate <= '1';
        test_left_right <= '1';
        wait for 2 ns;
        test_din <= std_logic_vector ( to_unsigned (1, test_din'length));
        test_shift_amount <= std_logic_vector ( to_unsigned (3, test_shift_amount'length));
        test_left_right <= '0';
        logic_arith <= '0';
        shift_rotate <= '0';
        test_left_right <= '1';
        wait for 2 ns;
        test_din <= std_logic_vector ( to_unsigned (1, test_din'length));
        test_shift_amount <= std_logic_vector ( to_unsigned (3, test_shift_amount'length));
        test_left_right <= '0';
        logic_arith <= '0';
        shift_rotate <= '1';
        test_left_right <= '1';
        wait for 2 ns;
        assert FALSE report "FIN DE SIMULATION" severity failure;
    end process;
end architecture behavior;
