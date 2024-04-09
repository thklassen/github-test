// enable API deprecated in Windows 10 2004. Particularly,
// ExAllocatePoolWithTag still gets used (instead of ExAllocatePool2)
// to support both current and older Kernel SDKs.
#define POOL_ZERO_DOWN_LEVEL_SUPPORT

#include <wdm.h>
#include <Wdf.h>
#include <wdfdriver.h>
#include <ntstrsafe.h>
#include <stdlib.h>

#define ARRAYSIZE 1000
#define COCOFUNCTION 0x801
#define DEVICE_WRITE CTL_CODE(FILE_DEVICE_UNKNOWN, COCOFUNCTION, METHOD_BUFFERED, FILE_WRITE_DATA)

static UNICODE_STRING DeviceName;
static UNICODE_STRING SymLinkName;

static PDEVICE_OBJECT DeviceObject = NULL;

static int err = 0;
static int written = 0;


static int csfputs(const char* s, void* stream)
{
    IO_STATUS_BLOCK ioStatusBlock;
    int size = 0;
    const char* copy = s;
    do
    {
        size++;
        copy++;
    } while (*copy);

    NTSTATUS ntstatus;

    ntstatus = ZwWriteFile(stream, NULL, NULL, NULL, &ioStatusBlock,
        (void*)s, size, NULL, NULL);
    if (!NT_SUCCESS(ntstatus)) {
        DbgPrint("COVERAGE: Can't write to file on disk\r\n");
        return 0;
    };
    return 1;
}

static void* csfopenappend(const char* path)
{
    err = 0;
    UNICODE_STRING     uniName;
    OBJECT_ATTRIBUTES  objAttr;
    char concat_path[1024];
    IO_STATUS_BLOCK    ioStatusBlock;
    ANSI_STRING AS;

    strcpy(concat_path, "\\DosDevices\\");
    strcat(concat_path, path);

    RtlInitAnsiString(&AS, concat_path);
    RtlAnsiStringToUnicodeString(&uniName, &AS, TRUE);
    //RtlInitUnicodeString(&uniName, concat_path);  // or L"\\SystemRoot\\example.txt"
    InitializeObjectAttributes(&objAttr, &uniName,
        OBJ_CASE_INSENSITIVE | OBJ_KERNEL_HANDLE,
        NULL, NULL);

    if (KeGetCurrentIrql() != PASSIVE_LEVEL)
        return NULL;


    HANDLE   handle;
    NTSTATUS ntstatus;

    ntstatus = ZwCreateFile(&handle,
        GENERIC_WRITE,
        &objAttr, &ioStatusBlock, NULL,
        FILE_ATTRIBUTE_NORMAL,
        0,
        FILE_OVERWRITE_IF,
        FILE_SYNCHRONOUS_IO_NONALERT,
        NULL, 0);
    if (!NT_SUCCESS(ntstatus)) {
        DbgPrint("COVERAGE: Can't create file on disk\r\n");
        err = 1;
        return 0;
    };
    written = 1;
    return (void*)handle;
}

static int csfclose(void* fp)
{
    if (fp == NULL) {
        DbgPrint("COVERAGE: Error in csfclose - no file pointer!\r\n");
        return 0;
    }
    ZwClose((HANDLE)fp);
    return 1;
}

NTSTATUS coverageCall(
    struct _DEVICE_OBJECT* DeviceObject,
    struct _IRP* Irp)
{
    NTSTATUS status = STATUS_SUCCESS;
    PIO_STACK_LOCATION irpsp = IoGetCurrentIrpStackLocation(Irp);

    Irp->IoStatus.Information = 0;
    IoCompleteRequest(Irp, IO_NO_INCREMENT);
    return status;
}


NTSTATUS coverageControl(
    struct _DEVICE_OBJECT* DeviceObject,
    struct _IRP* Irp)
{
    NTSTATUS status = STATUS_SUCCESS;
    PIO_STACK_LOCATION irpsp = IoGetCurrentIrpStackLocation(Irp);
    wchar_t * buffer = (wchar_t *)Irp->AssociatedIrp.SystemBuffer;
    ULONG inLength = irpsp->Parameters.DeviceIoControl.InputBufferLength;

