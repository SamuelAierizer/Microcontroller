-- Made by Aierizer Samuel
-- Started 25.04.19	
-- Functioning beta: 29.04.19


-------
-- D_FF
-------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity d_ff is
	port (	D, clk	: in std_logic;
		 	R, EN	: in std_logic;
			Q		: out std_logic);
end entity;

architecture beh of d_ff is
begin
	process(clk, R, EN)
	begin
		if EN = '1' then
			if (clk = '1' and clk'event) then 
				if R = '1' then Q <= '0';
				else Q <= D;
				end if;
			end if;
		end if;
	end process;
end architecture;


-----------------
-- 8 bit Register
-----------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Regi8 is
	port (	inp			: in std_logic_vector(7 downto 0);
			R, Clk, EN	: in std_logic;
			outp		: out std_logic_vector(7 downto 0));
end entity;	

architecture struct of Regi8 is

Component d_ff
	port (	D, clk	: in std_logic;
		 	R, EN	: in std_logic;
			Q		: out std_logic);
end component;

begin
	REG: for I in 0 to 7 generate
		FF: d_ff port map (D => inp(I), clk => Clk, R => R, EN => EN, Q => outp(I));
	end generate REG;
end architecture ;


-------------
-- DEMUX_1_16
-------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity	Demux_1_16 is
	port (	inp		: in std_logic;
			sel		: in std_logic_vector(3 downto 0);
			outp0	: out std_logic;
			outp1	: out std_logic;
			outp2	: out std_logic;
			outp3	: out std_logic;
			outp4	: out std_logic;
			outp5	: out std_logic;
			outp6	: out std_logic;
			outp7	: out std_logic;
			outp8	: out std_logic;
			outp9	: out std_logic;
			outp10	: out std_logic;
			outp11	: out std_logic;
			outp12	: out std_logic;
			outp13	: out std_logic;
			outp14	: out std_logic;
			outp15	: out std_logic);
end entity;

architecture beh of Demux_1_16 is
begin
	outp0 <= inp when sel = "0000" else 'Z';
	outp1 <= inp when sel = "0001" else 'Z';
	outp2 <= inp when sel = "0010" else 'Z';
	outp3 <= inp when sel = "0011" else 'Z';
	outp4 <= inp when sel = "0100" else 'Z';
	outp5 <= inp when sel = "0101" else 'Z';
	outp6 <= inp when sel = "0110" else 'Z';
	outp7 <= inp when sel = "0111" else 'Z';
	outp8 <= inp when sel = "1000" else 'Z';
	outp9 <= inp when sel = "1001" else 'Z';
	outp10 <= inp when sel = "1010" else 'Z';
	outp11 <= inp when sel = "1011" else 'Z';
	outp12 <= inp when sel = "1100" else 'Z';
	outp13 <= inp when sel = "1101" else 'Z';
	outp14 <= inp when sel = "1110" else 'Z';
	outp15 <= inp when sel = "1111" else 'Z';
				
end architecture;


-------------
-- DEMUX8_1_2
-------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Demux8_1_2 is
	port (	inp				: in std_logic_vector(7 downto 0);
			sel				: in std_logic;
			outp0, outp1	: out std_logic_vector(7 downto 0));
end entity;

architecture beh of Demux8_1_2 is
begin
	outp0 <= inp when sel = '0' else "ZZZZZZZZ";
	outp1 <= inp when sel = '1' else "ZZZZZZZZ";
end architecture;


------------
-- MUX8_16_1
------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux8_16_1 is
	port(	inp0 	: in std_logic_vector(7 downto 0);
			inp1 	: in std_logic_vector(7 downto 0);
			inp2 	: in std_logic_vector(7 downto 0);
			inp3 	: in std_logic_vector(7 downto 0);
			inp4 	: in std_logic_vector(7 downto 0);
			inp5 	: in std_logic_vector(7 downto 0);
			inp6 	: in std_logic_vector(7 downto 0);
			inp7 	: in std_logic_vector(7 downto 0);
			inp8 	: in std_logic_vector(7 downto 0);
			inp9 	: in std_logic_vector(7 downto 0);
			inp10 	: in std_logic_vector(7 downto 0);
			inp11 	: in std_logic_vector(7 downto 0);
			inp12 	: in std_logic_vector(7 downto 0);
			inp13 	: in std_logic_vector(7 downto 0); 
			inp14 	: in std_logic_vector(7 downto 0);
			inp15 	: in std_logic_vector(7 downto 0);
			sel		: in std_logic_vector(3 downto 0);
			outp	: out std_logic_vector(7 downto 0));
end entity;

architecture beh of Mux8_16_1 is
begin
	with sel select
	outp <=	inp0 when "0000",
			inp1 when "0001",
			inp2 when "0010",
			inp3 when "0011",
			inp4 when "0100",
			inp5 when "0101",
			inp6 when "0110",
			inp7 when "0111",
			inp8 when "1000",
			inp9 when "1001",
			inp10 when "1010",
			inp11 when "1011",
			inp12 when "1100",
			inp13 when "1101",
			inp14 when "1110",
			inp15 when "1111",
			"00000000" when others;
end architecture;


-----------------
-- Register_Block
-----------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Register_Block is
	port (	Input			: in std_logic_vector(7 downto 0);
			Sel_X, Sel_Y	: in std_logic_vector(3 downto 0);
			Opt, CLK, EN	: in std_logic;
			Out_Port		: out std_logic_vector(7 downto 0);
			Out_X, Out_Y	: out std_logic_vector(7 downto 0));
end entity;

architecture struct of Register_Block is

-- Components
Component Regi8
	port (	inp			: in std_logic_vector(7 downto 0);
			R, Clk, EN	: in std_logic;
			outp		: out std_logic_vector(7 downto 0));
end component;

Component Demux_1_16 
	port (	inp		: in std_logic;
			sel		: in std_logic_vector(3 downto 0);
			outp0	: out std_logic;
			outp1	: out std_logic;
			outp2	: out std_logic;
			outp3	: out std_logic;
			outp4	: out std_logic;
			outp5	: out std_logic;
			outp6	: out std_logic;
			outp7	: out std_logic;
			outp8	: out std_logic;
			outp9	: out std_logic;
			outp10	: out std_logic;
			outp11	: out std_logic;
			outp12	: out std_logic;
			outp13	: out std_logic;
			outp14	: out std_logic;
			outp15	: out std_logic);
end component;

Component Demux8_1_2
	port (	inp				: in std_logic_vector(7 downto 0);
			sel				: in std_logic;
			outp0, outp1	: out std_logic_vector(7 downto 0));
end component;

Component Mux8_16_1
	port(	inp0 	: in std_logic_vector(7 downto 0);
			inp1 	: in std_logic_vector(7 downto 0);
			inp2 	: in std_logic_vector(7 downto 0);
			inp3 	: in std_logic_vector(7 downto 0);
			inp4 	: in std_logic_vector(7 downto 0);
			inp5 	: in std_logic_vector(7 downto 0);
			inp6 	: in std_logic_vector(7 downto 0);
			inp7 	: in std_logic_vector(7 downto 0);
			inp8 	: in std_logic_vector(7 downto 0);
			inp9 	: in std_logic_vector(7 downto 0);
			inp10 	: in std_logic_vector(7 downto 0);
			inp11 	: in std_logic_vector(7 downto 0);
			inp12 	: in std_logic_vector(7 downto 0);
			inp13 	: in std_logic_vector(7 downto 0); 
			inp14 	: in std_logic_vector(7 downto 0);
			inp15 	: in std_logic_vector(7 downto 0);
			sel		: in std_logic_vector(3 downto 0);
			outp	: out std_logic_vector(7 downto 0));
end component;

-- Signals
type reg is array(0 to 15) of std_logic_vector(7 downto 0);
signal s: reg;
signal en_s: std_logic_vector(15 downto 0);
signal out_x_s: std_logic_vector(7 downto 0);

begin
									
	CLK_Dist: Demux_1_16 port map (	inp		=> EN,
									sel		=> Sel_x,
									outp0	=> en_s(0),
									outp1	=> en_s(1),
									outp2	=> en_s(2),
									outp3	=> en_s(3),
									outp4	=> en_s(4),
									outp5	=> en_s(5),
									outp6	=> en_s(6),
									outp7	=> en_s(7),
									outp8	=> en_s(8),
									outp9	=> en_s(9),
									outp10	=> en_s(10),
									outp11	=> en_s(11),
									outp12	=> en_s(12),										
									outp13	=> en_s(13),
									outp14	=> en_s(14),
									outp15  => en_s(15));
								
	REGI: for I in 0 to 15 generate
		PIECE: Regi8 port map (inp => Input, R => '0', Clk => Clk, EN => en_s(I), outp => s(I));
	end generate REGI; 
	
	MUX_X: Mux8_16_1 port map (	inp0	=> s(0), 
								inp1	=> s(1),	
								inp2 	=> s(2),
								inp3 	=> s(3),
								inp4 	=> s(4),																
								inp5 	=> s(5),
								inp6 	=> s(6),
								inp7 	=> s(7),
								inp8 	=> s(8),
								inp9 	=> s(9),
								inp10 	=> s(10),
								inp11 	=> s(11),
								inp12 	=> s(12),
								inp13 	=> s(13),
								inp14 	=> s(14),
								inp15 	=> s(15),
								sel		=> Sel_X,		
								outp	=> out_x_s);
								
	MUX_Y: Mux8_16_1 port map (	inp0	=> s(0), 
								inp1	=> s(1),	
								inp2 	=> s(2),
								inp3 	=> s(3),
								inp4 	=> s(4),																
								inp5 	=> s(5),
								inp6 	=> s(6),
								inp7 	=> s(7),
								inp8 	=> s(8),
								inp9 	=> s(9),
								inp10 	=> s(10),
								inp11 	=> s(11),
								inp12 	=> s(12),
								inp13 	=> s(13),
								inp14 	=> s(14),
								inp15 	=> s(15),
								sel		=> Sel_Y,		
								outp	=> Out_Y);
	
	OUTP: Demux8_1_2 port map (inp => out_x_s, sel => Opt, outp0 => Out_X, outp1 => Out_Port);
	
end architecture;

	