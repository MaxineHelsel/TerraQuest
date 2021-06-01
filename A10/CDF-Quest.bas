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

'declare variable names and data types
DIM SHARED file AS file
DIM SHARED player AS character
'DIM SHARED map AS map

DIM SHARED map.name AS STRING
DIM SHARED map.theme AS BYTE
DIM SHARED map.foldername AS STRING
DIM SHARED map.filename AS STRING
DIM SHARED map.worldname AS STRING
DIM SHARED map.protected AS STRING


DIM SHARED tile(40, 30) AS BYTE

DIM SHARED tick AS UNSIGNED INTEGER64

DIM SHARED window.x AS SINGLE
DIM SHARED window.y AS SINGLE

DIM SHARED debug AS UNSIGNED BIT

DIM SHARED gamename AS STRING
DIM SHARED buildinfo AS STRING
DIM SHARED ver AS STRING

DIM SHARED displayskip AS UNSIGNED BIT

DIM SHARED stillcam AS UNSIGNED BIT
DIM SHARED fullcam AS UNSIGNED BIT
DIM SHARED freecam AS UNSIGNED BIT
DIM SHARED noclip AS UNSIGNED BIT

DIM SHARED new AS UNSIGNED BIT

DIM SHARED hostos AS STRING
DIM SHARED bit32 AS UNSIGNED BIT

DIM SHARED gamemode AS BYTE

DIM SHARED tracked AS STRING
DIM SHARED frlock AS UNSIGNED BIT

DIM SHARED inventory(4, 6) AS INTEGER

DIM SHARED huddisp AS UNSIGNED BIT
DIM SHARED bgdraw AS UNSIGNED BIT

DIM SHARED keypr AS LONG



TYPE file
    char_file AS STRING
    grass_file AS STRING
    snow_file AS STRING
    interior_file AS STRING
    hudtex_file AS STRING
    char AS LONG
    grass AS LONG
    snow AS LONG
    interior AS LONG
    hudtex AS LONG
END TYPE



TYPE character
    x AS SINGLE
    y AS SINGLE
    lastx AS SINGLE
    lasty AS SINGLE

    tile AS BYTE
    tilefacing AS BYTE
    facing AS BYTE
    moving AS BYTE
    type AS BYTE

    level AS BYTE
    health AS BYTE
    points AS BYTE

END TYPE



'TYPE map
'    name AS STRING
'    theme AS BYTE
'    foldername AS STRING
'    filename AS STRING
'    worldname AS STRING
'END TYPE




IF DIREXISTS("Assets") THEN
    IF DIREXISTS("Assets\Tiles") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Music") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Sounds") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\SaveData") = 0 THEN MKDIR "Assets\SaveData": new = 1
ELSE ERROR 100
END IF

IF DIREXISTS("Worlds") = 0 THEN ERROR 101



'set default variables/load variables
'$include:'Assets\Sources\DefaultValues.ini'
gamename = "CDF-Quest"
buildinfo = "Core Mechanic Test"
ver = "Alpha Version 10"
OSPROBE

'include character data and other values in seperate files
file.char_file = "Assets\Tiles\character.png"
file.grass_file = "Assets\Tiles\grass2.png"
file.snow_file = "Assets\Tiles\snow.png"
file.interior_file = "Assets\Tiles\interior.png"
file.hudtex_file = "Assets\Tiles\HUD.png"

'load assets
file.char = LOADIMAGE(file.char_file)
file.grass = LOADIMAGE(file.grass_file)
file.snow = LOADIMAGE(file.snow_file)
file.interior = LOADIMAGE(file.interior_file)
file.hudtex = LOADIMAGE(file.hudtex_file)
'load mapdata from file

'Title Screen
LOADWORLD ("Hub")
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
    IF frlock = 0 THEN LIMIT 60
    tick = tick + 1
    IF displayskip = 0 THEN DISPLAY
    displayskip = 0
    CLS
LOOP


ERROR 102


SUB LOADWORLD (file AS STRING)
    DIM defaultmap AS STRING
    DIM mapversion AS STRING
    map.foldername = file
    OPEN "Worlds\" + file + "\Manifest.cdf" AS #1
    GET #1, 1, map.worldname
    GET #1, 2, defaultmap
    GET #1, 3, mapversion
    'GET #1, 4, map.protected
    CLOSE #1
    map.filename = defaultmap
    LOADMAP (defaultmap)
