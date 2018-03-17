library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity arp is
	port(
		clock: in std_logic
	-- while rx is high, rxdata will be read from
	; rx: in std_logic
	-- incoming data read on rising clock edge
	; rxdata: in unsigned(63 downto 0)
	-- while tx is high, txdata will be written to
	; tx: out std_logic
	-- outgoing data
	; txdata: out unsigned(63 downto 0)
	);
end arp;

architecture arp_impl of arp is
begin
	process (clock) is
		variable i : integer := 0;
	begin
		if rising_edge(clock) then
			tx <= '0';
			if rx = '1' then
				i := to_integer(rxdata(31 downto 0));
				if i mod 2 = 0 then
					txdata(63 downto 0) <= to_unsigned(i * i, 64);
					tx <= '1';
				end if;
			end if;
		end if;
	end process;
end arp_impl;
