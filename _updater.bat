@echo off
setlocal ENABLEDELAYEDEXPANSION
TITLE Default HUD File Updater
SET LOGFILE=extractlog.log
call :LogIt >> %LOGFILE% 
exit /b 0

:LogIt

echo ///////////////////////////////////////////////////////////////
echo // (1/10) - Setting default directories, deleting _tf2hud folder
echo ///////////////////////////////////////////////////////////////

set "default_tf2hud_folder=_tf2hud"
set "core_resource=resource"
set "core_scripts=scripts"

rd /s /q "%default_tf2hud_folder%"

echo ///////////////////////////////////////////////////////////////
echo // (2/10) - Extracting default hudfiles
echo ///////////////////////////////////////////////////////////////

IF NOT EXIST "%default_tf2hud_folder%\resource\ui" (mkdir "%default_tf2hud_folder%\resource\ui")
IF NOT EXIST "%default_tf2hud_folder%\scripts" (mkdir "%default_tf2hud_folder%\scripts")
#UpdateFiles\HLExtract.exe -p "..\..\tf2_misc_dir.vpk" -d "%default_tf2hud_folder%" -e "root\resource" -m -v -s
#UpdateFiles\HLExtract.exe -p "..\..\tf2_misc_dir.vpk" -d "%default_tf2hud_folder%\scripts" -e "root\scripts\HudLayout.res" -m -v -s
#UpdateFiles\HLExtract.exe -p "..\..\tf2_misc_dir.vpk" -d "%default_tf2hud_folder%\scripts" -e "root\scripts\HudAnimations_tf.txt" -m -v -s

echo ///////////////////////////////////////////////////////////////
echo // (3/10) - Removing minmode, [$OSX], and [$X360] lines from basehud
echo ///////////////////////////////////////////////////////////////

#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* _minmode _disabled
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* [$OSX] [disabled]
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* [$X360] [disabled]

echo ///////////////////////////////////////////////////////////////
echo // (4/10) - Removing lodef and hidef lines from basehud
echo ///////////////////////////////////////////////////////////////

#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* _lodef _disabled
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* _hidef _disabled

echo ///////////////////////////////////////////////
echo // (5/10) - Removing if_ lines from basehud
echo ///////////////////////////////////////////////
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* if_ disabled_

echo ///////////////////////////////////////////////////////////////
echo // (6/10) - Deleting unused folders and files
echo ///////////////////////////////////////////////////////////////
rd /s /q "%default_tf2hud_folder%\resource\ui\disguise_menu_360"
rd /s /q "%default_tf2hud_folder%\resource\ui\disguise_menu_sc"
rd /s /q "%default_tf2hud_folder%\resource\ui\build_menu_360"
rd /s /q "%default_tf2hud_folder%\resource\ui\build_menu_sc"

echo ///////////////////////////////////////////////////////////////
echo // (7/10) - Setting hidden attributes to prevent file deletion
echo ///////////////////////////////////////////////////////////////
attrib /s "%default_tf2hud_folder%\resource\roundinfo\*" +h
attrib /s "%default_tf2hud_folder%\resource\ui\*" +h
attrib /s "%default_tf2hud_folder%\resource\chatscheme.res" +h
attrib /s "%default_tf2hud_folder%\resource\clientscheme.res" +h
attrib /s "%default_tf2hud_folder%\resource\gamemenu.res" +h
attrib /s "%default_tf2hud_folder%\resource\sourcescheme.res" +h

echo ///////////////////////////////////////////////////////////////
echo // (8/10) - Deleting all unused files
echo ///////////////////////////////////////////////////////////////
del /s /q "%default_tf2hud_folder%\resource\*"

echo ///////////////////////////////////////////////////////////////
echo // (9/10) - Setting attributes back to defaults
echo ///////////////////////////////////////////////////////////////
attrib /s "%default_tf2hud_folder%\resource\roundinfo\*" -r -s -h
attrib /s "%default_tf2hud_folder%\resource\ui\*" -r -s -h
attrib /s "%default_tf2hud_folder%\resource\chatscheme.res" -r -s -h
attrib /s "%default_tf2hud_folder%\resource\clientscheme.res" -r -s -h
attrib /s "%default_tf2hud_folder%\resource\gamemenu.res" -r -s -h
attrib /s "%default_tf2hud_folder%\resource\sourcescheme.res" -r -s -h

echo ///////////////////////////////////////////////////////////////
echo // (10/10) - Copying stubborn default files over to core directory
echo ///////////////////////////////////////////////////////////////
copy /y "%default_tf2hud_folder%\resource\clientscheme.res" "%core_resource%\clientscheme_base.res"
copy /y "%default_tf2hud_folder%\resource\sourcescheme.res" "%core_resource%\sourcescheme_base.res"
copy /y "%default_tf2hud_folder%\resource\gamemenu.res" "%core_resource%\gamemenu_base.res"

echo Done.
echo Thanks to JarateKing and Wiethoofd for tips with this!

## TIMEOUT /T 20 >NUL
## exit