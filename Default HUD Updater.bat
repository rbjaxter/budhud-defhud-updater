@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
TITLE Default HUD File Updater
SET LOGFILE=#updatefiles\extractlog.log

:: Make sure people know what this is actually for
ECHO ====================================================================================================
ECHO budhud Default TF2 HUD Updater
ECHO ====================================================================================================
ECHO NOTE: THIS DOES NOT UPDATE YOUR HUD TO THE LATEST BUDHUD
ECHO       All this bat file does is extract TF2's default hud files and modify them to work with budhud.
ECHO       This means that you can run this file whenever there's a TF2 update (lol) to make the hud work
ECHO       on the newest version of TF2.
timeout /t -1

:: Make sure we have what we need first
ECHO ====================================================================================================
ECHO Checking directory for necessary files...
ECHO ====================================================================================================
IF NOT EXIST "..\..\tf2_misc_dir.vpk" (goto :ERROR_tf2_misc_dir)
IF NOT EXIST "#updatefiles" (goto :ERROR_updatefiles)
IF NOT EXIST "#updatefiles\_Modifier.exe" (goto :ERROR_modifier)
IF NOT EXIST "#updatefiles\HLExtract.exe" (goto :ERROR_hlextract)
GOTO :NOERROR

:ERROR_tf2_misc_dir
ECHO ERROR: Can't find tf2_misc_dir.vpk. Are you sure you installed the hud correctly?
ECHO        If you continue to have issues, check out the budhud Discord for help.
GOTO :END

:ERROR_updatefiles
ECHO ERROR: Can't find the #updatefiles folder. Are you sure you installed the hud correctly?
ECHO        If you continue to have issues, check out the budhud Discord for help.
GOTO :END

:ERROR_modifier
ECHO ERROR: Can't find _Modifier.exe in the #updatefiles folder. This is needed to remove certain text lines
ECHO        from the default TF2 hud. Please ensure budhud is installed correctly.
ECHO        If you continue to have issues, check out the budhud Discord for help.
GOTO :END

:ERROR_hlextract
ECHO ERROR: Can't find HLExtract.exe in the #updatefiles folder. This is needed to extract the default TF2
ECHO        hud from its VPK.
ECHO        If you continue to have issues, check out the budhud Discord for help.
GOTO :END

:NOERROR
ECHO ====================================================================================================
ECHO Check passed. You appear to have the necessary files.
ECHO Starting default hud extraction...
ECHO ====================================================================================================
TIMEOUT /t 7

ECHO ====================================================================================================
ECHO Setting default directories...
ECHO ====================================================================================================
SET "default_tf2hud_folder=_tf2hud"
SET "core_resource=resource"
SET "core_scripts=scripts"
SET "update_files=#updatefiles"
ECHO Done.

ECHO ====================================================================================================
ECHO Deleting _tf2hud directory...
ECHO ====================================================================================================
RD /s /q "%default_tf2hud_folder%"
ECHO Done.

ECHO ====================================================================================================
ECHO Extracting default HUD files...
ECHO ====================================================================================================
IF NOT EXIST "%default_tf2hud_folder%\resource\ui" (mkdir "%default_tf2hud_folder%\resource\ui")
IF NOT EXIST "%default_tf2hud_folder%\scripts" (mkdir "%default_tf2hud_folder%\scripts")
#UpdateFiles\HLExtract.exe -p "..\..\tf2_misc_dir.vpk" -d "%default_tf2hud_folder%" -e "root\resource" -m -v -s
#UpdateFiles\HLExtract.exe -p "..\..\tf2_misc_dir.vpk" -d "%default_tf2hud_folder%\scripts" -e "root\scripts\HudLayout.res" -m -v -s
#UpdateFiles\HLExtract.exe -p "..\..\tf2_misc_dir.vpk" -d "%default_tf2hud_folder%\scripts" -e "root\scripts\HudAnimations_tf.txt" -m -v -s
#UpdateFiles\HLExtract.exe -p "..\..\tf2_misc_dir.vpk" -d "%default_tf2hud_folder%\scripts" -e "root\scripts\mod_textures.txt" -m -v -s
ECHO Done.

