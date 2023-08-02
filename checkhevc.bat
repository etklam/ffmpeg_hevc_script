@echo off

set input_folder=E:\tg_upskirt
set output_folder=E:\test

for %%f in ("%input_folder%\*.*") do (
    ffmpeg -i "%%f" 2>&1 | findstr /C:"hevc" >nul
    if errorlevel 1 (
        move "%%f" "%output_folder%"
    )
)
echo move done