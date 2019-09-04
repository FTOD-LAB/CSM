library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.my_types.all;

entity ual_32b is
    port (
             a : IN std_logic_vector(31 downto 0);
             b : IN std_logic_vector(31 downto 0);
             sel_mux : IN std_logic_vector (2 downto 0);
             sel_adder : IN std_logic;
             CLK : IN std_logic;
             ValDec : IN std_logic_vector(4 downto 0);
             Slt_Slti : IN std_logic;
             Enable_V : IN std_logic;

             C : OUT std_logic;
             V : OUT std_logic;
             N : OUT std_logic;
             Z : OUT std_logic;
             RES : OUT std_logic_vector(31 downto 0)
         );
end entity ual_32b;

architecture behavoir of ual_32b is
    signal C30_out : std_logic;
    signal C31_out : std_logic;
    signal b_adder_in : std_logic_vector(31 downto 0);
    signal dout : nWays(7 downto 0);
    --signal out_000 : std_logic_vector(31 downto 0);
    --signal out_001 : std_logic_vector(31 downto 0);
    --signal out_010 : std_logic_vector(31 downto 0);
    --signal out_011 : std_logic_vector(31 downto 0);
    --signal out_100 : std_logic_vector(31 downto 0);
    --signal out_101 : std_logic_vector(31 downto 0);
    --signal out_110 : std_logic_vector(31 downto 0);
    --signal out_111 : std_logic_vector(31 downto 0);
    signal C_internal : std_logic;
    signal V_internal : std_logic;
    signal N_internal : std_logic;
    signal Z_internal : std_logic;
    signal Plt_internal : std_logic;

begin
    --AND
    dout(0) <= a and b;

    --OR
    dout(1) <= a or b;
    
    --ADDER
    b_adder_in <= b xor sel_adder;
    adder_32b : entity WORK.full_adder_32b
    port map (
                 a => a,
                 b => b_adder_in,
                 S => dout(2),
                 add_sub => sel_adder,
                 C30 => C30_out,
                 C31 => C31_out
             );
    --FLAGS
    C_internal <= C31_out xor sel_adder;
    V_internal <= Enable_V and (not Slt_Slti) and (C30_out xor C31_out);
    N_internal <= dout(2)(31);
    Z_internal <= not ( RES(31) or RES(30) or RES(29) or RES(28) or RES(27) or RES(26) or RES(25) or RES(24) or RES(23)
                  or RES(22) or RES(21) or RES(20) or RES(19) or RES(18) or RES(17) or RES(16) or RES(15) or RES(14) or
                  RES(13) or RES(12) or RES(11) or RES(10) or RES(9) or RES(8) or RES(7) or RES(6) or RES(5) or RES(4)
                  or RES(3) or RES(2) or RES(1) or RES(0) );


    --PLT
    Plt_internal <=  ((not Enable_V) and C_internal) or ((Enable_V and (C30_out xor C31_out)) xor N_internal);
    dout(3) <= (31 => Plt_internal, others => '0');

    --nor
    dout(4) <= a nor b;
    --xor
    dout(5) <= a xor b;

    --shift_right
    shifter_right : entity WORK.barrel_shifter
    port map (
                din => b,
                shift_amount => ValDec,
                left_right => '1',
                LogicArith => '0',
                ShiftRotate => '0',
                dout => dout(6)
            );

    --shift_left
    shifter_left : entity WORK.barrel_shifter
    port map (
                din => b,
                shift_amount => ValDec,
                left_right => '0',
                LogicArith => '0',
                ShiftRotate => '0',
                dout => dout(7)
            );
    
    --OUT
    mux_out : entity WORK.mux
    generic map ( n => 3 )
    port map ( SEL => sel_mux,
                din => dout,
                dout => RES
            );

    C <= C_internal when rising_edge(CLK);
    V <= V_internal when rising_edge(CLK);
    N <= N_internal when rising_edge(CLK);
    Z <= Z_internal when rising_edge(CLK);

end architecture behavoir;