    if( irpsp->Parameters.DeviceIoControl.IoControlCode == DEVICE_WRITE) {
        char *resultName;
        resultName = (char*)ExAllocatePoolWithTag(NonPagedPool, ARRAYSIZE, 'wri');
        RtlZeroMemory(resultName, ARRAYSIZE);

        int length;
        if( inLength < ARRAYSIZE ) {
            length = wcstombs(resultName, buffer, inLength);
        } else {
            length = wcstombs(resultName, buffer, ARRAYSIZE);
        }
        if (length == -1) {
            DbgPrint("COVERAGE: Error in csfclose - no file pointer!\r\n");
            return 1;
        }
        resultName[length] = 0;
        __coveragescanner_filename(resultName);

    } else {
        status = STATUS_INVALID_PARAMETER;
    }

    written = 0;
    __coveragescanner_save();

    if (err)
    {
        CHAR* kernelMessage = "COVERAGE: Error in writing coverage. Check your paths and file name.";
        Irp->IoStatus.Information = strlen(kernelMessage);
        size_t outputLength = irpsp->Parameters.DeviceIoControl.OutputBufferLength;
        size_t length = 0;
        if (outputLength < strlen(kernelMessage)) {
            length = outputLength;
        }
        else {
            length = strlen(kernelMessage);
        }
        RtlCopyMemory(Irp->AssociatedIrp.SystemBuffer, kernelMessage, length);
        Irp->IoStatus.Status = STATUS_SUCCESS;
        status = STATUS_SUCCESS;
    }
    else if (!written)
    {
        CHAR* kernelMessage = "COVERAGE: There is no data to write.";
        Irp->IoStatus.Information = strlen(kernelMessage);
        size_t outputLength = irpsp->Parameters.DeviceIoControl.OutputBufferLength;
        size_t length = 0;
        if (outputLength < strlen(kernelMessage)) {
            length = outputLength;
        }
        else {
            length = strlen(kernelMessage);
        }
        RtlCopyMemory(Irp->AssociatedIrp.SystemBuffer, kernelMessage, length);
        Irp->IoStatus.Status = STATUS_SUCCESS;
        status = STATUS_SUCCESS;
    }
    else
    {
        Irp->IoStatus.Status = status;
        Irp->IoStatus.Information = 0;
    }

    IoCompleteRequest(Irp, IO_NO_INCREMENT);
    return status;
}


void coverage_unload()
{
    IoDeleteSymbolicLink(&SymLinkName);
    IoDeleteDevice(DeviceObject);
    DbgPrint("COVERAGE: Driver Unload \r\n");
}

