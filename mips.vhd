library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity mips is -- single cycle MIPS processor
	
	generic(
		CONSTANT opCode_c : INTEGER; --6
		CONSTANT aluCtrl_c: INTEGER; --3
		CONSTANT bits_c   : INTEGER --32
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
	
	signal i_memtoreg, i_alusrc, i_regdst, i_regwrite, i_jump, i_pcsrc:	STD_LOGIC;
	signal o_zero:	STD_LOGIC;
	signal i_alucontrol:	STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0);
begin
	cont: controller
		port map(
			i_instr(bits_c-1 downto (bits_c - opCode_c)), i_instr(opCode_c-1 downto 0), o_zero, i_memtoreg,
			memwrite, i_pcsrc, i_alusrc, i_regdst,i_regwrite, i_jump, i_alucontrol
		);
	dp: datapath
		port map(
			i_clk, i_reset, i_memtoreg, i_pcsrc, i_alusrc,i_regdst, i_regwrite, i_jump, 
			i_alucontrol, o_zero, o_pc, i_instr, o_aluout, o_writedata,i_readdata
		);
end;
