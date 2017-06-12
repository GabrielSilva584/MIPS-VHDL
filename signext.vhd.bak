library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity signext is -- sign extender
	
	generic(
		CONSTANT bits_c: integer;
		CONSTANT adress_c: integer
	);
	
	port(
		a	: in	STD_LOGIC_VECTOR(adress_c-1 downto 0);
		y	: out	STD_LOGIC_VECTOR(bits_c-1 downto 0)
	);
end;

architecture behave of signext is

begin
	
	y(adress_c-1 downto 0)        <= a;
	y(bits_c-1 downto adress_c)   <= (others => a(adress_c-1));
	
end;