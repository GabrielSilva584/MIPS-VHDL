library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity mips is -- single cycle MIPS processor
	
	generic(
		CONSTANT opCode_c : INTEGER; --6
		CONSTANT aluCtrl_c: INTEGER; --3
		CONSTANT bits_c   : INTEGER; --32
		CONSTANT ctrl_c 	: INTEGER; --9
		CONSTANT aluOp_c	: INTEGER; --2
		CONSTANT adress_c : INTEGER; --16
		CONSTANT reg_c 	: INTEGER --5
	);
	
	port(
		i_clk, i_reset			  : in		STD_LOGIC;
		o_pc					     : out		STD_LOGIC_VECTOR(bits_c-1 downto 0);
		i_instr				     : in		STD_LOGIC_VECTOR(bits_c-1 downto 0);
		o_memwrite			     : out		STD_LOGIC;
		o_aluout, o_writedata  : out		STD_LOGIC_VECTOR(bits_c-1 downto 0);
		i_readdata			     : in		STD_LOGIC_VECTOR(bits_c-1 downto 0)
	);
end;

architecture struct of mips is
	component controller
	generic(
		CONSTANT opCode_c		: INTEGER; --6
		CONSTANT aluCtrl_c	: INTEGER; --3
		CONSTANT ctrl_c 		: INTEGER; --9
		CONSTANT aluOp_c		: INTEGER --2
	);
	port(
		i_op, i_funct			   : in		STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		i_zero				      : in		STD_LOGIC;
		o_memtoreg, o_memwrite  : out		STD_LOGIC;
		o_pcsrc, o_alusrc		   : out		STD_LOGIC;
		o_regdst, o_regwrite	   : out		STD_LOGIC;
		o_jump				      : out		STD_LOGIC;
		o_alucontrol			   : out		STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0)
	);
	end component;
	component datapath
	generic(
		CONSTANT bits_c : INTEGER; --32
		CONSTANT aluCtrl_c : INTEGER; --3
		CONSTANT adress_c : INTEGER; --16
		CONSTANT reg_c : INTEGER; --5
		CONSTANT opCode_c: INTEGER --6
	);
	port(
		i_clk, i_reset			 : in		STD_LOGIC;
		i_memtoreg, i_pcsrc	 : in		STD_LOGIC;
		i_alusrc, i_regdst	 : in		STD_LOGIC;
		i_regwrite, i_jump	 : in		STD_LOGIC;
		i_alucontrol			 : in		STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0);
		o_zero				    : out		STD_LOGIC;
		o_pc					    : buffer	STD_LOGIC_VECTOR(bits_c-1 downto 0);
		i_instr				    : in		STD_LOGIC_VECTOR(bits_c-1 downto 0);
		o_aluout, o_writedata : buffer	STD_LOGIC_VECTOR(bits_c-1 downto 0);
		i_readdata			    : in		STD_LOGIC_VECTOR(bits_c-1 downto 0));
	end component;
	
	signal memtoreg_s, alusrc_s, regdst_s	 			:	STD_LOGIC;
	signal zero_s, regwrite_s, jump_s, pcsrc_s		:	STD_LOGIC;
	signal alucontrol_s										:	STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0);
begin
	cont: controller
		generic map(
			opCode_c, aluCtrl_c, ctrl_c, aluOp_c	
		)
		port map(
			i_instr(bits_c-1 downto (bits_c - opCode_c)), i_instr(opCode_c-1 downto 0), zero_s, memtoreg_s,
			o_memwrite, pcsrc_s, alusrc_s, regdst_s, regwrite_s, jump_s, alucontrol_s
		);
	dp: datapath
		generic map(
			bits_c, aluCtrl_c, adress_c, reg_c, opCode_c
		)
		port map(
			i_clk, i_reset, memtoreg_s, pcsrc_s, alusrc_s, regdst_s, regwrite_s, jump_s, 
			alucontrol_s, zero_s, o_pc, i_instr, o_aluout, o_writedata, i_readdata
		);
end;
