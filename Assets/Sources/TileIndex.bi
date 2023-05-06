
Dim Shared TileIndex(1000, 5)
Dim Shared TileIndexData(1000, TileParameters) As Single
Dim Shared ContainerData(1000, 3)
Dim Shared TileName(1000, 3) As String

TileName(0, 0) = "Ground Air" 'Name of the tile
TileName(0, 1) = "Pure nothingness" 'tooltip
TileIndex(0, 0) = 0 'layer definition
TileIndex(0, 1) = 0 'x position on tilesheet
TileIndex(0, 2) = 0 'y position on tilesheet
TileIndexData(0, 0) = 1 'collision
TileIndexData(0, 1) = 0 'casts shadow
TileIndexData(0, 2) = 0 'blocks shadow
TileIndexData(0, 3) = 1 'has interior shadow
TileIndexData(0, 4) = 0 'resistance
TileIndexData(0, 5) = 0 'is solid
TileIndexData(0, 9) = 0 'Friction
TileIndexData(0, 10) = 10

TileName(1, 0) = "Air" 'Name of the tile
TileName(1, 1) = "Placeholder" 'tooltip
TileIndex(1, 0) = 1 'layer definition
TileIndex(1, 1) = 0 'x position on tilesheet
TileIndex(1, 2) = 0 'y position on tilesheet
TileIndexData(1, 0) = 0 'collision
TileIndexData(1, 1) = 0 'casts shadow
TileIndexData(1, 2) = 0 'blocks shadow
TileIndexData(1, 3) = 0 'has interior shadow
TileIndexData(1, 4) = 0 'resistance
TileIndexData(1, 5) = 0 'is solid

TileName(2, 0) = "Grass" 'Name of the tile
TileName(2, 1) = "Placeholder" 'tooltip
TileIndex(2, 0) = 0 'layer definition
TileIndex(2, 1) = 32 'x position on tilesheet
TileIndex(2, 2) = 0 'y position on tilesheet
TileIndex(2, 3) = 2 'itemid
TileIndex(2, 4) = 3 'transformation tile
TileIndexData(2, 0) = 0 'collision
TileIndexData(2, 1) = 0 'casts shadow
TileIndexData(2, 2) = 0 'blocks shadow
TileIndexData(2, 3) = 0 'has interior shadow
TileIndexData(2, 4) = 5 'resistance
TileIndexData(2, 5) = 1 'is solid
TileIndexData(2, 9) = 0.25 'friction
TileIndexData(2, 10) = 1

TileName(3, 0) = "Cut Grass" 'Name of the tile
TileName(3, 1) = "Placeholder" 'tooltip
TileIndex(3, 0) = 0 'layer definition
TileIndex(3, 1) = 48 'x position on tilesheet
TileIndex(3, 2) = 0 'y position on tilesheet
TileIndex(3, 3) = 3 'itemid
TileIndex(3, 4) = 4 'transformation tile
TileIndexData(3, 0) = 0 'collision
TileIndexData(3, 1) = 0 'casts shadow
TileIndexData(3, 2) = 0 'blocks shadow
TileIndexData(3, 3) = 0 'has interior shadow
TileIndexData(3, 4) = 5 'resistance
TileIndexData(3, 5) = 1 'is solid
TileIndexData(3, 9) = 0.25 'Friction
TileIndexData(3, 10) = 1.2

TileName(4, 0) = "Dirt" 'Name of the tile
TileName(4, 1) = "Placeholder" 'tooltip
TileIndex(4, 0) = 0 'layer definition
TileIndex(4, 1) = 64 'x position on tilesheet
TileIndex(4, 2) = 0 'y position on tilesheet
TileIndex(4, 3) = 4 'itemid
TileIndex(4, 4) = 21 'transformation tile
TileIndexData(4, 0) = 0 'collision
TileIndexData(4, 1) = 0 'casts shadow
TileIndexData(4, 2) = 0 'blocks shadow
TileIndexData(4, 3) = 0 'has interior shadow
TileIndexData(4, 4) = 4 'resistance
TileIndexData(4, 5) = 1 'is solid
TileIndexData(4, 9) = 0.2 'Friction
TileIndexData(4, 10) = 0.8


