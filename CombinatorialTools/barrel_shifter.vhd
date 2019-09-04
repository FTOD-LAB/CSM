library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter is
    port ( 
             din : IN std_logic_vector (31 downto 0);
             shift_amount : IN std_logic_vector(4 downto 0);
             left_right : IN std_logic ;
             LogicArith: IN std_logic ;
             ShiftRotate: IN std_logic ;
             dout: OUT std_logic_vector(31 downto 0)
         );
end entity barrel_shifter;
architecture behavior of barrel_shifter is
    signal din_core : std_logic_vector(31 downto 0);
    signal dout_core : std_logic_vector(31 downto 0);
begin
    GEN_MUX_INVERSE_BEFORE_CORE:
    for i in 0 to 31 generate
        mux_inverse_before_core: entity work.mux_1bit
        port map (
                     din1 => din(i),
                     din2 => din(31-i),
                     SEL => left_right,
                     dout => din_core(i)
                 );
    end generate GEN_MUX_INVERSE_BEFORE_CORE;

    shifter_core: entity WORK.barrel_shifter_core
    port map (
                 din => din_core,
                 shift_amount => shift_amount,
                 dout => dout_core,
                 ShiftRotate => ShiftRotate,
                 LogicArith => LogicArith
             );

    GEN_MUX_INVERSE_AFTER_CORE:
    for i in 0 to 31 generate
        mux_inverse_before_core: entity work.mux_1bit
        port map (
                     din1 => dout_core(i),
                     din2 => dout_core(31-i),
                     SEL => left_right,
                     dout => dout(i)
                 );
    end generate GEN_MUX_INVERSE_AFTER_CORE;
end architecture behavior;
