cd %~dp0

copy FETD0.gba FETD_1.gba

cd "%~dp0Event Assembler"

Core A FE8 "-output:%~dp0FETD_1.gba" "-input:%~dp0ROM Buildfile.event" -symOutput:FETD_Symbols1.txt

pause
