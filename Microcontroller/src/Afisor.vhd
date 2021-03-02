-- Made by Aierizer Samuel
-- Started 23.04.19


library IEEE;
use IEEE.STD_LOGIC_1164.all;   

entity afisor is
	port (	Clk						: in std_logic;
			In1, In2, In3, In4		: in std_logic_vector(3 downto 0);
			Out_Cat					: out std_logic_vector(6 downto 0);
			Out_An					: out std_logic_vector(3 downto 0);
			Zero					: out std_logic);
end entity;



architecture comp of afisor is

signal clk_70Hz, aux: std_logic;

signal reg: std_logic_vector(3 downto 0) := "1110";

signal sel: std_logic_vector(3 downto 0);

signal outp: std_logic_vector(3 downto 0); 

signal segm: std_logic_vector(6 downto 0);

begin
	
	Divizor: process (Clk)
		variable nr: natural range 0 to 1400000 := 0;
	begin
		if (Clk = '1' and Clk'Event) then
			nr := nr + 1;
			if(nr = 700_000) then
				clk_70Hz <= '1';
			elsif (nr = 1_400_000) then
				clk_70Hz <= '0';
				nr := 0;
			end if;
		end if;
	end process;
	
	Regi: process (clk_70hz, In1, In2, In3, In4, reg, aux)
	begin
		if (clk_70Hz = '1' and clk_70Hz'EVENT) then
			aux <= reg(0);
			reg(0) <= reg(1);
			reg(1) <= reg(2);
			reg(2) <= reg(3);
			reg(3) <= aux;
		end if;
	end process;
	

	Mux: process (reg, In1, In2, In3, In4)
	begin
		if		reg = "0111"	then outp <= In1;
		elsif	reg = "1011"	then outp <= In2;
		elsif	reg = "1101"	then outp <= In3;
		else	outp <= In4;
		end if;
	end process;
	
	Out_An <= outp;
	
	BCD: process (outp)
	begin
		case outp is
    		when "0000" => segm <= "0000001"; -- "0"     
    		when "0001" => segm <= "1001111"; -- "1" 
    		when "0010" => segm <= "0010010"; -- "2" 
    		when "0011" => segm <= "0000110"; -- "3" 
    		when "0100" => segm <= "1001100"; -- "4" 
    		when "0101" => segm <= "0100100"; -- "5" 
    		when "0110" => segm <= "0100000"; -- "6" 
   			when "0111" => segm <= "0001111"; -- "7" 
    		when "1000" => segm <= "0000000"; -- "8"     
    		when "1001" => segm <= "0000100"; -- "9" 
    		when "1010" => segm <= "0000010"; -- a
    		when "1011" => segm <= "1100000"; -- b
    		when "1100" => segm <= "0110001"; -- C
    		when "1101" => segm <= "1000010"; -- d
    		when "1110" => segm <= "0110000"; -- E
    		when "1111" => segm <= "0111000"; -- F
			when others => segm <= "1111111"; -- ERROR
    	end case;
	end process; 
	
	Out_Cat <= segm;
	
	Zero <= '0';
	
end architecture;	  