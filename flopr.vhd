library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity flopr is -- flip-flop with synchronous reset
	generic(
		width		: integer
	);
	port(
		clk, reset	: in		STD_LOGIC;
		d			: in		STD_LOGIC_VECTOR(width-1 downto 0);
		q			: out		STD_LOGIC_VECTOR(width-1 downto 0)
	);
end;

architecture asynchronous of flopr is
begin
	-- Implementar
end;