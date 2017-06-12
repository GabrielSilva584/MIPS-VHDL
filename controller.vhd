library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity controller is -- single cycle control decoder
	
	generic(
		CONSTANT opCode_c: INTEGER; --6
		CONSTANT aluCtrl_c: INTEGER; --3
		CONSTANT aluOp_c: INTEGER --2
	);
	
	port(
		op, funct			: in		STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		zero				: in		STD_LOGIC;
		memtoreg, memwrite	: out		STD_LOGIC;
		pcsrc, alusrc		: out		STD_LOGIC;
		regdst, regwrite	: out		STD_LOGIC;
		jump				: out		STD_LOGIC;
		alucontrol			: out		STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0));
end;

architecture struct of controller is
	
	component maindec
	port(
		op: in STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		memtoreg, memwrite: out STD_LOGIC;
		branch, alusrc: out STD_LOGIC;
		regdst, regwrite: out STD_LOGIC;
		jump: out STD_LOGIC;
		aluop: out STD_LOGIC_VECTOR(aluOp_c-1 downto 0)
	);
	end component;
	
	component aludec
	port(
		funct: in STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		aluop: in STD_LOGIC_VECTOR(aluOp_c-1 downto 0);
		alucontrol: out STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0)
	);
	end component;
	
	signal aluop: STD_LOGIC_VECTOR(aluOp_c-1 downto 0);
	signal branch: STD_LOGIC;
	
begin

	md: maindec
		port map(
			op, memtoreg, memwrite, branch,	alusrc, regdst, regwrite, jump, aluop
		);
	ad: aludec
		port map(
			funct, aluop, alucontrol
		);
	pcsrc <= branch and zero;
	
end;