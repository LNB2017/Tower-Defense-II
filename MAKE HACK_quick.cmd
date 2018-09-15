cd %~dp0

copy FE8_clean.gba FETD.gba

cd "%~dp0Event Assembler"

Core A FE8 "-output:%~dp0FETD.gba" "-input:%~dp0ROM Buildfile.event" -symOutput:Test_Symbols.txt

pause
