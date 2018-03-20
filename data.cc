#include <iostream>
#include <cstdint>
#include <iomanip>

#include "pcap.h"

reader rdr;
size_t ix;

extern "C"
bool init()
{
	rdr.read("data/arp_1.pcap");
	ix = 0;

	return true;
}

extern "C"
bool next_packet()
{
	// TODO: temp for write32
	std::cout << std::endl;

	ix = 0;
	return rdr.read_packet();
}

extern "C"
bool more()
{
	return ix < rdr.pkt.payload.size();
};

extern "C"
std::uint8_t next8()
{
	std::uint8_t value = 0;

	if (ix < rdr.pkt.payload.size())
		value = rdr.pkt.payload[ix++];

	std::cout << std::setw(2) << std::hex << value << std::endl;

	return value;
}

extern "C"
std::uint32_t next32()
{
	std::uint32_t value = 0;
	std::uint8_t* p = reinterpret_cast<std::uint8_t*>(&value);
	for (auto i = 0u; i < 4; ++i, ++ix, ++p)
	{
		if (ix >= rdr.pkt.payload.size())
			break;

		*p = rdr.pkt.payload[ix];
	}

	std::cout << std::setw(8) << std::hex << value << std::endl;

	return value;
}

extern "C"
std::int64_t next64()
{
	std::int64_t value = 0;
	std::int8_t* p = reinterpret_cast<std::int8_t*>(&value);
	for (auto i = 0u; i < 8; ++i, ++ix, ++p)
	{
		if (ix >= rdr.pkt.payload.size())
			break;

		*p = rdr.pkt.payload[ix];
	}

	std::cout << std::setw(16) << std::hex << value << std::endl;

	return value;
}

extern "C"
std::uint32_t write32(std::uint32_t v)
{
	std::cout << std::setw(8) << std::hex << v;

	return 0; // ignored anyway
}
