library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity adder is -- adder
	generic(
		CONSTANT bits_c: INTEGER
	);
	port(
		a, b	: in		STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		y		: out		STD_LOGIC_VECTOR(bits_c - 1 downto 0)
	);
end;

architecture behave of adder is
	SIGNAL carry: STD_LOGIC_VECTOR(bits_c downto 0);
begin
	carry(0) <= '0';
	
	Adder: for i in 0 to bits_c - 1 generate
		y(i) <= a(i) xor b(i) xor carry(i);
		carry(i+1) <= (a(i) and b(i)) or (carry(i) and a(i)) or (carry(i) and b(i));
	end generate;
end;