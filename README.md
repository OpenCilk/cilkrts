Intel(R) Cilk(TM) Plus runtime library

Index:
1. BUILDING
2. USING
3. DOXYGEN DOCUMENTATION
4. QUESTIONS OR BUGS
5. CONTRIBUTIONS

#
#  1. BUILDING:
#

To distribute applications that use the Cilk language extensions to
non-development systems, you need to build the Cilk runtime library
and distribute it with your application.  This instruction describes
the build process using CMake*, which supports Linux*, and OS X*.

You need the CMake tool and a C/C++ compiler that supports the Cilk
language extensions.  The requirements for each operating systems are:

- Common:
    CMake 3.4.3 or later
    Make tools such as make
- Linux:
    Tapir/LLVM compiler,
    or GCC* 4.9.2 or later (depracated),
    or Cilk-enabled branch of Clang*/LLVM* (http://cilkplus.github.io),
    or Intel(R) C++ Compiler v12.1 or later (depracated)
- OS X:
    Tapir/LLVM compiler,
    or Cilk-enabled branch of Clang*/LLVM* (http://cilkplus.github.io),
    or Intel C++ Compiler v12.1 or later (depracated)

The common steps to build the libraries are 1) invoke cmake with
appropriate options, 2) invoke a make tool available on the system.
The following examples show build processes on Linux/OS X.

Linux/OS X:
```bash
$ mkdir ./build && cd ./build
$ cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_INSTALL_PREFIX=./install ..
$ make && make install
```

#
#  2. USING:
#

The Tapir/LLVM compiler requires an explicit compiler option,
`-fcilkplus`, to enable Cilk language extensions.  For example,

```bash
$ clang -fcilkplus -o foo.exe foo.c 
```

#
#  3. DOXYGEN DOCUMENTATION:
#

The library source has Doxygen markup.  Generate HTML documentation
based on the markup by changing directory into runtime and running:

```
$ doxygen doxygen.cfg
```

#
#  4. QUESTIONS OR BUGS:
#

Issues with this Cilk runtime can be addressed on the Cilk Hub website
on GitHub: https://github.com/CilkHub/cilkrts/

#
#  5. CONTRIBUTIONS:
#

This Cilk runtime library, based on the the Intel Cilk Plus runtime
library, is dual licensed.  The upstream copy of the library is
maintained via the BSD-licensed version available at:
https://github.com/CilkHub/cilkrts/

Changes to this Cilk runtime are welcome and should be contributed to
the upstream version via https://github.com/CilkHub/cilkrts/.

The original Intel Cilk Plus runtime library is maintained via the
BSD-licensed version available at: http://cilkplus.org/

Changes to the Intel Cilk Plus runtime are welcome and should be
contributed to the upstream version via http://cilkplus.org/.

------------------------
Intel and Cilk are trademarks of Intel Corporation in the U.S. and/or
other countries.

*Other names and brands may be claimed as the property of others.
