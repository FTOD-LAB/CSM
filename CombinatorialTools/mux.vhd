library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_types is
    type nWays is array (natural range<>) of std_logic_vector(31 downto 0);
end package my_types;
    
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_types.all;

entity mux is
    generic (n : natural:= 5);
    port ( SEL : in  std_logic_vector (n-1 downto 0);
           din : in nWays(2**n-1 downto 0);
           dout : out std_logic_vector (31 downto 0)
       );
end entity mux;

architecture behavior of mux is
begin
    dout <= din(to_integer(unsigned(SEL)));
end architecture behavior;
