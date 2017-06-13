library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity datapath is -- MIPS datapath
	generic(
		CONSTANT bits_c : INTEGER; --32
		CONSTANT aluCtrl_c : INTEGER; --3
		CONSTANT adress_c : INTEGER; --16
		CONSTANT reg_c : INTEGER; --5
		CONSTANT opCode_c: INTEGER --6
	);
	port(
		i_clk, i_reset			: in		STD_LOGIC;
		i_memtoreg, i_pcsrc		: in		STD_LOGIC;
		i_alusrc, i_regdst		: in		STD_LOGIC;
		i_regwrite, i_jump		: in		STD_LOGIC;
		i_alucontrol			: in		STD_LOGIC_VECTOR(aluCtrl_c - 1 downto 0);
		o_zero				: out		STD_LOGIC;
		o_pc					: buffer	STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		i_instr				: in		STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		o_aluout, o_writedata	: buffer	STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		i_readdata			: in		STD_LOGIC_VECTOR(bits_c - 1 downto 0)
	);
end;
architecture struct of datapath is
	component alu
		generic(
			CONSTANT bits_c: INTEGER; --32
			CONSTANT aluCtrl_c: INTEGER --3
		);
		port(
			i_a, i_b: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			i_alucontrol: in STD_LOGIC_VECTOR(aluCtrl_c - 1 downto 0);
			o_result: buffer STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			o_zero: out STD_LOGIC
		);
	end component;
	component regfile
		generic(
			CONSTANT bits_c : INTEGER; --32
			CONSTANT reg_c  : INTEGER --5
		);
		port(
			i_clk: in STD_LOGIC;
			i_we3: in STD_LOGIC;
			i_ra1, i_ra2, i_wa3: in STD_LOGIC_VECTOR(reg_c - 1 downto 0);
			i_wd3: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			o_rd1, o_rd2: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
		);
	end component;
	component adder
		generic(
			CONSTANT bits_c : INTEGER --32
		);
		port(
			i_a, i_b: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			o_y: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
		);
	end component;
	component sl2
		generic(
			CONSTANT bits_c : INTEGER --32
		);
		port(
			i_a: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			o_y: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
		);
	end component;
	component signext
		generic(
			CONSTANT bits_c: INTEGER; --32
			CONSTANT adress_c: INTEGER --16
		);
		port(
			i_a: in STD_LOGIC_VECTOR(adress_c - 1 downto 0);
			o_y: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
		);
	end component;
	component flopr
		generic(
			width_g: integer
		);
		port(
			i_clk, i_reset: in STD_LOGIC;
			i_d: in STD_LOGIC_VECTOR(width_g-1 downto 0);
			o_q: out STD_LOGIC_VECTOR(width_g-1 downto 0)
		);
	end component;
	component mux2
		generic(
			width_g: integer
		);
		port(
			i_d0, i_d1: in STD_LOGIC_VECTOR(width_g-1 downto 0);
			i_s: in STD_LOGIC;
			o_y: out STD_LOGIC_VECTOR(width_g-1 downto 0)
		);
	end component;
	
	signal writereg_s: STD_LOGIC_VECTOR(reg_c - 1 downto 0);
	signal pcjump_s, pcnext_s, pcnextbr_s, pcplus4_s, pcbranch_s: STD_LOGIC_VECTOR(bits_c - 1 downto 0);
	signal signimm_s, signimmsh_s: STD_LOGIC_VECTOR(bits_c - 1 downto 0);
	signal srca_s, srcb_s, result_s: STD_LOGIC_VECTOR(bits_c - 1 downto 0);
begin
-- next PC logic
	pcjump_s <= pcplus4_s(bits_c - 1 downto bits_c - opCode_c + 2) & i_instr(bits_c - opCode_c - 1 downto 0) & "00";
	pcreg: flopr
		generic map(bits_c)
		port map(i_clk, i_reset, pcnext_s, o_pc);
	pcadd1: adder
		generic map(bits_c)
		port map(o_pc, X"00000004", pcplus4_s);
	immsh: sl2
		generic map(bits_c)
		port map(signimm_s, signimmsh_s);
	pcadd2: adder
		generic map(bits_c)
		port map(pcplus4_s, signimmsh_s, pcbranch_s);
	pcbrmux: mux2
		generic map(bits_c)
		port map(pcplus4_s, pcbranch_s, i_pcsrc, pcnextbr_s);
	pcmux: mux2
		generic map(bits_c)
		port map(pcnextbr_s, pcjump_s, i_jump, pcnext_s);
	-- register file logic
	rf: regfile
		generic map(bits_c, reg_c)
		port map(i_clk, i_regwrite, i_instr(bits_c - opCode_c - 1 downto bits_c - opCode_c - reg_c),
					i_instr(bits_c - opCode_c - reg_c - 1 downto bits_c - opCode_c - reg_c - reg_c),
					writereg_s, result_s, srca_s,	o_writedata);
	wrmux: mux2
		generic map(reg_c)
		port map(i_instr(bits_c - opCode_c - reg_c - 1 downto bits_c - opCode_c - reg_c - reg_c),
					i_instr(bits_c - opCode_c - reg_c - reg_c - 1 downto bits_c - opCode_c - reg_c - reg_c - reg_c),
					i_regdst, writereg_s);
	resmux: mux2
		generic map(bits_c)
		port map(o_aluout, i_readdata, i_memtoreg, result_s);
	se: signext
		generic map(bits_c, adress_c)
		port map(i_instr(adress_c - 1 downto 0), signimm_s);
	-- ALU logic
	srcbmux: mux2
		generic map(bits_c)
		port map(o_writedata, signimm_s, i_alusrc, srcb_s);
	mainalu: alu
		generic map(bits_c, aluCtrl_c)
		port map(srca_s, srcb_s, i_alucontrol, o_aluout, o_zero);
end;