END SUB

SUB LOADMAP (file AS STRING)
    DIM i, ii AS BYTE
    DIM iii AS INTEGER
    iii = 1
    OPEN "Worlds\" + map.foldername + "\Maps\" + file + ".cdf" AS #1
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            GET #1, iii, tile(ii, i)
            iii = iii + 1
        NEXT
    NEXT
    GET #1, iii, map.name
    iii = iii + 1
    GET #1, iii, map.theme
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


    IF DIREXISTS("Worlds\" + map.foldername) = 0 THEN MKDIR "Worlds\" + map.foldername: new = 1
    IF DIREXISTS("Worlds\" + map.foldername + "\Maps") = 0 THEN MKDIR "Worlds\" + map.foldername + "\Maps": new = 1

    OPEN "Worlds\" + map.foldername + "\Manifest.cdf" AS #1
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

    OPEN "Worlds\" + map.foldername + "\Maps\" + map.filename + ".cdf" AS #1
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

    IF DIREXISTS("Worlds\" + map.foldername) = 0 GOTO badpw
    IF DIREXISTS("Worlds\" + map.foldername + "\Maps") = 0 GOTO badpw


    OPEN "Worlds\" + map.foldername + "\Maps\" + map.filename + ".cdf" AS #1
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
                    SELECT CASE map.theme
                        CASE 0
                            PUTIMAGE (window.x - 72 + hboffset + (17 * hbpos) + hbitemsize, window.y + 68 - 16 - hboffset + hbitemsize)-(window.x - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, window.y + 68 - hboffset - hbitemsize), file.grass, , (inventory(1, hbpos + 1) * 16, hbpos * 16)-(inventory(1, hbpos + 1) * 16 + 15, hbpos * 16 + 15)
                        CASE 1
                            PUTIMAGE (window.x - 72 + hboffset + (17 * hbpos) + hbitemsize, window.y + 68 - 16 - hboffset + hbitemsize)-(window.x - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, window.y + 68 - hboffset - hbitemsize), file.snow, , (inventory(1, hbpos + 1) * 16, hbpos * 16)-(inventory(1, hbpos + 1) * 16 + 15, hbpos * 16 + 15)
                    END SELECT
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


SUB INTER
    SELECT CASE keypr
        CASE -15616
            debug = debug + 1
        CASE -15104
            huddisp = huddisp + 1
    END SELECT


END SUB




SUB DEV
    IF debug = 1 THEN
        PRINTMODE FILLBACKGROUND
        DIM comin AS STRING
        DIM dv AS SINGLE



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
                    LOCATE 28, 1: INPUT "Name of World Folder to load: ", map.foldername
                    LOADWORLD (map.foldername)

                CASE "theme"
                    LOCATE 28, 1: PRINT "                "
                    LOCATE 28, 1: INPUT "Set Theme ID: ", map.theme
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
    DIM hexid AS STRING
    FOR i = 0 TO 30

        FOR ii = 0 TO 40
            IF map.theme = 0 THEN
                tileposx = tile(ii, i) * 16
                tileposy = 0
                WHILE tileposx >= 256
                    tileposx = tileposx - 256
                    tileposy = tileposy + 16
                WEND
                PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (tileposx, tileposy)-(tileposx + 15, tileposy + 15)
            ELSEIF map.theme = 1 THEN
                tileposx = tile(ii, i) * 16
                WHILE tileposx >= 256
                    tileposx = tileposx - 256
                    tileposy = tileposy + 16
                WEND
                PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.snow, , (tileposx, tileposy)-(tileposx + 15, tileposy + 15)
            END IF
        NEXT
    NEXT
END SUB






'$include: 'Assets\Sources\TextControl.bm'
'$include: 'Assets\Sources\ErrorHandler.bm'
'$include: 'Assets\Sources\FrameRate.bm'
'$include: 'Assets\Sources\OsProbe.bm'
'$include: 'Assets\Sources\CollisionDetection.bm'
'$include: 'Assets\Sources\SpriteAnimation.bm'
'$include: 'Assets\Sources\PlayerControl.bm'
'$include: 'Assets\Sources\MapDraw.bm'
'$include: 'Assets\Sources\ScreenZoom.bm'



