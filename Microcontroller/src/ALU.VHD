-- Made by Aierizer Samuel
-- Started 20.04.19						  


-----------
-- Mux8 4:1	
-----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux8_4_1 is
	port(	A, B, C, D	: in STD_LOGIC_VECTOR(7 downto 0); 
			SEL			: in STD_LOGIC_VECTOR(1 downto 0); 
			X			: out STD_LOGIC_VECTOR(7 downto 0));
end Mux8_4_1;

architecture flux of Mux8_4_1 is
begin
with SEL select
	X <= A when "00",
	B when "01",
	C when "10",
	D when "11",
	"00000000" when others;
end flux;


----------
-- Mux 4:1
----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux_4_1 is
	port(	A, B, C, D	: in STD_LOGIC; 
			SEL			: in STD_LOGIC_VECTOR(1 downto 0); 
			X			: out STD_LOGIC);
end Mux_4_1;

architecture flux of Mux_4_1 is
begin
with SEL select
	X <= A when "00",
	B when "01",
	C when "10",
	D when "11",
	'0' when others;
end flux;


-----------------
--     ALU     --
-----------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU is
	port (	X_Alu, Y_Alu, Const	: in std_logic_vector(7 downto 0);
			Opt_Alu				: in std_logic_vector(2 downto 0);
			Sel_Alu				: in std_logic_vector(1 downto 0);
			Cin					: in std_logic;
			Enable				: in std_logic;
			Out_Alu				: out std_logic_vector(7 downto 0);
			Carry_Alu, Zero_Alu	: out std_logic);	
end entity;


architecture ALU_Block of ALU is

-- Component 
Component Logic_Block 
	port(	X_Alu, Y_Alu, Const		: in STD_LOGIC_VECTOR(7 downto 0); 
			Opt_Alu					: in STD_LOGIC_VECTOR(2 downto 0);
			Out_Logic				: out STD_LOGIC_VECTOR(7 downto 0);
			Zero_Logic				: out STD_LOGIC);
end component;

Component Arithmetic_Block is
	port(	X_Alu, Y_Alu, Const		: in STD_LOGIC_VECTOR(7 downto 0); 
			Opt_Alu					: in STD_LOGIC_VECTOR(2 downto 0);
			CIN						: in STD_LOGIC;
			Out_Arithmetic			: out STD_LOGIC_VECTOR(7 downto 0); 
			Carry_Arithmetic		: out STD_LOGIC;
			Zero_Arithmetic			: out STD_LOGIC); 
end component; 

Component Shift_Left
	port (	X_Alu		: in STD_LOGIC_VECTOR(7 downto 0);
			Opt_Alu		: in STD_LOGIC_VECTOR(2 downto 0);
			Cin			: in STD_LOGIC;
			OUT_SL		: out STD_LOGIC_VECTOR(7 downto 0);
			Carry_SL	: out STD_LOGIC;
			Zero_SL		: out STD_LOGIC);	
end component;	

Component Shift_Right
	port (	X_Alu		: in STD_LOGIC_VECTOR(7 downto 0);
			Opt_Alu		: in STD_LOGIC_VECTOR(2 downto 0);
			Cin			: in STD_LOGIC;
			OUT_SR		: out STD_LOGIC_VECTOR(7 downto 0);
			Carry_SR	: out STD_LOGIC;
			Zero_SR		: out STD_LOGIC);	
end component;

component Mux8_4_1 
	port(	A, B, C, D	: in STD_LOGIC_VECTOR(7 downto 0); 
			SEL			: in STD_LOGIC_VECTOR(1 downto 0); 
			X			: out STD_LOGIC_VECTOR(7 downto 0));
end component; 

component Mux_4_1 
	port(	A, B, C, D	: in STD_LOGIC; 
			SEL			: in STD_LOGIC_VECTOR(1 downto 0); 
			X			: out STD_LOGIC);
end component;


--Signal 
signal	out_logic_s			: std_logic_vector(7 downto 0);
signal	out_Arithmetic_s	: std_logic_vector(7 downto 0);
signal	out_sr_s			: std_logic_vector(7 downto 0);
signal	out_sl_s			: std_logic_vector(7 downto 0);

signal zero_logic_s			: std_logic;
signal zero_arithmetic_s	: std_logic;
signal zero_sr_s			: std_logic;
signal zero_sl_s			: std_logic;

signal carry_arithmetic_s	: std_logic;
signal carry_sr_s			: std_logic;
signal carry_sl_s			: std_logic; 

signal out_alu_s			: std_logic_vector(7 downto 0);
signal carry_alu_s, cin_s	: std_logic;
signal zero_alu_s			: std_logic;


begin
	
	Logic_b	: Logic_Block port map(	X_Alu => X_Alu, Y_Alu => Y_Alu, Const => Const,
									Opt_Alu => Opt_Alu, Out_Logic => out_logic_s, Zero_Logic => zero_logic_s);
	
	Arithmetic_b : Arithmetic_Block port map(	X_Alu => X_Alu, Y_Alu => Y_Alu, Const => Const, Opt_Alu => Opt_Alu,
												CIN => Cin, Out_Arithmetic => out_arithmetic_s, 
												Carry_Arithmetic => carry_arithmetic_s, Zero_Arithmetic => zero_arithmetic_s);
	
	Shift_Right_b :	Shift_Right port map(	X_Alu => X_Alu, Opt_Alu => Opt_Alu, Cin => Cin,
											OUT_SR => out_sr_s, Carry_SR => carry_sr_s, Zero_SR => zero_sr_s);
	
	Shift_Left_b : Shift_Left port map( X_Alu => X_Alu, Opt_Alu => Opt_Alu, Cin => Cin, OUT_SL => out_sl_s,
										Carry_SL => carry_sl_s,	Zero_SL => zero_sl_s);
	
	  
	Out_b : Mux8_4_1 port map (	A => out_logic_s, B => out_arithmetic_s, C => out_sr_s, D => out_sl_s, 
								SEL	=> Sel_Alu,	X => out_alu_s);
								
	cin_s <= '0' when Cin = 'U' else Cin;
								
	Carry_b : Mux_4_1 port map(	A => cin_s, B => carry_arithmetic_s, C => carry_sr_s, D => carry_sl_s, 
								SEL => Sel_Alu, X => carry_alu_s);
	
	Zero_b : Mux_4_1 port map(	A => zero_logic_s, B => zero_arithmetic_s, C => zero_sr_s, D => zero_sl_s,
								SEL => Sel_Alu, X => zero_alu_s);
	
	Out_Alu <= out_alu_s when Enable = '1' else "ZZZZZZZZ";
	Carry_Alu <= carry_alu_s;
	Zero_Alu <= zero_alu_s;
											
end architecture;