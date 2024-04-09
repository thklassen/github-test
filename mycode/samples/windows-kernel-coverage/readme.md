# How to setup your driver for kernel coverage:

## Create an option file "cocooption" that contains the settings for Coco

Add the following lines to the "cocooption" file which are mandatory:

--cs-on 
--cs-memory-pool=64000 
--cs-architecture=Kernel 
--cs-condition 
--cs-line 
--cs-function 
--cs-hit 
--cs-full-instrumentation 
--cs-coverage-save-function=coverage_init 
--cs-trigger-function=DriverEntry  

Add the following line with the path to the downloaded coverage.h file:

--cs-custom-library-source=$PATHTOCOVERAGEFILE$\coverage.h

Be aware that the complete setup only work if the DriverEntry function of your driver is still named "DriverEntry" or you rename the switch --cs-trigger-function=DriverEntry to your DriverEntry function in your driver. 

## Setup your Visual Studio 

Add the following line to the Visual Studio Settings under 

Project Settings > C/C++ > Commandline > Additional options

and 

Project Settings > Linker > Commandline > Additional options

--cs-option-file=$PATHTOOPTIONFILE$
Change the $PATHTOOPTIONFILE$ to your coco option file which we created earlier.

## Using the console application cocodump

Build the console application cocodump.

The cocodump needs to be executed by a command line with admin rights.
The usage of the cocodump tools is as following:

cocodump.exe $NAMEOFCOCODEVICE" "$OUTPUTFILE$"

You can run this application on the target machine once you installed the driver.
Please confirm with the winobj tool that there is a element with the name "coco-$YOURDRIVERNAME$" in the "Device" and the "/??/" folder. 

Use the cocodump application with the full name listed in "/??/".

So for example to dump the execution data from your driver with the name "driver" into the file "C:\driver.csexe" you would need to call:

cocodump.exe coco-driver "C:\driver.csexe"

Please check the command line output of the cocodump tool for any error messages.