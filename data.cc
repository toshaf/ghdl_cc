#include <iostream>
#include <cstdint>

std::uint32_t value;

extern "C"
bool init()
{
	value = 0;

	std::cout << "data_init" << std::endl;

	return true;
}

extern "C"
bool more()
{
	std::cout << (value < 10 ? "" : "no ") << "more available" << std::endl;
	return value < 10;
};

extern "C"
std::uint32_t next32()
{
	std::cout << "data_next32 value: " << value << std::endl;
	return value++;
}

extern "C"
std::uint32_t write32(std::uint32_t v)
{
	std::cout << "data_write32 v:" << v << std::endl;

	return v;
}
