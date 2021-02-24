$NOPREFIX
OPTION EXPLICIT
RANDOMIZE TIMER
SCREEN NEWIMAGE(640, 480, 32)

'40,30

'declare variable names and data types
DIM SHARED file AS file
DIM SHARED map AS map

'include character data and other values in seperate files
file.char_file = "Assets\Tiles\character.png"
file.grass_file = "Assets\Tiles\grass.png"
file.snow_file = "Assets\Tiles\snow.png"
file.interior_file = "Assets\Tiles\interior.png"

map.theme = 0

'load assets
file.char = LOADIMAGE(file.char_file)
file.grass = LOADIMAGE(file.grass_file)
file.snow = LOADIMAGE(file.snow_file)
file.interior = LOADIMAGE(file.interior_file)


DO
    DIM i AS BYTE
    DIM ii AS BYTE
    FOR i = 0 TO 30
        FOR ii = 0 TO 40
            IF map.theme = 0 THEN
                PUTIMAGE (ii * 16, i * 16), file.grass, , (16, 16)-(31, 31)
            ELSEIF map.theme = 1 THEN

            END IF
        NEXT
    NEXT


    PRINT FRAMEPS

    LIMIT 60
    DISPLAY
    CLS
LOOP


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
            IF map.theme = 0 THEN
                PUTIMAGE (ii * 16, i * 16), file.grass, , (16, 16)-(31, 31)
            ELSEIF map.theme = 1 THEN

            END IF
        NEXT
    NEXT
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

TYPE map
    theme AS BYTE
END TYPE



