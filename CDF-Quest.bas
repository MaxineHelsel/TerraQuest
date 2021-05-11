$NOPREFIX
OPTION EXPLICIT
'ON ERROR GOTO ERRORHANDLER
RANDOMIZE TIMER
SCREEN NEWIMAGE(640, 480, 32) '40x30
PRINTMODE KEEPBACKGROUND
TITLE "CDF-Quest"


'declare variable names and data types
DIM SHARED file AS file
DIM SHARED player AS character
'DIM SHARED map AS map

DIM SHARED map.name AS STRING
DIM SHARED map.theme AS BYTE
DIM SHARED map.foldername AS STRING
DIM SHARED map.filename AS STRING
DIM SHARED map.worldname AS STRING


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

DIM SHARED load AS BYTE

DIM SHARED new AS UNSIGNED BIT

DIM SHARED hostos AS STRING
DIM SHARED bit32 AS UNSIGNED BIT

DIM SHARED gamemode AS BYTE

DIM SHARED tracked AS BYTE
DIM SHARED frlock AS UNSIGNED BIT






IF DIREXISTS("Assets") THEN
    IF DIREXISTS("Assets\Tiles") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Graphics") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Music") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Sounds") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\SaveData") = 0 THEN MKDIR "Assets\SaveData": new = 1
ELSE ERROR 100
END IF

IF DIREXISTS("Worlds") = 0 THEN ERROR 101



'set default variables/load variables
gamename = "CDF-Quest"
buildinfo = "Core Mechanic Test"
ver = "Alpha 0.06"
OSPROBE

'include character data and other values in seperate files
file.char_file = "Assets\Tiles\character.png"
file.grass_file = "Assets\Tiles\grass.png"
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
DIM opt AS STRING
PRINT "placeholder title screen"
INPUT "(P)lay game, (C)reate map"; opt
IF opt = "p" THEN
    INPUT "World Folder: ", map.foldername
    LOADWORLD (map.foldername)
    GOTO game
END IF
IF opt = "c" THEN
    gamemode = 1
END IF


INPUT "(c)reate new map, (l)oad existing map"; opt
IF opt = "c" THEN
    INPUT "Map Name"; map.name
    INPUT "Map Folder Name"; map.foldername
    INPUT "Map Theme"; map.theme
ELSEIF opt = "l" THEN
    INPUT "Map Folder Name"; map.foldername
    load = 1
END IF


IF load = 1 THEN

END IF






game:
'debug default values
player.health = 8

DO
    SETBG
    SETMAP
    MOVE
    COLDET
    SPSET
    INTER
    IF gamemode = 1 THEN TILESET
    ZOOM
    HUD
    IF debug = 1 THEN DEV
    IF frlock = 0 THEN LIMIT 60
    tick = tick + 1
    IF displayskip = 0 THEN DISPLAY
    displayskip = 0
    CLS
LOOP

ERRORHANDLER: ERRORHANDLER

INPUT "World Folder: ", map.foldername

SUB LOADWORLD (file AS STRING)
    DIM defaultmap AS STRING
    DIM mapversion AS STRING
    map.foldername = file
    OPEN "Worlds\" + file + "\Manifest" AS #1
    GET #1, 1, map.worldname
    GET #1, 2, defaultmap
    GET #1, 3, mapversion
    CLOSE #1
    map.filename = defaultmap
    LOADMAP (defaultmap)
END SUB

