-- Made by Aierizer Samuel
-- Started 06.05.19


----------------
-- Counter Stack
----------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity program_counter_stack is
	port (	In_Stack		: in std_logic_vector(7 downto 0);
			Stack			: in std_logic_vector(1 downto 0);
			Reset, Clock	: in std_logic;
			Out_Stack		: out std_logic_vector(7 downto 0));
end entity;

architecture beh of program_counter_stack is

type mem is array(0 to 14) of std_logic_vector(7 downto 0);
signal reg	: mem;

begin
	
	process (Reset, Clock, Stack)
	variable cursor : natural range 0 to 15 := 0;
	begin
		if (Reset = '1') then
			reg(0 to 14) <= (others => "00000000");
			cursor := 0;
		else
			if (Clock = '1' and Clock'Event) then
				if (Stack(1) = '1') then
					if (Stack(0) = '1') then
						if (cursor < 14) then
							reg(cursor) <= In_Stack;
							cursor := cursor + 1;
						else
							reg(14) <= In_Stack;
						end if;
					else
						if (cursor > 0) then
							cursor := cursor - 1;
							Out_Stack <= reg(cursor);
							reg(cursor) <= "00000000";
						else
							Out_Stack <= reg(0);
							reg(0) <= "00000000";
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	
end architecture;
