library ieee.numeric_std;
use ieee.numeric_std.all;
library ieee.std_logic_1164;
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
	begin
		if rising_edge(clock) then
			if rx then
				txdata <= rxdata * rxdata;
				tx <= true;
			elsif
				tx <= false;
			end if;
		end if;
	end process;
end arp_impl;
