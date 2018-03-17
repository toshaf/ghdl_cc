main: data.o data_cc.o arp.o main.o
	ghdl -e -Wl,-ldata_cc.o main

data.o: data.vhdl
	ghdl -a data.vhdl

arp.o: arp.vhdl
	ghdl -a arp.vhdl

data_cc.o: data.cc
	g++ -c -o data_cc.o data.cc

main.o: main.vhdl
	ghdl -a main.vhdl

.PHONY: clean
clean:
	-@rm *.o
	-@rm *.cf
	-@rm main
