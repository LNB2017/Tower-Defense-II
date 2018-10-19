@rem RUN THIS AFTER "MAKE HACK.cmd" (whether full or quick)

cd %~dp0

copy FE8_clean.gba FETD0.gba

cd "%~dp0Event Assembler"

Core A FE8 "-output:%~dp0FETD0.gba" "-input:%~dp0Buildfile_graphics.event" -symOutput:FETD_GraphicsSymbols1.txt

pause
