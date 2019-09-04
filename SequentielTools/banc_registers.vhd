library ieee;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use CombinatorialTools.my_types.all;

entity banc_registers is
    generic ( n : natural := 4 );
    port (  din_w  :  in std_logic_vector (31 downto 0);
            clk : in std_logic;
            --Regs to read
            reg_r1 : in std_logic_vector (n-1 downto 0);
            reg_r2 : in std_logic_vector (n-1 downto 0);
            --Data read
            dout_r1 : out std_logic_vector(31 downto 0);
            dout_r2 : out std_logic_vector(31 downto 0);
            --Reg to write
            reg_w : in std_logic_vector (n-1 downto 0);
            W : in std_logic
        );
end entity banc_registers;

architecture behavior of banc_registers is
    signal decode_out : std_logic_vector( 2**n-1 downto 0);
    signal clk_ctrl : std_logic_vector( 2**n-1 downto 0);
    signal reg_out : nWays(2**n-1 downto 0);
begin 
    decoder : entity CombinatorialTools.nBitsDecoder
    generic map ( n )
    port map ( din => reg_w,
               dout => decode_out
           );

    clk_ctrl <=  clk and W and decode_out ;

    reg_out(0) <= (others => '0');
    GEN_REG:
    for i in 1 to 2**n-1 generate
        REGX : entity WORK.register_32b 
        port map
        (din => din_w,
         dout => reg_out(i),
         clk => clk_ctrl(i)
     );
 end generate GEN_REG;

 mux_1 : entity CombinatorialTools.mux
 generic map (n)
 port map (SEL => reg_r1,
           din => reg_out,
           dout => dout_r1
       );

 mux_2 : entity CombinatorialTools.mux
 generic map (n)
 port map (SEL => reg_r2,
           din =>reg_out,
           dout => dout_r2
       );
end architecture behavior;

