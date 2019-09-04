library ieee;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use CombinatorialTools.nBitsDecoder.all;
use CombinatorialTools.my_types.all;

entity sram is
    generic ( ADDR_WIDTH : natural := 12);
    port (
            address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
            data_in : in std_logic_vector(31 downto 0);
            data_out: out std_logic_vector(31 downto 0);
            CS : in std_logic;
            WE : in std_logic;
            OE : in std_logic;
            CLK: in std_logic
        );
end entity sram;

--TODO Pas possible de mettre 2^32 comme la taill
-- de mem, sinon overflow
architecture behavior of sram is
    signal mem : nWays(2**4 downto 0);
    signal address_mot : std_logic_vector(ADDR_WIDTH-3 downto 0);
    --TODO no initial value?
begin
    address_mot <= address(ADDR_WIDTH-1 downto 2);
    mem(to_integer(unsigned(address_mot) )) <= data_in when CS ='0' and WE='0' and rising_edge(CLK);
    data_out <= mem(to_integer(unsigned(address_mot) )) when not CS and WE and not OE else
                (others => 'Z');
end architecture behavior;
