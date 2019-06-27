# Cross compile in Docker container using MXE

## Prepare

- Create Dockerfile:
```
RUN apt-get install -y --no-install-recommends \
	autoconf \
	automake \
	autopoint \
	binutils \
	bison \
	build-essential \
	ca-certificates \
	cmake \
	debhelper \
	devscripts \
	fakeroot \
	flex \
	gcc \
	git \
	gperf \
	intltool \
	libgdk-pixbuf2.0-dev \
	libffi-dev \
	libgmp-dev \
	libmpc-dev \
	libmpfr-dev \
	libtool \
	libtool-bin \
	libz-dev \
	openssl \
	patch \
	pkg-config \
	p7zip-full \
	ruby \
	scons \
	subversion \
	texinfo \
	unzip \
	wget \
	lzip \
	python3-dev

RUN mkdir /build
WORKDIR  /build
RUN git clone https://github.com/mxe/mxe.git

RUN cd mxe && make qtbase
RUN cd mxe && make qtmultimedia
RUN cd mxe && make qtcharts

ENV PATH /build/mxe/usr/bin:$PATH

RUN ln -s /build/mxe/usr/bin/i686-w64-mingw32.static-qmake-qt5 /build/mxe/usr/bin/qmake
```
- Build 'qt' image:
```
docker build -t qt .
```
- Install `Windows x86 executable installer` of Python3.7 [https://www.python.org/downloads/release/python-370/] to C:\Python37
- Install `pexports` and `dlltools` from MinGW [https://osdn.net/projects/mingw/downloads/68260/mingw-get-setup.exe/]
  - `dlltools`: `mingw-get install mingw32-binutils-bin`
  - `pexports`: `mingw-get install mingw-utils`
- Generate Python lib:
```
cd C:\Python37
C:\MinGW\bin\pexports.exe python37.dll > python27.def
C:\MinGW\bin\dlltool.exe --dllname python37.dll -d python37.def -l libpython37.a
```

## Adjust sources

- Clone 'rdm' repo:
```
git clone --recursive https://github.com/uglide/RedisDesktopManager.git -b 2019 rdm
```
- Adapt the sources to compile:

- `3rdparty/pyotherside.pri`:
```
win32* {
    QMAKE_LIBS += -L/usr/python37/libs -lpython37
    INCLUDEPATH += /usr/python37/include
}
```

- `3rdparty.pri`:
```
win32* {
	QMAKE_CXXFLAGS += -D_hypot=hypot
```
- Download and extract to 3rdparty dir: `https://www.nuget.org/packages/zlib-msvc14-x64/1.2.11.7795`

## Compile
- Run docker container whith sources and python as volumes:
```
docker run -it -v C:\Python37-x64:/usr/python37 -v D:\Docker\Qt\RedisDesktopManager:/usr/rdm qt bash
```
- (INTO DOCKER CONTAINER):
```
cd /usr/rdm/src
qmake
make
```
- Check `D:\Docker\Qt\RedisDesktopManager\bin\windows\release` for .exe build and copy there python embedded https://www.python.org/downloads/release/python-370/



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
