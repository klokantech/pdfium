set BASE_DIR=%CD%

:DEPS
cd %BASE_DIR%
mkdir pdfium_deps
cd pdfium_deps
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
git clone https://chromium.googlesource.com/external/gyp.git
set PATH=c:\src\pdfium_deps\depot_tools;%PATH%

cd gyp
python setup.py install

:PDFIUM
cd %BASE_DIR%
git clone https://github.com/klokantech/pdfium pdfium

:BUILD
cd %BASE_DIR%\pdfium

python build\gyp_pdfium.py

REM Building x64
echo call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x64 > build_x64.bat
echo msbuild build\all.sln /p:Configuration=Release /p:Platform=x64 >> build_x64.bat
cmd /c build_x64.bat

REM Building x86
echo call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86 > build_x86.bat
echo msbuild build\all.sln /p:Configuration=Release /p:Platform=Win32 >> build_x86.bat
cmd /c build_x86.bat

