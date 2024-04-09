UNAME_S := $(shell uname -s)

######## Adjust to your system here ############
ifeq ($(UNAME_S),Darwin)
    TCLLIBS=-ltk8.5  -ltcl8.5
    TCLINCLUDES=-I/usr/include/tcl8.5 -I/opt/X11/include
    CXX=clang++
else
    TCLLIBS=-ltk8.5 -litcl3.4 -ltcl8.5
    TCLINCLUDES=-I/usr/include/tcl8.5
endif
################################################

CXXFLAGS=$(TCLINCLUDES)
LFLAGS=$(TCLLIBS)
ENCRYPT=tr 'abcdefghijklmnopqrstuvwxyz' 'zyxwvutsrqponmlkjihgfedcba'

all: proto.exe

clean:
	rm -f proto.exe 
	rm -f *.o
	rm -f *.tclx
	rm -f *.csmes *.csexe

proto.exe: main.o encrypt
	$(CXX) $(LFLAGS) -o proto.exe main.o

main.o: main.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c main.cpp

encrypt: mainwindow.tclx canvas.tclx input.tclx 

mainwindow.tclx: secret/mainwindow.tcl
	$(ENCRYPT) < secret/mainwindow.tcl > mainwindow.tclx

input.tclx: secret/input.tcl
	$(ENCRYPT) < secret/input.tcl > input.tclx

canvas.tclx: secret/canvas.tcl
	$(ENCRYPT) < secret/canvas.tcl > canvas.tclx
