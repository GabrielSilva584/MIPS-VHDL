library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity datapath is -- MIPS datapath
	generic(
		CONSTANT bits_c : INTEGER; --32
		CONSTANT aluCtrl_c : INTEGER; --3
		CONSTANT adress_c : INTEGER; --16
		CONSTANT reg_c : INTEGER; --5
		CONSTANT instr_c : INTEGER --32
	);
	port(
		clk, reset			: in		STD_LOGIC;
		memtoreg, pcsrc		: in		STD_LOGIC;
		alusrc, regdst		: in		STD_LOGIC;
		regwrite, jump		: in		STD_LOGIC;
		alucontrol			: in		STD_LOGIC_VECTOR(aluCtrl_c - 1 downto 0);
		zero				: out		STD_LOGIC;
		pc					: buffer	STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		instr				: in		STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		aluout, writedata	: buffer	STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		readdata			: in		STD_LOGIC_VECTOR(bits_c - 1 downto 0)
	);
end;
architecture struct of datapath is
	component alu
		generic(
			CONSTANT bits_c: INTEGER;
			CONSTANT aluCtrl_c: INTEGER
		);
		port(
			a, b: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			alucontrol: in STD_LOGIC_VECTOR(aluCtrl_c - 1 downto 0);
			result: buffer STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			zero: out STD_LOGIC
		);
	end component;
	component regfile
		port(
			clk: in STD_LOGIC;
			we3: in STD_LOGIC;
			ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
			wd3: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			rd1, rd2: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
		);
	end component;
	component adder
		generic(
			CONSTANT bits_c : INTEGER
		);
		port(
			a, b: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			y: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
		);
	end component;
	component sl2
		generic(
			CONSTANT bits_c : INTEGER
		);
		port(
			a: in STD_LOGIC_VECTOR(bits_c - 1 downto 0);
			y: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
			);
	end component;
	component signext
		generic(
			CONSTANT bits_c: INTEGER;
			CONSTANT adress_c: INTEGER
		);
		port(
			a: in STD_LOGIC_VECTOR(adress_c - 1 downto 0);
			y: out STD_LOGIC_VECTOR(bits_c - 1 downto 0)
		);
	end component;
	component flopr
		generic(
			width: integer
		);
		port(
			clk, reset: in STD_LOGIC;
			d: in STD_LOGIC_VECTOR(width-1 downto 0);
			q: out STD_LOGIC_VECTOR(width-1 downto 0)
		);
	end component;
	component mux2
		generic(
			width: integer
		);
		port(
			i_d0, i_d1: in STD_LOGIC_VECTOR(width-1 downto 0);
			i_s: in STD_LOGIC;
			o_y: out STD_LOGIC_VECTOR(width-1 downto 0)
		);
	end component;
	
	signal writereg: STD_LOGIC_VECTOR(4 downto 0);
	signal pcjump, pcnext, pcnextbr, pcplus4, pcbranch: STD_LOGIC_VECTOR(bits_c - 1 downto 0);
	signal signimm, signimmsh: STD_LOGIC_VECTOR(bits_c - 1 downto 0);
	signal srca, srcb, result: STD_LOGIC_VECTOR(bits_c - 1 downto 0);
begin
-- next PC logic
	pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
	pcreg: flopr
		generic map(bits_c)
		port map(clk, reset, pcnext, pc);
	pcadd1: adder
		generic map(bits_c)
		port map(pc, X"00000004", pcplus4);
	immsh: sl2
		generic map(bits_c)
		port map(signimm, signimmsh);
	pcadd2: adder
		generic map(bits_c)
		port map(pcplus4, signimmsh, pcbranch);
	pcbrmux: mux2
		generic map(bits_c)
		port map(pcplus4, pcbranch, pcsrc, pcnextbr);
	pcmux: mux2
		generic map(bits_c)
		port map(pcnextbr, pcjump, jump, pcnext);
	-- register file logic
	rf: regfile
		port map(clk, regwrite, instr(25 downto 21), instr(20 downto 16), writereg, result, srca,	writedata);
	wrmux: mux2
		generic map(5)
		port map(instr(20 downto 16), instr(15 downto 11), regdst, writereg);
	resmux: mux2
		generic map(bits_c)
		port map(aluout, readdata, memtoreg, result);
	se: signext
		generic map(bits_c, adress_c)
		port map(instr(adress_c - 1 downto 0), signimm);
	-- ALU logic
	srcbmux: mux2
		generic map(bits_c)
		port map(writedata, signimm, alusrc, srcb);
	mainalu: alu
		generic map(bits_c, aluCtrl_c)
		port map(srca, srcb, alucontrol, aluout, zero);
end;