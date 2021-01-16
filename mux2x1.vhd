library ieee;
use ieee.STD_LOGIC_1164.all;

entity mux2x1 is
port
(
	c_i  :  in std_logic;
	d_i  :  in std_logic;
	s2_i :  in std_logic;
	e_i  :  in std_logic;
	f_i  :  in std_logic;
	s3_i :  in std_logic;
	q2_o : out std_logic;
	q3_o : out std_logic
);
end mux2x1;

architecture Behavioral of mux2x1 is
signal temp1 : std_logic := '0';
signal temp2 : std_logic := '0';

begin

-------------------------------------------------------------
-- CONCURRENT ASSIGNMENT COMBINATIONAL DESIGN
-------------------------------------------------------------
q2_o <= c_i when s2_i = '1' else
				d_i;

-------------------------------------------------------------
-- Process COMBINATIONAL DESIGN
-------------------------------------------------------------

P_LABEL : process (s3_i, e_i, f_i) begin

	if (s3_i = '1') then
		q3_o <= e_i;
	else
		q3_o <= f_i;
	end if;
end process P_LABEL;

end architecture Behavioral;