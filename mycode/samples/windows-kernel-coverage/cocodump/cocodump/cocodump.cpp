
#include <windows.h>
#include <string>
#include <fileapi.h>
#include <intrin.h>
#include <windef.h>
#include <errhandlingapi.h>

std::string GetLastErrorAsString(DWORD errorMessageID)
{
	//Get the error message ID, if any.
	if (errorMessageID == 0) {
		return std::string(); //No error message has been recorded
	}

	LPSTR messageBuffer = nullptr;

	//Ask Win32 to give us the string version of that message ID.
	//The parameters we pass in, tell Win32 to create the buffer that holds the message for us (because we don't yet know how long the message string will be).
	size_t size = FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
		NULL, errorMessageID, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPSTR)&messageBuffer, 0, NULL);

	//Copy the error message into a std::string.
	std::string message(messageBuffer, size);

	//Free the Win32's string's buffer.
	LocalFree(messageBuffer);

	return message;
}

#define COCOFUNCTION 0x801
#define DEVICE_WRITE CTL_CODE(FILE_DEVICE_UNKNOWN, COCOFUNCTION, METHOD_BUFFERED, FILE_WRITE_DATA)
HANDLE devicehandle;

void printHelp() {
	printf("TRIGGER: Give driver name as first parameter.\n");
	printf("TRIGGER: Give output file name as second parameter.\n");
}

int wmain(int argc, wchar_t** argv)
{
	printf("TRIGGER: Release Saving Coverage\n");
	//  search for -cocodevice-symlink in "\\\\.\\" and create and close
	if (argc != 3) {
		printf("TRIGGER: Not enough commandline options\n");
		printHelp();
		return 1;
	}
	for (int i = 1; i < argc; i++) {
		if (!wcscmp(argv[i], L"-h") || !wcscmp(argv[i], L"-H") || !wcscmp(argv[i], L"--help")) {
			printHelp();
			return 1;
		}
	}

	const std::wstring A = L"\\\\.\\coco-";
	const std::wstring B = argv[1];
	const std::wstring result = A + B;
	// Open Create function of symlink device file
	devicehandle = CreateFile(result.c_str(), GENERIC_WRITE, 0, 0, OPEN_EXISTING
		, FILE_ATTRIBUTE_SYSTEM, 0);
	if (devicehandle == INVALID_HANDLE_VALUE) {
		printf("TRIGGER: Not a valid handle\n");
		return 1;
	}

	if (argc == 3)
	{
		char filename[8191] = { 0 };
		char returnedMessage[200] = { 0 };
		int len = wcslen(argv[2]);
		size_t returned;
		int length = wcstombs_s(&returned, filename, len, argv[2], len - 2);
		if (length == -1) {

		}

		DWORD writtenBytes = 0;
		DWORD bytesToWrite = (wcslen(argv[2]) + 1) * 2;
		if (!DeviceIoControl(devicehandle,
			DEVICE_WRITE,
			argv[2],
			bytesToWrite,
			returnedMessage,
			sizeof(returnedMessage),
			&writtenBytes,
			0)) {
			return 1;
		}
		else {
			printf("TRIGGER: Written to buffer!\n");
		}
		if (strlen(returnedMessage)) {
			printf("TRIGGER: Error message from driver %s\n", returnedMessage);
			CloseHandle(devicehandle);
			return 1;
		}
	}

	printf("TRIGGER: Closing handle\n");
	if (!CloseHandle(devicehandle)) {
		printf("TRIGGER: Can't write to file!\n");
		DWORD err = GetLastError();
		printf("TRIGGER: %s", GetLastErrorAsString(err).c_str());
		printf("TRIGGER: Can't write to file!\n");
		return 1;
	};

	printf("TRIGGER: Closed handle\n");
	printf("TRIGGER: Saved Coverage\n");
	return 0;
}
