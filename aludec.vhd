library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity aludec is -- ALU control decoder
	
	generic(
		CONSTANT opCode_c: INTEGER; --6
		CONSTANT aluCtrl_c: INTEGER; --3
		CONSTANT aluOp_c: INTEGER --2
	);
	
	port(
		funct		: in		STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		aluop		: in		STD_LOGIC_VECTOR(aluOp_c-1 downto 0);
		alucontrol	: out		STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0)
	);
	
end;

architecture behave of aludec is

begin
	
	process(aluop, funct) begin
		case aluop is
			when "00" => alucontrol <= "010"; -- add (for 1b/sb/addi)
			when "01" => alucontrol <= "110"; -- sub (for beq)
			when others =>
				case funct is -- R-type instructions
					when "100000" => alucontrol <= "010"; -- add
					when "100010" => alucontrol <= "110"; -- sub
					when "100100" => alucontrol <= "000"; -- and
					when "100101" => alucontrol <= "001"; -- or
					when "101010" => alucontrol <= "111"; -- slt
					when others   => alucontrol <= "---"; -- ???
				end case;
		end case;
	end process;
	
end;