
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
TileIndexData(2, 9) = 0.15 'friction
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
TileIndexData(3, 9) = 0.15 'Friction
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
TileIndexData(4, 9) = 0.15 'Friction
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
TileIndexData(7, 14) = 1


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
TileIndexData(10, 6) = 14 'light casts
TileIndexData(10, 16) = 0.13 'thermal output

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

TileName(19, 0) = "Stone Wall" 'Name of the tile
TileName(19, 1) = "Placeholder" 'tooltip
TileIndex(19, 0) = 1 'layer definition
TileIndex(19, 1) = 32 'x position on tilesheet
TileIndex(19, 2) = 16 'y position on tilesheet
TileIndex(19, 3) = 28 'itemid
TileIndexData(19, 0) = 1 'collision
TileIndexData(19, 1) = 1 'casts shadow
TileIndexData(19, 2) = 1 'blocks shadow
TileIndexData(19, 3) = 0 'has interior shadow
TileIndexData(19, 4) = 26 'resistance
TileIndexData(19, 5) = 1 'is solid
TileIndexData(19, 14) = 1 'requires pickaxe
TileIndexData(19, 15) = 1 'has lootpool

TileName(20, 0) = "Stone Path" 'Name of the tile
TileName(20, 1) = "Placeholder" 'tooltip
TileIndex(20, 0) = 1 'layer definition
TileIndex(20, 1) = 48 'x position on tilesheet
TileIndex(20, 2) = 16 'y position on tilesheet
TileIndex(20, 3) = 29 'itemid
TileIndexData(20, 0) = 0 'collision
TileIndexData(20, 1) = 0 'casts shadow
TileIndexData(20, 2) = 0 'blocks shadow
TileIndexData(20, 3) = 0 'has interior shadow
TileIndexData(20, 4) = 10 'resistance
TileIndexData(20, 5) = 0 'is solid
TileIndexData(20, 14) = 1 'requires pickaxe

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

TileName(22, 0) = "Advanced Crafting Station" 'Name of the tile
TileName(22, 1) = "Placeholder" 'tooltip
TileIndex(22, 0) = 1 'layer definition
TileIndex(22, 1) = 176 'x position on tilesheet
TileIndex(22, 2) = 16 'y position on tilesheet
TileIndex(22, 3) = 99 'itemid
TileIndexData(22, 0) = 1 'collision
TileIndexData(22, 1) = 1 'casts shadow
TileIndexData(22, 2) = 1 'blocks shadow
TileIndexData(22, 3) = 0 'has interior shadow
TileIndexData(22, 4) = 45 'resistance
TileIndexData(22, 5) = 1 'is soli
TileIndexData(22, 8) = 4
TileIndexData(22, 14) = 1 'requires pickaxe

TileName(23, 0) = "Wood Floor" 'Name of the tile
TileName(23, 1) = "Placeholder" 'tooltip
TileIndex(23, 0) = 0 'layer definition
TileIndex(23, 1) = 192 'x position on tilesheet
TileIndex(23, 2) = 16 'y position on tilesheet
TileIndex(23, 3) = 2 'itemid
TileIndexData(23, 0) = 0 'collision
TileIndexData(23, 1) = 0 'casts shadow
TileIndexData(23, 2) = 0 'blocks shadow
TileIndexData(23, 3) = 0 'has interior shadow
TileIndexData(23, 4) = 19 'resistance
TileIndexData(23, 5) = 1 'is solid
TileIndexData(23, 9) = 0.25 'friction
TileIndexData(23, 10) = 1

'24 imbuement station
TileName(24, 0) = "Imbuement Station" 'Name of the tile
TileName(24, 1) = "Placeholder" 'tooltip
TileIndex(24, 0) = 1 'layer definition
TileIndex(24, 1) = 176 'x position on tilesheet
TileIndex(24, 2) = 16 'y position on tilesheet
TileIndex(24, 3) = 113 'itemid
TileIndexData(24, 0) = 1 'collision
TileIndexData(24, 1) = 1 'casts shadow
TileIndexData(24, 2) = 1 'blocks shadow
TileIndexData(24, 3) = 0 'has interior shadow
TileIndexData(24, 4) = 45 'resistance
TileIndexData(24, 5) = 1 'is soli
TileIndexData(24, 8) = 6
TileIndexData(24, 14) = 1 'requires pickaxe
'info: crafting level 2,3,4,5 are reserved for standard tables up to aetherian workbench, level 6 is for imbuement, 7,8,9,10 are for furnaces


