cd %~dp0

copy FETD_1.gba FETD.gba

cd "%~dp0Tables"

echo: | (c2ea "%~dp0FE8_clean.gba")

cd "%~dp0Event Assembler"

Core A FE8 "-output:%~dp0FETD.gba" "-input:%~dp0Buildfile2.event" -symOutput:FETD_Symbols2.txt

pause
