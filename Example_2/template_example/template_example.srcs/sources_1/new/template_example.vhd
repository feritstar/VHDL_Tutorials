----------------------------------------------------------------------------------
-- Company: 
-- Engineer: mfy
-- 
-- Create Date: 12/29/2020 10:22:41 PM
-- Design Name: 
-- Module Name: template_example - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
library xil_defaultlib;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.NUMERIC_STD.ALL;
-- user defined packages
use work.example_package.ALL;
--------------------------------------------------------------------
-- ENTITY DECLARATION
--------------------------------------------------------------------
entity template_example is
generic(
    c_clkfreq   : integer                        := 100_000_000;
    c_sclkfreq  : integer                        := 1_000_000;
    c_i2cfreq   : integer                        := 400_000;
    c_bitnum    : integer                        := 8;
    c_is_sim    : boolean                        := false;
    c_cfgr_freq : std_logic_vector ( 7 downto 0) := x"A3"
);
Port(
    input1_i          : in std_logic_vector( (c_bitnum - 1) downto 0);
    input2_i          : in std_logic;
    output1_o         : out std_logic;
    output2_o         : out std_logic_vector(1 downto 0);
    inout1_io         : inout std_logic_vector(15 downto 0);
    inout2_io         : inout std_logic
);
end template_example;
--------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------
architecture Behavioral of template_example is
--------------------------------------------------------------------
-- CONSTANT DECLARATIONS
--------------------------------------------------------------------
constant c_constant1   : integer   := 30;
constant c_timer1mslim : integer   := c_clkfreq / 1000;
constant c_constant2   : std_logic_vector ( (c_bitnum -  1) downto 0) := (others => '0');
--------------------------------------------------------------------
-- COMPONENT DECLARATIONS
--------------------------------------------------------------------
component my_component is
generic(
	gen1 : integer   := 10;
	gen2 : std_logic := '0'
);
port(
	in1  : in std_logic_vector ((c_bitnum - 1) downto 0);
	out1 : out std_logic
);
end component my_component;
--------------------------------------------------------------------
-- TYPE DECLARATIONS
--------------------------------------------------------------------
type t_state is (S_START, S_OPERATION, S_TERMINATE, S_IDLE);
--subtype is  a type with a constraint
subtype t_decimal_digit is integer range 0 to 9;
subtype t_byte is bit_vector(7 downto 0);
-- record
type my_record_type is record
	param1 : std_logic;
	param2 : std_logic_vector(3 downto 0);
end record;
--------------------------------------------------------------------
-- SIGNAL DECLARATIONS
--------------------------------------------------------------------
signal s0       : std_logic_vector(7 downto 0);            -- signal without initialization
signal s1       : std_logic_vector(7 downto 0) := x"00";   -- signal with initialization 
signal s2       : integer range 0 to 255	   := 0;       -- integer signal with range limit, 8 bit HW
signal s3       : integer                      := 0;       -- integer signal without range limit, 32 bit HW
signal s4       : std_logic                    := '0';
signal state    : t_state                      := S_START; -- t_state => S_START, S_OPERATION, S_TERMINATE, S_IDLE
signal bcd      : t_decimal_digit              := 0;       -- t_decimal_digit => 0,1,2,3,4,5,6,7,8,9
signal opcode   : t_byte                       := x"AB";   -- t_byte => 00 to FF
signal s_record : my_record_type;
signal sda_ena_n : std_logic := '0';
--------------------------------------------------------------------
-- BEGIN STARTS
--------------------------------------------------------------------
begin
--------------------------------------------------------------------
-- COMPONENT INSTANTIATIONS
--------------------------------------------------------------------
my_comp1 : my_component
generic map(
	gen1 => c_i2cfreq,
	gen2 => '0'
)
port map (
	in1  => input1_i,
	out1 => output1_o
);
--------------------------------------------------------------------
-- CONCURRENT ASSIGNMENTS
--------------------------------------------------------------------
s1 <= x"01" when s0 < 30 else
	  x"02" when s0 < 40 else
	  x"03";

with state select
s0 <= x"01" when S_START,
	  x"02" when S_OPERATION,
	  x"03" when S_TERMINATE,
	  x"04" when others;

s3 <= 5 + 2;
s4 <= (input1_i(3) and input1_i(2)) xor input2_i;
--s4 <= ... --multiple driven net error

s_record.param1	<= '0';
s_record.param2 <= "0101";

inout2_io <= '0' when sda_ena_n = '0' else 'Z'; -- 'Z' is open collector or high impedance or high Z

 -----------------------------------------------------------------------------------------------------
-- SEQUENTIAL ASSIGNMENTS -- PROCESS BLOCK
-- NOTE: Process block work concurrently with each other
--		 Tool gives multiple driven net error if a signal is assigned in multiple process blocks		
------------------------------------------------------------------------------------------------------

-- COMBINATIONAL PROCESS
P_COMBINATIONAL : process (s0, state, input1_i, input2_i) begin

	s4 <= '0';
	-- if / elsif / else block
	if(s0 < 30) then
		s1 <= x"01";
	elsif (s0 < 40) then
		s1 <= x"02";
	else
		s1 <= x"03";
	end if;

	-- case block
	case state is

		 when S_START =>
		 		s0 <= x"01";
		 when S_OPERATION =>
		 		s0 <= x"02";
		 when S_TERMINATE =>
		 		s0 <= x"03";
		 when others =>
		 		s0 <= x"04";
	end case;

	s4 <= (input1_i(3) and input1_i(2)) xor input2_i;
	s4 <= (input1_i(3) or input1_i(2)) xnor input2_i; -- multiple driven net error will not occured.
end process P_COMBINATIONAL;
------------------------------------------------------------------------------------------------------

-- SEQUENTIAL PROCESS
P_SEQUENTIAL : process(clk) begin
	if(rising_edge(clk)) then
		-- ...
	end if;
end process P_SEQUENTIAL;

end Behavioral;






