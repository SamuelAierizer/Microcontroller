-- Made by Aierizer Samuel
-- Started 29.04.19						  


--------
-- Flags
--------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity zero_carry_flags is
	port (	save, clk, R, E			: in std_logic;
			Zero_Alu, Carry_Alu		: in std_logic;
			Zero_Save, Carry_Save	: in std_logic;
			Out_Zero, Out_Carry		: out std_logic);
end entity;


architecture beh of zero_carry_flags is

Component d_ff 
	port (	D, clk	: in std_logic;
		 	R, EN	: in std_logic;
			Q		: out std_logic);
end component;

component Mux_2_1
	port (	A, B	: in std_logic;
			Sel		: in std_logic;
			X	: out std_logic);
end component;


signal zero_s, carry_s : std_logic;

begin
	
	Zero_Mux: Mux_2_1 port map (A => Zero_Alu, B => Zero_Save, Sel => Save, X => zero_s);
	
	Carry_Mux: Mux_2_1 port map (A => Carry_Alu, B => Carry_Save, Sel => Save, X => carry_s);
	
	Zero_D : d_ff port map (D => zero_s, clk => clk, R => R, EN => E, Q => Out_Zero);   

	Carry_D : d_ff port map (D => carry_s, clk => clk, R => R, EN => E, Q => Out_Carry);	
	
end architecture;
