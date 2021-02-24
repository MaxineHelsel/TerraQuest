'define variables
DIM tile(3, 10)

'define file names
tsgrass$ = "sprites/grass.png"

'define screen size
SCREEN _NEWIMAGE(384, 384 - 48, 32)

'load files
ts.grass = _LOADIMAGE(tsgrass$)
ts.snow = _LOADIMAGE(tssnow$)
'dummy var
'DO
x = ((INT(RND * 24)) * 16)
y = ((INT(RND * 21)) * 16)




'LOOP
DO
    IF m = 0 THEN RESTORE mapbase

    IF m = 1 THEN RESTORE mapdata

    WHILE maply < 21

        WHILE maplx < 24

            FOR i = prog TO prog + 23
                READ px
                IF px = 0 THEN dx = 0: dy = 0
                IF px = 1 THEN dx = 1: dy = 0
                IF px = 2 THEN dx = 2: dy = 0
                IF px = 3 THEN dx = 3: dy = 0
                IF px = 4 THEN dx = 4: dy = 0
                IF px = 5 THEN dx = 5: dy = 0
                IF px = 6 THEN dx = 6: dy = 0
                IF px = 7 THEN dx = 7: dy = 0
                IF px = 8 THEN dx = 8: dy = 0
                IF px = 9 THEN dx = 9: dy = 0
                IF px = 10 THEN dx = 0: dy = 1
                IF px = 11 THEN dx = 1: dy = 1
                IF px = 12 THEN dx = 2: dy = 1
                IF px = 13 THEN dx = 3: dy = 1
                IF px = 14 THEN dx = 4: dy = 1
                IF px = 15 THEN dx = 5: dy = 1
                IF px = 16 THEN dx = 6: dy = 1
                IF px = 17 THEN dx = 7: dy = 1
                IF px = 18 THEN dx = 8: dy = 1
                IF px = 19 THEN dx = 9: dy = 1
                IF px = 20 THEN dx = 0: dy = 2
                IF px = 21 THEN dx = 1: dy = 2
                IF px = 22 THEN dx = 2: dy = 2
                IF px = 23 THEN dx = 3: dy = 2
                IF px = 24 THEN dx = 4: dy = 2
                IF px = 25 THEN dx = 5: dy = 2
                IF px = 26 THEN dx = 6: dy = 2
                IF px = 27 THEN dx = 7: dy = 2
                IF px = 28 THEN dx = 8: dy = 2
                IF px = 29 THEN dx = 9: dy = 2

                _PUTIMAGE (maplx * 16, maply * 16)-(maplx * 16 + 15, maply * 16 + 15), ts.grass, 0, (dx * 16, dy * 16)
                _DELAY 1 / 30
                LOCATE 1, 1: PRINT "px"; px, "mpx"; maplx, "mpy"; maply, "pg"; prog, "i"; i
                maplx = maplx + 1

            NEXT
        WEND
        maply = maply + 1
        maplx = 0
        prog = i
    WEND
    m = m + 1
LOOP


END
mapbase:
DATA 10

mapdata:
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,20,21,22,23,24,25,26,27,28,29,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,00,00,00,00,02,00,00,00,00,00,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
DATA 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10

DO
    'stage 1

    IF mtype = 1 THEN

        x = x + xmod
        IF x MOD 10 = 0 THEN frame = frame + 1
        IF frame > spframe THEN frame = 1
        PCOPY 2, 1
        IF turn = 1 THEN
            _PUTIMAGE (x, 250), spritesheet, 1, (p1.chrshtx + (spwidth * (frame - 1)), p1.chrshty)-(p1.chrshtx + (spwidth * (frame - 1)) + spwidth, p1.chrshty + spheight)
            _PUTIMAGE (510, 250), spritesheet, 1, (p2.chrshtx + spwidth, p2.chrshty)-(p2.chrshtx, p2.chrshty + 35)
            IF x = 476 THEN anim = 2
        END IF
        IF turn = 2 THEN
            _PUTIMAGE (110, 250), spritesheet, 1, (p1.chrshtx, p1.chrshty)-(p1.chrshtx + spwidth, p1.chrshty + 35)
            _PUTIMAGE (x, 250), spritesheet, 1, (p2.chrshtx + spwidth + (spwidth * (frame - 1)), p2.chrshty)-(p2.chrshtx + (spwidth * (frame - 1)), p2.chrshty + spheight)
            IF x = 124 THEN anim = 2

        END IF
        PCOPY 1, 0
        _DELAY 1 / 120

    END IF
LOOP UNTIL anim = 2


