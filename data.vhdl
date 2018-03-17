library ieee;
use ieee.numeric_std.all;

package data is
	function init return boolean;
	attribute foreign of init : function is "VHPIDIRECT init";

	function more return boolean;
	attribute foreign of more : function is "VHPIDIRECT more";

	function next32 return integer;
	attribute foreign of next32 : function is "VHPIDIRECT next32";

	-- should be a procedure but I can't get that to work under GHDL
	function write32(v : integer) return integer;
	attribute foreign of write32 : function is "VHPIDIRECT write32";
end data;

package body data is
	function init return boolean is
	begin
		assert false severity failure;
	end init;

	function more return boolean is
	begin
		assert false severity failure;
	end more;

	function next32 return integer is
	begin
		assert false severity failure;
	end next32;

	function write32(v : integer) return integer is
	begin
		assert false severity failure;
	end write32;
end data;