ECHO ====================================================================================================
ECHO Removing minmode, [$OSX], and [$X360] lines from basehud...
ECHO ====================================================================================================
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* _minmode _disabled
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* [$OSX] [disabled]
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* [$X360] [disabled]
ECHO Done.

ECHO ====================================================================================================
ECHO Removing lodef and hidef lines from basehud...
ECHO ====================================================================================================
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* _lodef _disabled
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* _hidef _disabled
ECHO Done.

ECHO ====================================================================================================
ECHO Removing if_ lines from basehud...
ECHO ====================================================================================================
#UpdateFiles\_Modifier.exe -i -r -c -- %default_tf2hud_folder%\* if_ disabled_
ECHO Done.

ECHO ====================================================================================================
ECHO Deleting unused default hud folders and files...
ECHO ====================================================================================================
RD /s /q "%default_tf2hud_folder%\resource\ui\disguise_menu_360"
RD /s /q "%default_tf2hud_folder%\resource\ui\disguise_menu_sc"
RD /s /q "%default_tf2hud_folder%\resource\ui\build_menu_360"
RD /s /q "%default_tf2hud_folder%\resource\ui\build_menu_sc"
ECHO Done.

ECHO ====================================================================================================
ECHO Setting hidden attributes to prevent file deletion...
ECHO ====================================================================================================
ATTRIB /s "%default_tf2hud_folder%\resource\roundinfo\*" +h
ATTRIB /s "%default_tf2hud_folder%\resource\ui\*" +h
ATTRIB /s "%default_tf2hud_folder%\resource\chatscheme.res" +h
ATTRIB /s "%default_tf2hud_folder%\resource\clientscheme.res" +h
ATTRIB /s "%default_tf2hud_folder%\resource\gamemenu.res" +h
ATTRIB /s "%default_tf2hud_folder%\resource\sourcescheme.res" +h
ECHO Done.

ECHO ====================================================================================================
ECHO Deleting more unused default hud files...
ECHO ====================================================================================================
DEL /s /q "%default_tf2hud_folder%\resource\*"
ECHO Done.

ECHO ====================================================================================================
ECHO Setting attributes back to defaults...
ECHO ====================================================================================================
ATTRIB /s "%default_tf2hud_folder%\resource\roundinfo\*" -r -s -h
ATTRIB /s "%default_tf2hud_folder%\resource\ui\*" -r -s -h
ATTRIB /s "%default_tf2hud_folder%\resource\chatscheme.res" -r -s -h
ATTRIB /s "%default_tf2hud_folder%\resource\clientscheme.res" -r -s -h
ATTRIB /s "%default_tf2hud_folder%\resource\gamemenu.res" -r -s -h
ATTRIB /s "%default_tf2hud_folder%\resource\sourcescheme.res" -r -s -h
ECHO Done.

ECHO ====================================================================================================
ECHO Copying stubborn default files over to core directory...
ECHO ====================================================================================================
COPY /y "%default_tf2hud_folder%\resource\clientscheme.res" "%core_resource%\clientscheme_base.res"
COPY /y "%default_tf2hud_folder%\resource\sourcescheme.res" "%core_resource%\sourcescheme_base.res"
COPY /y "%default_tf2hud_folder%\resource\gamemenu.res" "%core_resource%\gamemenu_base.res"
COPY /y "%update_files%\confirmdialog.res" "%default_tf2hud_folder%\resource\ui\econ\confirmdialog.res"
ECHO Done.

ECHO ====================================================================================================
ECHO Latest default hud files have been downloaded and modified to work with budhud.
ECHO ====================================================================================================

:END
PAUSE