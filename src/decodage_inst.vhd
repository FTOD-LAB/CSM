library ieee;
library Combinatorialtools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use combinatorialtools.nBitsDecoder.all;

entity decodage_inst is
    signal inst_out 
end entity;

architecture behavior of test is
begin
    decoder_32b : entity WORK,nBits
