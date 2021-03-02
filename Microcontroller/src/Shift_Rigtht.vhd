-- Made by Aierizer Samuel
-- Started 20.04.19
-- Working Beta: 20.04.19
-- Secound beta: 23.04.19 -> not sure if works for every case

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Right is
	port (	X_Alu		: in STD_LOGIC_VECTOR(7 downto 0);
			Opt_Alu		: in STD_LOGIC_VECTOR(2 downto 0);
			Cin			: in STD_LOGIC;
			OUT_SR		: out STD_LOGIC_VECTOR(7 downto 0);
			Carry_SR	: out STD_LOGIC;
			Zero_SR		: out STD_LOGIC);	
end entity;

architecture beh of Shift_Right is

signal reg: STD_LOGIC_VECTOR(7 downto 0);
signal bit_0, bit_7: std_logic;

begin
	
	bit_0 <= X_Alu(0);
	bit_7 <= X_Alu(7);
	Carry_SR <= X_Alu(0);
		
	reg(0) <= X_Alu(1);
	reg(1) <= X_Alu(2);
	reg(2) <= X_Alu(3);
	reg(3) <= X_Alu(4);
	reg(4) <= X_Alu(5);
	reg(5) <= X_Alu(6);
	reg(6) <= X_Alu(7);
	
	
	with Opt_Alu select
		reg(7) <= '0' when "110",
		'1'		when "111",
		bit_7 	when "010",
		Cin 	when "000",
		bit_0 	when "100",
		'0'		when others;
	
	Zero_SR <= '1' when (reg = "00000000") else '0';

	Out_SR <= reg;	

end architecture;
	
	