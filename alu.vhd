library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity alu is
	port(
		a, b		: in		STD_LOGIC_VECTOR(31 downto 0);
		alucontrol	: in		STD_LOGIC_VECTOR(2 downto 0);
		result		: buffer	STD_LOGIC_VECTOR(31 downto 0);
		zero		: out		STD_LOGIC
	);
end entity;

architecture behave of alu is
	constant zero_const : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
	process(alucontrol, a, b) is
	begin
		case alucontrol is
			when "000" => -- and
				result <= a and b;
			when "001" => -- or
				result <= a or b;
			when "010" => -- add
				result <= a + b;
			when "011" => -- not used
				result <= zero_const; --null;
			when "100" => -- and
				result <= a and not b;
			when "101" => -- or
				result <= a or not b;
			when "110" => -- sub
				result <= a - b;
			when "111" => -- slt
				if (a<b) then
					result <= (0 => '1', others =>'0');
				else
					result <= zero_const;
				end if;
			when others =>
				result <= zero_const;
		end case;
	end process;
	zero <= '1' when result = zero_const else '0';
end nula;
