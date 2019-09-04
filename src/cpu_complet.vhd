library ieee;
library CombinatorialTools;
library SequentielTools;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    port (
    signal CPU_CLK : IN std_logic;
    signal CLK_memInst : IN std_logic;
    signal WE_memInst : IN std_logic;
    signal OE_memInst : IN std_logic;
    signal data_in_memInst: IN std_logic_vector(31 downto 0);
    signal CP_TEST : IN std_logic_vector(31 downto 0);
    signal TEST : in std_logic
    );
end entity;

architecture behavior of cpu is
    signal NOT_CPU_CLK: std_logic;

    --minterm instruction
    signal minterm_inst : std_logic_vector(63 downto 0);

    --inst
    signal inst : std_logic_vector(31 downto 0);

    -- MemVersReg
    signal memVersReg : std_logic_vector(1 downto 0);
    signal memVersReg_muxOut: std_logic_vector(31 downto 0);

    -- Bans Registres
    signal outReg1 : std_logic_vector(31 downto 0);
    signal outReg2 : std_logic_vector(31 downto 0);

    -- UAL signals
    signal UAL_A : std_logic_vector(31 downto 0);
    signal UAL_B : std_logic_vector(31 downto 0);
    signal UAL_sel : std_logic_vector(3 downto 0);
    signal UAL_ValDec : std_logic_vector (4 downto 0);
    signal UAL_Slt_Slti : std_logic;
    signal UAL_Enable_V : std_logic;
    signal C : std_logic;
    signal V : std_logic;
    signal N : std_logic;
    signal Z : std_logic;
    signal UAL_OUT : std_logic_vector(31 downto 0);

    signal UALOp : std_logic_vector(1 downto 0);
    signal ExtOp : std_logic;
    signal outExtOp : std_logic_vector(31 downto 0);

    signal CPSrc : std_logic;

    signal RegDst : std_logic_vector(1 downto 0);
    signal RegDst_muxOut: std_logic_vector(4 downto 0);

    --UALSrc
    signal UALSrc: std_logic_vector(1 downto 0);
    signal UALSrc_muxOut : std_logic_vector(31 downto 0);
    signal UALSrc_lui : std_logic_vector(31 downto 0);

    --data memory
    signal CS_dataMem : std_logic;
    signal WE_dataMem : std_logic;
    signal OE_dataMem : std_logic;
    signal LireMem_W : std_logic;
    signal LireMem_UB : std_logic;
    signal LireMem_UH : std_logic;
    signal LireMem_SB : std_logic;
    signal LireMem_SH : std_logic;
    signal EcrireMem_B : std_logic;
    signal EcrireMem_H : std_logic;
    signal EcrireMem_W : std_logic;
    signal EcrireReg : std_logic;
    signal outMemData : std_logic_vector(31 downto 0);
    signal W_dataMem : std_logic;
    signal R_dataMem : std_logic;
    signal addresse_in : std_logic_vector(31 downto 0);

    --branchement
    signal B_eq : std_logic;
    signal B_ne : std_logic;
    signal B_lez : std_logic;
    signal B_gtz : std_logic;
    signal B_ltz : std_logic;
--
    --Saut
    signal Saut : std_logic_vector(1 downto 0);
    signal addr_jal_j : std_logic_vector(31 downto 0);
    signal CP_plus_4 : std_logic_vector(31 downto 0);
    signal addr_relative : std_logic_vector(31 downto 0);
    signal addr_relative_buf: std_logic_vector(31 downto 0);

    --CP
    signal CP : std_logic_vector(31 downto 0);
    signal Saut_muxOut : std_logic_vector(31 downto 0);
    signal CPSrc_muxOut : std_logic_vector(31 downto 0);

    signal zeros : std_logic_vector(31 downto 0);
