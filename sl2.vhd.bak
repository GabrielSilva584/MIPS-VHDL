library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity sl2 is -- shift left by 2
	generic(
		CONSTANT bits_c : INTEGER
	);
	port(
		a: in 	STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		y: out	STD_LOGIC_VECTOR(bits_c - 1 downto 0)
	);
end;

architecture behave of sl2 is
begin
	y(bits_c - 1 downto 2) <= a(bits_c - 3 downto 0);
	y(1 downto 0) <= (others => '0');
end;