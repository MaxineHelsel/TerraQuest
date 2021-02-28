$NOPREFIX
OPTION EXPLICIT
ON ERROR GOTO ERRORHANDLER
ERRORHANDLER: ERRORHANDLER
RANDOMIZE TIMER
SCREEN NEWIMAGE(640, 480, 32)
PRINTMODE KEEPBACKGROUND
TITLE "CDF-Quest"

'40,30

'declare variable names and data types
DIM SHARED file AS file

DIM SHARED player AS character

DIM SHARED tick AS UNSIGNED INTEGER64

DIM SHARED tile(40, 30) AS BYTE

DIM SHARED window.x AS SINGLE
DIM SHARED window.y AS SINGLE

DIM SHARED debug AS UNSIGNED BIT

DIM SHARED gamename AS STRING
DIM SHARED ver AS STRING

DIM SHARED displayskip AS UNSIGNED BIT

DIM SHARED stillcam AS UNSIGNED BIT
DIM SHARED fullcam AS UNSIGNED BIT
DIM SHARED freecam AS UNSIGNED BIT
DIM SHARED noclip AS UNSIGNED BIT

DIM SHARED map.name AS STRING
DIM SHARED map.theme AS BYTE
DIM SHARED map.foldername AS STRING

DIM SHARED load AS BYTE

DIM SHARED new AS UNSIGNED BIT

DIM SHARED hostos AS STRING
DIM SHARED bit32 AS UNSIGNED BIT





IF DIREXISTS("Assets") THEN
    IF DIREXISTS("Assets\Tiles") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Graphics") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Music") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\Sounds") = 0 THEN ERROR 100
    IF DIREXISTS("Assets\SaveData") = 0 THEN MKDIR "Assets\SaveData": new = 1
ELSE ERROR 100
END IF

IF DIREXISTS("Maps") = 0 THEN ERROR 101



'set default variables/load variables
gamename = "CDF-Quest Game Engine Test"
ver = "Alpha 0.03"
OSPROBE

'include character data and other values in seperate files
file.char_file = "Assets\Tiles\character.png"
file.grass_file = "Assets\Tiles\grass.png"
file.snow_file = "Assets\Tiles\snow.png"
file.interior_file = "Assets\Tiles\interior.png"

'load assets
file.char = LOADIMAGE(file.char_file)
file.grass = LOADIMAGE(file.grass_file)
file.snow = LOADIMAGE(file.snow_file)
file.interior = LOADIMAGE(file.interior_file)

'load mapdata from file


DIM opt AS STRING
PRINT "placeholder title screen"
INPUT "(P)lay game, (C)reate map"; opt
IF opt = "p" THEN
    map.theme = 0
    tile(10, 10) = 2
    tile(11, 10) = 2

    tile(14, 10) = 2
    tile(17, 10) = 1
    tile(17, 12) = 2
    tile(19, 10) = 2
    tile(19, 12) = 2

    tile(33, 22) = 2
    tile(8, 9) = 3

    GOTO game
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

DO
    SETBG
    SETMAP
    MOVE
    COLDET
    SPSET
    INTER
    ZOOM
    IF debug = 1 THEN DEV
    LIMIT 60
    tick = tick + 1
    IF displayskip = 0 THEN DISPLAY
    displayskip = 0
    CLS
LOOP



SUB DEV
    PRINTMODE FILLBACKGROUND
    DIM comin AS STRING
    DIM dv AS SINGLE


    PRINT gamename
    LOCATE 1, 80 - LEN(ver) - 8
    PRINT "Version: " + ver

    PRINT "Framerate: "; FRAMEPS
    LOCATE 2, 80 - LEN(hostos) - 17
    PRINT "Operating System: " + hostos

    PRINT "Frame: "; tick
    LOCATE 3, 80 - 13 - 6
    PRINT "Architecture:";
    PRINT STR$(64 / (bit32 + 1)) + "-Bit"

    PRINT "Player.x: "; player.x; "/"; INT(player.x / 16)
    PRINT "Player.y: "; player.y; "/"; INT(player.y / 16)
    PRINT "Player.facing: "; player.facing
    PRINT "Player is moving?: "; player.moving
    PRINT "Current Tile ID: "; player.tile
    PRINT window.x; window.y
    PRINT freecam
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





SUB SETBG
    DIM i AS BYTE
    DIM ii AS BYTE
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            IF map.theme = 0 THEN
                PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (16, 16)-(31, 31)
            ELSEIF map.theme = 1 THEN
                PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.snow, , (16, 16)-(31, 31)
            END IF
        NEXT
    NEXT
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



