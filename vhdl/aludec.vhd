library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity aludec is -- ALU control decoder
	
	generic(
		CONSTANT opCode_c		: INTEGER; --6
		CONSTANT aluCtrl_c	: INTEGER; --3
		CONSTANT aluOp_c		: INTEGER --2
	);
	
	port(
		i_funct			: in		STD_LOGIC_VECTOR(opCode_c-1 downto 0);
		i_aluop			: in		STD_LOGIC_VECTOR(aluOp_c-1 downto 0);
		o_alucontrol	: out		STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0)
	);
	
end;

architecture behave of aludec is

begin
	
	process(i_aluop, i_funct) begin
		case i_aluop is
			when "00" => o_alucontrol <= "010"; -- add (for 1b/sb/addi)
			when "01" => o_alucontrol <= "110"; -- sub (for beq)
			when others =>
				case i_funct is -- R-type instructions
					when "100000" => o_alucontrol <= "010"; -- add
					when "100010" => o_alucontrol <= "110"; -- sub
					when "100100" => o_alucontrol <= "000"; -- and
					when "100101" => o_alucontrol <= "001"; -- or
					when "101010" => o_alucontrol <= "111"; -- slt
					when others   => o_alucontrol <= "---"; -- ???
				end case;
		end case;
	end process;
end;