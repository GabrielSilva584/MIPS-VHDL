library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity mux2 is -- two-input multiplexer
	generic(
		width_g			: INTEGER
	);
	port(
		i_d0, i_d1	: in		STD_LOGIC_VECTOR(width_g - 1 downto 0);
		i_s			: in		STD_LOGIC;
		o_y			: out		STD_LOGIC_VECTOR(width_g - 1 downto 0)
	);
end;

architecture behave of mux2 is
begin
	o_y <= 	i_d0 WHEN i_s = '0' ELSE
				i_d1;
end;