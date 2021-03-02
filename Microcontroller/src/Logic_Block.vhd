-- Made by Aierizer Samuel
-- Started 04.04.19
-- First Beta: 10.04.19 - simulation useless
-- Stable Release: 23.04.19


-------------
-- Load Block
-------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Load_Block is
	port(	In_Aux		: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_Load	: out STD_LOGIC_VECTOR(7 downto 0));
end Load_Block;

architecture Load of Load_Block is
begin
	Out_Load <= In_Aux;
end Load;


------------
-- And Block
------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity And_Block is
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_And			: out STD_LOGIC_VECTOR(7 downto 0)); 
end And_Block;

architecture flux of And_Block is
	signal Aux: STD_LOGIC_VECTOR(7 downto 0);
begin
	Aux <= X_Alu and In_Aux;
	Out_And <= Aux;
end flux;


-----------
-- Or Block
-----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Or_Block is
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_Or			: out STD_LOGIC_VECTOR(7 downto 0)); 
end Or_Block;

architecture flux of Or_Block is
	signal Aux: STD_LOGIC_VECTOR(7 downto 0);
begin
	Aux <= X_Alu or In_Aux;
	Out_Or <= Aux;
end flux;


------------
-- Xor Block
------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Xor_Block is
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_Xor			: out STD_LOGIC_VECTOR(7 downto 0)); 
end Xor_Block;

architecture flux of Xor_Block is
	signal Aux: STD_LOGIC_VECTOR(7 downto 0);
begin
	Aux <= X_Alu xor In_Aux;
	Out_Xor <= Aux;
end flux;


--------------
-- Logic Block
--------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Logic_Block is
	port(	X_Alu, Y_Alu, Const		: in STD_LOGIC_VECTOR(7 downto 0); 
			Opt_Alu					: in STD_LOGIC_VECTOR(2 downto 0);
			Out_Logic				: out STD_LOGIC_VECTOR(7 downto 0);
			Zero_Logic				: out STD_LOGIC);
end Logic_Block;

architecture Logic of Logic_Block is

-- Component declaration

component Mux8_2_1 
	port(	A, B	: in STD_LOGIC_VECTOR(7 downto 0); 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC_VECTOR(7 downto 0));
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

component Load_Block 
	port(	In_Aux		: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_Load	: out STD_LOGIC_VECTOR(7 downto 0));
end component;

component And_Block 
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_And			: out STD_LOGIC_VECTOR(7 downto 0));
end component;

component Or_Block 
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_Or			: out STD_LOGIC_VECTOR(7 downto 0));
end component;

component Xor_Block 
	port(	X_Alu, In_Aux	: in STD_LOGIC_VECTOR(7 downto 0); 
			Out_Xor			: out STD_LOGIC_VECTOR(7 downto 0));
end component;

-- Signal declaration
-- input signals
signal sig_x_alu: std_logic_vector(7 downto 0);
signal sig_in_aux: std_logic_vector(7 downto 0); 

signal sig_mux_sel: std_logic_vector(1 downto 0);
signal sig_mux_opt: std_logic;

-- output signals
signal sig_out_load: std_logic_vector(7 downto 0);
signal sig_out_and: std_logic_vector(7 downto 0);
signal sig_out_or: std_logic_vector(7 downto 0);
signal sig_out_xor: std_logic_vector(7 downto 0);
signal out_logic_s: std_logic_vector(7 downto 0);

begin  
	sig_x_alu <= X_Alu;
	
	sig_mux_sel(0) <= Opt_Alu(0);
	sig_mux_sel(1) <= Opt_Alu(1);
	
	sig_mux_opt <= Opt_Alu(2);
	
	Mux_in_aux	: Mux8_2_1 	port map (A => Const, B => Y_Alu, SEL => sig_mux_opt, X => sig_in_aux);
	
	Load_part	: Load_Block port map (In_Aux => sig_in_aux, Out_Load => sig_out_load);
	
	And_part	: And_Block port map (X_Alu => sig_x_alu, In_Aux => sig_in_aux, Out_And => sig_out_and);
	
	Or_part		: Or_Block 	port map (X_Alu => sig_x_alu, In_Aux => sig_in_aux, Out_Or => sig_out_or);
	
	Xor_part	: Xor_Block	port map (X_Alu => sig_x_alu, In_Aux => sig_in_aux, Out_Xor => sig_out_xor);
	
	Mux_out		: Mux8_4_1 	port map (A => sig_out_load, B => sig_out_and, C => sig_out_or, D=> sig_out_xor,
									  SEL => sig_mux_sel, X => out_logic_s);	
	
	Zero_Logic <= '1' when (out_logic_s = "00000000") else '0'; 
	
	Out_Logic <= out_logic_s;

end Logic;