'25 deep water
TileName(25, 0) = "Deep Water" 'Name of the tile
TileName(25, 1) = "Placeholder" 'tooltip
TileIndex(25, 0) = 0 'layer definition
TileIndex(25, 1) = 32 'x position on tilesheet
TileIndex(25, 2) = 32 'y position on tilesheet
TileIndex(25, 3) = -1 'itemid
TileIndexData(25, 0) = 0 'collision
TileIndexData(25, 1) = 0 'casts shadow
TileIndexData(25, 2) = 0 'blocks shadow
TileIndexData(25, 3) = 0 'has interior shadow
TileIndexData(25, 4) = 1000 'resistance
TileIndexData(25, 5) = 0 'is solid
TileIndexData(25, 9) = 0.04 'friction
TileIndexData(25, 10) = 0.4
TileIndexData(25, 11) = 1


'26 void

'27 Sandstone
TileName(28, 0) = "Sandstone Wall" 'Name of the tile
TileName(28, 1) = "Placeholder" 'tooltip
TileIndex(28, 0) = 1 'layer definition
TileIndex(28, 1) = 0 'x position on tilesheet
TileIndex(28, 2) = 32 'y position on tilesheet
TileIndex(28, 3) = 28 'itemid
TileIndexData(28, 0) = 1 'collision
TileIndexData(28, 1) = 1 'casts shadow
TileIndexData(28, 2) = 1 'blocks shadow
TileIndexData(28, 3) = 0 'has interior shadow
TileIndexData(28, 4) = 54 'resistance
TileIndexData(28, 5) = 1 'is solid
TileIndexData(28, 14) = 1 'requires pickaxe
TileIndexData(28, 15) = 1 'has lootpool

'28 Calcite
TileName(28, 0) = "Calcite Wall" 'Name of the tile
TileName(28, 1) = "Placeholder" 'tooltip
TileIndex(28, 0) = 1 'layer definition
TileIndex(28, 1) = 0 'x position on tilesheet
TileIndex(28, 2) = 32 'y position on tilesheet
TileIndex(28, 3) = 28 'itemid
TileIndexData(28, 0) = 1 'collision
TileIndexData(28, 1) = 1 'casts shadow
TileIndexData(28, 2) = 1 'blocks shadow
TileIndexData(28, 3) = 0 'has interior shadow
TileIndexData(28, 4) = 45 'resistance
TileIndexData(28, 5) = 1 'is solid
TileIndexData(28, 14) = 1 'requires pickaxe
TileIndexData(28, 15) = 1 'has lootpool

'29 Sand
TileName(29, 0) = "Sand" 'Name of the tile
TileName(29, 1) = "Placeholder" 'tooltip
TileIndex(29, 0) = 0 'layer definition
TileIndex(29, 1) = 224 'x position on tilesheet
TileIndex(29, 2) = 16 'y position on tilesheet
TileIndex(29, 3) = 116 'itemid
TileIndexData(29, 0) = 0 'collision
TileIndexData(29, 1) = 0 'casts shadow
TileIndexData(29, 2) = 0 'blocks shadow
TileIndexData(29, 3) = 0 'has interior shadow
TileIndexData(29, 4) = 19 'resistance
TileIndexData(29, 5) = 0 'is solid
TileIndexData(29, 9) = 0.12 'friction
TileIndexData(29, 10) = 0.9
TileIndexData(29, 15) = 1

'30 Glass
TileName(30, 0) = "Glass" 'Name of the tile
TileName(30, 1) = "Placeholder" 'tooltip
TileIndex(30, 0) = 1 'layer definition
TileIndex(30, 1) = 16 'x position on tilesheet
TileIndex(30, 2) = 32 'y position on tilesheet
TileIndex(30, 3) = 116 'itemid
TileIndexData(30, 0) = 1 'collision
TileIndexData(30, 1) = 1 'casts shadow
TileIndexData(30, 2) = 1 'blocks shadow
TileIndexData(30, 3) = 0 'has interior shadow
TileIndexData(30, 4) = 5 'resistance
TileIndexData(30, 5) = 0 'is solid


'31 asphault
TileName(31, 0) = "Asphault" 'Name of the tile
TileName(31, 1) = "Placeholder" 'tooltip
TileIndex(31, 0) = 0 'layer definition
TileIndex(31, 1) = 48 'x position on tilesheet
TileIndex(31, 2) = 32 'y position on tilesheet
TileIndex(31, 3) = 116 'itemid
TileIndexData(31, 0) = 0 'collision
TileIndexData(31, 1) = 0 'casts shadow
TileIndexData(31, 2) = 0 'blocks shadow
TileIndexData(31, 3) = 0 'has interior shadow
TileIndexData(31, 4) = 33 'resistance
TileIndexData(31, 5) = 0 'is solid
TileIndexData(31, 9) = 0.35 'friction
TileIndexData(31, 10) = 2.5

