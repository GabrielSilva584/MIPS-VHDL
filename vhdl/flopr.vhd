library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity flopr is -- flip-flop with synchronous reset
	
	generic(
		width_g		: INTEGER
	);
	
	port(
		i_clk, i_reset	: in		STD_LOGIC;
		i_d			   : in		STD_LOGIC_VECTOR(width_g-1 downto 0);
		o_q			   : out		STD_LOGIC_VECTOR(width_g-1 downto 0)
	);
end;

architecture synchronous of flopr is
begin
	
	risingEdge: PROCESS(i_clk, i_reset)
	BEGIN
		IF (i_clk'EVENT AND i_clk'LAST_VALUE = '0') THEN
			IF i_reset = '1' THEN o_q <= (others => '0');
			ELSE o_q <= i_d;
			END IF;
		END IF;
	END PROCESS;
	
end;