TileName(5, 0) = "Bush" 'Name of the tile
TileName(5, 1) = "Placeholder" 'tooltip
TileIndex(5, 0) = 1 'layer definition
TileIndex(5, 1) = 80 'x position on tilesheet
TileIndex(5, 2) = 0 'y position on tilesheet
TileIndex(5, 3) = 5 'itemid
TileIndexData(5, 0) = 1 'collision
TileIndexData(5, 1) = 0 'casts shadow
TileIndexData(5, 2) = 1 'blocks shadow
TileIndexData(5, 3) = 0 'has interior shadow
TileIndexData(5, 4) = 10 'resistance
TileIndexData(5, 5) = 0 'is solid
TileIndexData(0, 9) = 0 'Friction

TileName(6, 0) = "Chest" 'Name of the tile
TileName(6, 1) = "Placeholder" 'tooltip
TileIndex(6, 0) = 1 'layer definition
TileIndex(6, 1) = 96 'x position on tilesheet
TileIndex(6, 2) = 0 'y position on tilesheet
TileIndex(6, 3) = 6 'itemid
TileIndexData(6, 0) = 1 'collision
TileIndexData(6, 1) = 0 'casts shadow
TileIndexData(6, 2) = 1 'blocks shadow
TileIndexData(6, 3) = 0 'has interior shadow
TileIndexData(6, 4) = 14 'resistance
TileIndexData(6, 5) = 0 'is solid
TileIndexData(6, 7) = 1 'is container
ContainerData(6, 0) = 5 'number of slots  -1
ContainerData(6, 1) = 2 'number of rows
ContainerData(6, 2) = 0 'dissapears on empty


TileName(7, 0) = "CobbleStone Wall" 'Name of the tile
TileName(7, 1) = "Placeholder" 'tooltip
TileIndex(7, 0) = 1 'layer definition
TileIndex(7, 1) = 112 'x position on tilesheet
TileIndex(7, 2) = 0 'y position on tilesheet
TileIndex(7, 3) = 7 'itemid
TileIndexData(7, 0) = 1 'collision
TileIndexData(7, 1) = 1 'casts shadow
TileIndexData(7, 2) = 1 'blocks shadow
TileIndexData(7, 3) = 0 'has interior shadow
TileIndexData(7, 4) = 24 'resistance
TileIndexData(7, 5) = 1 'is solid


TileName(8, 0) = "Wood Wall" 'Name of the tile
TileName(8, 1) = "Placeholder" 'tooltip
TileIndex(8, 0) = 1 'layer definition
TileIndex(8, 1) = 128 'x position on tilesheet
TileIndex(8, 2) = 0 'y position on tilesheet
TileIndex(8, 3) = 8 'itemid
TileIndexData(8, 0) = 1 'collision
TileIndexData(8, 1) = 1 'casts shadow
TileIndexData(8, 2) = 1 'blocks shadow
TileIndexData(8, 3) = 0 'has interior shadow
TileIndexData(8, 4) = 19 'resistance
TileIndexData(8, 5) = 1 'is solid


TileName(9, 0) = "Unlit Campfire" 'Name of the tile
TileName(9, 1) = "Placeholder" 'tooltip
TileIndex(9, 0) = 1 'layer definition
TileIndex(9, 1) = 144 'x position on tilesheet
TileIndex(9, 2) = 0 'y position on tilesheet
TileIndex(9, 3) = 9 'itemid
TileIndexData(9, 0) = 1 'collision
TileIndexData(9, 1) = 0 'casts shadow
TileIndexData(9, 2) = 1 'blocks shadow
TileIndexData(9, 3) = 0 'has interior shadow
TileIndexData(9, 4) = 15 'resistance
TileIndexData(9, 5) = 0 'is solid