begin
    NOT_CPU_CLK <= not CPU_CLK;
    ------------------------------
    ----  Memory Instruction  ----
    ------------------------------
    mem_inst : entity SequentielTools.sram
    generic map( ADDR_WIDTH => 32 )
    port map(
                address => CP,
                data_in => data_in_memInst,
                data_out => inst,
                CS => '0',
                WE => WE_memInst,
                OE => OE_memInst,
                CLK => CLK_memInst
            );
    ------------------------------
    ---------  Decodage  ---------
    ------------------------------
    decodage_inst: entity CombinatorialTools.nBitsDecoder
    generic map (n => 6)
    port map (din => inst(31 downto 26),
              dout => minterm_inst 
          );


    ------------------------------
    ------- Mux MemVersReg ------- 
    ------------------------------
    memVersReg(1) <= (minterm_inst(0) and not inst(5) and inst(3)) or minterm_inst(1) or minterm_inst(3);
    memVersReg(0) <= minterm_inst(32) or minterm_inst(33) or minterm_inst(35) or minterm_inst(36) or minterm_inst(37);
    memVersReg_muxOut <= Saut_muxOut when memVersReg = "10" else
                         outMemData when memVersReg = "01" else
                         UAL_OUT when memVersReg = "00";

    ------------------------------
    --------- Mux RegDst --------- 
    ------------------------------
    RegDst(0) <= minterm_inst(0);
    RegDst(1) <= minterm_inst(1) or minterm_inst(1);

    RegDst_muxOut <= inst(20 downto 16)  when RegDst = "00" else
                     inst(15 downto 11)  when RegDst = "01" else
                     (others => '1') when RegDst = "10";

    ------------------------------
    ------ Banc de registres ----- 
    ------------------------------
    EcrireReg <= minterm_inst(0) or minterm_inst(1) or minterm_inst(3) or minterm_inst(8) or minterm_inst(9) or minterm_inst(10) or minterm_inst(11) or minterm_inst(12) or minterm_inst(13) or minterm_inst(14) or minterm_inst(15) or minterm_inst(32) or minterm_inst(33) or minterm_inst(35) or minterm_inst(36) or minterm_inst(37);
    --TODO use CPU_CLK? USE NOT_CPU_CLK
    banc_registre : entity SequentielTools.banc_registers
    generic map (5)
    port map(  din_w => memVersReg_muxOut,
               CLK => NOT_CPU_CLK,
               --Regs to read
               reg_r1 => inst(25 downto 21),
               reg_r2 => inst(20 downto 16),
               --Data read
               dout_r1 => outReg1,
               dout_r2 => outReg2,
            --Reg to write
               reg_w => RegDst_muxOut,
               W => EcrireReg
           );

    ------------------------------
    ---- Operation Extension ----- 
    ------------------------------
    ExtOp <= minterm_inst(1) or minterm_inst(4) or minterm_inst(5) or minterm_inst(6) or minterm_inst(7) or minterm_inst(8) or minterm_inst(10) or minterm_inst(32) or minterm_inst(33) or minterm_inst(35) or minterm_inst(36) or minterm_inst(37) or minterm_inst(40) or minterm_inst(41) or minterm_inst(43);

    outExtOp(31 downto 16) <= (others => '1') when ExtOp and inst(15) else
    (others => '0');
    outExtOp(15 downto 0)  <= inst(15 downto 0);

    ------------------------------
    -------  Control UAL ---------
    ------------------------------
    UALOp(0) <= minterm_inst(1) or minterm_inst(4) or minterm_inst(5) or minterm_inst(6) or minterm_inst(7) or minterm_inst(8) or minterm_inst(9) or minterm_inst(10) or minterm_inst(11) or minterm_inst(12) or minterm_inst(13) or minterm_inst(14) or minterm_inst(15);

    UALOp(1) <= minterm_inst(0) or minterm_inst(8) or minterm_inst(9) or minterm_inst(10) or minterm_inst(11) or minterm_inst(12) or minterm_inst(13) or minterm_inst(14) or minterm_inst(15);

    --Enable_V
    UAL_Enable_V <= ( UALOp(1) and not UALOp(0) and inst(5) and not inst(2) and not inst(0) ) OR 
                    ( UALOp(1) and UALOp(0) and not inst(26) and not inst(28) );
    --UAL_Slt_Slti
    UAL_Slt_Slti <= (UALOp(1) and not UALOp(0) and inst(3) and not inst(2) and inst(1) and not inst(0)) OR
                    (UALOp(1) and UALOp(0) and not inst(28) and inst(27) and not inst(26));
    --UAL_sel
    UAL_sel(0) <= (UALOp(1) and not UALOp(0) and 
                  ((not inst(5) and not inst(3) and not inst(2) and not inst(1) and not inst(0))
                  OR (inst(5) and not inst(3) and inst(2) and not inst(1) and inst(0)) 
                  OR (not inst(5) and not inst(3) and inst(2) and inst(1) and not inst(0))
                  OR (not inst(5) and inst(3) and not inst(2) and inst(1))
              ))
    OR (UALOp(1) and UALOp(0) and (inst(27) or (inst(28) and inst(26))));


    UAL_sel(1) <= (not UALOp(1))OR 
                  (UALOp(1)and not UALOp(0) and
                  ( (not inst(3) and not inst(2) and not inst(0))
                    OR (not inst(5) and not inst(3) and inst(2) and not inst(1) and not inst(0))
                    OR (not inst(5) and inst(3) and not inst(2) and not inst(1) and inst(0))
                    OR (inst(5) and not inst(3) and not inst(2) and inst(0))
                    OR (not inst(5) and inst(3) and not inst(2) and inst(1))
                  )
                  )
