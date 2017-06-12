library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity maindec is -- main control decoder
	
	generic(
		CONSTANT opCode_c		: INTEGER; --6
		CONSTANT ctrl_c		: INTEGER; --9
		CONSTANT aluOp_c		: INTEGER --2
	);
	
	port(
		i_op							: in		STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		o_memtoreg, o_memwrite	: out		STD_LOGIC;
		o_branch, o_alusrc		: out		STD_LOGIC;
		o_regdst, o_regwrite		: out		STD_LOGIC;
		o_jump						: out		STD_LOGIC;
		o_aluop						: out		STD_LOGIC_VECTOR(aluOp_c-1 downto 0)
	);
	
end;

architecture behave of maindec is
	signal controls_s		: STD_LOGIC_VECTOR(ctrl_c-1 downto 0);
begin
	process(i_op)
	begin
		case i_op is
			when "000000" => controls_s <= "110000010"; -- Rtyp
			when "100011" => controls_s <= "101001000"; -- LW
			when "101011" => controls_s <= "001010000"; -- SW
			when "000100" => controls_s <= "000100001"; -- BEQ
			when "001000" => controls_s <= "101000000"; -- ADDI
			when "000010" => controls_s <= "000000100"; -- J
			when others   => controls_s <= "---------"; -- illegal i_op
		end case;
	end process;
	o_regwrite	<= controls_s(8);
	o_regdst		<= controls_s(7);
	o_alusrc		<= controls_s(6);
	o_branch		<= controls_s(5);
	o_memwrite	<= controls_s(4);
	o_memtoreg	<= controls_s(3);
	o_jump		<= controls_s(2);
	o_aluop		<= controls_s(1 downto 0);
end;