TileName(10, 0) = "Campfire" 'Name of the tile
TileName(10, 1) = "Placeholder" 'tooltip
TileIndex(10, 0) = 1 'layer definition
TileIndex(10, 1) = 160 'x position on tilesheet
TileIndex(10, 2) = 0 'y position on tilesheet
TileIndex(10, 3) = 10 'itemid
TileIndexData(10, 0) = 1 'collision
TileIndexData(10, 1) = 0 'casts shadow
TileIndexData(10, 2) = 1 'blocks shadow
TileIndexData(10, 3) = 0 'has interior shadow
TileIndexData(10, 4) = 15 'resistance
TileIndexData(10, 5) = 0 'is solid
TileIndexData(10, 6) = 12 'light casts

TileName(11, 0) = "Ground Item" 'Name of the tile
TileName(11, 1) = "Placeholder" 'tooltip
TileIndex(11, 0) = 1 'layer definition
TileIndex(11, 1) = 176 'x position on tilesheet
TileIndex(11, 2) = 0 'y position on tilesheet
TileIndex(11, 3) = -1 'itemid
TileIndexData(11, 0) = 0 'collision
TileIndexData(11, 1) = 0 'casts shadow
TileIndexData(11, 2) = 0 'blocks shadow
TileIndexData(11, 3) = 0 'has interior shadow
TileIndexData(11, 4) = 0 'resistance
TileIndexData(11, 5) = 0 'is solid
TileIndexData(11, 6) = 0 'light casts
TileIndexData(11, 7) = 1 'is container
ContainerData(11, 0) = 0 'number of slots -1
ContainerData(11, 1) = 0 'number of slots -1
ContainerData(11, 2) = 1 'dissapears on empty

TileName(12, 0) = "Berry Bush" 'Name of the tile
TileName(12, 1) = "Placeholder" 'tooltip
TileIndex(12, 0) = 1 'layer definition
TileIndex(12, 1) = 192 'x position on tilesheet
TileIndex(12, 2) = 0 'y position on tilesheet
TileIndex(12, 3) = 20 'itemid
TileIndexData(12, 0) = 1 'collision
TileIndexData(12, 1) = 0 'casts shadow
TileIndexData(12, 2) = 1 'blocks shadow
TileIndexData(12, 3) = 0 'has interior shadow
TileIndexData(12, 4) = 11 'resistance
TileIndexData(12, 5) = 0 'is solid


TileName(13, 0) = "Water"
TileName(13, 1) = ""
TileIndex(13, 0) = 0
TileIndex(13, 1) = 208 'x position on tilesheet
TileIndex(13, 2) = 0 'y position on tilesheet
TileIndex(13, 3) = -1 'itemid
TileIndexData(13, 0) = 0 'collision
TileIndexData(13, 1) = 0 'casts shadow
TileIndexData(13, 2) = 0 'blocks shadow
TileIndexData(13, 3) = 0 'has interior shadow
TileIndexData(13, 4) = 1000 'resistance
TileIndexData(13, 5) = 0 'is solid
TileIndexData(13, 9) = 0.04 'friction
TileIndexData(13, 10) = 0.4 'max speed
TileIndexData(13, 11) = 1 'tile spread

TileName(14, 0) = "Ice"
TileName(14, 1) = ""
TileIndex(14, 0) = 0
TileIndex(14, 1) = 224 'x position on tilesheet
TileIndex(14, 2) = 0 'y position on tilesheet
TileIndex(14, 3) = -1 'itemid
TileIndexData(14, 0) = 0 'collision
TileIndexData(14, 1) = 0 'casts shadow
TileIndexData(14, 2) = 0 'blocks shadow
TileIndexData(14, 3) = 0 'has interior shadow
TileIndexData(14, 4) = 19 'resistance
TileIndexData(14, 5) = 0 'is solid
TileIndexData(14, 9) = 0.01 'friction
TileIndexData(14, 10) = 2 'max speed
TileIndexData(14, 11) = 0 'tile spread

