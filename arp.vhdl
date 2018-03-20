library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity arp is
	port(
		clock: in std_logic
	-- while rx is high, rxdata will be read from
	; rx: in std_logic
	-- incoming data read on rising clock edge
	; rxdata: in signed(63 downto 0)
	-- while tx is high, txdata will be written to
	; tx: out std_logic
	-- outgoing data
	; txdata: out signed(63 downto 0)
	);
end arp;

architecture arp_impl of arp is
begin
	process (clock) is
		variable recv : boolean := false;
		variable ctr : integer := 0;
		variable dst, src : signed(47 downto 0);
	begin
		if rising_edge(clock) then

			tx <= '0';

			if rx = '1' then
				if recv then
					ctr := ctr + 1;
				else
					ctr := 0; -- reset
				end if;
				recv := true;
			end if;

			case ctr is
				when 0 =>
					dst := rxdata(47 downto 0);
					src(15 downto 0) := rxdata(63 downto 48);
				when 1 =>
					src(47 downto 16) := rxdata(31 downto 0);
					tx <= '1';
					txdata(47 downto 0) <= src;
					txdata(63 downto 48) <= dst(15 downto 0);
				when 2 =>
					tx <= '1';
					txdata(31 downto 0) <= dst(47 downto 16);
					txdata(63 downto 32) <= to_signed(0, 32);
				when others =>
					tx <= '0';
			end case;
		end if;
	end process;
end arp_impl;
