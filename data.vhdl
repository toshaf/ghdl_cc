library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package data is
	function init return boolean;
	attribute foreign of init : function is "VHPIDIRECT init";

	function next_packet return boolean;
	attribute foreign of next_packet : function is "VHPIDIRECT next_packet";

	function more return boolean;
	attribute foreign of more : function is "VHPIDIRECT more";

	function next8 return integer;
	attribute foreign of next8 : function is "VHPIDIRECT next8";

	function next32 return integer;
	attribute foreign of next32 : function is "VHPIDIRECT next32";

	function next64 return signed;
	attribute foreign of next64 : function is "VHPIDIRECT next64";

	-- should be a procedure but I can't get that to work under GHDL
	function write32(v : integer) return integer;
	attribute foreign of write32 : function is "VHPIDIRECT write32";
end data;

package body data is
	function init return boolean is
	begin
		assert false severity failure;
	end init;

	function next_packet return boolean is
	begin
		assert false severity failure;
	end next_packet;

	function more return boolean is
	begin
		assert false severity failure;
	end more;

	function next8 return integer is
	begin
		assert false severity failure;
	end next8;

	function next32 return integer is
	begin
		assert false severity failure;
	end next32;

	function next64 return signed is
	begin
		assert false severity failure;
	end next64;

	function write32(v : integer) return integer is
	begin
		assert false severity failure;
	end write32;
end data;
