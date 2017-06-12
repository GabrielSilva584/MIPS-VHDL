library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity regfile is -- three-port register file

	generic(
		CONSTANT bits_c : INTEGER; --32
		CONSTANT reg_c  : INTEGER --5
	);

	port(
		i_clk				      : in		STD_LOGIC;
		i_we3				      : in		STD_LOGIC;
		i_ra1, i_ra2, i_wa3	: in		STD_LOGIC_VECTOR(reg_c - 1 downto 0);
		i_wd3				      : in		STD_LOGIC_VECTOR(bits_c - 1 downto 0);
		o_rd1, o_rd2			: out		STD_LOGIC_VECTOR(bits_c - 1 downto 0)
	);

end;

architecture behave of regfile is

	type ramtype is array(bits_c - 1 downto 0) of STD_LOGIC_VECTOR(bits_c - 1 downto 0);
	signal mem_s: ramtype;

begin
	-- three-ported register file
	-- read two ports combinationally
	-- write third port on rising edge of clock
	process(i_clk) begin
		if(i_clk'event and i_clk = '1') then
			if i_we3 = '1' then
				mem_s(CONV_INTEGER(i_wa3)) <= i_wd3;
			end if;
		end if;
	end process;

	process(i_ra1, i_ra2, mem_s) begin
		if(conv_integer(i_ra1) = 0) then
			o_rd1 <= X"00000000";  -- register 0 holds 0
		else
			o_rd1 <= mem_s(CONV_INTEGER(i_ra1));
		end if;
		if(conv_integer(i_ra2) = 0) then
			o_rd2 <= X"00000000";
		else
			o_rd2 <= mem_s(CONV_INTEGER(i_ra2));
		end if;
	end process;
	
end;