'32 eggplant lvl1
TileName(32, 0) = "Eggplant" 'Name of the tile
TileName(32, 1) = "Placeholder" 'tooltip
TileIndex(32, 0) = 1 'layer definition
TileIndex(32, 1) = 80 'x position on tilesheet
TileIndex(32, 2) = 16 'y position on tilesheet
TileIndex(32, 3) = 37 'itemid
TileIndexData(32, 0) = 0 'collision
TileIndexData(32, 1) = 0 'casts shadow
TileIndexData(32, 2) = 0 'blocks shadow
TileIndexData(32, 3) = 0 'has interior shadow
TileIndexData(32, 4) = 10 'resistance
TileIndexData(32, 5) = 0 'is solid
TileIndexData(32, 9) = 0 'Friction

'33 eggplant lvl1
TileName(33, 0) = "Eggplant" 'Name of the tile
TileName(33, 1) = "Placeholder" 'tooltip
TileIndex(33, 0) = 1 'layer definition
TileIndex(33, 1) = 96 'x position on tilesheet
TileIndex(33, 2) = 16 'y position on tilesheet
TileIndex(33, 3) = 37 'itemid
TileIndexData(33, 0) = 0 'collision
TileIndexData(33, 1) = 0 'casts shadow
TileIndexData(33, 2) = 0 'blocks shadow
TileIndexData(33, 3) = 0 'has interior shadow
TileIndexData(33, 4) = 10 'resistance
TileIndexData(33, 5) = 0 'is solid
TileIndexData(33, 9) = 0 'Friction

'32 eggplant lvl3
TileName(34, 0) = "Eggplant" 'Name of the tile
TileName(34, 1) = "Placeholder" 'tooltip
TileIndex(34, 0) = 1 'layer definition
TileIndex(34, 1) = 112 'x position on tilesheet
TileIndex(34, 2) = 16 'y position on tilesheet
TileIndex(34, 3) = 37 'itemid
TileIndexData(34, 0) = 0 'collision
TileIndexData(34, 1) = 0 'casts shadow
TileIndexData(34, 2) = 0 'blocks shadow
TileIndexData(34, 3) = 0 'has interior shadow
TileIndexData(34, 4) = 10 'resistance
TileIndexData(34, 5) = 0 'is solid
TileIndexData(34, 9) = 0 'Friction

'35 eggplant lvl4
TileName(35, 0) = "Eggplant" 'Name of the tile
TileName(35, 1) = "Placeholder" 'tooltip
TileIndex(35, 0) = 1 'layer definition
TileIndex(35, 1) = 128 'x position on tilesheet
TileIndex(35, 2) = 16 'y position on tilesheet
TileIndex(35, 3) = 36 'itemid
TileIndexData(35, 0) = 0 'collision
TileIndexData(35, 1) = 0 'casts shadow
TileIndexData(35, 2) = 0 'blocks shadow
TileIndexData(35, 3) = 0 'has interior shadow
TileIndexData(35, 4) = 10 'resistance
TileIndexData(35, 5) = 0 'is solid
TileIndexData(35, 9) = 0 'Friction

''36-41 aetherian wall

TileName(36, 0) = "Aetherian Wall" 'Name of the tile
TileName(36, 1) = "Placeholder" 'tooltip
TileIndex(36, 0) = 1 'layer definition
TileIndex(36, 1) = 64 'x position on tilesheet
TileIndex(36, 2) = 32 'y position on tilesheet
TileIndex(36, 3) = -1 'itemid
TileIndexData(36, 0) = 1 'collision
TileIndexData(36, 1) = 1 'casts shadow
TileIndexData(36, 2) = 1 'blocks shadow
TileIndexData(36, 3) = 0 'has interior shadow
TileIndexData(36, 4) = 59 'resistance
TileIndexData(36, 5) = 1 'is solid

TileName(37, 0) = "Aetherian Wall" 'Name of the tile
TileName(37, 1) = "Placeholder" 'tooltip
TileIndex(37, 0) = 1 'layer definition
TileIndex(37, 1) = 80 'x position on tilesheet
TileIndex(37, 2) = 32 'y position on tilesheet
TileIndex(37, 3) = -1 'itemid
TileIndexData(37, 0) = 1 'collision
TileIndexData(37, 1) = 1 'casts shadow
TileIndexData(37, 2) = 1 'blocks shadow
TileIndexData(37, 3) = 0 'has interior shadow
TileIndexData(37, 4) = 59 'resistance
TileIndexData(37, 5) = 1 'is solid

TileName(38, 0) = "Aetherian Wall" 'Name of the tile
TileName(38, 1) = "Placeholder" 'tooltip
TileIndex(38, 0) = 1 'layer definition
TileIndex(38, 1) = 96 'x position on tilesheet
TileIndex(38, 2) = 32 'y position on tilesheet
TileIndex(38, 3) = -1 'itemid
TileIndexData(38, 0) = 1 'collision
TileIndexData(38, 1) = 1 'casts shadow
TileIndexData(38, 2) = 1 'blocks shadow
TileIndexData(38, 3) = 0 'has interior shadow
TileIndexData(38, 4) = 59 'resistance
TileIndexData(38, 5) = 1 'is solid