SUB LOADMAP (file AS STRING)
    DIM i, ii AS BYTE
    DIM iii AS INTEGER
    iii = 1
    OPEN "Worlds\" + map.foldername + "\Maps\" + file AS #1
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
    iii = 1
    CLS
    AUTODISPLAY
    INPUT "World Folder: ", map.foldername
    INPUT "World Name: ", map.worldname
    INPUT "Map Name: ", map.name
    INPUT "Map Filename: ", map.filename
    INPUT "Default Map Filename: ", defaultmap
    INPUT "Map Theme: ", map.theme


    IF DIREXISTS("Worlds\" + map.foldername) = 0 THEN MKDIR "Worlds\" + map.foldername
    IF DIREXISTS("Worlds\" + map.foldername + "\Maps") = 0 THEN MKDIR "Worlds\" + map.foldername + "\Maps"

    OPEN "Worlds\" + map.foldername + "\Manifest" AS #1
    PUT #1, 1, map.worldname
    PUT #1, 2, defaultmap
    PUT #1, 3, ver
    CLOSE #1

    OPEN "Worlds\" + map.foldername + "\Maps\" + map.filename AS #1
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
END SUB

SUB HUD

    DIM tmpheal AS BYTE
    DIM token AS BYTE
    token = 1

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
END SUB

SUB TILESET
    IF KEYDOWN(105) THEN

        SELECT CASE KEYHIT
            CASE 49

                tile(INT((player.x + 8) / 16), INT((player.y + 8) / 16)) = 0
            CASE 50
                tile(INT((player.x + 8) / 16), INT((player.y + 8) / 16)) = 1
            CASE 51
                tile(INT((player.x + 8) / 16), INT((player.y + 8) / 16)) = 2


        END SELECT
    END IF
END SUB



SUB DEV
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
        CASE 0
            PRINT "None Selected"
            PRINT "Click on Tile or Entity to view its data"
        CASE 1
            PRINT "Player"
            PRINT "POS:"; player.x; ","; player.y; "("; INT(player.x / 16); ","; INT(player.y / 16); ")"
            PRINT "Facing:"; player.facing
            PRINT "Motion:"; player.moving
            PRINT "Contacted Tile ID:"; player.tile
            PRINT "Facing Tile ID:"; player.tilefacing
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
                fullcam = 0
                freecam = 0
            CASE "fullcam", "fc"
                fullcam = fullcam + 1
                stillcam = 0
                freecam = 0
            CASE "freecam", "frc"
                freecam = freecam + 1
                fullcam = 0
                stillcam = 0
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
                LOCATE 28, 1: PRINT "               "
                LOCATE 28, 1: INPUT "Set Theme ID", map.theme


            CASE ELSE
        END SELECT
        displayskip = 1

    END IF
    PRINTMODE KEEPBACKGROUND
END SUB

SUB INTER
    SELECT CASE KEYHIT
        CASE -15616
            debug = debug + 1

    END SELECT

END SUB




'tile list
'0=grass
'1=cut grass
'2=bush
'3=barrel



SUB SETMAP
    DIM i AS BYTE
    DIM ii AS BYTE
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            IF map.theme = 0 THEN
                IF tile(ii, i) = 1 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (0, 16)-(15, 31)
                IF tile(ii, i) = 2 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (128, 16)-(143, 31)
                IF tile(ii, i) = 3 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (32, 16)-(47, 31)
            ELSEIF map.theme = 1 THEN
                IF tile(ii, i) = 1 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.snow, , (0, 16)-(15, 31)
                IF tile(ii, i) = 2 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.snow, , (128, 16)-(143, 31)
                IF tile(ii, i) = 3 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.snow, , (32, 16)-(47, 31)
            END IF
        NEXT
    NEXT
END SUB




SUB ZOOM
    IF stillcam = 0 AND freecam = 0 THEN
        window.x = player.x
        window.y = player.y
    END IF
    IF window.x - 72 < 0 THEN window.x = 72
    IF window.y - 52 < 0 THEN window.y = 52
    IF window.x + 88 > 640 THEN window.x = 552
    IF window.y + 68 > 480 THEN window.y = 412

    IF fullcam = 0 THEN WINDOW SCREEN(window.x - 72, window.y - 52)-(window.x + 88, window.y + 68) ELSE WINDOW
END SUB


'$include: 'Assets\Sources\TextControl.bm'
'$include: 'Assets\Sources\ErrorHandler.bm'
'$include: 'Assets\Sources\FrameRate.bm'
'$include: 'Assets\Sources\OsProbe.bm'
'$include: 'Assets\Sources\CollisionDetection.bm'
'$include: 'Assets\Sources\SpriteAnimation.bm'
'$include: 'Assets\Sources\PlayerControl.bm'
'$include: 'Assets\Sources\MapDraw.bm'

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



