@rem RUN THIS AFTER "MAKE HACK.cmd" (whether full or quick)

cd %~dp0

copy FETD_1.gba FETD.gba

cd "%~dp0Event Assembler"

Core A FE8 "-output:%~dp0FETD.gba" "-input:%~dp0Buildfile1.event"

pause
