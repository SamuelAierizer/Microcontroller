-- Made by Aierizer Samuel
-- Started 29.04.19


--------------------
-- Counter with load
--------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
	port (	Parallel_in			: in std_logic_vector(7 downto 0);
			Clk, R, Load, En	: in std_logic;
			Output				: out std_logic_vector(7 downto 0));
end entity;

architecture count of counter is
signal nr : std_logic_vector(7 downto 0) := "00000000";
begin
	
	process (CLK, R, En)
	begin 
		if R='1' then nr <= "00000000";
		else
			if (En = '1') then
				if (Clk='1' and Clk'EVENT) then	
					if Load='1' then 
						nr <= Parallel_in;
					else
						nr <= nr + 1;
					end if;
				end if;
			end if;
		end if;
	end process;  
	
	Output <= nr;
	
end architecture;


-----------------------
-- Program Flow Control
-----------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity Program_Flow_Control is
	port (	Const					: in std_logic_vector(7 downto 0);
			Sel						: in std_logic_vector(4 downto 0);
			Carry, Zero, Clk, R, EN, S	: in std_logic;
			Address 				: out std_logic_vector(7 downto 0));
end entity;

----------------------------------------------
--    10 Inc, 01 Jump, 11 Call, 00 Return   --
-- 0XX Uncond, 100 Z, 101 NZ, 110 C, 111 NC --
----------------------------------------------
architecture beh of Program_Flow_Control is

component counter
	port (	Parallel_in			: in std_logic_vector(7 downto 0);
			Clk, R, Load, En	: in std_logic;
			Output				: out std_logic_vector(7 downto 0));
end component;

component program_counter_stack
	port (	In_Stack		: in std_logic_vector(7 downto 0);
			Stack			: in std_logic_vector(1 downto 0);
			Reset, Clock	: in std_logic;
			Out_Stack		: out std_logic_vector(7 downto 0));
end component;

component Mux8_2_1
	port(	A, B	: in STD_LOGIC_VECTOR(7 downto 0); 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC_VECTOR(7 downto 0));
end component; 

component Mux_2_1
	port(	A, B	: in STD_LOGIC; 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC);
end component;

signal cond, load, in_load : std_logic;
signal c_and1, c_and2, c_and3, c_and4 : std_logic;
signal s0_and1, s0_and2 : std_logic;
signal s1_and1, s1_and2, s1_and3, s1_and4 : std_logic;

signal Stack : std_logic_vector(1 downto 0);
signal mux_cond : std_logic;
signal en_s : std_logic;

signal to_stack, from_stack	: std_logic_vector(7 downto 0);	
signal par_load, add_s	: std_logic_vector(7 downto 0);

signal valid_sel_s : std_logic_vector(4 downto 0);

begin
	
	valid_sel_s <= Sel;

	c_and1 <= ((not(valid_sel_s(1))) and (not(valid_sel_s(0)))) and Zero;
	c_and2 <= ((not(valid_sel_s(1))) and valid_sel_s(0)) and not(Zero);
	c_and3 <= (valid_sel_s(1) and valid_sel_s(0)) and (not(Carry));
	c_and4 <= (valid_sel_s(1) and (not(valid_sel_s(0)))) and Carry;
	cond <= c_and1 or c_and2 or c_and3 or c_and4;
	
	load <= ( ( (not(valid_sel_s(4))) and (not(valid_sel_s(3))) ) or valid_sel_s(3) ) and (cond or ( not( valid_sel_s(2) ) ) );
	
	s0_and1 <= (valid_sel_s(4) and valid_sel_s(3)) and (not(valid_sel_s(2)));
	s0_and2 <= (valid_sel_s(4) and valid_sel_s(3)) and load;
	Stack(0) <= s0_and1 or s0_and2;
	
	s1_and1 <= ((not(valid_sel_s(4))) and (not(valid_sel_s(3)))) and (not(valid_sel_s(2)));
	s1_and2 <= ((not(valid_sel_s(4))) and (not(valid_sel_s(3)))) and load;
	s1_and3 <= (valid_sel_s(4) and valid_sel_s(3)) and (not(valid_sel_s(2)));
	s1_and4 <= (valid_sel_s(4) and valid_sel_s(3)) and load;
	Stack(1) <= s1_and1 or s1_and2 or s1_and3 or s1_and4;
	
	
	Num: counter port map (	Parallel_in => par_load, Clk => Clk, R => R,
			Load => load, En => en_s, Output => add_s);
	
	mux_cond <= load and (valid_sel_s(4) nor valid_sel_s(3));	-- Condition for valid return;
		
	to_stack <= add_s + 1;	
	LIFO : program_counter_stack port map(	In_Stack => to_stack, Stack => Stack,
			Reset => R, Clock => S, Out_Stack => from_stack);
	
	en_mux : Mux_2_1 port map( A => EN, B => '1', SEL => mux_cond, X => en_s);
	
	Load_mux : Mux8_2_1	port map( A => Const, B => from_stack, SEL => mux_cond, X => par_load);
	
	Address <= add_s; 
	
			
end architecture;
