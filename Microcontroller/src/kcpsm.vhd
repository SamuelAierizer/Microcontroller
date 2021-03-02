-- Made by Aierizer Samuel
-- Started 06.05.19


-----------------
-- Clock Split --
-----------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Clock_Split is
	port (	Clk						: in std_logic;
			Instruction, Registers	: out std_logic); 
end entity;

architecture desc of Clock_Split is

signal opt : std_logic := '0';
signal cond : std_logic := '0';

begin
	
	process (Clk)
	variable nr : natural range 0 to 1 := 0;
	begin
		if (clk = '1' and clk'event) then
			if nr = 1 then
				nr := 0;
				opt <= '0';
			else
				nr := 1; 
				opt <= '1';
			end if;
		end if;
	end process; 
	
	Instruction <= opt;
	cond <= '1' when opt = '1';
	Registers <= '0' when cond = '0' else not opt;
	
end architecture;


---------------------------------
--							   --
--    8-BIT MICROCONTROLLER    --
--							   --
---------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity kcpsm is
	port (	IN_PORT					: in std_logic_vector(7 downto 0);
			INTERRUPT, RESET, CLK	: in std_logic;
			OUT_PORT, PORT_ID		: out std_logic_vector(7 downto 0);
			READ_STROBE				: out std_logic; 
			WRITE_STROBE			: out std_logic);
end entity;

architecture microcontroller of kcpsm is

-- Components
component Control_Unit 
	port (	Instruction				: in std_logic_vector(15 downto 0);
			Reset					: in std_logic;
			Const					: out std_logic_vector(7 downto 0);
			-- Alu
			Opt_Alu					: out std_logic_vector(2 downto 0);
			Sel_Alu					: out std_logic_vector(1 downto 0);
			Alu_Enable				: out std_logic;
			-- Register block
			Sel_X, Sel_Y			: out std_logic_vector(3 downto 0);
			-- Port Address Control
			Sel_port, Read, Write	: out std_logic;
			-- Program Flow Control
			Sel_prog_flow			: out std_logic_vector(4 downto 0);
			-- Flags
			Reset_flags		 		: out std_logic);
end component;

component ALU 
	port (	X_Alu, Y_Alu, Const	: in std_logic_vector(7 downto 0);
			Opt_Alu				: in std_logic_vector(2 downto 0);
			Sel_Alu				: in std_logic_vector(1 downto 0);
			Cin					: in std_logic;
			Enable				: in std_logic;
			Out_Alu				: out std_logic_vector(7 downto 0);
			Carry_Alu, Zero_Alu	: out std_logic);	
end component;

component Register_Block 
	port (	Input			: in std_logic_vector(7 downto 0);
			Sel_X, Sel_Y	: in std_logic_vector(3 downto 0);
			Opt, CLK, EN	: in std_logic;
			Out_Port		: out std_logic_vector(7 downto 0);
			Out_X, Out_Y	: out std_logic_vector(7 downto 0));
end component;

component Program_Memory 
	port (	Address		: in std_logic_vector(7 downto 0);
			Clk			: in std_logic;
			Instruction	: out std_logic_vector(15 downto 0));
end component;

component port_address_control 
	port (	Const, sY			: in std_logic_vector(7 downto 0);
			Sel, Read, Write	: in std_logic;
			Port_Id				: out std_logic_vector(7 downto 0);
			Read_Strobe			: out std_logic;
			Write_Strobe		: out std_logic);
end component;

component zero_carry_flags
	port (	save, clk, R, E			: in std_logic;
			Zero_Alu, Carry_Alu		: in std_logic;
			Zero_Save, Carry_Save	: in std_logic;
			Out_Zero, Out_Carry		: out std_logic);
end component;

component Interrupt_Flag_Store
	port (	Zero, Carry			: in std_logic;
			clk, reset			: in std_logic;
			Out_Zero, Out_Carry	: out std_logic);
end component;

component Program_Flow_Control 
	port (	Const					: in std_logic_vector(7 downto 0);
			Sel						: in std_logic_vector(4 downto 0);
			Carry, Zero, Clk, R, EN, S	: in std_logic;
			Address 				: out std_logic_vector(7 downto 0));
end component;

component Clock_Split is
	port (	Clk						: in std_logic;
			Instruction, Registers	: out std_logic); 
end component;

Component Mux8_2_1 is
	port(	A, B	: in STD_LOGIC_VECTOR(7 downto 0); 
			SEL		: in STD_LOGIC; 
			X		: out STD_LOGIC_VECTOR(7 downto 0));
end component;


-- signals
signal in_regi						: std_logic_vector(7 downto 0);
signal instruction_s				: std_logic_vector(15 downto 0);
signal address_s					: std_logic_vector(7 downto 0);
signal const_s, const_alu			: std_logic_vector(7 downto 0);
-- Alu
signal out_alu_s, alu_new			: std_logic_vector(7 downto 0);
signal opt_alu_s					: std_logic_vector(2 downto 0);
signal sel_alu_s					: std_logic_vector(1 downto 0);
signal alu_enable_s					: std_logic;
signal carry_alu_s, zero_alu_s		: std_logic;
-- Register Block
signal out_x_s, out_y_s				: std_logic_vector(7 downto 0);
signal sel_x_s, sel_y_s				: std_logic_vector(3 downto 0);
signal en_reg						: std_logic;
-- Program Address Control
signal sel_port_s, read_s, write_s	: std_logic;
signal clk_stack					: std_logic;
--Program Flow Control
signal sel_prog_flow_s				: std_logic_vector(4 downto 0);	
signal flow_clk_s					: std_logic;
-- Flags
signal reset_flags_s, save_s	    : std_logic;
signal carry_s, zero_s				: std_logic;
signal carry_save_s, zero_save_s	: std_logic;

signal clk_1, clk_2		 			: std_logic; 
signal clk_read, clk_write			: std_logic;

begin
	
	Memory : Program_Memory port map ( Address => address_s, Clk => clk_1, Instruction => instruction_s);
	
	clock: Clock_Split port map( Clk => CLK, Instruction => clk_1, Registers => clk_2);
	
	en_reg <= alu_enable_s and clk_2;
	
	CU : Control_Unit port map ( Instruction	=> instruction_s,
			Reset => RESET, Const => const_s,
			-- Alu
			Opt_Alu => opt_alu_s, Sel_Alu => sel_alu_s, 
			Alu_Enable => alu_enable_s,
			-- Register block
			Sel_X => sel_x_s, Sel_Y => sel_y_s,
			-- Port Address Control
			Sel_port => sel_port_s, Read => read_s, Write => write_s,
			-- Program Flow Control
			Sel_prog_flow => sel_prog_flow_s,
			-- Flags
			Reset_flags => reset_flags_s);
			
	Port_in: Mux8_2_1 port map( A => const_s, B => IN_PORT, SEL => read_s, X => const_alu);		
			
	ALU_Block : ALU port map (	X_Alu => out_x_s, Y_Alu => out_y_s, Const => const_alu,
			Opt_Alu	=> opt_alu_s, Sel_Alu => sel_alu_s, Cin => carry_s,
			Enable => alu_enable_s,
			Out_Alu => out_alu_s, Carry_Alu => carry_alu_s, Zero_Alu => zero_alu_s);
	
	Regi : Register_Block port map (	Input => out_alu_s, Sel_X =>sel_x_s, Sel_Y => sel_y_s,
			Opt => write_s, CLK => CLK, EN => en_reg,
			Out_Port => OUT_PORT, Out_X => out_x_s, Out_Y => out_y_s);
		 
	clk_read <= read_s and clk_2;
	clk_write <= write_s and clk_2;
	Port_Control : port_address_control port map (	Const => const_s, sY => out_y_s,
			Sel => sel_port_s, Read => clk_read, Write => clk_write,
			Port_Id => PORT_ID, Read_Strobe => READ_STROBE, Write_Strobe => WRITE_STROBE);
			
	Flags : zero_carry_flags	port map (	save => INTERRUPT, clk => CLK, R => reset_flags_s, E => alu_enable_s,
			Zero_Alu => zero_alu_s, Carry_Alu => carry_alu_s,
			Zero_Save => zero_save_s, Carry_Save => carry_save_s,
			Out_Zero => zero_s, Out_Carry => carry_s); 
	
	Flag_Store : Interrupt_Flag_Store port map (	Zero => zero_s, Carry => carry_s,
			clk => CLK, reset => RESET,	Out_Zero => zero_save_s, Out_Carry => carry_save_s);	
			
	process (CLK)
	variable nr : natural range 0 to 1 := 0; 
	begin
		if (CLK = '0' and CLK'EVENT) then
			if nr = 0 then
				clk_stack <= '0';
				nr := 1;
			else
				nr := 0;
				clk_stack <= '1';
			end if;
		end if;
	end process;
				
	Program_Control : Program_Flow_Control port map( Const => const_s, Sel => sel_prog_flow_s, Carry => carry_s,
	Zero => zero_s, Clk => clk_2, R => RESET, EN => '1', S => clk_stack, Address => address_s);
	
end architecture;



library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ms is
end entity;

architecture arh_ms of ms is

component kcpsm is
	port (	IN_PORT					: in std_logic_vector(7 downto 0);
			INTERRUPT, RESET, CLK	: in std_logic;
			OUT_PORT, PORT_ID		: out std_logic_vector(7 downto 0);
			READ_STROBE				: out std_logic; 
			WRITE_STROBE			: out std_logic);
end component;

signal IN_PORT, OUT_PORT, PORT_ID	: std_logic_vector(7 downto 0);
signal INTERRUPT, RESET, CLK, READ_STROBE, WRITE_STROBE : std_logic;

begin 
	
	UCT : kcpsm port map (	IN_PORT, INTERRUPT, RESET, CLK, OUT_PORT, PORT_ID, READ_STROBE, WRITE_STROBE);
	
	process (CLK)
	begin
		if CLK = 'U' then CLK <= '0';
		else CLK <= not(CLK) after 5ns;
		end if;
	end process;
	
	IN_PORT <= "01110111";
	
	RESET <= '0'; INTERRUPT <= '0';
	
end architecture;
