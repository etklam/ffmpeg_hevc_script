@echo off

set input_folder=E:\wait
set output_folder=E:\output
set done_folder="%input_folder%\done"

set nvenc_preset=slow
set nvenc_qp=23

for %%f in ("%input_folder%\*.*") do (
    ffmpeg -i "%%f" 2>&1 | findstr /C:"hevc" >nul
    if errorlevel 1 (
        echo Transcoding "%%f" to HEVC...
        ffmpeg -y -hwaccel cuvid -i "%%f" -c:v hevc_nvenc -preset:v %nvenc_preset% -cq:v %nvenc_qp% -c:a copy -c:s copy "%output_folder%\%%~nf.hevc.mkv"
        echo Finished transcoding "%%f".
        move "%%f" "%done_folder%"
    ) else (
        move "%%f" "%output_folder%"
    )
)
echo All videos converted to HEVC.
