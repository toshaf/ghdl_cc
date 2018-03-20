library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity main is
end;

architecture main_impl of main is
	signal clock, rx, tx : std_logic := '0';
	signal rxdata, txdata : signed(63 downto 0);
	constant EDGE : time := 3 ns; -- 6 ns clock cycle
begin
	dut : entity work.arp(arp_impl)
	port map(clock => clock, rx => rx, rxdata => rxdata, tx => tx, txdata => txdata);

	process is
		variable a, discard : integer := 0;
		variable temp : signed(63 downto 0);
	begin

		if not work.data.init then
			assert false report "failed to init" severity failure;
		end if;

		while work.data.next_packet loop

			while work.data.more loop

				rxdata <= signed(work.data.next64);
				rx <= '1';

				clock <= '1';
				wait for EDGE;

				if tx = '1' then
					a := to_integer(txdata(31 downto 0));
					discard := work.data.write32(a);
					a := to_integer(txdata(63 downto 32));
					discard := work.data.write32(a);
				end if;

				clock <= '0';
				wait for EDGE;
			end loop;

			-- clean up last of tx
			loop
				clock <= '1';
				wait for EDGE;

				if tx = '1' then
					a := to_integer(txdata(31 downto 0));
					discard := work.data.write32(a);
					a := to_integer(txdata(63 downto 32));
					discard := work.data.write32(a);
				end if;

				clock <= '0';
				wait for EDGE;

				if tx = '0' then
					exit;
				end if;

			end loop;

		end loop;

		assert false report "done" severity note;
		wait;
	end process;
end main_impl;
