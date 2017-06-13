@echo off

REM Place it in your encoding folder and start it whenever you need a directory for a new show (or additional folders in an existing one).
set enc=Encode_DVD.bat

set /p FolderName="Enter Showname: "
@echo.

:RetryOVACount
set /p OVACount="Enter Number of OVAs: "
@echo %OVACount%|findstr /xr "[1-9][0-9]* 0" >nul && (
    @echo. ) || (
    @echo Not a valid number!
    goto :RetryOVACount
)

:RetrySpCount
set /p EpisodeCount="Enter Number of Specials: "
@echo %EpisodeCount%|findstr /xr "[1-9][0-9]* 0" >nul && (
    @echo. ) || (
    @echo Not a valid number!
    goto :RetrySpCount
)

:RetryChapterCount
set /p BDMenuCount="Enter Number of Chapters: "
@echo %BDMenuCount%|findstr /xr "[1-9][0-9]* 0" >nul && (
    @echo. ) || (
    @echo Not a valid number!
    goto :RetryChapterCount
)

if not exist "%FolderName%" md "%FolderName%"
cd "%FolderName%"

if not exist "%FolderName%/%enc%" copy "%~dp0\%enc%"

if %OVACount%==0 goto :Special_Step
set OVA_Counter=0
:OVALoop
set /a OVA_Counter=OVA_Counter+1
if %OVA_Counter% LSS 10 set OVA_Number=0%OVA_Counter%
if %OVA_Counter% GEQ 10 set OVA_Number=%OVA_Counter%
if not exist "OVA %OVA_Number%" md "OVA %OVA_Number%"
if not %OVA_Counter% == %OVACount% goto :OVALoop

:Special_Step
if %EpisodeCount%==0 goto :Chapter_Step
set Episode_Counter=0
:EpisodeLoop
set /a Episode_Counter=Episode_Counter+1
if %Episode_Counter% LSS 10 set episodeNumber=0%Episode_Counter%
if %Episode_Counter% GEQ 10 set episodeNumber=%Episode_Counter%
if not exist "Special %episodeNumber%" md "Special %episodeNumber%"
if not %Episode_Counter% == %EpisodeCount% goto :EpisodeLoop

:Chapter_Step
if %BDMenuCount%==0 goto :Last_Step
set BDMenu_Counter=0
:BDMenuLoop
set /a BDMenu_Counter=BDMenu_Counter+1
if %BDMenu_Counter% LSS 10 set BDMenu_Number=0%BDMenu_Counter%
if %BDMenu_Counter% GEQ 10 set BDMenu_Number=%BDMenu_Counter%
if not exist "Chapter %BDMenu_Number%" md "Chapter %BDMenu_Number%"
if not %BDMenu_Counter% == %BDMenuCount% goto :BDMenuLoop

:Last_Step
if not exist "Chapter 01" goto :AVS2
cd "Chapter 01"
if not exist 480.avs @echo #AVCSource("src.dga") or DGSource("src.dgi") > 480.avs
:AVS2
if not exist "OVA 01" goto :AVS3
cd "OVA 01"
if not exist 480.avs @echo #AVCSource("src.dga") or DGSource("src.dgi") > 480.avs
:AVS3
if not exist "Special 01" goto :end
cd "Special 01"
if not exist 480.avs @echo #AVCSource("src.dga") or DGSource("src.dgi") > 480.avs

:end
@echo Done!
timeout 1 > nul
REM pause
