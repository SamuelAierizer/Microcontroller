-- Made by Aierizer Samuel
-- Started 17.04.19
-- First Beta: 18.04.19
-- Secound beta: 23.04.19 -> not sure if works for every case

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Left is
	port (	X_Alu		: in STD_LOGIC_VECTOR(7 downto 0);
			Opt_Alu		: in STD_LOGIC_VECTOR(2 downto 0);
			Cin			: in STD_LOGIC;
			OUT_SL		: out STD_LOGIC_VECTOR(7 downto 0);
			Carry_SL	: out STD_LOGIC;
			Zero_SL		: out STD_LOGIC);	
end entity;

architecture beh of Shift_Left is

signal reg: STD_LOGIC_VECTOR(7 downto 0);
signal bit_0, bit_7: std_logic;

begin
	
	bit_0 <= X_Alu(0);
	bit_7 <= X_Alu(7);
	Carry_SL <= X_Alu(7);
		
	reg(1) <= X_Alu(0);
	reg(2) <= X_Alu(1);
	reg(3) <= X_Alu(2);
	reg(4) <= X_Alu(3);
	reg(5) <= X_Alu(4);
	reg(6) <= X_Alu(5);
	reg(7) <= X_Alu(6);
	
	with Opt_Alu select
		reg(0) <= '0' when "110",
		'1'		when "111",
		bit_0 	when "100",
		Cin 	when "000",
		bit_7 	when "010",
		'0'		when others;
	
	Zero_SL <= '1' when (reg = "00000000") else '0';

	Out_SL <= reg;	

end architecture;
	
	