@echo off
setlocal enabledelayedexpansion

set SOURCE_FOLDER="E:\wait"
set OUTPUT_FOLDER="E:\output"
set DONE_FOLDER="%SOURCE_FOLDER%\done"

set NVENC_PRESET="slow"
set NVENC_QP="23"
set NVENC_MAXRATE="10M"
set NVENC_BUFSIZE="20M"

for %%i in ("%SOURCE_FOLDER%\*.mp4" "%SOURCE_FOLDER%\*.avi" "%SOURCE_FOLDER%\*.mov" "%SOURCE_FOLDER%\*.mkv" "%SOURCE_FOLDER%\*.wmv" "%SOURCE_FOLDER%\*.flv" "%SOURCE_FOLDER%\*.webm") do (
    echo Converting "%%i" to HEVC...
    ffmpeg -y -hwaccel cuvid -i "%%i" -c:v hevc_nvenc -preset:v %NVENC_PRESET% -cq:v %NVENC_QP% -maxrate:v %NVENC_MAXRATE% -bufsize:v %NVENC_BUFSIZE% -c:a copy -c:s copy "%OUTPUT_FOLDER%\%%~ni.hevc.mkv"
    echo Finished converting "%%i".
    move "%%i" "%DONE_FOLDER%\"
)

echo All videos converted to HEVC.