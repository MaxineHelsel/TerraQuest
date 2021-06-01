
'declare variable names and data types
DIM SHARED file AS file
DIM SHARED player AS character
DIM SHARED settings AS settings
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
    experience AS LONG
    gold AS LONG


END TYPE

TYPE settings
    framerate AS INTEGER
    tickrate AS SINGLE
END TYPE

 
