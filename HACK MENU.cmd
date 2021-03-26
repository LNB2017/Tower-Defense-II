@echo off

set "base_dir=%~dp0"
set "source_rom=%~dp0FE8_clean.gba"
set "main_event=%~dp0ROM Buildfile.event"
set "target_rom=%~dp0FETD.gba"
set "target_ups=%~dp0FETD.ups"
set "ups=%~dp0Tools\ups\ups"
set "symcombo=%~dp0Tools\SymCombo\SymCombo.jar"
set "c2ea=%~dp0Tools\C2EA\c2ea"
set "parsefile=%~dp0Event Assembler\Tools\ParseFile.exe"
set "textprocess=%~dp0Tools\TextProcess\text-process-classic"
set "tmx2ea=%~dp0Tools\tmx2ea\tmx2ea"

echo Press 1 to run EA (make hack)
echo Press 2 to run C2EA (tables)
echo Press 3 to run Textprocess
echo Press 4 to run TMX2EA (maps)
echo Press 5 to run all
echo:

:Top

set input=
set /P input=

if /I "%input%" == "1" ( 
	goto :EA
) else if /I "%input%" == "2" ( 
	goto :C2EA
) else if /I "%input%" == "3" ( 
	goto :Textprocess
) else if /I "%input%" == "4" ( 
	goto :TMX2EA
) else if /I "%input%" == "5" ( 
	goto :Main
)
pause

:Main

:TMX2EA

echo:
echo Compiling maps...

echo: 
cd "%base_dir%Maps"
echo: | ("%tmx2ea%" -s)
echo:
cd "%base_dir%"
echo: 

if /I "%input%" == "4" ( 
	goto :EndProgram
)


:Textprocess

echo:
echo Compiling text...

echo:
cd "%base_dir%Text"
echo: | ("%textprocess%" "text_buildfile.txt" --parser-exe "%parsefile%")
cd "%base_dir%"
echo:

if /I "%input%" == "3" ( 
	goto :EndProgram
)

:C2EA

echo:
echo Compiling tables...

echo: 
cd "%base_dir%Tables"
echo: | ("%c2ea%" "%source_rom%")
cd "%base_dir%"
echo: 

if /I "%input%" == "2" ( 
	goto :EndProgram
)

:EA

echo:
echo Making hack...

echo:
echo Copying ROM...
echo:

copy "%source_rom%" "%target_rom%"

echo:
echo Compiling...
echo:

cd "%base_dir%Event Assembler"
ColorzCore A FE8 "-output:%target_rom%" "-input:%main_event%" "--nocash-sym" "--build-times"

echo:
echo Writing sym file...

java -jar "%symcombo%" "%~dp0FETD.sym" "%~dp0Tools\SymCombo\Stan.sym"

echo:
echo Generating patch...
echo:

cd "%base_dir%"
"%ups%" diff -b "%source_rom%" -m "%target_rom%" -o "%target_ups%"

:EndProgram

echo Done!
pause
