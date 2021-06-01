$NOPREFIX
OPTION EXPLICIT
ON ERROR GOTO ERRORHANDLER
RANDOMIZE TIMER
SCREEN NEWIMAGE(640, 480, 32) '40x30
PRINTMODE KEEPBACKGROUND
TITLE "CDF-Quest"


'TODO
'Change all references of multiple repeating sets of the same thing for grass and ice to just 1 thing,
'and make the part where it asks for what tilesheet just have it as a variable and have it set when files are loaded or something

'$include: 'Assets\Sources\VariableDeclaration.bi'
'$include: 'Assets\Sources\DefaultValues.bi'

INITIALIZE

GOTO game
ERROR 102
ERRORHANDLER: ERRORHANDLER
game:

DO
    SETBG
    SETMAP
    MOVE
    COLDET
    SPSET
    INTER
    ZOOM
    HUD
    DEV
    keypr = KEYHIT
    IF frlock = 0 THEN LIMIT settings.framerate
    tick = tick + settings.tickrate
    IF displayskip = 0 THEN DISPLAY
    displayskip = 0
    CLS
LOOP


ERROR 102


SUB ERRORHANDLER
    AUTODISPLAY
    CLS
    KEYCLEAR
    LOCATE 1, 1
    CENTERPRINT "CDF ERROR HANDLER"
    PRINT "Error Code:"; ERR
    LOCATE 2, 1
    ENDPRINT "Error Line:" + STR$(ERRORLINE)
    PRINT "--------------------------------------------------------------------------------"
    PRINT
    '       PRINT "--------------------------------------------------------------------------------"
    SELECT CASE ERR
        CASE 100
            PRINT "Assets folder is incomplete, this error can be triggered by one or more of the"
            PRINT "following conditions:"
            PRINT
            PRINT
            PRINT "     The assets folder is missing"
            PRINT
            PRINT "     Sub-directories in the Assets folder are missing"
            PRINT
            PRINT "     The contents of assets, or the directory itself is corrupted"
            PRINT
            PRINT "     You do not have proper permissions to access the assets directory"
            PRINT
            PRINT
            PRINT "Make sure the entireity of the assets folder is present and accessible to your"
            PRINT "user account and, if necessary, redownload the assets folder."
            PRINT
            PRINT "The assets folder, and its contents are necessary for the game to load, as it"
            PRINT "contains all sprite and texture files, sounds and music, user saved data, and"
            PRINT "world files. Without these, the game will not play correctly. It is advised to"
            PRINT "not continue."
            CONTPROMPT

        CASE 101
            PRINT "This is a legacy error code, and should never be triggered in game, if it has"
            PRINT "been triggered, not due to the /error command, please contact the developer"
            CONTPROMPT

        CASE 102
            PRINT "Invalid Code Position, This error occurs when the program flow enters an area"
            PRINT "that it should not be, This is most likely a programming issue, and not an end"
            PRINT "user issue."
            PRINT ""
            PRINT "There is no user solution to this issue, please file a bug report to the"
            PRINT "developers, including the line number and what you were doing when it occured."
            CONTPROMPT

        CASE 103
            PRINT "This world was not made for this version of "; gamename; ". This means one of"
            PRINT "the following cases is true:"
            PRINT
            PRINT
            PRINT "     You are attempting to load an out of date world"
            PRINT
            PRINT "     You are attempting to load a world designed for a newer version of"
            PRINT "     "; gamename
            PRINT
            PRINT "     Your world manifest is corrupted"
            PRINT
            PRINT
            PRINT "Double check the world version and game version."
            PRINT "World: ("; mapversion; ") Game: ("; ver; ")"
            PRINT
            PRINT "If you are certain that this is a mistake, you may try to update the manifest"
            PRINT "here. Note that this does not update old worlds, just broken manifest files"
            PRINT "Otherwise you can try to load a different world. "; gamename; ""
            PRINT "does not support loading out of version worlds."
            PRINT
            PRINT
            CENTERPRINT "(U)pdate manifest, (R)eturn to existing map, (Q)uit to desktop."
            DO
                IF KEYDOWN(113) THEN SYSTEM
                IF KEYDOWN(114) THEN RESUME NEXT
                IF KEYDOWN(117) THEN
                    OPEN "Assets\Worlds\" + prevfolder + "\Manifest.cdf" AS #1
                    PUT #1, 3, ver
                    CLOSE #1

                    RESUME NEXT

                END IF
            LOOP


        CASE ELSE
            PRINT "Unrecognized error, contact developers"
            CONTPROMPT

    END SELECT
    KEYCLEAR
    CLS
    RESUME NEXT
