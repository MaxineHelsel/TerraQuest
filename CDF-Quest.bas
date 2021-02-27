$NOPREFIX
OPTION EXPLICIT
RANDOMIZE TIMER
SCREEN NEWIMAGE(640, 480, 32)
TITLE "CDF-Quest"

'40,30

'declare variable names and data types
DIM SHARED file AS file
DIM SHARED player AS character
DIM SHARED tick AS UNSIGNED INTEGER64
DIM SHARED tile(40, 30) AS BYTE
DIM SHARED theme AS BYTE
DIM SHARED window.x AS SINGLE
DIM SHARED window.y AS SINGLE
DIM debug AS BYTE
DIM SHARED gamename AS STRING
DIM SHARED cdfcc AS INTEGER

'set default variables/load variables
player.x = 10
player.y = 10
debug = 1
gamename = "CDF-Quest Game Engine Test"
cdfcc = 1



'include character data and other values in seperate files
file.char_file = "Assets\Tiles\character.png"
file.grass_file = "Assets\Tiles\grass.png"
file.snow_file = "Assets\Tiles\snow.png"
file.interior_file = "Assets\Tiles\interior.png"

'load mapdata from file
theme = 0
tile(10, 10) = 2
tile(11, 10) = 2

tile(14, 10) = 2
tile(17, 10) = 2
tile(17, 12) = 2
tile(19, 10) = 2
tile(19, 12) = 2

'load assets
file.char = LOADIMAGE(file.char_file)
file.grass = LOADIMAGE(file.grass_file)
file.snow = LOADIMAGE(file.snow_file)
file.interior = LOADIMAGE(file.interior_file)



DO
    SETBG
    SETMAP
    MOVE
    COLDET
    SPSET
    ZOOM
    IF debug = 1 THEN DEV
    LIMIT 60
    tick = tick + 1
    DISPLAY
    CLS
LOOP



SUB DEV
    PRINT gamename
    PRINT "Framerate: "; FRAMEPS
    PRINT "Frame: "; tick
    PRINT "Player.x: "; player.x
    PRINT "Player.y: "; player.y
    PRINT "Player.facing: "; player.facing
    PRINT "Player is moving?: "; player.moving
    PRINT "Current Tile ID: "; player.tile

END SUB



FUNCTION FRAMEPS
    STATIC ps AS BYTE
    STATIC cs AS BYTE
    STATIC frame AS INTEGER
    STATIC frps AS INTEGER
    ps = cs
    cs = VAL(MID$(TIME$, 7, 2))
    IF cs = ps THEN frame = frame + 1 ELSE frps = frame: frame = 0
    FRAMEPS = frps + 1
END FUNCTION



SUB SETBG
    DIM i AS BYTE
    DIM ii AS BYTE
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            IF theme = 0 THEN
                PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (16, 16)-(31, 31)
            ELSEIF theme = 1 THEN
                PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.snow, , (16, 16)-(31, 31)
            END IF
        NEXT
    NEXT
END SUB
'tile list
'0=grass
'1=cut grass
'2=bush



SUB SETMAP
    DIM i AS BYTE
    DIM ii AS BYTE
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            IF theme = 0 THEN
                IF tile(ii, i) = 1 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (0, 16)-(15, 31)
                IF tile(ii, i) = 2 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (128, 16)-(143, 31)
            ELSEIF theme = 1 THEN
                IF tile(ii, i) = 1 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (0, 16)-(15, 31)
                IF tile(ii, i) = 2 THEN PUTIMAGE (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), file.grass, , (128, 16)-(143, 31)
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
END SUB



SUB COLDET
    player.tile = tile(INT((player.x + 8) / 16), INT((player.y + 8) / 16))

    SELECT CASE tile(INT((player.x + 1) / 16), INT((player.y) / 16))
        CASE 2
            SWAP player.y, player.lasty
            GOTO col2
    END SELECT

    SELECT CASE tile(INT((player.x + 1) / 16), INT((player.y + 14) / 16))
        CASE 2
            SWAP player.y, player.lasty
    END SELECT

    SELECT CASE tile(INT((player.x + 14) / 16), INT((player.y + 1) / 16))
        CASE 2
            SWAP player.y, player.lasty
            GOTO col2
    END SELECT

    SELECT CASE tile(INT((player.x + 14) / 16), INT((player.y + 14) / 16))
        CASE 2
            SWAP player.y, player.lasty
    END SELECT

    col2:

    SELECT CASE tile(INT((player.x + 1) / 16), INT((player.y + 1) / 16))
        CASE 2
            SWAP player.y, player.lasty
            player.x = player.lastx
    END SELECT

    SELECT CASE tile(INT((player.x + 14) / 16), INT((player.y + 1) / 16))
        CASE 2
            SWAP player.y, player.lasty
            player.x = player.lastx
    END SELECT

    SELECT CASE tile(INT((player.x + 1) / 16), INT((player.y + 14) / 16))
        CASE 2
            SWAP player.y, player.lasty
            player.x = player.lastx
    END SELECT

    SELECT CASE tile(INT((player.x + 14) / 16), INT((player.y + 14) / 16))
        CASE 2
            SWAP player.y, player.lasty
            player.x = player.lastx
    END SELECT
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
    IF KEYDOWN(32) = 0 THEN WINDOW SCREEN(window.x - 72, window.y - 52)-(window.x + 88, window.y + 68) ELSE WINDOW
    window.x = player.x
    window.y = player.y
    IF window.x - 72 < 0 THEN window.x = 72
    IF window.y - 52 < 0 THEN window.y = 52
    IF window.x + 88 > 640 THEN window.x = 552
    IF window.y + 68 > 480 THEN window.y = 412
END SUB



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



