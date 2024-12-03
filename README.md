# CPU with exceptions

# Install
### Install the following Linux dependencies (No need to do this on Windows)
```
$ sudo dpkg --add-architecture i386
$ sudo apt update
$ sudo apt install libxft2:i386 libxext6:i386 libncurses5:i386 bzip2:i386 g++-multilib
```
### Install Intel Quartus
Go to:
https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime/resource.html

And pick Intel Quartus Prime Lite Edition 20.1. Then go to individual files and install the following.
- Quartus Prime
- ModelSim
- Cyclone IV

Then run:
```
$ ./QuartusLiteSetup-20.1.0.711-linux.run
```
*Make sure you pick the free version and that you select Cyclone IV and ModelSim.*

# Load the project
Open Quartus.
*File->Open->processor_arm_expections.qpf*

# Run the project
Run *Analysis & Synthesis*
Then *RTL simulation*


### Possible issues.
You may see an error refering to a Licence environment variable. If you do, make sure you have installed the deps,
and that you installed the *FREE* version of the files.
