library ieee;
library CombinatorialTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use CombinatorialTools.nBitsDecoder.all;
use CombinatorialTools.my_types.all;

entity data_memory is
    generic ( ADDR_WIDTH : natural := 32);
    port (
            address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
            data_in : in std_logic_vector(31 downto 0);
            data_out: out std_logic_vector(31 downto 0);
            EcrireMem_B : in std_logic;
            EcrireMem_H : in std_logic;
            EcrireMem_W : in std_logic;
            LireMem_W : in std_logic;
            LireMem_UB : in std_logic;
            LireMem_UH : in std_logic;
            LireMem_SB : in std_logic;
            LireMem_SH : in std_logic;
            CS : in std_logic;
            WE : in std_logic;
            OE : in std_logic;
            CLK: in std_logic
        );
end entity data_memory;

--not using EcrireMem(3 downto 0)
architecture behavior of data_memory is
    --pas de memoire trop grande, sinon crash
    --signal mem : nWays(2**ADDR_WIDTH-1 downto 0);
    signal mem : nWays(ADDR_WIDTH-1 downto 0);
    signal address_mot : std_logic_vector(ADDR_WIDTH-3 downto 0);
    signal Selected : std_logic;
    signal data_out_buf : std_logic_vector (31 downto 0);
    signal data_out_buf1 : std_logic_vector (31 downto 0);
    signal buf : std_logic_vector(31 downto 0);
    --TODO no initial value?
begin
    address_mot <= address(ADDR_WIDTH-1 downto 2);
    --address_mot(ADDR_WIDTH-3 downto 0) <= address(ADDR_WIDTH-1 downto 2);
    Selected <= '1' when CS ='0' and WE='0' and rising_edge(CLK) else '0';


    buf(31 downto 24) <= data_in(31 downto 24) when EcrireMem_W and Selected else
                        data_in(23 downto 16) when address(1) and EcrireMem_H and Selected else
                        data_in(7 downto 0) when address(1) and address(0) and EcrireMem_B and Selected;



    buf(23 downto 16) <= data_in(23 downto 16) when EcrireMem_W and Selected else
    data_in(7 downto 0) when address(1) and EcrireMem_H and Selected else
    data_in(7 downto 0) when address(1) and not address(0) and EcrireMem_B and Selected;

    buf(15 downto 8) <= data_in(15 downto 8)   when EcrireMem_W='1' and Selected='1' else
    data_in(15 downto 8) when EcrireMem_H='1' and address(1)='0' and Selected='1' else
    data_in(7 downto 0) when EcrireMem_B='1' and address(1)='0' and address(0)='1' and Selected='1';

    buf(7 downto 0) <= data_in(7 downto 0) when EcrireMem_W='1' and Selected='1' else
    data_in(7 downto 0) when EcrireMem_H='1' and address(1)='0' and Selected = '1' else
    data_in(7 downto 0) when EcrireMem_B='1' and address(1)='0' and address(0) = '0' and Selected='1';

    mem(to_integer(unsigned(address_mot))) <= buf when Selected = '1';



  --TODO Verify
    data_out_buf <= mem(to_integer(unsigned(address_mot) )) when not CS and WE and not OE;

    data_out_buf1(31 downto 16) <= data_out_buf(31 downto 16) when LireMem_W else
    (others => '1') when (LireMem_SH and data_out_buf(15)) or (LireMem_SB and data_out_buf(7)) else
    (others => '0');
    data_out_buf1(15 downto 8) <= data_out_buf(15 downto 8) when LireMem_W or LireMem_SH or LireMem_UH else
    (others => '1') when LireMem_SB and data_out_buf(7) else
    (others => '0'); 
    data_out_buf1(7 downto 0) <= data_out_buf(7 downto 0);

    data_out <= data_out_buf1 when not CS and WE and not OE else
                (others => 'Z');

data_out <= mem(0);
end architecture behavior;
    --mem(0)(31 downto 24) <= data_in(31 downto 24);
    --mem(0)(23 downto 16) <= data_in(23 downto 16);
    --mem(0)(15 downto 8) <= data_in(15 downto 8);
    --mem(to_integer(unsigned (address_mot)))(7 downto 0) <= data_in(7 downto 0);
