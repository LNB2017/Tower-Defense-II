cd %~dp0

copy FE8_clean.gba FETD.gba

cd "%~dp0Tables"

echo: | (c2ea "%~dp0FE8_clean.gba")

cd "%~dp0Text"

echo: | (textprocess_v2 text_buildfile.txt)

cd "%~dp0Event Assembler"

Core A FE8 "-output:%~dp0FETD.gba" "-input:%~dp0ROM Buildfile.event"

rem cd "%~dp0ups"

rem ups diff -b "%~dp0FE8_clean.gba" -m "%~dp0SkillsTest.gba" -o "%~dp0SkillsTest.ups"

pause
