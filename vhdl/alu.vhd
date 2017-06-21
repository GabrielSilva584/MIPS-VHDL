library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity alu is

	generic(
		CONSTANT bits_c    : INTEGER; --32
		CONSTANT aluCtrl_c : INTEGER  --3
	);

	port(
		i_a, i_b			: in		STD_LOGIC_VECTOR(bits_c-1 downto 0);
		i_alucontrol	: in		STD_LOGIC_VECTOR(aluCtrl_c-1 downto 0);
		o_result		   : buffer	STD_LOGIC_VECTOR(bits_c-1 downto 0);
		o_zero			: out		STD_LOGIC
	);
	
end entity;

architecture behave of alu is

	CONSTANT zero_const_c : STD_LOGIC_VECTOR(bits_c-1 downto 0) := (others => '0');

	ALIAS alucontrol_s : STD_LOGIC_VECTOR(2 downto 0) is
		i_alucontrol(2 downto 0);

begin

	process(alucontrol_s, i_a, i_b) is
	begin
		case alucontrol_s is
			when "000" => -- and
				o_result <= i_a and i_b;
			when "001" => -- or
				o_result <= i_a or i_b;
			when "010" => -- add
				o_result <= i_a + i_b;
			when "011" => -- nor
				o_result <= i_a nor i_b;
			when "100" => -- and
				o_result <= i_a and not i_b;
			when "101" => -- or
				o_result <= i_a or not i_b;
			when "110" => -- sub
				o_result <= i_a - i_b;
			when "111" => -- slt
				if (i_a<i_b) then
					o_result <= (0 => '1', others =>'0');
				else
					o_result <= zero_const_c;
				end if;
			when others =>
				o_result <= zero_const_c;
		end case;
	end process;

	o_zero <= 	'1' when o_result = zero_const_c else
				'1' when o_result(bits_c - 1) = '1' and alucontrol_s = "100" else
				'0';
	
end;