library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity main is
end;

architecture main_impl of main is
	signal clock, rx, tx : std_logic := '0';
	signal rxdata, txdata : unsigned(63 downto 0);
	constant EDGE : time := 3 ns; -- 6 ns clock cycle
begin
	dut : entity work.arp(arp_impl)
	port map(clock => clock, rx => rx, rxdata => rxdata, tx => tx, txdata => txdata);

	process is
		variable i, a, d : integer := 0;
	begin

		if not work.data.init then
			assert false report "failed to init" severity failure;
		end if;

		while work.data.more loop
			i := work.data.next32;

			rxdata(63 downto 32) <= to_unsigned(0, 32);
			rxdata(31 downto 0) <= to_unsigned(i, 32);
			rx <= '1';

			clock <= '1';
			wait for EDGE;

			if tx = '1' then
				a := to_integer(txdata);
				d := work.data.write32(a);
				assert false report "i: " & integer'image(i) & " a: " & integer'image(a) severity note;
			else
				assert false report "i: " & integer'image(i) & " no tx" severity note;
			end if;

			clock <= '0';
			wait for EDGE;
		end loop;

		assert false report "done" severity note;
		wait;
	end process;
end main_impl;