TileName(39, 0) = "Aetherian Wall" 'Name of the tile
TileName(39, 1) = "Placeholder" 'tooltip
TileIndex(39, 0) = 1 'layer definition
TileIndex(39, 1) = 112 'x position on tilesheet
TileIndex(39, 2) = 32 'y position on tilesheet
TileIndex(39, 3) = -1 'itemid
TileIndexData(39, 0) = 1 'collision
TileIndexData(39, 1) = 1 'casts shadow
TileIndexData(39, 2) = 1 'blocks shadow
TileIndexData(39, 3) = 0 'has interior shadow
TileIndexData(39, 4) = 59 'resistance
TileIndexData(39, 5) = 1 'is solid

TileName(40, 0) = "Aetherian Wall" 'Name of the tile
TileName(40, 1) = "Placeholder" 'tooltip
TileIndex(40, 0) = 1 'layer definition
TileIndex(40, 1) = 128 'x position on tilesheet
TileIndex(40, 2) = 32 'y position on tilesheet
TileIndex(40, 3) = -1 'itemid
TileIndexData(40, 0) = 1 'collision
TileIndexData(40, 1) = 1 'casts shadow
TileIndexData(40, 2) = 1 'blocks shadow
TileIndexData(40, 3) = 0 'has interior shadow
TileIndexData(40, 4) = 59 'resistance
TileIndexData(40, 5) = 1 'is solid

TileName(41, 0) = "Aetherian Wall" 'Name of the tile
TileName(41, 1) = "Placeholder" 'tooltip
TileIndex(41, 0) = 1 'layer definition
TileIndex(41, 1) = 144 'x position on tilesheet
TileIndex(41, 2) = 32 'y position on tilesheet
TileIndex(41, 3) = -1 'itemid
TileIndexData(41, 0) = 1 'collision
TileIndexData(41, 1) = 1 'casts shadow
TileIndexData(41, 2) = 1 'blocks shadow
TileIndexData(41, 3) = 0 'has interior shadow
TileIndexData(41, 4) = 59 'resistance
TileIndexData(41, 5) = 1 'is solid
'42 aetherian carpet

TileName(42, 0) = "Aetherian Carpet" 'Name of the tile
TileName(42, 1) = "Placeholder" 'tooltip
TileIndex(42, 0) = 0 'layer definition
TileIndex(42, 1) = 160 'x position on tilesheet
TileIndex(42, 2) = 32 'y position on tilesheet
TileIndex(42, 3) = -1 'itemid
TileIndexData(42, 0) = 0 'collision
TileIndexData(42, 1) = 0 'casts shadow
TileIndexData(42, 2) = 0 'blocks shadow
TileIndexData(42, 3) = 0 'has interior shadow
TileIndexData(42, 4) = 59 'resistance
TileIndexData(42, 5) = 0 'is solid
TileIndexData(42, 9) = 0.2 'friction
TileIndexData(42, 10) = 1

'43 torch

TileName(43, 0) = "Torch" 'Name of the tile
TileName(43, 1) = "Placeholder" 'tooltip
TileIndex(43, 0) = 1 'layer definition
TileIndex(43, 1) = 176 'x position on tilesheet
TileIndex(43, 2) = 32 'y position on tilesheet
TileIndex(43, 3) = 120 'itemid
TileIndexData(43, 0) = 0 'collision
TileIndexData(43, 1) = 0 'casts shadow
TileIndexData(43, 2) = 1 'blocks shadow
TileIndexData(43, 3) = 0 'has interior shadow
TileIndexData(43, 4) = 5 'resistance
TileIndexData(43, 5) = 0 'is solid
TileIndexData(43, 6) = 9 'light casts
TileIndexData(43, 16) = 0

'44 Ice Campfire
TileName(44, 0) = "Ice Campfire" 'Name of the tile
TileName(44, 1) = "Placeholder" 'tooltip
TileIndex(44, 0) = 1 'layer definition
TileIndex(44, 1) = 192 'x position on tilesheet
TileIndex(44, 2) = 32 'y position on tilesheet
TileIndex(44, 3) = 121 'itemid
TileIndexData(44, 0) = 1 'collision
TileIndexData(44, 1) = 0 'casts shadow
TileIndexData(44, 2) = 1 'blocks shadow
TileIndexData(44, 3) = 0 'has interior shadow
TileIndexData(44, 4) = 15 'resistance
TileIndexData(44, 5) = 0 'is solid
TileIndexData(44, 6) = 8 'light casts
TileIndexData(44, 16) = -0.08
