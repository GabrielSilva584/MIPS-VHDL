library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity adder is -- adder
	generic(
		CONSTANT bits_c	: INTEGER
	);
	port(
		i_a, i_b		: in		STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		o_y			: out		STD_LOGIC_VECTOR(bits_c - 1 downto 0)
	);
end;

architecture behave of adder is
	SIGNAL carry: STD_LOGIC_VECTOR(bits_c downto 0);
begin
	carry(0) <= '0';
	
	Adder: for i in 0 to bits_c - 1 generate
		o_y(i) <= i_a(i) xor i_b(i) xor carry(i);
		carry(i+1) <= (i_a(i) and i_b(i)) or (carry(i) and i_a(i)) or (carry(i) and i_b(i));
	end generate;
end;