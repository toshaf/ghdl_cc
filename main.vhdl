library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity main is
end;

architecture main_impl of main is
	signal clock : std_logic := '0';
	constant EDGE : time := 3 ns; -- 6 ns clock cycle
begin

	process is
		variable d : integer;
	begin
		if not work.data.init then
			assert false report "failed to init" severity failure;
		end if;

		while work.data.more loop
			d := work.data.next32;
			assert false report "d: " & integer'image(d) severity note;
		end loop;

		assert false report "done" severity note;
		wait;
	end process;
end main_impl;
