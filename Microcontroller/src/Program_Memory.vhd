-- Made by Aierizer Samuel
-- Started 29.04.19	

	
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity Program_Memory is
	port (	Address		: in std_logic_vector(7 downto 0);
			Clk			: in std_logic;
			Instruction	: out std_logic_vector(15 downto 0));
end entity;

architecture beh of Program_Memory is

type memory is array (255 downto 0) of std_logic_vector(15 downto 0);
signal inst: memory := (

--	0 => "0000000011111110",			--	00 		Load	s0, FE		0001		
--	1 => "0100000000000001",			-- 	01		Add 	s0, 01		40FE		
--	2 => "1001010100000001",			--	02		Jump 	NZ, 01		9901		
--	3 => "0000101011110000",			--	03 		Load 	sA, F0		0AF0
--	4 => "1110000011111111",			--	04 		Output 	s0, FF		E0FF
--	5 => "1010000011111111",			--	05 		Input 	s0, FF		A0FF
--	others => "1110101000110011");		--	 		Output 	sA, 33		EA33



	0 => "0000000000000001",			-- 00		Load 	s0, 01		0001
	1 => "0000000100001000",			-- 01		Load 	s1, 08		0108
	2 => "1100000000010100",			-- 02		Add 	s0, s1		C014
	3 => "1111000000010011",			-- 03		Output	s0, s1		E013
	4 => "1000001100001111",			-- 04		Call	0F			830F
	5 => "1100000000010000",			-- 05		Load 	s0, s1		C010
	6 => "1100000000010001",			-- 06		And 	s0, s1		C011
	7 => "0000111100110011",			-- 07		Load	sF, 33		0F33
	8 => "1100000000010111",			-- 08		Subcy	s0, s1		C017
	9 => "1110000000110011",			-- 09		Output	s0, 33		E033
	10 => "1101111100001000",			-- 10		Sra		sF			DF08
	11 => "1110111100110011",			-- 11		Output  sF, 33      EF33
	12 => "1101111100000110",			-- 12		Sl0		sF			DF06
	13 => "1110111100110011",			-- 13		Output  sF, 33      EF33
	14 => "1000000100010001",			-- 14		Jump	11			8111
	15 => "1010001100110011",			-- 15		Input	s3, 33		A333
	16 => "1000000010000000",			-- 16		Return				8080
	others => "1110000000110011");	    -- 			Output	s0, 33		E033

	
begin
	
	process (Clk)
	begin
		if (Clk = '1' and Clk'Event) then
			Instruction <= inst(conv_integer( Address ));
		end if;
	end process;
	
end architecture;
