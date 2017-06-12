library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity signext is -- sign extender
	generic(
		CONSTANT bits_c : INTEGER
	);
	port(
		a	: in	STD_LOGIC_VECTOR(15 downto 0);
		y	: out	STD_LOGIC_VECTOR(bits_c - 1 downto 0)
	);
end;

architecture behave of signext is
	ALIAS y_baixo : STD_LOGIC_VECTOR(15 downto 0) IS y(15 downto 0);
begin
	y_baixo <= a(15 downto 0);
	SignExtend: for i in 16 to bits_c - 1 generate
		y(i) <= a(15);
	end generate;
end;