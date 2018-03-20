#pragma once 

#include <iostream>
#include <fstream>
#include <vector>
#include <stdexcept>
#include <sstream>

constexpr uint32_t MAGIC = 0xa1b2c3d4;
constexpr uint32_t MAGIC_BE = 0xd4c3b2a1;

enum Network
{
	ETHERNET = 1,
};

std::ostream& operator<<(std::ostream& os, Network n)
{
	switch (n)
	{
		case ETHERNET:
			return os << "ETHERNET";
		default:
			return os << "Network(" << (int)n << ")";
	}
}

struct file_header
{
	uint32_t magic_number;   /* magic number */
	uint16_t version_major;  /* major version number */
	uint16_t version_minor;  /* minor version number */
	int32_t  thiszone;       /* GMT to local correction */
	uint32_t sigfigs;        /* accuracy of timestamps */
	uint32_t snaplen;        /* max length of captured packets, in octets */
	uint32_t network;        /* data link type */
};

void write_file_header(std::ostream& os)
{
	file_header header;
	header.magic_number = MAGIC;
	header.version_major = 2;
	header.version_minor = 4;
	header.thiszone = 0;
	header.sigfigs = 0;
	header.snaplen = 262144;
	header.network = ETHERNET;

	os.write((char*)&header, sizeof(header));
}

std::ostream& operator<<(std::ostream& os, const file_header& hdr)
{
	switch (hdr.magic_number)
	{
		case MAGIC:
			std::cout << "pcap(le)";
			break;
		case MAGIC_BE:
			std::cout << "pcap(be)";
			break;
		default:
			// TODO nanosecond precision
			std::cout << "not_pcap?";
			return os;
	}

	std::cout << " v=" << hdr.version_major << "." << hdr.version_minor;
	std::cout << " adjust_s=" << hdr.thiszone;
	std::cout << " sigfigs=" << hdr.sigfigs;
	std::cout << " snaplen=" << hdr.snaplen;
	std::cout << " network=" << (Network)hdr.network;

	return os;
}

struct packet_header
{
	uint32_t ts_sec;
	uint32_t ts_usec;
	uint32_t incl_len;
	uint32_t orig_len;
};

void write_packet(std::ostream& os, const std::vector<uint8_t>& v)
{
	packet_header header;
	header.ts_sec = time(nullptr);
	header.ts_usec = 0;
	header.incl_len = v.size(); // TODO: use snaplen
	header.orig_len = v.size();

	os.write((const char*)&header, sizeof(header));
	os.write((const char*)&v[0], v.size());
}

std::ostream& operator<<(std::ostream& os, const packet_header& hdr)
{
	return std::cout
		<< "ts_sec=" << hdr.ts_sec
		<< " ts_usec=" << hdr.ts_usec
		<< " incl_len=" << hdr.incl_len
		<< " orig_len=" << hdr.orig_len;
}

struct packet
{
	packet_header hdr;
	std::vector<uint8_t> payload;
};

std::ostream& operator<<(std::ostream& os, const packet& pkt)
{
	return os << pkt.hdr;
}

struct reader
{
	void read(std::string fname)
	{
		infile.open(fname, std::ifstream::binary);
		if (!infile)
		{
			std::stringstream ss;
			ss << "failed to open file " << fname;

			throw std::runtime_error(ss.str());
		}

		if (!infile.read((char*)&hdr, sizeof(hdr)))
			throw std::runtime_error("failed to read file header");

		if (hdr.magic_number != MAGIC)
			throw std::runtime_error("unsupported pcap");
	}

	bool read_packet()
	{
		if (!infile.read((char*)&pkt.hdr, sizeof(pkt.hdr)))
			return false;

		pkt.payload.resize(pkt.hdr.incl_len);
		if (!infile.read((char*)&pkt.payload[0], pkt.hdr.incl_len))
			throw std::runtime_error("failed to load packet payload");

		return true;
	}

	std::ifstream infile;
	file_header hdr;
	packet pkt;
};