TileName(15, 0) = "Crafting Station" 'Name of the tile
TileName(15, 1) = "Placeholder" 'tooltip
TileIndex(15, 0) = 1 'layer definition
TileIndex(15, 1) = 240 'x position on tilesheet
TileIndex(15, 2) = 0 'y position on tilesheet
TileIndex(15, 3) = 21 'itemid
TileIndexData(15, 0) = 1 'collision
TileIndexData(15, 1) = 1 'casts shadow
TileIndexData(15, 2) = 1 'blocks shadow
TileIndexData(15, 3) = 0 'has interior shadow
TileIndexData(15, 4) = 19 'resistance
TileIndexData(15, 5) = 1 'is soli
TileIndexData(15, 8) = 3

TileName(16, 0) = "Wooden Ladder" 'Name of the tile
TileName(16, 1) = "Placeholder" 'tooltip
TileIndex(16, 0) = 0 'layer definition
TileIndex(16, 1) = 0 'x position on tilesheet
TileIndex(16, 2) = 16 'y position on tilesheet
TileIndex(16, 3) = 25 'itemid
TileIndexData(16, 0) = 1 'collision
TileIndexData(16, 1) = 0 'casts shadow
TileIndexData(16, 2) = 1 'blocks shadow
TileIndexData(16, 3) = 1 'has interior shadow
TileIndexData(16, 4) = 19 'resistance
TileIndexData(16, 5) = 1 'is solid
TileIndexData(16, 9) = 0.8 'Friction
TileIndexData(16, 10) = 0.8

TileName(17, 0) = "Carrot" 'Name of the tile
TileName(17, 1) = "Placeholder" 'tooltip
TileIndex(17, 0) = 1 'layer definition
TileIndex(17, 1) = 16 'x position on tilesheet
TileIndex(17, 2) = 16 'y position on tilesheet
TileIndex(17, 3) = 26 'itemid
TileIndexData(17, 0) = 0 'collision
TileIndexData(17, 1) = 0 'casts shadow
TileIndexData(17, 2) = 1 'blocks shadow
TileIndexData(17, 3) = 0 'has interior shadow
TileIndexData(17, 4) = 5 'resistance
TileIndexData(17, 5) = 0 'is solid

TileName(18, 0) = "Stone Wall" 'Name of the tile
TileName(18, 1) = "Placeholder" 'tooltip
TileIndex(19, 0) = 1 'layer definition
TileIndex(19, 1) = 32 'x position on tilesheet
TileIndex(19, 2) = 16 'y position on tilesheet
TileIndex(19, 3) = 28 'itemid
TileIndexData(19, 0) = 1 'collision
TileIndexData(19, 1) = 1 'casts shadow
TileIndexData(19, 2) = 1 'blocks shadow
TileIndexData(19, 3) = 0 'has interior shadow
TileIndexData(19, 4) = 29 'resistance
TileIndexData(19, 5) = 1 'is solid

TileName(20, 0) = "Stone Path" 'Name of the tile
TileName(20, 1) = "Placeholder" 'tooltip
TileIndex(20, 0) = 1 'layer definition
TileIndex(20, 1) = 48 'x position on tilesheet
TileIndex(20, 2) = 16 'y position on tilesheet
TileIndex(20, 3) = 29 'itemid
TileIndexData(20, 0) = 0 'collision
TileIndexData(20, 1) = 0 'casts shadow
TileIndexData(20, 2) = 1 'blocks shadow
TileIndexData(20, 3) = 0 'has interior shadow
TileIndexData(20, 4) = 10 'resistance
TileIndexData(20, 5) = 0 'is solid

TileName(21, 0) = "Farmland" 'Name of the tile
TileName(21, 1) = "Placeholder" 'tooltip
TileIndex(21, 0) = 0 'layer definition
TileIndex(21, 1) = 160 'x position on tilesheet
TileIndex(21, 2) = 16 'y position on tilesheet
TileIndex(21, 3) = 14 'itemid
TileIndex(21, 4) = 0 'transformation tile
TileIndexData(21, 0) = 0 'collision
TileIndexData(21, 1) = 0 'casts shadow
TileIndexData(21, 2) = 0 'blocks shadow
TileIndexData(21, 3) = 0 'has interior shadow
TileIndexData(21, 4) = 4 'resistance
TileIndexData(21, 5) = 1 'is solid
TileIndexData(21, 9) = 0.08 'Friction
TileIndexData(21, 10) = 0.72

