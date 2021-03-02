-- Made by Aierizer Samuel
-- Started 06.05.19


library IEEE;
use IEEE.STD_LOGIC_1164.all; 		  	   

entity fpga is
	port (	IN_PORT					: in std_logic_vector(7 downto 0);
			INTERRUPT, RESET, CLK	: in std_logic;
			Out_Cat					: out std_logic_vector(6 downto 0);	
			Out_An					: out std_logic_vector(3 downto 0);
			READ_STROBE				: out std_logic; 
			WRITE_STROBE			: out std_logic;
			Zero						: out std_logic);
end entity;

architecture desc of fpga is

component kcpsm
	port (	IN_PORT					: in std_logic_vector(7 downto 0);
			INTERRUPT, RESET, CLK	: in std_logic;
			OUT_PORT, PORT_ID		: out std_logic_vector(7 downto 0);
			READ_STROBE				: out std_logic; 
			WRITE_STROBE			: out std_logic);
end component;


component afisor 
	port (	Clk						: in std_logic;
			In1, In2, In3, In4		: in std_logic_vector(3 downto 0);
			Out_Cat					: out std_logic_vector(6 downto 0);
			Out_An					: out std_logic_vector(3 downto 0);
			Zero					: out std_logic);
end component;

signal out_port_s, port_id_s	: std_logic_vector(7 downto 0);

begin
	
	U1 : kcpsm port map(IN_PORT => IN_PORT, INTERRUPT => INTERRUPT, RESET => RESET, CLK => CLK,
			OUT_PORT => out_port_s, PORT_ID => port_id_s,
			READ_STROBE => READ_STROBE, WRITE_STROBE => WRITE_STROBE);	
			
	U2 : afisor port map(Clk => CLK, In1 => out_port_s(7 downto 4), In2 => out_port_s(3 downto 0), 
			In3 => port_id_s(7 downto 4), In4 => port_id_s(3 downto 0), Out_Cat => Out_Cat,
			Out_An => Out_An,	Zero => Zero);
	
	
end architecture;
