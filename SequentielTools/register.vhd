library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_32b is
    port ( din : in std_logic_vector(31 downto 0);
            dout : out std_logic_vector(31 downto 0);
            clk : in std_logic
        );
end entity register_32b;

architecture behavior of register_32b is
--    signal reg : std_logic_vector(31 downto 0);
begin
        dout <= din when rising_edge(clk);
--    dout <= reg;
--    process (clk)
--    begin
--        if rising_edge(clk) then
--            reg <= din;
--        end if;
--    end process; 
end architecture behavior;
