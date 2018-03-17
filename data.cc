#include <stdio.h>
#include <cstdint>

std::uint32_t value;

extern "C"
bool init()
{
	value = 0;

	printf("data_init\n");

	return true;
}

extern "C"
bool more()
{
	printf("data_more value: %u\n", value);
	return value < 10;
};

extern "C"
std::uint32_t next32()
{
	printf("data_next32 value: %u\n", value);
	return value++;
}

extern "C"
std::uint32_t write32(std::uint32_t v)
{
	printf("data_write32 v: %u\n", v);
}
