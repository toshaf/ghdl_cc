main: main.o
	ghdl -e -Wl,-ldata_cc.o -Wl,-lstdc++ main

data.o: data.vhdl data_cc.o
	ghdl -a data.vhdl

arp.o: arp.vhdl
	ghdl -a arp.vhdl

data_cc.o: data.cc
	g++ -std=c++11 -c -o data_cc.o data.cc

main.o: main.vhdl data.o arp.o
	ghdl -a main.vhdl

.PHONY: clean
clean:
	-@rm *.o
	-@rm *.cf
	-@rm main
