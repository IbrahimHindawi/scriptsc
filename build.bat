@echo off

:: WARNING:
:: Must be executed from project root directory using `scripts\bbuild.bat`
::
:: TODO(Ibrahim): Implement Debug and Release to CompileCommand.

:: Setup Script Variables
for %%I in (.) do set projectName=%%~nxI
:: echo %projectName%

:: set CompileCommand=msbuild build\%projectName%.sln -nologo -m -v:m /property:Configuration=Debug /property:VcpkgEnabled=false
set CompileCommand=cmake --build build
:: set CompileCommand=cmake --build build --target %projectName%

:: Program Begin
echo Use -h to display available commands.
echo:
goto GETOPTS

:Help
echo -b to build.
echo -c to compile.
echo -cr to compile and run.
echo -mb to build haikal.
echo -mc to compile haikal.
echo -r to run exe.
echo -x to clean up.
goto :eof

:: TODO(Ibrahim): Move to NMake for faster compilation
:: cmake -G "NMake Makefiles" ..
:Build
mkdir build
pushd build
:: cmake .. "-DCMAKE_TOOLCHAIN_FILE=C:\devel\vcpkg\scripts\buildsystems\vcpkg.cmake" "-DCMAKE_BUILD_TYPE=Debug" "-DProjectNameParam:STRING=%projectName%"
:: powershell -Command ..\scripts\clang-build.ps1 -export-jsondb
:: cmake .. -G"Ninja" "-DCMAKE_BUILD_TYPE=Debug" "-DProjectNameParam:STRING=%projectName%" -DCMAKE_C_COMPILER=clang-cl
cmake .. -G"Ninja" "-DCMAKE_BUILD_TYPE=Debug" "-DProjectNameParam:STRING=%projectName%"
popd build
:: Ninja builds everything
:: echo Building haikal metaprogram generator...
:: cmake --build build\extern\haikal
goto :eof

:Compile
call extern\haikal\build\haikal.exe
%CompileCommand%
goto :eof

:CompileRun
call extern\haikal\build\haikal.exe
%CompileCommand%
build\%projectName%.exe
:: build\%projectName%.exe
goto :eof

:MetaBuild
echo Building haikal.
pushd extern\haikal
echo %cd%
call scripts\build.bat -x
call scripts\build.bat -b
popd
goto :eof

:MetaCompile
echo Compile haikal.
pushd extern\haikal
echo %cd%
call scripts\build.bat -c
popd
goto :eof

:Run
:: build\Debug\%projectName%.exe
build\%projectName%.exe
goto :eof

:CleanUp
echo Destroy build folder.
rmdir /S /Q build
goto :eof

:GETOPTS
if /I "%1" == "-h" call :Help
if /I "%1" == "-b" call :Build
if /I "%1" == "-c" call :Compile
if /I "%1" == "-cr" call :CompileRun
if /I "%1" == "-mb" call :MetaBuild
if /I "%1" == "-mc" call :MetaCompile
if /I "%1" == "-r" call :Run
if /I "%1" == "-x" call :CleanUp
shift
if not "%1" == "" call :Epilogue
:Epilogue
goto :eof
