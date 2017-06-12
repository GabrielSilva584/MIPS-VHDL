library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity controller is -- single cycle control decoder
	
	generic(
		CONSTANT opCode_c		: INTEGER; --6
		CONSTANT aluCtrl_c	: INTEGER; --3
		CONSTANT ctrl_c 		: INTEGER; --9
		CONSTANT aluOp_c		: INTEGER --2
	);
	
	port(
		i_op, i_funct				: in		STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		i_zero						: in		STD_LOGIC;
		o_memtoreg, o_memwrite	: out		STD_LOGIC;
		o_pcsrc, o_alusrc			: out		STD_LOGIC;
		o_regdst, o_regwrite		: out		STD_LOGIC;
		o_jump						: out		STD_LOGIC;
		o_alucontrol				: out		STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0));
end;

architecture struct of controller is
	
	component maindec
	generic(
		CONSTANT opCode_c		: INTEGER; --6
		CONSTANT ctrl_c		: INTEGER; --9
		CONSTANT aluOp_c		: INTEGER --2
	);
	port(
		i_op							: in STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		o_memtoreg, o_memwrite	: out STD_LOGIC;
		o_branch, o_alusrc		: out STD_LOGIC;
		o_regdst, o_regwrite		: out STD_LOGIC;
		o_jump						: out STD_LOGIC;
		o_aluop						: out STD_LOGIC_VECTOR(aluOp_c-1 downto 0)
	);
	end component;
	
	component aludec
	generic(
		CONSTANT opCode_c		: INTEGER; --6
		CONSTANT aluCtrl_c	: INTEGER; --3
		CONSTANT aluOp_c		: INTEGER --2
	);
	port(
		i_funct			: in STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		i_aluop			: in STD_LOGIC_VECTOR(aluOp_c-1 downto 0);
		o_alucontrol	: out STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0)
	);
	end component;
	
	signal aluop_s		: STD_LOGIC_VECTOR(aluOp_c-1 downto 0);
	signal branch_s	: STD_LOGIC;
	
begin

	md: maindec
		generic map(
			opCode_c, ctrl_c, aluOp_c
		)
		port map(
			i_op, o_memtoreg, o_memwrite, branch_s,
			o_alusrc, o_regdst, o_regwrite, o_jump, aluop_s
		);
	ad: aludec
		generic map(
			opCode_c, aluCtrl_c, aluOp_c
		)
		port map(
			i_funct, aluop_s, o_alucontrol
		);
	o_pcsrc <= branch_s and i_zero;
	
end;