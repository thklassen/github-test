all: dump_on_event.exe dump_on_event_cs.exe

dbg: all
	devenv /DebugExe dump_on_event.exe 

clean:
	del /Q dump_on_event.exe dump_on_event.obj dump_on_event.ilk *.pdb  dump_on_event_cs.exe

dump_on_event.exe: dump_on_event.cpp Makefile
	cl /nologo /Zi /EHsc "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /nologo dump_on_event.cpp /Fedump_on_event.exe

dump_on_event_cs.exe: dump_on_event.cs Makefile
	csc /nologo  -out:dump_on_event_cs.exe dump_on_event.cs
