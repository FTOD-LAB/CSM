library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity decoder is
	generic (N : natural);
	port (
		E : in std_logic; -- Enable
		I : in std_logic_vector(N-1 downto 0); -- Inputs
		O : out std_logic_vector(2**N-1 downto 0) -- Outputs
	);
end entity;

architecture decoder_arch of decoder is
begin
	O <= (others => 'Z') when E = '0'
		else std_logic_vector(to_unsigned(2**to_integer(unsigned(I)), O'length));
end architecture;
