library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter_core is
    port (
             din : IN std_logic_vector (31 downto 0);
             shift_amount : IN std_logic_vector(4 downto 0);
             dout: OUT std_logic_vector(31 downto 0);
             ShiftRotate : IN std_logic;
             LogicArith : IN std_logic
         );
end entity barrel_shifter_core;

architecture behavior of barrel_shifter_core is
    signal out_mux0 : std_logic_vector(31 downto 0);
    signal out_mux1 : std_logic_vector(31 downto 0);
    signal out_mux2 : std_logic_vector(31 downto 0);
    signal out_mux3 : std_logic_vector(31 downto 0);
    signal out_mux4 : std_logic_vector(31 downto 0);

    signal mux_src0 : std_logic;
    signal mux_src1 : std_logic_vector(1 downto 0);
    signal mux_src2 : std_logic_vector(3 downto 0);
    signal mux_src3 : std_logic_vector(7 downto 0);
    signal mux_src4 : std_logic_vector(15 downto 0);
begin
    --level 0
    GEN_mux_src0 : entity work.mux_1bit
    port map (
                 din1 => LogicArith,
                 din2 => din(31),
                 sel => ShiftRotate,
                 dout => mux_src0
             );
    GEN_mux0_0 : entity work.mux_1bit
    port map (
                 din1 => din(0),
                 din2 => mux_src0,
                 sel => shift_amount(0),
                 dout => out_mux0(0)
             );
    GEN_MUX0:
    for i in 1 to 31 generate
        mux0 : entity work.mux_1bit
        port map (
                     din1 => din(i),
                     din2 => din(i-1),
                     sel => shift_amount(0),
                     dout => out_mux0(i)
                 );
    end generate GEN_MUX0;

--level 1
    GEN_MUX1_1:
    for i in 0 to 1 generate
        GEN_mux_src1 : entity work.mux_1bit
        port map (
                     din1 => LogicArith,
                     din2 => out_mux0(31-1+i),
                     sel => ShiftRotate,
                     dout => mux_src1(i)
                 );
        mux1_1 : entity work.mux_1bit
        port map (
                     din1 => out_mux0(i),
                     din2 => mux_src1(i),
                     sel => shift_amount(1),
                     dout => out_mux1(i)
                 );
    end generate GEN_MUX1_1;
    GEN_MUX1:
    for i in 2 to 31 generate
        mux1 : entity work.mux_1bit
        port map (
                     din1 => out_mux0(i),
                     din2 => out_mux0(i-2),
                     sel => shift_amount(1),
                     dout => out_mux1(i)
                 );
    end generate GEN_MUX1;

--level 2
    GEN_MUX2_2:
    for i in 0 to 3 generate 
        GEN_mux_src2 : entity work.mux_1bit
        port map (
                     din1 => out_mux1(31-3+i),
                     din2 => LogicArith,
                     sel => ShiftRotate,
                     dout => mux_src2(i)
                 );
        mux2_2 : entity work.mux_1bit
        port map (
                     din1 => out_mux1(i),
                     din2 => mux_src2(i),
                     sel => shift_amount(2),
                     dout => out_mux2(i)
                 );
    end generate GEN_MUX2_2;
    GEN_MUX2:
    for i in 4 to 31 generate
        mux2 : entity work.mux_1bit
        port map (
                     din1 => out_mux1(i),
                     din2 => out_mux1(i-4),
                     sel => shift_amount(2),
                     dout => out_mux2(i)
                 );
    end generate GEN_MUX2;

--level 3
    GEN_MUX3_3:
    for i in 0 to 7 generate 
        GEN_mux_src3 : entity work.mux_1bit
        port map (
                     din1 => out_mux2(31+i-7),
                     din2 => LogicArith,
                     sel => ShiftRotate,
                     dout => mux_src3(i)
                 );
        mux3_3 : entity work.mux_1bit
        port map (
                     din1 => out_mux2(i),
                     din2 => mux_src3(i),
                     sel => shift_amount(3),
                     dout => out_mux3(i)
                 );
    end generate GEN_MUX3_3;
    GEN_MUX3:
    for i in 8 to 31 generate 
        mux3 : entity work.mux_1bit
        port map (
                     din1 => out_mux2(i),
                     din2 => out_mux2(i-8),
                     sel => shift_amount(3),
                     dout => out_mux3(i)
                 );
    end generate GEN_MUX3;

--level 4
    GEN_MUX4_4:
    for i in 0 to 15 generate 
        GEN_mux_src4 : entity work.mux_1bit
        port map (
                     din1 => out_mux3(31+i-15),
                     din2 => LogicArith,
                     sel => ShiftRotate,
                     dout => mux_src4(i)
                 );
        mux4_4 : entity work.mux_1bit
        port map (
                     din1 => out_mux3(i),
                     din2 => mux_src4(i),
                     sel => shift_amount(4),
                     dout => out_mux4(i)
                 );
    end generate GEN_MUX4_4;
    GEN_MUX4:
    for i in 16 to 31 generate 
        mux4 : entity work.mux_1bit
        port map (
                     din1 => out_mux3(i),
                     din2 => out_mux3(i-16),
                     sel => shift_amount(4),
                     dout => out_mux4(i)
                 );
    end generate GEN_MUX4;
    dout <= out_mux4;

end architecture behavior;
