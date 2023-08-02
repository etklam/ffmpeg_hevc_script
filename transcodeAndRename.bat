@echo off

set input_folder=E:\wait
set output_folder=E:\output
set done_folder="%input_folder%\done"

set nvenc_preset=slow
set nvenc_qp=23
set nvenc_maxrate=10M
set nvenc_bufsize=20M

for %%f in ("%input_folder%\*.*") do (
    ffmpeg -i "%%f" 2>&1 | findstr /C:"hevc" >nul
    if errorlevel 1 (
        echo Transcoding "%%f" to HEVC...
        set "output_file=%output_folder%\%%~nf.hevc.mkv"
        if exist "!output_file!" (
            set count=1
            set "output_file=%output_folder%\%%~nf_!count!.hevc.mkv"
            :loop
            if exist "!output_file!" (
                set /a count+=1
                set "output_file=%output_folder%\%%~nf_!count!.hevc.mkv"
                goto :loop
            )
        )
        ffmpeg -y -hwaccel cuvid -i "%%f" -c:v hevc_nvenc -preset:v %nvenc_preset% -cq:v %nvenc_qp% -maxrate:v %nvenc_maxrate% -bufsize:v %nvenc_bufsize% -c:a copy -c:s copy "!output_file!"
        echo Finished transcoding "%%f".
        move "%%f" "%done_folder%"
    ) else (
        set "output_file=%output_folder%\%%~nxf"
        if exist "!output_file!" (
            set count=1
            set "output_file=%output_folder%\%%~nf_!count!%%~xf"
            :loop
            if exist "!output_file!" (
                set /a count+=1
                set "output_file=%output_folder%\%%~nf_!count!%%~xf"
                goto :loop
            )
        )
        move "%%f" "!output_file!"
    )
)
echo All videos converted to HEVC.