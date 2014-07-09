NIEM NDR Tools
====

A set of tools for testing and using the NIEM Naming and Design Rules Schematron rules.

Available on github at https://github.com/webb/niem-ndr-tools

There are several [NIEM NDR versions](http://reference.niem.gov/niem/specification/naming-and-design-rules/).



# Installing the NIEM NDR tools

## Installing on Windows 7 with Cygwin
  
1. Install Cygwin. 
  
  In Cygwin, install packages:
  * git
  * make
  * curl
  * unzip
  * patch
2. Clone the repository using git:
  
  In a Cygwin terminal:

  ```bash
cd
git clone https://github.com/webb/niem-ndr-tools.git
```
3. Build the toolset:

  Make sure you're on the Internet.

  In a Cygwin terminal:

    ```bash
cd ~/niem-ndr-tools
make all
````
