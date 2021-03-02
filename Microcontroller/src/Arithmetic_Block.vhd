-- Made by Aierizer Samuel
-- Started 10.04.19
-- Stable Release: 23.04.19
-- First Beta 17.04.19


-----------
-- Mux8 2:1
-----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux8_2_1 is
	port(	A, B	: in STD_LOGIC_VECTOR(7 downto 0); 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC_VECTOR(7 downto 0));
end Mux8_2_1;

architecture Mux8_2_1 of Mux8_2_1 is
begin
	X <= A when (SEL = '0') else B;
end;


----------
-- Mux 2:1
----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux_2_1 is
	port(	A, B	: in STD_LOGIC; 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC);
end Mux_2_1;

architecture Mux_2_1 of Mux_2_1 is
begin
	X <= A when (SEL = '0') else B;
end;


-----------
-- And gate
-----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity And_gate is
	port (	A, B	: in STD_LOGIC;
			X		: out STD_LOGIC);
end entity;

architecture flux of And_gate is
begin
	X <= A and B;
end architecture;


----------
-- Or gate
----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Or_gate is
	port (	A, B	: in STD_LOGIC;
			X		: out STD_LOGIC);
end entity;

architecture flux of Or_gate is
begin
	X <= A or B;
end architecture;


-----------
-- Xor gate
-----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Xor3_gate is
	port (	A, B, C	: in STD_LOGIC;
			X		: out STD_LOGIC);
end entity;

architecture flux of Xor3_gate is
begin
	X <= (A xor B) xor C;
end architecture;


-----------------------
-- 1 bit Complete Adder
-----------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Complete_Adder is
	port ( 	A, CIN, B	: in STD_LOGIC;
			COUT, Y		: out STD_LOGIC);
end entity;

architecture flux of Complete_Adder is

-- Gate Component 
	
component Or_gate 
	port (	A, B	: in STD_LOGIC;
			X		: out STD_LOGIC);
end component;

Component And_gate
	port (	A, B	: in STD_LOGIC;
			X		: out STD_LOGIC);
end component;

Component Xor3_gate
	port (	A, B, C	: in STD_LOGIC;
			X		: out STD_LOGIC);
end component;
	
-- Signals
signal	a_or_b : STD_LOGIC;
signal	a_and_b: STD_LOGIC;
signal	or_and_cin: STD_LOGIC;

begin
	
	Y_OUT	: Xor3_gate port map (A => A, B => CIN, C => B, X => Y);
	
	U1		: Or_gate port map (A => A, B => B, X => a_or_b);
	
	U2_1	: And_gate port map (A => a_or_b, B => CIN, X => or_and_cin);
	
	U2_2	: And_gate port map (A => A, B => B, X => a_and_b);
	
	U3		: Or_gate port map (A => or_and_cin, B => a_and_b, X => Cout);
	
end architecture;	


----------------------
-- 1 bit Complete Subb
----------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Complete_Subb is
	port ( 	A, CIN, B	: in STD_LOGIC;
			COUT, Y		: out STD_LOGIC);
end entity;

architecture flux of Complete_Subb is

-- Gate Component 
	
component Or_gate 
	port (	A, B	: in STD_LOGIC;
			X		: out STD_LOGIC);
end component;

Component And_gate
	port (	A, B	: in STD_LOGIC;
			X		: out STD_LOGIC);
end component;

Component Xor3_gate
	port (	A, B, C	: in STD_LOGIC;
			X		: out STD_LOGIC);
end component;
	
-- Signals
signal 	not_a: STD_LOGIC;
signal	a_or_b : STD_LOGIC;
signal	a_and_b: STD_LOGIC;
signal	or_and_cin: STD_LOGIC;

begin
	not_a <= not A;
	
	Y_OUT	: Xor3_gate port map (A => A, B => CIN, C => B, X => Y);
	
	U1		: Or_gate port map (A => not_A, B => B, X => a_or_b);
	
	U2_1	: And_gate port map (A => a_or_b, B => CIN, X => or_and_cin);
	
	U2_2	: And_gate port map (A => not_A, B => B, X => a_and_b);
	
	U3		: Or_gate port map (A => or_and_cin, B => a_and_b, X => Cout);
	
end architecture;	


------------
-- Add Block
------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Add_Block is
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			CIN				: in STD_LOGIC;
			Out_Add			: out STD_LOGIC_VECTOR(7 downto 0); 
			Carry_Add		: out STD_LOGIC); 
end entity;

architecture Add of Add_Block is

