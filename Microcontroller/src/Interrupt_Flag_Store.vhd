-- Made by Aierizer Samuel
-- Started 29.04.19						  


-------------
-- Flag Store
------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Interrupt_Flag_Store is
	port (	Zero, Carry			: in std_logic;
			clk, reset			: in std_logic;
			Out_Zero, Out_Carry	: out std_logic);
end entity;

architecture beh of Interrupt_Flag_Store is	

component d_ff
	port (	D, clk	: in std_logic;
		 	R, EN	: in std_logic;
			Q		: out std_logic);
end component;

begin
	
	Zero_D	: d_ff port map (D => Zero, clk => clk, R => reset, EN => '1', Q => Out_Zero);	  
	
	Carry_D	: d_ff port map (D => Carry, clk => clk, R => reset, EN => '1', Q => Out_Carry);	 
	
end architecture;

