-- Made by Aierizer Samuel
-- Started 29.04.19
-- Error> sel_prog_flow remains U, no reset


------------------
-- Control Unit --
------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Control_Unit is
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
end entity;

architecture cu of Control_Unit is

component Clock_Split
	port (	Clk						: in std_logic;
			Instruction, Registers	: out std_logic); 
end component;

signal reg: std_logic_vector(15 downto 0); 

begin

	reg <= Instruction;
	Const <= reg(7 downto 0); 
	Sel_X <= reg(11 downto 8);
	Sel_Y <= reg(7 downto 4);
	
	process (reset, reg)
	begin 
		if (Reset = '1') then
			Alu_Enable <= '0';
			Reset_flags <= '1';
			Sel_prog_flow <= "10000";
		else 
			Reset_flags <= '0';
				if (reg(15) = '0') then
					Alu_Enable <= '1';
					Sel_Alu <= reg(15 downto 14);
					Opt_Alu(2) <= reg(15);
					Opt_Alu(1 downto 0) <= reg(13 downto 12);
					Sel_prog_flow <= "10000";
				else
					if (reg(14) = '0') then
						Alu_Enable <= '0';
						if(reg(13) = '0') then
							Sel_prog_flow(4 downto 3) <= reg(9 downto 8); 
							Sel_prog_flow(2 downto 0) <= reg(12 downto 10);
						else
							Alu_Enable <= '1';
							Opt_Alu <= "000";
							Sel_Alu <= "00";
							Sel_port <= reg(12);
							Sel_prog_flow <= "10000";	
						end if;
					else
						Alu_Enable <= not reg(13);
						if (reg(13) = '0') then
							if (reg(12) = '0') then
								Sel_Alu <= reg(3 downto 2);
								Opt_Alu(2) <= '1';
								Opt_Alu(1 downto 0) <= reg(1 downto 0);
								Sel_prog_flow <= "10000";
							else
								Sel_Alu(1) <= reg(15);
								Sel_Alu(0) <= reg(3);
								Sel_prog_flow <= "10000";	
							end if;
						else
							Sel_port <= reg(12);
							Sel_prog_flow <= "10000"; 
						end if;
					end if;
				end if;
		end if;
	end process;
	
	Read <= '1' when (reg(15 downto 13) = "101" and Reset = '0') else '0';
	Write <= '1' when (reg(15 downto 13) = "111" and Reset = '0') else '0';
	
end architecture;
