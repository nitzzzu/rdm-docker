# How to compile Redis desktop manager on Windows platform

- Install Visual Studio 2015 Community with Updates, even if you have a newer Visual Studio installed:
```
choco install visualstudio2015community
```
- Install [Qt 5.9.6](https://www.qt.io/download) with msvc2015 compiler. This will install Qt in `C:\Qt\5.9.6\msvc2015` and `Qt Creator`
- You might have to copy `rc.exe` and `rcdll.dll` from `C:\Program Files (x86)\Microsoft SDKs` to `C:\Qt\5.9.6\msvc2015` if you cannot compile.
- Install [Win32 OpenSSL](https://slproweb.com/download/Win32OpenSSL-1_0_2p.exe) to `C:\OpenSSL-Win32 folder`
- Install [CMake](https://cmake.org/download/) and check the installation to add to the PATH
- Open `VS2015 x86 Native Tools Command Prompt`
```
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86

set QTDIR=C:\Qt\5.9\msvc2015
set PATH=%QTDIR%\bin;%PATH%
set SRCDIR=c:\rdm
```
- Get the sources for RedisDesktopManager:
```
git clone --recursive https://github.com/uglide/RedisDesktopManager.git -b 0.9 c:\rdm
```
- Create `Release` folder:
```
cd %SRCDIR%
mkdir release
```
- Compile libssh2
```
cd ./3rdparty/qredisclient/3rdparty/qsshclient/3rdparty/libssh2
cmake -DCRYPTO_BACKEND=WinCNG -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=./output --build .
cmake --build . --target install
mkdir build\src\release
copy output\lib\* build\src\release
copy output\bin\* %SRCDIR%\release
```
- Compile RDM
```
cd %SRCDIR%/src
qmake CONFIG+=release
nmake /S /NOLOGO release

cd %SRCDIR%
copy /y .\bin\windows\release\rdm.exe .\release\rdm.exe
copy /y .\bin\windows\release\rdm.pdb .\release\rdm.pdb
cd .\release
windeployqt --no-angle --no-opengl-sw --no-compiler-runtime --no-translations --release --force --qmldir %SRCDIR%\src\qml rdm.exe

rmdir /S /Q .\platforminputcontexts
rmdir /S /Q .\qmltooling
rmdir /S /Q .\QtGraphicalEffects
del /Q  .\imageformats\qtiff.dll
del /Q  .\imageformats\qwebp.dll
```
