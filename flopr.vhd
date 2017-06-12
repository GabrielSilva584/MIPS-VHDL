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

architecture synchronous of flopr is
begin
	
	risingEdge: PROCESS(clk, reset)
	BEGIN
		IF (clk'EVENT AND clk'LAST_VALUE = '0') THEN
			IF reset = '1' THEN q <= (others => '0');
			ELSE q <= d;
			END IF;
		END IF;
	END PROCESS;
	
end;