END SUB

SUB CONTPROMPT
    PRINT
    PRINT

    CENTERPRINT "(I)gnore this error and continue anyway, (Q)uit to desktop"
    DO
        IF KEYDOWN(113) THEN SYSTEM
        IF KEYdown(105) THEN RESUME NEXT
    LOOP
END SUB



SUB SETTHEME
    SELECT CASE map.theme
        CASE 0
            theme = file.grass
        CASE 1
            theme = file.snow
    END SELECT
END SUB



SUB SAVESETTINGS

    OPEN "Assets\SaveData\Settings.cdf" AS #1
    PUT #1, 1, settings.framerate
    PUT #1, 2, settings.tickrate
    CLOSE #1

END SUB




SUB LOADSETTINGS

    OPEN "Assets\SaveData\Settings.cdf" AS #1
    GET #1, 1, settings.framerate
    GET #1, 2, settings.tickrate
    CLOSE #1

END SUB



SUB LOADWORLD (file AS STRING)
    DIM defaultmap AS STRING
    prevfolder = map.foldername
    map.foldername = file
    OPEN "Assets\Worlds\" + file + "\Manifest.cdf" AS #1
    GET #1, 3, mapversion
    IF mapversion <> ver THEN
        map.foldername = prevfolder
        prevfolder = file
        CLOSE #1
        ERROR 103
    END IF

    GET #1, 1, map.worldname
    GET #1, 2, defaultmap
    'GET #1, 4, map.protected
    CLOSE #1
    map.filename = defaultmap
    LOADMAP (defaultmap)
END SUB

SUB LOADMAP (file AS STRING)
    DIM i, ii AS BYTE
    DIM iii AS INTEGER
    iii = 1
    'TODO added error checking to see if map file exists
    OPEN "Assets\Worlds\" + map.foldername + "\Maps\" + file + ".cdf" AS #1
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            GET #1, iii, tile(ii, i)
            iii = iii + 1
        NEXT
    NEXT
    GET #1, iii, map.name
    iii = iii + 1
    GET #1, iii, map.theme
    SETTHEME
    CLOSE #1

END SUB

