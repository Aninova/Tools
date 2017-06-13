@echo off

REM Install directories are C:\Tools and %userprofile%\AppData\Roaming\Microsoft\Windows\SendTo

REM List of files to download
set binaries=^
avs4x264mod.exe ^
avs4x26x.exe ^
cwebp.exe ^
eac3to.exe ^
ffmpeg.exe ^
Filelist.txt ^
mkvmerge.exe ^
nconvert.exe ^
neroAacEnc.exe ^
rhash.exe ^
scxvid.exe ^
vfr.py ^
wput.exe ^
x264_r2762_64_CtMod-10bit-all.exe ^
x264_r2762_64_CtMod-8bit-all.exe ^
xdelta3.exe

set scripts=^
API_Upload_Nyaa.py

set sendto_scripts=^
Create_Torrent.bat ^
Upload_Torrent.bat

REM Various URLs/Paths
set node_version=v6.10.3
set install_dir=C:\Tools
set sendto_path=%appdata%\Microsoft\Windows\SendTo
set bin_url=https://bitbucket.org/Fremder/tools/raw/dc9a67813ed852baa86c9435ac2a3e3e243b011d/bin
set scripts_url=https://bitbucket.org/Fremder/tools/raw/dc9a67813ed852baa86c9435ac2a3e3e243b011d/scripts
set node_url=https://nodejs.org/dist/%node_version%/node-%node_version%-x64.msi



echo #       Install Script 0.3.1  #
echo _____________________________________
echo.

echo Scripts will be saved to these directories:
echo %install_dir%
echo %sendto_path%
echo.

if not exist "%install_dir%" md "%install_dir%" 
if not exist "%install_dir%\bin" md "%install_dir%\bin"
if not exist "%install_dir%\scripts" md "%install_dir%\scripts"
echo.

if exist "%PROGRAMFILES%\nodejs\node.exe" echo Node found. Proceeding...
if not exist "%PROGRAMFILES%\nodejs\node.exe" set /p node_prompt="Nodejs is required for create-torrent. Install now? (y/n)"
echo.

if /I "%node_prompt%"=="y" (
    if exist "node-%node_version%-x64.msi" (
        echo Found nodejs %node_version% installer, starting now...
        msiexec.exe /i "node-%node_version%-x64.msi"
    )
    if not exist "node-%node_version%-x64.msi" (
        echo Downloading nodejs %node_version%...
        powershell Start-BitsTransfer %node_url%
        echo Download finished, starting installer...
        msiexec.exe /i "node-%node_version%-x64.msi"
    )
    del "node-%node_version%-x64.msi"
    echo.
)

REM echo Installing nodejs modules...
if exist %install_dir%\node_modules\.bin\create-torrent.cmd set /p install_ct="Create-Torrent found. Reinstall/Update? (y/n)"
echo.

pushd "%install_dir%"
if /I "%install_ct%"=="y" call npm -s install create-torrent && echo.
if not exist %install_dir%\node_modules\.bin\create-torrent.cmd call npm -s install create-torrent && echo.
popd

set /p overwrite="Overwrite existing binaries/scripts? (y/n)"
echo.

for %%a in (%binaries%) do (
    if exist "%install_dir%\bin\%%a" if /I "%overwrite%"=="y" powershell Start-BitsTransfer %bin_url%/%%a "%install_dir%\bin" && echo Overwrote %%a
    if exist "%install_dir%\bin\%%a" if /I "%overwrite%"=="n" echo Skipped %%a
    if not exist "%install_dir%\bin\%%a" powershell Start-BitsTransfer %bin_url%/%%a "%install_dir%\bin" && echo Copied %%a
)

for %%a in (%scripts%) do (
    if exist "%install_dir%\scripts\%%a" if /I "%overwrite%"=="y" powershell Start-BitsTransfer %scripts_url%/%%a "%install_dir%\scripts" && echo Overwrote %%a
    if exist "%install_dir%\scripts\%%a" if /I "%overwrite%"=="n" echo Skipped %%a
    if not exist "%install_dir%\scripts\%%a" powershell Start-BitsTransfer %scripts_url%/%%a "%install_dir%\scripts" && echo Copied %%a
)

for %%a in (%sendto_scripts%) do (
    if exist "%sendto_path%\%%a" if /I "%overwrite%"=="y" powershell Start-BitsTransfer %scripts_url%/%%a "%sendto_path%" && echo Overwrote %%a
    if exist "%sendto_path%\%%a" if /I "%overwrite%"=="n" echo Skipped %%a
    if not exist "%sendto_path%\%%a" powershell Start-BitsTransfer %scripts_url%/%%a "%sendto_path%" && echo Copied %%a
)

echo.
echo Done!
echo.

pause