library ieee;
library SequentielTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testBancReg is
end entity testBancReg;


architecture behavior of testBancReg is
    SIGNAL toWrite : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL reg_toWrite : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL toRead_1 : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL toRead_2 : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL clk_test : STD_LOGIC;
    SIGNAL read_1 : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL read_2 : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL W_test : STD_LOGIC;

begin
    registers : entity WORK.banc_registers 
    generic map ( 2 )
    port map(  din_w  => toWrite,
            clk => clk_test,
            reg_r1 => toRead_1,
            reg_r2 => toRead_2,
            dout_r1 => read_1,
            dout_r2 => read_2,
            reg_w => reg_toWrite,
            W => W_test
        );

    process
    begin 
        wait for 2 ns;
        W_test <= '1';
        toRead_1 <= std_logic_vector( to_unsigned (0, toRead_1'length));
        toRead_2 <= std_logic_vector( to_unsigned (0, toRead_2'length));
        
        for i in 0 to 3 loop
            toWrite <= std_logic_vector( to_unsigned (i, toWrite'length));
            reg_toWrite <= std_logic_vector ( to_unsigned (i, reg_toWrite'length));
            wait for 4 ns;
        end loop;
        toRead_2 <= std_logic_vector( to_unsigned (0, toRead_2'length));
        for i in 0 to 3 loop
            toRead_1 <= std_logic_vector( to_unsigned (i, toRead_1'length));
            wait for 4 ns;
        end loop;
        
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
            


           