SUB SAVEMAP
    DIM i, ii AS BYTE
    DIM iii AS INTEGER
    DIM defaultmap AS STRING
    DIM temppw AS STRING
    DIM new AS BYTE
    iii = 1
    CLS
    AUTODISPLAY
    INPUT "World Name: ", map.worldname
    INPUT "World Folder: ", map.foldername
    INPUT "Map Name: ", map.name
    INPUT "Map Filename: ", map.filename
    INPUT "Default Map Filename: ", defaultmap
    INPUT "Map Theme: ", map.theme
    INPUT "Protected World Password: ", map.protected


    IF DIREXISTS("Assets\Worlds\" + map.foldername) = 0 THEN MKDIR "Assets\Worlds\" + map.foldername: new = 1
    IF DIREXISTS("Assets\Worlds\" + map.foldername + "\Maps") = 0 THEN MKDIR "Assets\Worlds\" + map.foldername + "\Maps": new = 1

    OPEN "Assets\Worlds\" + map.foldername + "\Manifest.cdf" AS #1
    IF new = 0 THEN
        GET #1, 4, temppw
        IF temppw <> map.protected THEN
            CLOSE #1
            PRINT "Incorrect Password, Map not saved"
            DELAY 2
            GOTO badpw
        END IF
    END IF

    PUT #1, 1, map.worldname
    PUT #1, 2, defaultmap
    PUT #1, 3, ver
    PUT #1, 4, map.protected
    CLOSE #1

    OPEN "Assets\Worlds\" + map.foldername + "\Maps\" + map.filename + ".cdf" AS #1
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            PUT #1, iii, tile(ii, i)
            iii = iii + 1
        NEXT
    NEXT
    PUT #1, iii, map.name
    iii = iii + 1
    PUT #1, iii, map.theme
    CLOSE #1
    badpw:
END SUB

SUB UPDATEMAP
    DIM i, ii AS BYTE
    DIM iii AS INTEGER
    iii = 1

    IF DIREXISTS("Assets\Worlds\" + map.foldername) = 0 GOTO badpw
    IF DIREXISTS("Assets\Worlds\" + map.foldername + "\Maps") = 0 GOTO badpw


    OPEN "Assets\Worlds\" + map.foldername + "\Maps\" + map.filename + ".cdf" AS #1
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            PUT #1, iii, tile(ii, i)
            iii = iii + 1
        NEXT
    NEXT
    PUT #1, iii, map.name
    iii = iii + 1
    PUT #1, iii, map.theme
    CLOSE #1
    badpw:

END SUB

SUB HUD
    IF huddisp = 0 THEN
        DIM tmpheal AS BYTE
        DIM token AS BYTE
        DIM hboffset AS BYTE
        DIM hbpos AS BYTE
        DIM hbitemsize AS SINGLE

        hboffset = 1
        token = 1
        hbitemsize = 2

        tmpheal = player.health

        WHILE tmpheal > 0
            SELECT CASE tmpheal
                CASE 1
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (64, 32)-(95, 63)
                CASE 2
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (32, 32)-(63, 63)
                CASE 3
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (0, 32)-(31, 63)
                CASE 4
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (128, 0)-(159, 31)
                CASE 5
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (96, 0)-(127, 31)
                CASE 6
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (64, 0)-(95, 31)
                CASE 7
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (32, 0)-(63, 31)
                CASE 8 TO 255
                    PUTIMAGE (window.x + 88 - 16, window.y - 52 + (token - 1) * 16)-(window.x + 88, window.y - 52 + 16 + (token - 1) * 16), file.hudtex, , (0, 0)-(31, 31)

            END SELECT
            tmpheal = tmpheal - 8
            token = token + 1
        WEND

        'Hotbar
        FOR hbpos = 0 TO 5
            PUTIMAGE (window.x - 72 + hboffset + (17 * hbpos), window.y + 68 - 16 - hboffset)-(window.x - 72 + 16 + hboffset + (17 * hbpos), window.y + 68 - hboffset), file.hudtex, , (0, 64)-(31, 95)
        NEXT

        SELECT CASE gamemode
            CASE 1
                FOR hbpos = 0 TO 5
                    PUTIMAGE (window.x - 72 + hboffset + (17 * hbpos) + hbitemsize, window.y + 68 - 16 - hboffset + hbitemsize)-(window.x - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, window.y + 68 - hboffset - hbitemsize), theme, , (inventory(1, hbpos + 1) * 16, hbpos * 16)-(inventory(1, hbpos + 1) * 16 + 15, hbpos * 16 + 15)
                NEXT



                IF KEYDOWN(49) THEN tile(INT((player.x + 8) \ 16), INT((player.y + 8) \ 16)) = inventory(1, 1)

                IF KEYDOWN(50) THEN tile(INT((player.x + 8) \ 16), INT((player.y + 8) \ 16)) = inventory(1, 2) + 16

                IF KEYDOWN(51) THEN tile(INT((player.x + 8) \ 16), INT((player.y + 8) \ 16)) = inventory(1, 3) + 32

                IF KEYDOWN(52) THEN tile(INT((player.x + 8) \ 16), INT((player.y + 8) \ 16)) = inventory(1, 4) + 48

                IF KEYDOWN(53) THEN tile(INT((player.x + 8) \ 16), INT((player.y + 8) \ 16)) = inventory(1, 5) + 64

                IF KEYDOWN(54) THEN tile(INT((player.x + 8) \ 16), INT((player.y + 8) \ 16)) = inventory(1, 6) + 80

                SELECT CASE keypr
                    CASE 33
                        inventory(1, 1) = inventory(1, 1) + 1
                        IF inventory(1, 1) > 4 THEN inventory(1, 1) = 0
                    CASE 64
                        inventory(1, 2) = inventory(1, 2) + 1
                        IF inventory(1, 2) > 4 THEN inventory(1, 2) = 0
                    CASE 35
                        inventory(1, 3) = inventory(1, 3) + 1
                        IF inventory(1, 3) > 3 THEN inventory(1, 3) = 0
                    CASE 36
                        inventory(1, 4) = inventory(1, 4) + 1
                        IF inventory(1, 4) > 9 THEN inventory(1, 4) = 0
                    CASE 37
                        inventory(1, 5) = inventory(1, 5) + 1
                        IF inventory(1, 5) > 4 THEN inventory(1, 5) = 0
                    CASE 94
                        inventory(1, 6) = inventory(1, 6) + 1
                        IF inventory(1, 6) > 1 THEN inventory(1, 6) = 0

                END SELECT

        END SELECT

    END IF

END SUB




SUB DEV
    IF debug = 1 THEN
        PRINTMODE FILLBACKGROUND
        DIM comin AS STRING
        DIM dv AS SINGLE
        DIM dummystring AS STRING



        LOCATE 1, 1
        ENDPRINT "Debug Menu (Press F3 to Close)"
        PRINT
        ENDPRINT "Version: " + ver
        ENDPRINT "Operating System: " + hostos
        ENDPRINT "Architecture:" + STR$(64 / (bit32 + 1)) + "-Bit"
        PRINT
        ENDPRINT "Flags:"
        IF stillcam = 1 THEN ENDPRINT "Still Camera Enabled"
        IF freecam = 1 THEN ENDPRINT "Free Camera Enabled"
        IF fullcam = 1 THEN ENDPRINT "Full Camera Enabled"
        IF noclip = 1 THEN ENDPRINT "No Clip Enabled"
        IF bgdraw = 1 THEN ENDPRINT "Background Drawing Disabled"


        LOCATE 1, 1
        PRINT gamename; " ("; buildinfo; ")"
        PRINT
        PRINT "FPS:" + STR$(FRAMEPS) + " /" + STR$(tick)
        PRINT "Window:"; window.x; ","; window.y
        PRINT "Current Map: "; map.name; " ("; map.filename; "|"; map.foldername; ")"
        PRINT "World Name: "; map.worldname
        PRINT "Gamemode: ";
        SELECT CASE gamemode
            CASE 0
                PRINT "Debug Mode"
            CASE 1
                PRINT "Map Editor"
            CASE 2
                PRINT "Explorer"
            CASE 3
                PRINT "Combat"
            CASE 4
                PRINT "Hub"
        END SELECT

        PRINT
        PRINT "Data Viewer: ";
        SELECT CASE tracked
            CASE ""
                PRINT "None Selected"
                PRINT "Start tracking an entity to view its data"
            CASE "player", "1"
                PRINT "Player"
                PRINT "POS:"; player.x; ","; player.y; "("; INT((player.x + 8) / 16); ","; INT((player.y + 8) / 16); ")"
                PRINT "Facing:"; player.facing
                PRINT "Motion:"; player.moving
                PRINT "Contacted Tile ID:"; player.tile; "(" + HEX$(player.tile) + ")"
                PRINT "Facing Tile ID:"; player.tilefacing; "(" + HEX$(player.tilefacing) + ")"
            CASE ELSE
                PRINT "Unrecognized Tile or Entity"
        END SELECT

        IF KEYDOWN(47) THEN
            KEYCLEAR

            LOCATE 28, 1: INPUT "/", comin
            SELECT CASE comin
                CASE "teleport", "tp"
                    LOCATE 28, 1: PRINT "               "
                    LOCATE 28, 1: INPUT "Teleport x: ", player.x
                    LOCATE 28, 1: PRINT "               "
                    LOCATE 28, 1: INPUT "Teleport y: ", player.y
                CASE "tileport", "tip"
                    LOCATE 28, 1: PRINT "               "
                    LOCATE 28, 1: INPUT "Teleport x: ", dv
                    player.x = dv * 16
                    LOCATE 28, 1: PRINT "               "
                    LOCATE 28, 1: INPUT "Teleport y: ", dv
                    player.y = dv * 16

                CASE "stillcam", "sc"
                    stillcam = stillcam + 1
                CASE "fullcam", "fc"
                    fullcam = fullcam + 1
                CASE "freecam", "frc"
                    freecam = freecam + 1
                CASE "noclip", "nc"
                    noclip = noclip + 1
                CASE "exit"
                    SYSTEM
                CASE "error"
                    LOCATE 28, 1: PRINT "                              "
                    LOCATE 28, 1: INPUT "Simulate error number: ", dv
                    ERROR dv
                CASE "gamemode", "gm"
                    LOCATE 28, 1: PRINT "                         "
                    LOCATE 28, 1: INPUT "Change Gamemode to: ", gamemode
                CASE "health"
                    LOCATE 28, 1: PRINT "                      "
                    LOCATE 28, 1: INPUT "Set Health to: ", player.health
                CASE "track", "tr"
                    LOCATE 28, 1: PRINT "                               "
                    LOCATE 28, 1: INPUT "Track Entity ID or Tile ID: ", tracked
                CASE "framerate-unlock", "fru"
                    frlock = frlock + 1
                CASE "save"
                    SAVEMAP
                CASE "load"
                    LOCATE 28, 1: PRINT "                                "
                    LOCATE 28, 1: INPUT "Name of Map File to load: ", map.filename
                    LOADMAP (map.filename)
                CASE "loadworld"
                    LOCATE 28, 1: PRINT "                                "
                    LOCATE 28, 1: INPUT "Name of World Folder to load: ", dummystring
                    LOADWORLD (dummystring)

                CASE "theme"
                    LOCATE 28, 1: PRINT "                "
                    LOCATE 28, 1: INPUT "Set Theme ID: ", map.theme
                    SETTHEME
                CASE "set-tile", "st"
                    LOCATE 28, 1: PRINT "                "
                    LOCATE 28, 1: INPUT "Set Tile ID: ", tile(INT((player.x + 8) / 16), INT((player.y + 8) / 16))
                CASE "bgdraw"
                    bgdraw = bgdraw + 1
                CASE "update", "up"
                    UPDATEMAP


                CASE ELSE
            END SELECT
            displayskip = 1

        END IF
        PRINTMODE KEEPBACKGROUND
    END IF
END SUB


SUB SETMAP
    DIM i AS BYTE
    DIM ii AS BYTE
    DIM tileposx AS INTEGER
    DIM tileposy AS INTEGER
    FOR i = 0 TO 30

        FOR ii = 0 TO 40

            tileposx = tile(ii, i) * 16
            tileposy = 0
            WHILE tileposx >= 256
                tileposx = tileposx - 256
                tileposy = tileposy + 16
            WEND
            PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), theme, , (tileposx, tileposy)-(tileposx + 15, tileposy + 15)
        NEXT
    NEXT
END SUB


SUB INTER
    SELECT CASE keypr
        CASE -15616
            debug = debug + 1
        CASE -15104
            huddisp = huddisp + 1
    END SELECT
END SUB





'$include: 'Assets\Sources\Initialization.bm'
'$include: 'Assets\Sources\TextControl.bm'
'$include: 'Assets\Sources\ErrorHandler.bm'
'$include: 'Assets\Sources\FrameRate.bm'
'$include: 'Assets\Sources\OsProbe.bm'
'$include: 'Assets\Sources\CollisionDetection.bm'
'$include: 'Assets\Sources\SpriteAnimation.bm'
'$include: 'Assets\Sources\PlayerControl.bm'
'$include: 'Assets\Sources\MapDraw.bm'
'$include: 'Assets\Sources\ScreenZoom.bm'



