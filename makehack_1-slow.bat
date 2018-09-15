cd %~dp0

copy FE8_clean.gba FETD_1.gba

cd "%~dp0Text"

echo: | (textprocess_v2 text_buildfile.txt)

cd "%~dp0Event Assembler"

Core A FE8 "-output:%~dp0FETD_1.gba" "-input:%~dp0Buildfile1.event" -symOutput:FETD_Symbols1.txt

pause
