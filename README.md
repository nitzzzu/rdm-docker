# How to compile Redis desktop manager on Windows platform

- Clone the repo to `C:\`
```
git clone --recursive https://github.com/uglide/RedisDesktopManager.git
```
- Install Visual Studio 2015 Community with Updates, even if you have a newer Visual Studio installed:
```
choco install visualstudio2015community
```
- Install [Qt 5.9.6](https://www.qt.io/download) with msvc2015 compiler. This will install Qt in `C:\Qt\5.9.6\msvc2015` and `Qt Creator`
- You might have to copy `rc.exe` and `rcdll.dll` from `C:\Program Files (x86)\Microsoft SDKs` to `C:\Qt\5.9.6\msvc2015` if you cannot compile.
- Install [Win32 OpenSSL](https://slproweb.com/download/Win32OpenSSL-1_0_2p.exe) to `C:\OpenSSL-Win32 folder`
- Install [CMake](https://cmake.org/download/)
- Build `libssh2` library in folder `3rdparty/qredisclient/3rdparty/qsshclient/3rdparty/libssh2` using `CMake`. This will produce the .lib and .dll
```
cmake -DCRYPTO_BACKEND=WinCNG -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=./output --build .
cmake --build . --target install
mkdir build\src\release
copy output\lib\* build\src\release
```
- Open `./src/rdm.pro` in `Qt Creator`. Choose `Desktop Qt 5.9.6 MSVC2015 32bit > Release profile` and run build. (Ctrl-B). This will produce `C:\rdm\bin\windows\release\rdm.exe`
- To create a redist package:
```
C:\Qt\5.9.6\msvc2015\bin\windeployqt --qmldir C:\rdm\src\qml C:\rdm\bin\windows\release
copy libssh2.dll, libeay32.dll, ssleay32.dll, vcredist_x86.exe to the package
```
