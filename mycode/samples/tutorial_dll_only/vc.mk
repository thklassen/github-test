all: tutorial.exe tutorial_load_library.exe

clean:
	del /Q *.exp *.dll *.exe *.lib *.obj *.csexe *.csmes 

tutorial.exe: tutorial.dll main.obj
	link /NOLOGO /OUT:tutorial.exe main.obj tutorial.lib

tutorial_load_library.exe: tutorial.dll main_load_library.obj
	link /NOLOGO /OUT:tutorial_load_library.exe main_load_library.obj 

tutorial.lib: tutorial.dll

tutorial.dll: tutorial.obj
	cslink /NOLOGO /DLL /OUT:tutorial.dll tutorial.obj

tutorial.obj: tutorial.cpp tutorial.h
	cscl.exe --cs-count /nologo /c /EHsc tutorial.cpp

main.obj: main.cpp tutorial.h
	cl.exe /nologo /c /EHsc main.cpp

main_load_library.obj: main_load_library.cpp tutorial.h
	cl.exe /nologo /c /EHsc main_load_library.cpp
