library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity nBitsDecoder is
    generic (n : natural);
    port ( din : in std_logic_vector (n-1 downto 0) ;
           dout : out std_logic_vector ( (2**n)-1 downto 0)   
       );
end entity nBitsDecoder;

architecture behavior of nBitsDecoder is
begin
    
    gen_out: for i in 0 to 2**n-1 generate
        dout(i) <= '1' when to_integer(unsigned(din)) = i else '0';
    end generate;

--    cette version ci-dessous ne supporte pqs une puissance superieur a 32.
--    dout <= std_logic_vector(to_unsigned(2**to_integer(unsigned(din)),dout'length )); 
end architecture behavior;