-- Componente
component Complete_Adder 
	port ( 	A, CIN, B	: in STD_LOGIC;
			COUT, Y		: out STD_LOGIC);
end component;

-- Semnale
signal out_s: STD_LOGIC_VECTOR(7 downto 0);
signal cin_s: STD_LOGIC_VECTOR(8 downto 0);

begin
	cin_s(0) <= CIN;
	
	ADD_B: for I in 0 to 7 generate
		ADD_I	:	Complete_Adder port map (A => X_Alu(I), CIN => cin_s(I), B => In_Aux(I), COUT => cin_s(I+1), Y => out_s(I));
	end generate ADD_B;
	
	Out_Add <= out_s;
	
	Carry_Add <= cin_s(8);
	
end architecture;


-------------
-- Subb Block
-------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Subb_Block is
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			CIN				: in STD_LOGIC;
			Out_Subb		: out STD_LOGIC_VECTOR(7 downto 0); 
			Carry_Subb		: out STD_LOGIC); 
end entity;

architecture Subb of Subb_Block is

-- Componente
component Complete_Subb
	port ( 	A, CIN, B	: in STD_LOGIC;
			COUT, Y		: out STD_LOGIC);
end component;

-- Semnale
signal out_s: STD_LOGIC_VECTOR(7 downto 0);
signal cin_s: STD_LOGIC_VECTOR(8 downto 0);

begin
	
	cin_s(0) <= CIN;
	
	SUBB_B: for I in 0 to 7 generate
		SUBB_I	:	Complete_Subb port map (A => X_Alu(I), CIN => cin_s(I), B => In_Aux(I), COUT => cin_s(I+1), Y => out_s(I));
	end generate SUBB_B;

	Out_Subb <= out_s;
	
	Carry_Subb <= cin_s(8);
	
	
end architecture;


-------------------
-- Arithmetic Block
-------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Arithmetic_Block is
	port(	X_Alu, Y_Alu, Const		: in STD_LOGIC_VECTOR(7 downto 0); 
			Opt_Alu					: in STD_LOGIC_VECTOR(2 downto 0);
			CIN						: in STD_LOGIC;
			Out_Arithmetic			: out STD_LOGIC_VECTOR(7 downto 0); 
			Carry_Arithmetic		: out STD_LOGIC;
			Zero_Arithmetic			: out STD_LOGIC); 
end entity;

architecture Arithmetic of Arithmetic_Block is

-- Component 
	
Component Add_Block
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			CIN				: in STD_LOGIC;
			Out_Add			: out STD_LOGIC_VECTOR(7 downto 0); 
			Carry_Add		: out STD_LOGIC); 
end component;

Component Subb_Block 
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			CIN				: in STD_LOGIC;
			Out_Subb		: out STD_LOGIC_VECTOR(7 downto 0); 
			Carry_Subb		: out STD_LOGIC); 
end component; 

Component Mux8_2_1
	port(	A, B	: in STD_LOGIC_VECTOR(7 downto 0); 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC_VECTOR(7 downto 0));
end component;

component Mux_2_1
	port(	A, B	: in STD_LOGIC; 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC);
end component;
	
-- Signal

signal in_aux_s, out_add_s, out_subb_s, out_arithmetic_s: STD_LOGIC_VECTOR(7 downto 0);
signal cin_s, carry_add_s, carry_subb_s: STD_LOGIC;
signal sel: STD_LOGIC;

begin												 
	
	Mux8_in		:	Mux8_2_1 port map (A => Const, B => Y_Alu, SEL => Opt_Alu(2), X => in_aux_s);	
	
	Out_s		:	Mux8_2_1 port map (A => out_add_s, B => out_subb_s, SEL => Opt_Alu(1), X => out_arithmetic_s); 
	
	Cerry_s		:	Mux_2_1 port map (A => carry_add_s, B => carry_subb_s, SEL => Opt_Alu(1), X => Carry_Arithmetic);
	
	CINS		:	Mux_2_1 port map (A => '0', B => Cin, SEL => Opt_Alu(0), X => cin_s);
	
	ADD			: 	Add_Block port map (X_Alu => X_Alu, In_Aux => in_aux_s, Cin => cin_s, Out_Add => out_add_s, Carry_Add => carry_add_s);
	
	SUBB		: 	Subb_Block port map (X_Alu => X_Alu, In_Aux => in_aux_s, Cin => cin_s, Out_Subb => out_subb_s, Carry_Subb => carry_subb_s);
	
	Zero_Arithmetic <= '1' when (out_arithmetic_s = "00000000") else '0'; 
	
	Out_Arithmetic <= out_arithmetic_s;
	
end architecture;