#include <tcl.h>
#include <tk.h>
#if !defined(__APPLE__)
#  include <itcl.h>
#endif

#include <errno.h>
#include <string.h>
#include <fstream>
#include <string>
#include <cerrno>

static std::string readFile(const char *fileName)
{
    std::ifstream file(fileName, std::ios::in);
    if (!file) {
        fprintf(stderr, "Failed to open %s: %s\n", fileName, strerror(errno));
        return std::string();
    }
    std::string code;
    file.seekg(0, std::ios::end);
    code.resize(file.tellg());
    file.seekg(0, std::ios::beg);
    file.read(&code[0], code.size());
    file.close();
    return code;
}

// simple symmetric encryption swapping lower-case alphabet characters
static void decrypt(std::string *str)
{
    for (std::string::iterator it = str->begin();
         it != str->end(); ++it) {
        if (*it >= 'a' && *it <= 'z') {
            *it = 'a' + ('z' - *it);
        }
    }
}

static int getScriptFileName(Tcl_Interp *interp, std::string *fileName)
{
    const int ret = Tcl_Eval(interp, "info script");
    if (ret == TCL_OK) {
        *fileName = Tcl_GetStringResult(interp);
    }
    return ret;
}

static int setScriptFileName(Tcl_Interp *interp, const std::string &fileName)
{
    std::string code = "info script ";
    code += "\"" + fileName + "\"";
    return Tcl_Eval(interp, code.c_str());
}

static bool evalFile(Tcl_Interp *interp, const char *fileName)
{
    std::string code = readFile(fileName);
    const char *suffix = strstr(fileName, ".tclx");
    if (suffix && *(suffix + 5) == '\0') {
        decrypt(&code);
    }

    std::string oldFileName;
    if (getScriptFileName(interp, &oldFileName) != TCL_OK) {
        fprintf(stderr, "Warning: failed to determine current source file "
                        "name: %s\n",
                Tcl_GetStringResult(interp));
    }

    if (setScriptFileName(interp, fileName) != TCL_OK) {
        fprintf(stderr, "Warning: failed to set source file name: %s\n",
                Tcl_GetStringResult(interp));
    }

    if (Tcl_Eval(interp, code.c_str()) != TCL_OK) {
        fprintf(stderr, "Evaluation of %s failed: %s\n",
                fileName,
                Tcl_GetStringResult(interp));
        return false;
    }

    if (setScriptFileName(interp, oldFileName) != TCL_OK) {
        fprintf(stderr, "Warning: failed to restore source file name: %s\n",
                Tcl_GetStringResult(interp));
    }

    return true;
}

int main(int argc, char **argv)
{
    Tcl_FindExecutable(argv[0]);

    Tcl_Interp *interp = Tcl_CreateInterp();
    if (interp == NULL) {
        fprintf(stderr, "Tcl_CreateInterp() failed\n");
        return 1;
    }

    if (Tcl_Init(interp) != TCL_OK) {
        fprintf(stderr, "Tcl_Init() failed: %s\n",
                Tcl_GetStringResult(interp));
        return 1;
    }
    if (Tk_Init(interp) != TCL_OK) {
        fprintf(stderr, "Tk_Init() failed: %s\n",
                Tcl_GetStringResult(interp));
        return 1;
    }
#if !defined(__APPLE__)
    if (Itcl_Init(interp) != TCL_OK) {
        fprintf(stderr, "Itcl_Init() failed: %s\n",
                Tcl_GetStringResult(interp));
        return 1;
    }
#endif

    for (int a = 1; a < argc; ++a) {
        const char *fileName = argv[a];
        if (!evalFile(interp, fileName)) {
            return 1;
        }
    }

    Tk_MainLoop();

    return 0;
}