OR (UALOp(1) and UALOp(0) and not inst(28));

    UAL_sel(2) <= (UALOp(1) and not UALOp(0) and
                        ((not inst(5) and not inst(3) and not inst(2) and not inst(0))
                         OR (not inst(5) and not inst(3) and inst(2) and inst(1))
                        )
                  )
                  OR (UALOp(1) and UALOp(0) and inst(28) and inst(27) and not inst(26));

    UAL_sel(3) <= (not UALOp(1) and UALOp(0))
                  OR (UALOp(1) and not UALOp(0) and 
                        ( (inst(5) and not inst(3) and not inst(2) and inst(1))
                            OR (not inst(5) and inst(3) and not inst(2) and inst(1))
                        )
                     )
                  OR (UALOp(1) and UALOp(0) and not inst(28) and inst(27));


    ------------------------------
    --------  Mux UALSrc ---------
    ------------------------------
    UALSrc (1) <=  minterm_inst(15) or minterm_inst(1);
    UALSrc (0) <=  minterm_inst(8) or minterm_inst(9) or minterm_inst(10) or minterm_inst(11) or minterm_inst(12) or minterm_inst(13) or minterm_inst(14) or minterm_inst(15) or minterm_inst(32) or minterm_inst(33) or minterm_inst(35) or minterm_inst(36) or minterm_inst(37) or minterm_inst(40) or minterm_inst(41) or minterm_inst(43) ;
    UALSrc_lui (31 downto 16) <= inst(15 downto 0);
    UALSrc_lui (15 downto 0) <= (others => '0');

    UALSrc_muxOut <= outReg2 when UALSrc = "00" else
                     outExtOp    when UALSrc = "01" else
                     (others => '0') when UALSrc = "10" else
                     UALSrc_lui  when UALSrc = "11";

    ------------------------------
    -----------  UAL  ------------
    ------------------------------
    --TODO use CPU_CLK??? USE NOT_CPU_CLK
    --TODO dans le cas de Shift, pas de shift a valeur immediate?
    UAL_A <= outReg1;
    UAL_B <= UALSrc_muxOut;
    UAL: entity CombinatorialTools.UAL_32b
    port map (UAL_A,UAL_B,UAL_sel(2 downto 0),UAL_sel(3),NOT_CPU_CLK,inst(10 downto 6), UAL_Slt_Slti,UAL_Enable_V,C,V,N,Z,UAL_OUT);

    ------------------------------
    -------  Data Memory  --------
    ------------------------------
    --TODO use CPU_CLK??? USE NOT_CPU_CLK
    LireMem_W <= minterm_inst(35);
    LireMem_UB <= minterm_inst(36);
    LireMem_UH <= minterm_inst(37);
    LireMem_SB <= minterm_inst(32);
    LireMem_SH <= minterm_inst(33);
    EcrireMem_B <= minterm_inst(40);
    EcrireMem_H <= minterm_inst(41);
    EcrireMem_W <= minterm_inst(43);

    W_dataMem <= EcrireMem_W or EcrireMem_H or EcrireMem_B;
    R_dataMem <= LireMem_W or LireMem_UB or LireMem_UH or LireMem_SB or LireMem_SH;
    WE_dataMem <= not W_dataMem;
    CS_dataMem <= not (W_dataMem or R_dataMem);
    OE_dataMem <= '0';
    
    addresse_in <= (others => '0') when CS_dataMem
                   else UAL_OUT;
    dataMem : entity SequentielTools.data_memory
    port map(addresse_in, outReg2, outMemData, EcrireMem_B,EcrireMem_H,EcrireMem_W, LireMem_W, LireMem_UB, LireMem_UH, LireMem_SB, LireMem_SH, CS_dataMem, WE_dataMem, OE_dataMem, NOT_CPU_CLK);


    ------------------------------
    --------  Mux CPSrc ----------
    ------------------------------

    CPSrc <= ( minterm_inst(4) and Z ) OR 
             ( minterm_inst(6) and not Z )  OR 
             ( minterm_inst(6) and (N or Z)) OR 
             ( minterm_inst(7)and not N and not Z) OR 
             ( (minterm_inst(1) and (N and not inst(16))) or ((not N and Z) and inst(16)) );


    -------------------------------------------------------
    ------------------- Saut & CP -------------------------
    -------------------------------------------------------
    CP_plus_4 <= std_logic_vector(to_unsigned(
                                    to_integer(unsigned(CP))+4,
                                    CP_plus_4'length)
                                 );

    addr_jal_j (31 downto 28) <= CP(31 downto 28);
    addr_jal_j (27 downto 2) <= inst(25 downto 0);
    addr_jal_j (1 downto 0) <= (others => '0');
    addr_relative_buf(31 downto 2)<= outExtOp(29 downto 0);
    addr_relative_buf(1 downto 0)<= (others => '0');

    addr_relative <= std_logic_vector(to_unsigned(
                                        to_integer(unsigned(CP))+ to_integer(unsigned(addr_relative_buf)),
                                        addr_relative'length)
                                    );
    CP <= CP_TEST when TEST else
          Saut_muxOut when rising_edge(CPU_CLK);
    CPSrc_muxOut <= addr_relative when CPSrc = '1' else
                    CP_plus_4 ;

    Saut(0) <= minterm_inst(2) or minterm_inst(3);
    Saut(1) <= minterm_inst(0) and inst(5) and inst(3);

    Saut_muxOut <= CPSrc_muxOut when Saut = "00" else
                   addr_jal_j when Saut = "01"else
                   UAL_OUT when Saut ="10";
--addr_deroutement when "11";
end architecture;