SUB MOVE
    player.moving = 0
    player.lastx = player.x
    player.lasty = player.y
    IF KEYDOWN(119) THEN
        player.y = player.y - .5
        player.facing = 0
        player.moving = 1
        IF KEYDOWN(100306) = 0 THEN player.y = player.y - .5
    END IF
    IF KEYDOWN(115) THEN
        player.y = player.y + .5
        player.facing = 1
        player.moving = 1
        IF KEYDOWN(100306) = 0 THEN player.y = player.y + .5
    END IF
    IF KEYDOWN(97) THEN
        player.x = player.x - .5
        player.facing = 2
        player.moving = 1
        IF KEYDOWN(100306) = 0 THEN player.x = player.x - .5
    END IF
    IF KEYDOWN(100) THEN
        player.x = player.x + .5
        player.facing = 3
        player.moving = 1
        IF KEYDOWN(100306) = 0 THEN player.x = player.x + .5
    END IF
    IF player.x <= 0 THEN player.x = 0
    IF player.y <= 0 THEN player.y = 0
    IF player.x >= 640 - 16 THEN player.x = 640 - 16
    IF player.y >= 480 - 16 THEN player.y = 480 - 16
    IF freecam = 1 THEN
        player.x = player.lastx
        player.y = player.lasty
        IF player.moving = 1 THEN
            SELECT CASE player.facing
                CASE 0
                    window.y = window.y - 1
                CASE 1
                    window.y = window.y + 1
                CASE 2
                    window.x = window.x - 1
                CASE 3
                    window.x = window.x + 1
            END SELECT
        END IF
    END IF
END SUB





SUB SPSET
    STATIC anim AS BYTE
    SELECT CASE player.facing
        CASE 0
            IF player.moving = 1 THEN
                IF anim < 15 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (0, 0)-(15, 17)
                IF anim > 14 AND anim < 30 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 0)-(31, 17)
                IF anim > 29 AND anim < 45 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (32, 0)-(47, 17)
                IF anim > 44 AND anim < 60 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 0)-(31, 17)
            ELSE
                PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 0)-(31, 17)
            END IF
        CASE 1
            IF player.moving = 1 THEN
                IF anim < 15 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (0, 36)-(15, 54)
                IF anim > 14 AND anim < 30 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 36)-(31, 53)
                IF anim > 29 AND anim < 45 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (32, 36)-(47, 53)
                IF anim > 44 AND anim < 60 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 36)-(31, 53)
            ELSE
                PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 36)-(31, 53)
            END IF

        CASE 2
            IF player.moving = 1 THEN
                IF anim < 15 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (0, 54)-(15, 71)
                IF anim > 14 AND anim < 30 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 54)-(31, 71)
                IF anim > 29 AND anim < 45 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (32, 54)-(47, 71)
                IF anim > 44 AND anim < 60 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 54)-(31, 71)
            ELSE
                PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 54)-(31, 71)
            END IF

        CASE 3
            IF player.moving = 1 THEN
                IF anim < 15 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (0, 18)-(15, 35)
                IF anim > 14 AND anim < 30 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 18)-(31, 35)
                IF anim > 29 AND anim < 45 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (32, 18)-(47, 35)
                IF anim > 44 AND anim < 60 THEN PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 18)-(31, 35)
            ELSE
                PUTIMAGE (INT(player.x), INT(player.y) - 2)-((INT(player.x)) + 16, (INT(player.y) - 2) + 16), file.char, , (16, 18)-(31, 35)
            END IF
    END SELECT

    anim = anim + 1
    IF KEYDOWN(100306) = 0 THEN anim = anim + 1
    IF anim > 59 THEN anim = 0
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

'$include: 'Assets\Sources\ErrorHandler.bm'
'$include: 'Assets\Sources\TextControl.bm'
'$include: 'Assets\Sources\FrameRate.bm'
'$include: 'Assets\Sources\OsProbe.bm'
'$include: 'Assets\Sources\CollisionDetection.bm'

TYPE file
    char_file AS STRING
    grass_file AS STRING
    snow_file AS STRING
    interior_file AS STRING
    char AS LONG
    grass AS LONG
    snow AS LONG
    interior AS LONG
END TYPE



TYPE character
    x AS SINGLE
    y AS SINGLE
    lastx AS SINGLE
    lasty AS SINGLE
    tile AS BYTE

    facing AS BYTE
    moving AS BYTE
    type AS BYTE

    level AS BYTE

END TYPE



TYPE settings
    mode AS BYTE
END TYPE



