-- Made by Aierizer Samuel
-- Started 29.04.19	

	
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity port_address_control is
	port (	Const, sY			: in std_logic_vector(7 downto 0);
			Sel, Read, Write	: in std_logic;
			Port_Id				: out std_logic_vector(7 downto 0);
			Read_Strobe			: out std_logic;
			Write_Strobe		: out std_logic);
end entity;				 

architecture beh of port_address_control is

begin
	
	Port_Id <= sY when Sel = '1' else Const;
	
	Read_Strobe <= Read;
	
	Write_Strobe <= Write;
	
end architecture;