void coverage_init() {
    PDRIVER_OBJECT DriverObject;
    WDFDRIVER driv = WdfGetDriver();
    if( driv == NULL ) {
        DbgPrint("COVERAGE: Can't receive correct Driver \r\n");
        return;
    }

    DriverObject = WdfDriverWdmGetDriverObject(driv);

    __coveragescanner_set_custom_io(
        0,
        csfputs,
        csfopenappend,
        0,
        0,
        csfclose,
        0);

    // TODO Determinating the size
    int size = ARRAYSIZE;
    DeviceName.Length = 0;
    DeviceName.MaximumLength = size + 2;
    DeviceName.Buffer = (wchar_t*)ExAllocatePoolWithTag(NonPagedPool, size, 'devc');
    RtlZeroMemory(DeviceName.Buffer, size);

    SymLinkName.Length = 0;
    SymLinkName.MaximumLength = size + 2;
    SymLinkName.Buffer = (wchar_t*)ExAllocatePoolWithTag(NonPagedPool, size, 'syml');
    RtlZeroMemory(SymLinkName.Buffer, size);

    // Preparing const strings for the naming of device and symlink
    UNICODE_STRING catDeviceString1;
    RtlInitUnicodeString(&catDeviceString1, L"\\Device\\coco-");

    UNICODE_STRING catSymlinkString1;
    RtlInitUnicodeString(&catSymlinkString1, L"\\??\\coco-");

    NTSTATUS status;
    status = STATUS_SUCCESS;

    // This next part is used to delete the "/Driver/" part from "/Driver/$DRIVERNAME$"
    UNICODE_STRING copy;
    copy.Buffer = (wchar_t*)ExAllocatePoolWithTag(NonPagedPool, DriverObject->DriverName.Length, 'test');
    RtlZeroMemory(copy.Buffer, DriverObject->DriverName.Length);

    copy.Length = DriverObject->DriverName.Length;
    copy.MaximumLength = DriverObject->DriverName.MaximumLength;
    RtlUnicodeStringCopy(&copy, &DriverObject->DriverName);

    int lastFoundSlash = -1;
    for (int i = 0; i < copy.Length; i++) {
        wchar_t character;
        character = (wchar_t)copy.Buffer[i];
        if (character == '/' || character == '\\') lastFoundSlash = i + 1;
    }
    if (lastFoundSlash >= copy.Length || lastFoundSlash < 0) {
        DbgPrint("COVERAGE: The device name has trailing Backslash\r\n");
        return;
    }

    copy.Buffer = copy.Buffer + lastFoundSlash;
    copy.Length = copy.Length - (lastFoundSlash * 2);
    copy.MaximumLength = copy.Length + 2;

    char *tempName;
    tempName = (char*)ExAllocatePoolWithTag(NonPagedPool, size, 'tmpn');
    RtlZeroMemory(tempName, size);

    char *resultName;
    resultName = (char*)ExAllocatePoolWithTag(NonPagedPool, size, 'res');
    RtlZeroMemory(resultName, size);
    strcpy(resultName, "C:\\");

    int length;
    if( copy.Length < ARRAYSIZE ) {
        length = wcstombs(tempName, copy.Buffer, copy.Length);
    } else {
        length = wcstombs(tempName, copy.Buffer, ARRAYSIZE);
    }
    if( length == -1 ) {
        DbgPrint("COVERAGE: Error in converting string\r\n");
        return;
    }
    strcat(resultName, tempName);
    __coveragescanner_filename(resultName);
    // Concatenating the Device Name
    // "\Device\" + $DRIVERNAME$ + "-cocodevice"
    status = RtlUnicodeStringCat(&DeviceName, &catDeviceString1);
    if (status != STATUS_SUCCESS) {
        DbgPrint("COVERAGE: Error in Concatenating 1\r\n");
        return;
    }

    status = RtlUnicodeStringCat(&DeviceName, &copy);
    if (status != STATUS_SUCCESS) {
        DbgPrint("COVERAGE: Error in Concatenating 2\r\n");
        return;
    }


    // Concatenating the SymlinkName
    // "\Device\" + $DRIVERNAME$ + "-cocodevice" + "-symlink"
    status = RtlUnicodeStringCat(&SymLinkName, &catSymlinkString1);
    if (status != STATUS_SUCCESS) {
        DbgPrint("COVERAGE: Error in Concatenating 4\r\n");
        return;
    }

    status = RtlUnicodeStringCat(&SymLinkName, &copy);
    if (status != STATUS_SUCCESS) {
        DbgPrint("COVERAGE: Error in Concatenating 5\r\n");
        return;
    }


    // Creating a device to interact with the driver
    status = IoCreateDevice(DriverObject, 0, &DeviceName, FILE_DEVICE_UNKNOWN, FILE_DEVICE_SECURE_OPEN, FALSE, &DeviceObject);
    if (!NT_SUCCESS(status)) {
        DbgPrint("COVERAGE: Creating Coverage Device Failed\r\n");
        return;
    };

    // Symbolic Link for the user application:
    status = IoCreateSymbolicLink(&SymLinkName, &DeviceName);
    if (!NT_SUCCESS(status)) {
        DbgPrint("COVERAGE: Creating Coverage Symlink Failed\r\n");
        IoDeleteDevice(DeviceObject);
        return;
    };

    // Set the Majorfunctions interactions to the coverageCall function
    for( int i = 0; i < IRP_MJ_MAXIMUM_FUNCTION; i++)
    {
        DriverObject->MajorFunction[i] = coverageCall;
    }
    DriverObject->MajorFunction[IRP_MJ_DEVICE_CONTROL] = coverageControl;

    return;
}
