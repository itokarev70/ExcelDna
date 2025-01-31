setlocal

set PackageVersion=%1
set DllVersion=%2
set MSBuildPath=%3

set rcfile=..\Source\versioninfo.rc2
PowerShell "(Get-Content %rcfile%) -replace '\d+,\d+,\d+,\d+', '%DllVersion%'.Replace('.',',') -replace '\d+\.\d+\.\d+\.\d+', '%DllVersion%' | Set-Content %rcfile%"
@if errorlevel 1 goto end

%MSBuildPath% ..\Source\ExcelDna.sln /t:restore,build /p:Configuration=Release
@if errorlevel 1 goto end

%MSBuildPath% ..\Source\ExcelDna.sln /t:restore,build /p:Configuration=Release /p:Platform=x64
@if errorlevel 1 goto end

call build.bat
@if errorlevel 1 goto end

cd ..\Package
call package.cmd %PackageVersion%
@if errorlevel 1 goto end

:end
