Dim Shared ItemIndex(1000, InvParameters)
Dim Shared ItemName(1000, 2) As String

ItemName(0, 0) = "Creative Shovel"
ItemName(0, 1) = "Allows you to break ground tiles"
ItemIndex(0, 0) = 1 'item type (1 means tool)
ItemIndex(0, 1) = 16 'item texture x cord
ItemIndex(0, 2) = 0 'item texture y cord
ItemIndex(0, 3) = 0 'tool max durabillity
ItemIndex(0, 4) = 1 'tool current durrabillity
ItemIndex(0, 5) = 0 'tool type
ItemIndex(0, 6) = 1000 'tool strength
ItemIndex(0, 7) = 1 'current stack
ItemIndex(0, 8) = 1 'max stack
ItemIndex(0, 9) = 0 'Item ID

ItemName(1, 0) = "Creative Axe"
ItemName(1, 1) = "Allows you to break wall tiles"
ItemIndex(1, 0) = 1 'item type (1 means tool)
ItemIndex(1, 1) = 32 'item texture x cord
ItemIndex(1, 2) = 0 'item texture y cord
ItemIndex(1, 3) = 0 'tool max durabillity
ItemIndex(1, 4) = 1 'tool current durrabillity
ItemIndex(1, 5) = 1 'tool type
ItemIndex(1, 6) = 1000 'tool strength
ItemIndex(1, 7) = 1 'current stack
ItemIndex(1, 8) = 1 'max stack
ItemIndex(1, 9) = 1 'Item ID

ItemName(2, 0) = "Grass" 'Name of the Item
ItemName(2, 1) = "Placeholder" 'tooltip
ItemIndex(2, 0) = 0 'item type
ItemIndex(2, 1) = 48 'x position on tilesheet
ItemIndex(2, 2) = 0 'y position on tilesheet
ItemIndex(2, 3) = 2 'tile id
ItemIndex(2, 4) = 0 'layer
ItemIndex(2, 7) = 1 'current stack
ItemIndex(2, 8) = 100 'max stack
ItemIndex(2, 9) = 2 'Item ID


ItemName(3, 0) = "Cut Grass" 'Name of the Item
ItemName(3, 1) = "Placeholder" 'tooltip
ItemIndex(3, 0) = 0 'layer definition
ItemIndex(3, 1) = 64 'x position on tilesheet
ItemIndex(3, 2) = 0 'y position on tilesheet
ItemIndex(3, 3) = 3 'tile id
ItemIndex(3, 4) = 0
ItemIndex(3, 7) = 1 'current stack
ItemIndex(3, 8) = 100 'max stack
ItemIndex(3, 9) = 3 'Item ID


ItemName(4, 0) = "Dirt" 'Name of the tile
ItemName(4, 1) = "Placeholder" 'tooltip
ItemIndex(4, 0) = 0 'layer definition
ItemIndex(4, 1) = 80 'x position on tilesheet
ItemIndex(4, 2) = 0 'y position on tilesheet
ItemIndex(4, 3) = 4 'tile id
ItemIndex(4, 4) = 0 'tile id
ItemIndex(4, 7) = 1 'current stack
ItemIndex(4, 8) = 100 'max stack
ItemIndex(4, 9) = 4 'Item ID


ItemName(5, 0) = "Bush" 'Name of the tile
ItemName(5, 1) = "Placeholder" 'tooltip
ItemIndex(5, 0) = 0 'layer definition
ItemIndex(5, 1) = 96 'x position on tilesheet
ItemIndex(5, 2) = 0 'y position on tilesheet
ItemIndex(5, 3) = 5 'tile id
ItemIndex(5, 4) = 1 'tile id
ItemIndex(5, 7) = 1 'current stack
ItemIndex(5, 8) = 100 'max stack
ItemIndex(5, 9) = 5 'Item ID


ItemName(6, 0) = "Chest" 'Name of the tile
ItemName(6, 1) = "Placeholder" 'tooltip
ItemIndex(6, 0) = 0 'layer definition
ItemIndex(6, 1) = 112 'x position on tilesheet
ItemIndex(6, 2) = 0 'y position on tilesheet
ItemIndex(6, 3) = 6 'tile id
ItemIndex(6, 4) = 1 'tile id
ItemIndex(6, 7) = 1 'current stack
ItemIndex(6, 8) = 100 'max stack
ItemIndex(6, 9) = 6 'Item ID


ItemName(7, 0) = "Cobblestone Wall" 'Name of the tile
ItemName(7, 1) = "Placeholder" 'tooltip
ItemIndex(7, 0) = 0 'layer definition
ItemIndex(7, 1) = 128 'x position on tilesheet
ItemIndex(7, 2) = 0 'y position on tilesheet
ItemIndex(7, 3) = 7 'tile id
ItemIndex(7, 4) = 1 'tile id
ItemIndex(7, 7) = 1 'current stack
ItemIndex(7, 8) = 100 'max stack
ItemIndex(7, 9) = 7 'Item ID


ItemName(8, 0) = "Wood Wall" 'Name of the tile
ItemName(8, 1) = "Placeholder" 'tooltip
ItemIndex(8, 0) = 0 'layer definition
ItemIndex(8, 1) = 144 'x position on tilesheet
ItemIndex(8, 2) = 0 'y position on tilesheet
ItemIndex(8, 3) = 8 'tile id
ItemIndex(8, 4) = 1 'tile id
ItemIndex(8, 7) = 1 'current stack
ItemIndex(8, 8) = 100 'max stack
ItemIndex(8, 9) = 8 'Item ID

ItemName(9, 0) = "Unlit Campfire" 'Name of the tile
ItemName(9, 1) = "Placeholder" 'tooltip
ItemIndex(9, 0) = 0 'item type
ItemIndex(9, 1) = 160 'x position on tilesheet
ItemIndex(9, 2) = 0 'y position on tilesheet
ItemIndex(9, 3) = 9 'tile id
ItemIndex(9, 4) = 1 'tile id
ItemIndex(9, 7) = 1 'current stack
ItemIndex(9, 8) = 100 'max stack
ItemIndex(9, 9) = 9 'Item ID

ItemName(10, 0) = "Campfire" 'Name of the tile
ItemName(10, 1) = "Placeholder" 'tooltip
ItemIndex(10, 0) = 0 'item type
ItemIndex(10, 1) = 176 'x position on tilesheet
ItemIndex(10, 2) = 0 'y position on tilesheet
ItemIndex(10, 3) = 10 'tile id
ItemIndex(10, 4) = 1 'tile id
ItemIndex(10, 7) = 1 'current stack
ItemIndex(10, 8) = 100 'max stack
ItemIndex(10, 9) = 10 'Item ID

ItemName(11, 0) = "Creative Pickaxe"
ItemName(11, 1) = "Allows you to mine"
ItemIndex(11, 0) = 1 'item type (1 means tool)
ItemIndex(11, 1) = 192 'item texture x cord
ItemIndex(11, 2) = 0 'item texture y cord
ItemIndex(11, 3) = 0 'tool max durabillity
ItemIndex(11, 4) = 1 'tool current durrabillity
ItemIndex(11, 5) = 2 'tool type
ItemIndex(11, 6) = 1000 'tool strength
ItemIndex(11, 7) = 1 'current stack
ItemIndex(11, 8) = 1 'max stack
ItemIndex(11, 9) = 11 'Item ID

ItemName(12, 0) = "Creative Sword"
ItemName(12, 1) = "Allows you to fight"
ItemIndex(12, 0) = 2 'item type (1 means tool)
ItemIndex(12, 1) = 208 'item texture x cord
ItemIndex(12, 2) = 0 'item texture y cord
ItemIndex(12, 3) = 0 'tool max durabillity
ItemIndex(12, 4) = 1 'tool current durrabillity
ItemIndex(12, 5) = 0 'swing delay
ItemIndex(12, 6) = 1000 'attack strength
ItemIndex(12, 7) = 1 'current stack
ItemIndex(12, 8) = 1 'max stack
ItemIndex(12, 9) = 12 'Item ID

ItemName(13, 0) = "Creative Hoe"
ItemName(13, 1) = "Allows you to fight"
ItemIndex(13, 0) = 1 'item type (1 means tool)
ItemIndex(13, 1) = 224 'item texture x cord
ItemIndex(13, 2) = 0 'item texture y cord
ItemIndex(13, 3) = 0 'tool max durabillity
ItemIndex(13, 4) = 1 'tool current durrabillity
ItemIndex(13, 5) = 3 'swing delay
ItemIndex(13, 6) = 1000 'attack strength
ItemIndex(13, 7) = 1 'current stack
ItemIndex(13, 8) = 1 'max stack
ItemIndex(13, 9) = 13 'Item ID

ItemName(14, 0) = "Farmland" 'Name of the tile
ItemName(14, 1) = "Placeholder" 'tooltip
ItemIndex(14, 0) = 0 'layer definition
ItemIndex(14, 1) = 240 'x position on tilesheet
ItemIndex(14, 2) = 0 'y position on tilesheet
ItemIndex(14, 3) = 4 'tile id
ItemIndex(14, 4) = 0 'tile id
ItemIndex(14, 7) = 1 'current stack
ItemIndex(14, 8) = 100 'max stack
ItemIndex(14, 9) = 14 'Item ID


ItemName(15, 0) = "Wood Shovel"
ItemName(15, 1) = "Allows you to break ground tiles"
ItemIndex(15, 0) = 1 'item type (1 means tool)
ItemIndex(15, 1) = 0 'item texture x cord
ItemIndex(15, 2) = 16 'item texture y cord
ItemIndex(15, 3) = 100 'tool max durabillity
ItemIndex(15, 4) = 100 'tool current durrabillity
ItemIndex(15, 5) = 0 'tool type
ItemIndex(15, 6) = 20 'tool strength
ItemIndex(15, 7) = 1 'current stack
ItemIndex(15, 8) = 1 'max stack
ItemIndex(15, 9) = 15 'Item ID

ItemName(16, 0) = "Wooden Axe"
ItemName(16, 1) = "Allows you to break wall tiles"
ItemIndex(16, 0) = 1 'item type (1 means tool)
ItemIndex(16, 1) = 16 'item texture x cord
ItemIndex(16, 2) = 16 'item texture y cord
ItemIndex(16, 3) = 100 'tool max durabillity
ItemIndex(16, 4) = 100 'tool current durrabillity
ItemIndex(16, 5) = 1 'tool type
ItemIndex(16, 6) = 20 'tool strength
ItemIndex(16, 7) = 1 'current stack
ItemIndex(16, 8) = 1 'max stack
ItemIndex(16, 9) = 16 'Item ID

ItemName(17, 0) = "Wooden Pickaxe"
ItemName(17, 1) = "Allows you to mine"
ItemIndex(17, 0) = 1 'item type (1 means tool)
ItemIndex(17, 1) = 32 'item texture x cord
ItemIndex(17, 2) = 16 'item texture y cord
ItemIndex(17, 3) = 100 'tool max durabillity
ItemIndex(17, 4) = 100 'tool current durrabillity
ItemIndex(17, 5) = 2 'tool type
ItemIndex(17, 6) = 20 'tool strength
ItemIndex(17, 7) = 1 'current stack
ItemIndex(17, 8) = 1 'max stack
ItemIndex(17, 9) = 17 'Item ID

ItemName(18, 0) = "Wooden Sword"
ItemName(18, 1) = "Allows you to fight"
ItemIndex(18, 0) = 2 'item type (1 means tool)
ItemIndex(18, 1) = 48 'item texture x cord
ItemIndex(18, 2) = 16 'item texture y cord
ItemIndex(18, 3) = 100 'tool max durabillity
ItemIndex(18, 4) = 100 'tool current durrabillity
ItemIndex(18, 5) = 60 'swing delay
ItemIndex(18, 6) = 1 'attack strength
ItemIndex(18, 7) = 1 'current stack
ItemIndex(18, 8) = 1 'max stack
ItemIndex(18, 9) = 18 'item id

ItemName(19, 0) = "Raw Wood"
ItemName(19, 1) = "Crafting Material"
ItemIndex(19, 0) = 3 'item type (1 means tool)
ItemIndex(19, 1) = 64 'item texture x cord
ItemIndex(19, 2) = 16 'item texture y cord
ItemIndex(19, 3) = 0 '
ItemIndex(19, 4) = 0 '
ItemIndex(19, 5) = 0 '
ItemIndex(19, 6) = 0 '
ItemIndex(19, 7) = 1 'current stack
ItemIndex(19, 8) = 100 'max stack
ItemIndex(19, 9) = 19 'Item ID

ItemName(20, 0) = "Berry Bush" 'Name of the tile
ItemName(20, 1) = "Placeholder" 'tooltip
ItemIndex(20, 0) = 0 'item type
ItemIndex(20, 1) = 80 'x position on tilesheet
ItemIndex(20, 2) = 16 'y position on tilesheet
ItemIndex(20, 3) = 12 'tile id
ItemIndex(20, 4) = 1 'layer
ItemIndex(20, 7) = 1 'current stack
ItemIndex(20, 8) = 100 'max stack
ItemIndex(20, 9) = 20 'Item ID

ItemName(21, 0) = "Crafting Station"
ItemName(21, 1) = "Placeholder"
ItemIndex(21, 0) = 0 'type
ItemIndex(21, 1) = 96 'ssx
ItemIndex(21, 2) = 16 'ssy
ItemIndex(21, 3) = 15 'tileID
ItemIndex(21, 4) = 1 'layer
ItemIndex(21, 7) = 1 'current stack
ItemIndex(21, 8) = 100 'max stack
ItemIndex(21, 9) = 21 'Item ID

ItemName(22, 0) = "Tool Handle"
ItemName(22, 1) = "Crafting Material"
ItemIndex(22, 0) = 3 'item type (1 means tool)
ItemIndex(22, 1) = 112 'item texture x cord
ItemIndex(22, 2) = 16 'item texture y cord
ItemIndex(22, 3) = 0 '
ItemIndex(22, 4) = 0 '
ItemIndex(22, 5) = 0 '
ItemIndex(22, 6) = 0 '
ItemIndex(22, 7) = 1 'current stack
ItemIndex(22, 8) = 100 'max stack
ItemIndex(22, 9) = 22 'Item ID

ItemName(23, 0) = "Red Berries"
ItemName(23, 1) = "Food Item"
ItemIndex(23, 0) = 4 'item type (4 means consumable)
ItemIndex(23, 1) = 128 'item texture x cord
ItemIndex(23, 2) = 16 'item texture y cord
ItemIndex(23, 3) = 0 'consumable type
ItemIndex(23, 4) = 0 '
ItemIndex(23, 5) = 0 '
ItemIndex(23, 6) = 0 '
ItemIndex(23, 7) = 1 'current stack
ItemIndex(23, 8) = 100 'max stack
ItemIndex(23, 9) = 23 'Item ID

ItemName(24, 0) = "Health Wheel"
ItemName(24, 1) = "Consumable, increases max health by 8"
ItemIndex(24, 0) = 4 'item type (4 means consumable)
ItemIndex(24, 1) = 144 'item texture x cord
ItemIndex(24, 2) = 16 'item texture y cord
ItemIndex(24, 3) = 1 'consumable type
ItemIndex(24, 4) = 0 '
ItemIndex(24, 5) = 0 '
ItemIndex(24, 6) = 0 '
ItemIndex(24, 7) = 1 'current stack
ItemIndex(24, 8) = 100 'max stack
ItemIndex(24, 9) = 24 'Item ID

ItemName(25, 0) = "Wooden Ladder" 'Name of the tile
ItemName(25, 1) = "Placeholder" 'tooltip
ItemIndex(25, 0) = 0 'Item type
ItemIndex(25, 1) = 160 'x position on tilesheet
ItemIndex(25, 2) = 16 'y position on tilesheet
ItemIndex(25, 3) = 16 'tile id
ItemIndex(25, 4) = 0 'Layer
ItemIndex(25, 7) = 1 'current stack
ItemIndex(25, 8) = 100 'max stack
ItemIndex(25, 9) = 25 'Item ID

ItemName(26, 0) = "Carrot"
ItemName(26, 1) = "Food Item"
ItemIndex(26, 0) = 4 'item type (4 means consumable)
ItemIndex(26, 1) = 176 'item texture x cord
ItemIndex(26, 2) = 16 'item texture y cord
ItemIndex(26, 3) = 0 'consumable type
ItemIndex(26, 4) = 0 '
ItemIndex(26, 5) = 0 '
ItemIndex(26, 6) = 0 '
ItemIndex(26, 7) = 1 'current stack
ItemIndex(26, 8) = 100 'max stack
ItemIndex(26, 9) = 26 'Item ID

'27 ice
ItemName(27, 0) = "Ice"
ItemName(27, 1) = "Placeholder"
ItemIndex(27, 0) = 0 'type
ItemIndex(27, 1) = 192 'ssx
ItemIndex(27, 2) = 16 'ssy
ItemIndex(27, 3) = 14 'tileID
ItemIndex(27, 4) = 0 'layer
ItemIndex(27, 7) = 1 'current stack
ItemIndex(27, 8) = 100 'max stack
ItemIndex(27, 9) = 27 'Item ID

'28 stone wall
ItemName(28, 0) = "Stone Wall"
ItemName(28, 1) = "Placeholder"
ItemIndex(28, 0) = 0 'type
ItemIndex(28, 1) = 208 'ssx
ItemIndex(28, 2) = 16 'ssy
ItemIndex(28, 3) = 19 'tileID
ItemIndex(28, 4) = 1 'layer
ItemIndex(28, 7) = 1 'current stack
ItemIndex(28, 8) = 100 'max stack
ItemIndex(28, 9) = 28 'Item ID

'29 raw stone
ItemName(29, 0) = "Raw Stone"
ItemName(29, 1) = "Crafting Material"
ItemIndex(29, 0) = 0 'item type (1 means tool)
ItemIndex(29, 1) = 224 'item texture x cord
ItemIndex(29, 2) = 16 'item texture y cord
ItemIndex(29, 3) = 20 '
ItemIndex(29, 4) = 1 '
ItemIndex(29, 5) = 0 '
ItemIndex(29, 6) = 0 '
ItemIndex(29, 7) = 1 'current stack
ItemIndex(29, 8) = 100 'max stack
ItemIndex(29, 9) = 29 'Item ID

'30 wooden hoe
ItemName(30, 0) = "Wooden Hoe"
ItemName(30, 1) = "Allows you to fight"
ItemIndex(30, 0) = 1 'item type (1 means tool)
ItemIndex(30, 1) = 240 'item texture x cord
ItemIndex(30, 2) = 16 'item texture y cord
ItemIndex(30, 3) = 0 'tool max durabillity
ItemIndex(30, 4) = 1 'tool current durrabillity
ItemIndex(30, 5) = 3 '
ItemIndex(30, 6) = 10 'attack strength
ItemIndex(30, 7) = 1 'current stack
ItemIndex(30, 8) = 1 'max stack
ItemIndex(30, 9) = 30 'Item ID

'31-35 stone toolset

ItemName(31, 0) = "Stone Shovel"
ItemName(31, 1) = "Allows you to break ground tiles"
ItemIndex(31, 0) = 1 'item type (1 means tool)
ItemIndex(31, 1) = 0 'item texture x cord
ItemIndex(31, 2) = 32 'item texture y cord
ItemIndex(31, 3) = 100 'tool max durabillity
ItemIndex(31, 4) = 100 'tool current durrabillity
ItemIndex(31, 5) = 0 'tool type
ItemIndex(31, 6) = 30 'tool strength
ItemIndex(31, 7) = 1 'current stack
ItemIndex(31, 8) = 1 'max stack
ItemIndex(31, 9) = 31 'Item ID

ItemName(32, 0) = "Stone Axe"
ItemName(32, 1) = "Allows you to break wall tiles"
ItemIndex(32, 0) = 1 'item type (1 means tool)
ItemIndex(32, 1) = 16 'item texture x cord
ItemIndex(32, 2) = 32 'item texture y cord
ItemIndex(32, 3) = 100 'tool max durabillity
ItemIndex(32, 4) = 100 'tool current durrabillity
ItemIndex(32, 5) = 1 'tool type
ItemIndex(32, 6) = 30 'tool strength
ItemIndex(32, 7) = 1 'current stack
ItemIndex(32, 8) = 1 'max stack
ItemIndex(32, 9) = 32 'Item ID

ItemName(33, 0) = "Stone Pickaxe"
ItemName(33, 1) = "Allows you to mine"
ItemIndex(33, 0) = 1 'item type (1 means tool)
ItemIndex(33, 1) = 32 'item texture x cord
ItemIndex(33, 2) = 32 'item texture y cord
ItemIndex(33, 3) = 100 'tool max durabillity
ItemIndex(33, 4) = 100 'tool current durrabillity
ItemIndex(33, 5) = 2 'tool type
ItemIndex(33, 6) = 30 'tool strength
ItemIndex(33, 7) = 1 'current stack
ItemIndex(33, 8) = 1 'max stack
ItemIndex(33, 9) = 33 'Item ID

ItemName(34, 0) = "Stone Sword"
ItemName(34, 1) = "Allows you to fight"
ItemIndex(34, 0) = 2 'item type (1 means tool)
ItemIndex(34, 1) = 48 'item texture x cord
ItemIndex(34, 2) = 32 'item texture y cord
ItemIndex(34, 3) = 100 'tool max durabillity
ItemIndex(34, 4) = 100 'tool current durrabillity
ItemIndex(34, 5) = 40 'swing delay
ItemIndex(34, 6) = 1 'attack strength
ItemIndex(34, 7) = 1 'current stack
ItemIndex(34, 8) = 1 'max stack
ItemIndex(34, 9) = 34 'item id

ItemName(35, 0) = "Stone Hoe"
ItemName(35, 1) = "hoe"
ItemIndex(35, 0) = 1 'item type (1 means tool)
ItemIndex(35, 1) = 64 'item texture x cord
ItemIndex(35, 2) = 32 'item texture y cord
ItemIndex(35, 3) = 0 'tool max durabillity
ItemIndex(35, 4) = 1 'tool current durrabillity
ItemIndex(35, 5) = 3 '
ItemIndex(35, 6) = 20 'attack strength
ItemIndex(35, 7) = 1 'current stack
ItemIndex(35, 8) = 1 'max stack
ItemIndex(35, 9) = 35 'Item ID

'36 eggplant
ItemName(36, 0) = "Eggplant"
ItemName(36, 1) = "Food Item"
ItemIndex(36, 0) = 4 'item type (4 means consumable)
ItemIndex(36, 1) = 80 'item texture x cord
ItemIndex(36, 2) = 32 'item texture y cord
ItemIndex(36, 3) = 0 'consumable type
ItemIndex(36, 4) = 0 '
ItemIndex(36, 5) = 0 '
ItemIndex(36, 6) = 0 '
ItemIndex(36, 7) = 1 'current stack
ItemIndex(36, 8) = 100 'max stack
ItemIndex(36, 9) = 36 'Item ID

'37 eggplant seeds

ItemName(37, 0) = "Eggplant Seeds" 'Name of the tile
ItemName(37, 1) = "Placeholder" 'tooltip
ItemIndex(37, 0) = 5 'type
ItemIndex(37, 1) = 96 'x position on tilesheet
ItemIndex(37, 2) = 32 'y position on tilesheet
ItemIndex(37, 3) = 32 'tile id
ItemIndex(37, 4) = 1 'layer
ItemIndex(37, 7) = 1 'current stack
ItemIndex(37, 8) = 100 'max stack
ItemIndex(37, 9) = 37 'Item ID

'38-45 ores

ItemName(38, 0) = "Tin Ore 
ItemName(38, 1) = "Crafting Material"
ItemIndex(38, 0) = 3 'item type (1 means tool)
ItemIndex(38, 1) = 112 'item texture x cord
ItemIndex(38, 2) = 32 'item texture y cord
ItemIndex(38, 3) = 0 '
ItemIndex(38, 4) = 0 '
ItemIndex(38, 5) = 0 '
ItemIndex(38, 6) = 0 '
ItemIndex(38, 7) = 1 'current stack
ItemIndex(38, 8) = 100 'max stack
ItemIndex(38, 9) = 38 'Item ID

ItemName(39, 0) = "Copper Ore 
ItemName(39, 1) = "Crafting Material"
ItemIndex(39, 0) = 3 'item type (1 means tool)
ItemIndex(39, 1) = 128 'item texture x cord
ItemIndex(39, 2) = 32 'item texture y cord
ItemIndex(39, 3) = 0 '
ItemIndex(39, 4) = 0 '
ItemIndex(39, 5) = 0 '
ItemIndex(39, 6) = 0 '
ItemIndex(39, 7) = 1 'current stack
ItemIndex(39, 8) = 100 'max stack
ItemIndex(39, 9) = 39 'Item ID

ItemName(40, 0) = "Iron Ore 
ItemName(40, 1) = "Crafting Material"
ItemIndex(40, 0) = 3 'item type (1 means tool)
ItemIndex(40, 1) = 144 'item texture x cord
ItemIndex(40, 2) = 32 'item texture y cord
ItemIndex(40, 3) = 0 ' 
ItemIndex(40, 4) = 0 '
ItemIndex(40, 5) = 0 '
ItemIndex(40, 6) = 0 '
ItemIndex(40, 7) = 1 'current stack
ItemIndex(40, 8) = 100 'max stack
ItemIndex(40, 9) = 40 'Item ID

ItemName(41, 0) = "Platinum Ore 
ItemName(41, 1) = "Crafting Material"
ItemIndex(41, 0) = 3 'item type (1 means tool)
ItemIndex(41, 1) = 160 'item texture x cord
ItemIndex(41, 2) = 32 'item texture y cord
ItemIndex(41, 3) = 0 ' 
ItemIndex(41, 4) = 0 '
ItemIndex(41, 5) = 0 '
ItemIndex(41, 6) = 0 '
ItemIndex(41, 7) = 1 'current stack
ItemIndex(41, 8) = 100 'max stack
ItemIndex(41, 9) = 41 'Item ID

ItemName(42, 0) = "Titanium Ore 
ItemName(42, 1) = "Crafting Material"
ItemIndex(42, 0) = 3 'item type (1 means tool)
ItemIndex(42, 1) = 176 'item texture x cord
ItemIndex(42, 2) = 32 'item texture y cord
ItemIndex(42, 3) = 0 ' 
ItemIndex(42, 4) = 0 '
ItemIndex(42, 5) = 0 '
ItemIndex(42, 6) = 0 '
ItemIndex(42, 7) = 1 'current stack
ItemIndex(42, 8) = 100 'max stack
ItemIndex(42, 9) = 42 'Item ID

ItemName(43, 0) = "Cobalt Ore 
ItemName(43, 1) = "Crafting Material"
ItemIndex(43, 0) = 3 'item type (1 means tool)
ItemIndex(43, 1) = 192 'item texture x cord
ItemIndex(43, 2) = 32 'item texture y cord
ItemIndex(43, 3) = 0 ' 
ItemIndex(43, 4) = 0 '
ItemIndex(43, 5) = 0 '
ItemIndex(43, 6) = 0 '
ItemIndex(43, 7) = 1 'current stack
ItemIndex(43, 8) = 100 'max stack
ItemIndex(43, 9) = 43 'Item ID

ItemName(44, 0) = "Chromium Ore 
ItemName(44, 1) = "Crafting Material"
ItemIndex(44, 0) = 3 'item type (1 means tool)
ItemIndex(44, 1) = 208 'item texture x cord
ItemIndex(44, 2) = 32 'item texture y cord
ItemIndex(44, 3) = 0 ' 
ItemIndex(44, 4) = 0 '
ItemIndex(44, 5) = 0 '
ItemIndex(44, 6) = 0 '
ItemIndex(44, 7) = 1 'current stack
ItemIndex(44, 8) = 100 'max stack
ItemIndex(44, 9) = 44 'Item ID

ItemName(45, 0) = "Tungsten Ore 
ItemName(45, 1) = "Crafting Material"
ItemIndex(45, 0) = 3 'item type (1 means tool)
ItemIndex(45, 1) = 224 'item texture x cord
ItemIndex(45, 2) = 32 'item texture y cord
ItemIndex(45, 3) = 0 ' 
ItemIndex(45, 4) = 0 '
ItemIndex(45, 5) = 0 '
ItemIndex(45, 6) = 0 '
ItemIndex(45, 7) = 1 'current stack
ItemIndex(45, 8) = 100 'max stack
ItemIndex(45, 9) = 45 'Item ID
'46-53 bars


ItemName(46, 0) = "Refined Tin
ItemName(46, 1) = "Crafting Material"
ItemIndex(46, 0) = 3 'item type (1 means tool)
ItemIndex(46, 1) = 112 'item texture x cord
ItemIndex(46, 2) = 48 'item texture y cord
ItemIndex(46, 3) = 0 '
ItemIndex(46, 4) = 0 '
ItemIndex(46, 5) = 0 '
ItemIndex(46, 6) = 0 '
ItemIndex(46, 7) = 1 'current stack
ItemIndex(46, 8) = 100 'max stack
ItemIndex(46, 9) = 46 'Item ID

ItemName(47, 0) = "Refined Copper 
ItemName(47, 1) = "Crafting Material"
ItemIndex(47, 0) = 3 'item type (1 means tool)
ItemIndex(47, 1) = 128 'item texture x cord
ItemIndex(47, 2) = 48 'item texture y cord
ItemIndex(47, 3) = 0 '
ItemIndex(47, 4) = 0 '
ItemIndex(47, 5) = 0 '
ItemIndex(47, 6) = 0 '
ItemIndex(47, 7) = 1 'current stack
ItemIndex(47, 8) = 100 'max stack
ItemIndex(47, 9) = 47 'Item ID

ItemName(48, 0) = "Refind Iron 
ItemName(48, 1) = "Crafting Material"
ItemIndex(48, 0) = 3 'item type (1 means tool)
ItemIndex(48, 1) = 144 'item texture x cord
ItemIndex(48, 2) = 48 'item texture y cord
ItemIndex(48, 3) = 0 ' 
ItemIndex(48, 4) = 0 '
ItemIndex(48, 5) = 0 '
ItemIndex(48, 6) = 0 '
ItemIndex(48, 7) = 1 'current stack
ItemIndex(48, 8) = 100 'max stack
ItemIndex(48, 9) = 48 'Item ID

ItemName(49, 0) = "Refind Platinum
ItemName(49, 1) = "Crafting Material"
ItemIndex(49, 0) = 3 'item type (1 means tool)
ItemIndex(49, 1) = 160 'item texture x cord
ItemIndex(49, 2) = 48 'item texture y cord
ItemIndex(49, 3) = 0 ' 
ItemIndex(49, 4) = 0 '
ItemIndex(49, 5) = 0 '
ItemIndex(49, 6) = 0 '
ItemIndex(49, 7) = 1 'current stack
ItemIndex(49, 8) = 100 'max stack
ItemIndex(49, 9) = 49 'Item ID

ItemName(50, 0) = "Refind Titanium
ItemName(50, 1) = "Crafting Material"
ItemIndex(50, 0) = 3 'item type (1 means tool)
ItemIndex(50, 1) = 176 'item texture x cord
ItemIndex(50, 2) = 48 'item texture y cord
ItemIndex(50, 3) = 0 ' 
ItemIndex(50, 4) = 0 '
ItemIndex(50, 5) = 0 '
ItemIndex(50, 6) = 0 '
ItemIndex(50, 7) = 1 'current stack
ItemIndex(50, 8) = 100 'max stack
ItemIndex(50, 9) = 50 'Item ID

ItemName(51, 0) = "Refind Cobalt
ItemName(51, 1) = "Crafting Material"
ItemIndex(51, 0) = 3 'item type (1 means tool)
ItemIndex(51, 1) = 192 'item texture x cord
ItemIndex(51, 2) = 48 'item texture y cord
ItemIndex(51, 3) = 0 ' 
ItemIndex(51, 4) = 0 '
ItemIndex(51, 5) = 0 '
ItemIndex(51, 6) = 0 '
ItemIndex(51, 7) = 1 'current stack
ItemIndex(51, 8) = 100 'max stack
ItemIndex(51, 9) = 51 'Item ID

ItemName(52, 0) = "Refind Chromium
ItemName(52, 1) = "Crafting Material"
ItemIndex(52, 0) = 3 'item type (1 means tool)
ItemIndex(52, 1) = 208 'item texture x cord
ItemIndex(52, 2) = 48 'item texture y cord
ItemIndex(52, 3) = 0 ' 
ItemIndex(52, 4) = 0 '
ItemIndex(52, 5) = 0 '
ItemIndex(52, 6) = 0 '
ItemIndex(52, 7) = 1 'current stack
ItemIndex(52, 8) = 100 'max stack
ItemIndex(52, 9) = 52 'Item ID

ItemName(53, 0) = "Refind Tungsten
ItemName(53, 1) = "Crafting Material"
ItemIndex(53, 0) = 3 'item type (1 means tool)
ItemIndex(53, 1) = 224 'item texture x cord
ItemIndex(53, 2) = 48 'item texture y cord
ItemIndex(53, 3) = 0 ' 
ItemIndex(53, 4) = 0 '
ItemIndex(53, 5) = 0 '
ItemIndex(53, 6) = 0 '
ItemIndex(53, 7) = 1 'current stack
ItemIndex(53, 8) = 100 'max stack
ItemIndex(53, 9) = 53 'Item ID

'54-58 tool handles

ItemName(54, 0) = "Iron Tool Handle 
ItemName(54, 1) = "Crafting Material"
ItemIndex(54, 0) = 3 'item type (1 means tool)
ItemIndex(54, 1) = 240 'item texture x cord
ItemIndex(54, 2) = 32 'item texture y cord
ItemIndex(54, 3) = 0 ' 
ItemIndex(54, 4) = 0 '
ItemIndex(54, 5) = 0 '
ItemIndex(54, 6) = 0 '
ItemIndex(54, 7) = 1 'current stack
ItemIndex(54, 8) = 100 'max stack
ItemIndex(54, 9) = 54 'Item ID

ItemName(55, 0) = "Platinum Tool Handle 
ItemName(55, 1) = "Crafting Material"
ItemIndex(55, 0) = 3 'item type (1 means tool)
ItemIndex(55, 1) = 80 'item texture x cord
ItemIndex(55, 2) = 48 'item texture y cord
ItemIndex(55, 3) = 0 ' 
ItemIndex(55, 4) = 0 '
ItemIndex(55, 5) = 0 '
ItemIndex(55, 6) = 0 '
ItemIndex(55, 7) = 1 'current stack
ItemIndex(55, 8) = 100 'max stack
ItemIndex(55, 9) = 55 'Item ID

ItemName(56, 0) = "Titanium Tool Handle 
ItemName(56, 1) = "Crafting Material"
ItemIndex(56, 0) = 3 'item type (1 means tool)
ItemIndex(56, 1) = 96 'item texture x cord
ItemIndex(56, 2) = 48 'item texture y cord
ItemIndex(56, 3) = 0 ' 
ItemIndex(56, 4) = 0 '
ItemIndex(56, 5) = 0 '
ItemIndex(56, 6) = 0 '
ItemIndex(56, 7) = 1 'current stack
ItemIndex(56, 8) = 100 'max stack
ItemIndex(56, 9) = 56 'Item ID

ItemName(57, 0) = "Cobalt Tool Handle 
ItemName(57, 1) = "Crafting Material"
ItemIndex(57, 0) = 3 'item type (1 means tool)
ItemIndex(57, 1) = 240 'item texture x cord
ItemIndex(57, 2) = 48 'item texture y cord
ItemIndex(57, 3) = 0 ' 
ItemIndex(57, 4) = 0 '
ItemIndex(57, 5) = 0 '
ItemIndex(57, 6) = 0 '
ItemIndex(57, 7) = 1 'current stack
ItemIndex(57, 8) = 100 'max stack
ItemIndex(57, 9) = 57 'Item ID

ItemName(58, 0) = "Chromium Tool Handle 
ItemName(58, 1) = "Crafting Material"
ItemIndex(58, 0) = 3 'item type (1 means tool)
ItemIndex(58, 1) = 80 'item texture x cord
ItemIndex(58, 2) = 64 'item texture y cord
ItemIndex(58, 3) = 0 ' 
ItemIndex(58, 4) = 0 '
ItemIndex(58, 5) = 0 '
ItemIndex(58, 6) = 0 '
ItemIndex(58, 7) = 1 'current stack
ItemIndex(58, 8) = 100 'max stack
ItemIndex(58, 9) = 58 'Item ID
'59-63 tin toolset

ItemName(59, 0) = "Tin Shovel"
ItemName(59, 1) = "Allows you to break ground tiles"
ItemIndex(59, 0) = 1 'item type (1 means tool)
ItemIndex(59, 1) = 0 'item texture x cord
ItemIndex(59, 2) = 48 'item texture y cord
ItemIndex(59, 3) = 100 'tool max durabillity
ItemIndex(59, 4) = 100 'tool current durrabillity
ItemIndex(59, 5) = 0 'tool type
ItemIndex(59, 6) = 40 'tool strength
ItemIndex(59, 7) = 1 'current stack
ItemIndex(59, 8) = 1 'max stack
ItemIndex(59, 9) = 59 'Item ID

ItemName(60, 0) = "Tin Axe"
ItemName(60, 1) = "Allows you to break wall tiles"
ItemIndex(60, 0) = 1 'item type (1 means tool)
ItemIndex(60, 1) = 16 'item texture x cord
ItemIndex(60, 2) = 48 'item texture y cord
ItemIndex(60, 3) = 100 'tool max durabillity
ItemIndex(60, 4) = 100 'tool current durrabillity
ItemIndex(60, 5) = 1 'tool type
ItemIndex(60, 6) = 40 'tool strength
ItemIndex(60, 7) = 1 'current stack
ItemIndex(60, 8) = 1 'max stack
ItemIndex(60, 9) = 60 'Item ID

ItemName(61, 0) = "Tin Pickaxe"
ItemName(61, 1) = "Allows you to mine"
ItemIndex(61, 0) = 1 'item type (1 means tool)
ItemIndex(61, 1) = 32 'item texture x cord
ItemIndex(61, 2) = 48 'item texture y cord
ItemIndex(61, 3) = 100 'tool max durabillity
ItemIndex(61, 4) = 100 'tool current durrabillity
ItemIndex(61, 5) = 2 'tool type
ItemIndex(61, 6) = 40 'tool strength
ItemIndex(61, 7) = 1 'current stack
ItemIndex(61, 8) = 1 'max stack
ItemIndex(61, 9) = 61 'Item ID

ItemName(62, 0) = "Tin Sword"
ItemName(62, 1) = "Allows you to fight"
ItemIndex(62, 0) = 2 'item type (1 means tool)
ItemIndex(62, 1) = 48 'item texture x cord
ItemIndex(62, 2) = 48 'item texture y cord
ItemIndex(62, 3) = 100 'tool max durabillity
ItemIndex(62, 4) = 100 'tool current durrabillity
ItemIndex(62, 5) = 40 'swing delay
ItemIndex(62, 6) = 2 'attack strength
ItemIndex(62, 7) = 1 'current stack
ItemIndex(62, 8) = 1 'max stack
ItemIndex(62, 9) = 62 'item id

ItemName(63, 0) = "Tin Hoe"
ItemName(63, 1) = "hoe"
ItemIndex(63, 0) = 1 'item type (1 means tool)
ItemIndex(63, 1) = 64 'item texture x cord
ItemIndex(63, 2) = 48 'item texture y cord
ItemIndex(63, 3) = 0 'tool max durabillity
ItemIndex(63, 4) = 1 'tool current durrabillity
ItemIndex(63, 5) = 3 '
ItemIndex(63, 6) = 30 'attack strength
ItemIndex(63, 7) = 1 'current stack
ItemIndex(63, 8) = 1 'max stack
ItemIndex(63, 9) = 63 'Item ID

'64-68 copper toolset

ItemName(64, 0) = "Copper Shovel"
ItemName(64, 1) = "Allows you to break ground tiles"
ItemIndex(64, 0) = 1 'item type (1 means tool)
ItemIndex(64, 1) = 0 'item texture x cord
ItemIndex(64, 2) = 64 'item texture y cord
ItemIndex(64, 3) = 100 'tool max durabillity
ItemIndex(64, 4) = 100 'tool current durrabillity
ItemIndex(64, 5) = 0 'tool type
ItemIndex(64, 6) = 50 'tool strength
ItemIndex(64, 7) = 1 'current stack
ItemIndex(64, 8) = 1 'max stack
ItemIndex(64, 9) = 64 'Item ID

ItemName(65, 0) = "Copper Axe"
ItemName(65, 1) = "Allows you to break wall tiles"
ItemIndex(65, 0) = 1 'item type (1 means tool)
ItemIndex(65, 1) = 16 'item texture x cord
ItemIndex(65, 2) = 64 'item texture y cord
ItemIndex(65, 3) = 100 'tool max durabillity
ItemIndex(65, 4) = 100 'tool current durrabillity
ItemIndex(65, 5) = 1 'tool type
ItemIndex(65, 6) = 50 'tool strength
ItemIndex(65, 7) = 1 'current stack
ItemIndex(65, 8) = 1 'max stack
ItemIndex(65, 9) = 65 'Item ID

ItemName(66, 0) = "Copper Pickaxe"
ItemName(66, 1) = "Allows you to mine"
ItemIndex(66, 0) = 1 'item type (1 means tool)
ItemIndex(66, 1) = 32 'item texture x cord
ItemIndex(66, 2) = 64 'item texture y cord
ItemIndex(66, 3) = 100 'tool max durabillity
ItemIndex(66, 4) = 100 'tool current durrabillity
ItemIndex(66, 5) = 2 'tool type
ItemIndex(66, 6) = 50 'tool strength
ItemIndex(66, 7) = 1 'current stack
ItemIndex(66, 8) = 1 'max stack
ItemIndex(66, 9) = 66 'Item ID

ItemName(67, 0) = "Copper Sword"
ItemName(67, 1) = "Allows you to fight"
ItemIndex(67, 0) = 2 'item type (1 means tool)
ItemIndex(67, 1) = 48 'item texture x cord
ItemIndex(67, 2) = 64 'item texture y cord
ItemIndex(67, 3) = 100 'tool max durabillity
ItemIndex(67, 4) = 100 'tool current durrabillity
ItemIndex(67, 5) = 30 'swing delay
ItemIndex(67, 6) = 2 'attack strength
ItemIndex(67, 7) = 1 'current stack
ItemIndex(67, 8) = 1 'max stack
ItemIndex(67, 9) = 67 'item id

ItemName(68, 0) = "Copper Hoe"
ItemName(68, 1) = "hoe"
ItemIndex(68, 0) = 1 'item type (1 means tool)
ItemIndex(68, 1) = 64 'item texture x cord
ItemIndex(68, 2) = 64 'item texture y cord
ItemIndex(68, 3) = 0 'tool max durabillity
ItemIndex(68, 4) = 1 'tool current durrabillity
ItemIndex(68, 5) = 3 '
ItemIndex(68, 6) = 40 'attack strength
ItemIndex(68, 7) = 1 'current stack
ItemIndex(68, 8) = 1 'max stack
ItemIndex(68, 9) = 68'Item ID


'Iron Toolset (69-73)
ItemName(69, 0) = "Iron Shovel"
ItemName(69, 1) = "Allows you to break ground tiles"
ItemIndex(69, 0) = 1 'item type (1 means tool)
ItemIndex(69, 1) = 0 'item texture x cord
ItemIndex(69, 2) = 80 'item texture y cord
ItemIndex(69, 3) = 100 'tool max durabillity
ItemIndex(69, 4) = 100 'tool current durrabillity
ItemIndex(69, 5) = 0 'tool type
ItemIndex(69, 6) = 60 'tool strength
ItemIndex(69, 7) = 1 'current stack
ItemIndex(69, 8) = 1 'max stack
ItemIndex(69, 9) = 69 'Item ID

ItemName(70, 0) = "Iron Axe"
ItemName(70, 1) = "Allows you to break wall tiles"
ItemIndex(70, 0) = 1 'item type (1 means tool)
ItemIndex(70, 1) = 16 'item texture x cord
ItemIndex(70, 2) = 80 'item texture y cord
ItemIndex(70, 3) = 100 'tool max durabillity
ItemIndex(70, 4) = 100 'tool current durrabillity
ItemIndex(70, 5) = 1 'tool type
ItemIndex(70, 6) = 60 'tool strength
ItemIndex(70, 7) = 1 'current stack
ItemIndex(70, 8) = 1 'max stack
ItemIndex(70, 9) = 70 'Item ID

ItemName(71, 0) = "Iron Pickaxe"
ItemName(71, 1) = "Allows you to mine"
ItemIndex(71, 0) = 1 'item type (1 means tool)
ItemIndex(71, 1) = 32 'item texture x cord
ItemIndex(71, 2) = 80 'item texture y cord
ItemIndex(71, 3) = 100 'tool max durabillity
ItemIndex(71, 4) = 100 'tool current durrabillity
ItemIndex(71, 5) = 2 'tool type
ItemIndex(71, 6) = 60 'tool strength
ItemIndex(71, 7) = 1 'current stack
ItemIndex(71, 8) = 1 'max stack
ItemIndex(71, 9) = 71 'Item ID

ItemName(72, 0) = "Iron Sword"
ItemName(72, 1) = "Allows you to fight"
ItemIndex(72, 0) = 2 'item type (1 means tool)
ItemIndex(72, 1) = 48 'item texture x cord
ItemIndex(72, 2) = 80 'item texture y cord
ItemIndex(72, 3) = 100 'tool max durabillity
ItemIndex(72, 4) = 100 'tool current durrabillity
ItemIndex(72, 5) = 30 'swing delay
ItemIndex(72, 6) = 3 'attack strength
ItemIndex(72, 7) = 1 'current stack
ItemIndex(72, 8) = 1 'max stack
ItemIndex(72, 9) = 72 'item id

ItemName(73, 0) = "Iron Hoe"
ItemName(73, 1) = "hoe"
ItemIndex(73, 0) = 1 'item type (1 means tool)
ItemIndex(73, 1) = 64 'item texture x cord
ItemIndex(73, 2) = 80 'item texture y cord
ItemIndex(73, 3) = 0 'tool max durabillity
ItemIndex(73, 4) = 1 'tool current durrabillity
ItemIndex(73, 5) = 3 '
ItemIndex(73, 6) = 50 'attack strength
ItemIndex(73, 7) = 1 'current stack
ItemIndex(73, 8) = 1 'max stack
ItemIndex(73, 9) = 73 'Item ID

'64-68 Platinum Toolset

ItemName(74, 0) = "Platinum Shovel"
ItemName(74, 1) = "Allows you to break ground tiles"
ItemIndex(74, 0) = 1 'item type (1 means tool)
ItemIndex(74, 1) = 0 'item texture x cord
ItemIndex(74, 2) = 96 'item texture y cord
ItemIndex(74, 3) = 100 'tool max durabillity
ItemIndex(74, 4) = 100 'tool current durrabillity
ItemIndex(74, 5) = 0 'tool type
ItemIndex(74, 6) = 50 'tool strength
ItemIndex(74, 7) = 1 'current stack
ItemIndex(74, 8) = 1 'max stack
ItemIndex(74, 9) = 74 'Item ID
itemindex(74,10) = 1 'imbuable

ItemName(75, 0) = "Platinum Axe"
ItemName(75, 1) = "Allows you to break wall tiles"
ItemIndex(75, 0) = 1 'item type (1 means tool)
ItemIndex(75, 1) = 16 'item texture x cord
ItemIndex(75, 2) = 96 'item texture y cord
ItemIndex(75, 3) = 100 'tool max durabillity
ItemIndex(75, 4) = 100 'tool current durrabillity
ItemIndex(75, 5) = 1 'tool type
ItemIndex(75, 6) = 55 'tool strength
ItemIndex(75, 7) = 1 'current stack
ItemIndex(75, 8) = 1 'max stack
ItemIndex(75, 9) = 75 'Item ID
itemindex(75,10) = 1 'imbuable

ItemName(76, 0) = "Platinum Pickaxe"
ItemName(76, 1) = "Allows you to mine"
ItemIndex(76, 0) = 1 'item type (1 means tool)
ItemIndex(76, 1) = 32 'item texture x cord
ItemIndex(76, 2) = 96 'item texture y cord
ItemIndex(76, 3) = 100 'tool max durabillity
ItemIndex(76, 4) = 100 'tool current durrabillity
ItemIndex(76, 5) = 2 'tool type
ItemIndex(76, 6) = 55 'tool strength
ItemIndex(76, 7) = 1 'current stack
ItemIndex(76, 8) = 1 'max stack
ItemIndex(76, 9) = 76 'Item ID
itemindex(76,10) = 1 'imbuable

ItemName(77, 0) = "Platium Sword"
ItemName(77, 1) = "Allows you to fight"
ItemIndex(77, 0) = 2 'item type (1 means tool)
ItemIndex(77, 1) = 48 'item texture x cord
ItemIndex(77, 2) = 96 'item texture y cord
ItemIndex(77, 3) = 100 'tool max durabillity
ItemIndex(77, 4) = 100 'tool current durrabillity
ItemIndex(77, 5) = 40 'swing delay
ItemIndex(77, 6) = 3 'attack strength
ItemIndex(77, 7) = 1 'current stack
ItemIndex(77, 8) = 1 'max stack
ItemIndex(77, 9) = 77 'item id
itemindex(77,10) = 1 'imbuable

ItemName(78, 0) = "Platinum Hoe"
ItemName(78, 1) = "hoe"
ItemIndex(78, 0) = 1 'item type (1 means tool)
ItemIndex(78, 1) = 64 'item texture x cord
ItemIndex(78, 2) = 96 'item texture y cord
ItemIndex(78, 3) = 0 'tool max durabillity
ItemIndex(78, 4) = 1 'tool current durrabillity
ItemIndex(78, 5) = 3 '
ItemIndex(78, 6) = 45 'attack strength
ItemIndex(78, 7) = 1 'current stack
ItemIndex(78, 8) = 1 'max stack
ItemIndex(78, 9) = 78'Item ID
itemindex(78,10) = 1 'imbuable

'79-83 titanium toolset

ItemName(79, 0) = "Titanium Shovel"
ItemName(79, 1) = "Allows you to break ground tiles"
ItemIndex(79, 0) = 1 'item type (1 means tool)
ItemIndex(79, 1) = 0 'item texture x cord
ItemIndex(79, 2) = 112 'item texture y cord
ItemIndex(79, 3) = 100 'tool max durabillity
ItemIndex(79, 4) = 100 'tool current durrabillity
ItemIndex(79, 5) = 0 'tool type
ItemIndex(79, 6) = 70 'tool strength
ItemIndex(79, 7) = 1 'current stack
ItemIndex(79, 8) = 1 'max stack
ItemIndex(79, 9) = 79 'Item ID
itemindex(79,10) = 1 'imbuable

ItemName(80, 0) = "Titanium Axe"
ItemName(80, 1) = "Allows you to break wall tiles"
ItemIndex(80, 0) = 1 'item type (1 means tool)
ItemIndex(80, 1) = 16 'item texture x cord
ItemIndex(80, 2) = 112 'item texture y cord
ItemIndex(80, 3) = 100 'tool max durabillity
ItemIndex(80, 4) = 100 'tool current durrabillity
ItemIndex(80, 5) = 1 'tool type
ItemIndex(80, 6) = 70 'tool strength
ItemIndex(80, 7) = 1 'current stack
ItemIndex(80, 8) = 1 'max stack
ItemIndex(80, 9) = 80 'Item ID
itemindex(80,10) = 1 'imbuable

ItemName(81, 0) = "Titanium Pickaxe"
ItemName(81, 1) = "Allows you to mine"
ItemIndex(81, 0) = 1 'item type (1 means tool)
ItemIndex(81, 1) = 32 'item texture x cord
ItemIndex(81, 2) = 112'item texture y cord
ItemIndex(81, 3) = 100 'tool max durabillity
ItemIndex(81, 4) = 100 'tool current durrabillity
ItemIndex(81, 5) = 2 'tool type
ItemIndex(81, 6) = 70 'tool strength
ItemIndex(81, 7) = 1 'current stack
ItemIndex(81, 8) = 1 'max stack
ItemIndex(81, 9) = 81 'Item ID
itemindex(81,10) = 1 'imbuable

ItemName(82, 0) = "Titanium Sword"
ItemName(82, 1) = "Allows you to fight"
ItemIndex(82, 0) = 2 'item type (1 means tool)
ItemIndex(82, 1) = 48 'item texture x cord
ItemIndex(82, 2) = 112 'item texture y cord
ItemIndex(82, 3) = 100 'tool max durabillity
ItemIndex(82, 4) = 100 'tool current durrabillity
ItemIndex(82, 5) = 30 'swing delay
ItemIndex(82, 6) = 4 'attack strength
ItemIndex(82, 7) = 1 'current stack
ItemIndex(82, 8) = 1 'max stack
ItemIndex(82, 9) = 82 'item id
itemindex(82,10) = 1 'imbuable

ItemName(83, 0) = "Titanium Hoe"
ItemName(83, 1) = "hoe"
ItemIndex(83, 0) = 1 'item type (1 means tool)
ItemIndex(83, 1) = 64 'item texture x cord
ItemIndex(83, 2) = 112 'item texture y cord
ItemIndex(83, 3) = 0 'tool max durabillity
ItemIndex(83, 4) = 1 'tool current durrabillity
ItemIndex(83, 5) = 3 '
ItemIndex(83, 6) = 60 'attack strength
ItemIndex(83, 7) = 1 'current stack
ItemIndex(83, 8) = 1 'max stack
ItemIndex(83, 9) = 83'Item ID
itemindex(83,10) = 1 'imbuable

'84-88 cobalt toolset

ItemName(84, 0) = "Cobalt Shovel"
ItemName(84, 1) = "Allows you to break ground tiles"
ItemIndex(84, 0) = 1 'item type (1 means tool)
ItemIndex(84, 1) = 0 'item texture x cord
ItemIndex(84, 2) = 128 'item texture y cord
ItemIndex(84, 3) = 100 'tool max durabillity
ItemIndex(84, 4) = 100 'tool current durrabillity
ItemIndex(84, 5) = 0 'tool type
ItemIndex(84, 6) = 80 'tool strength
ItemIndex(84, 7) = 1 'current stack
ItemIndex(84, 8) = 1 'max stack
ItemIndex(84, 9) = 84 'Item ID
itemindex(84,10) = 1 'imbuable

ItemName(85, 0) = "Cobalt Axe"
ItemName(85, 1) = "Allows you to break wall tiles"
ItemIndex(85, 0) = 1 'item type (1 means tool)
ItemIndex(85, 1) = 16 'item texture x cord
ItemIndex(85, 2) = 128 'item texture y cord
ItemIndex(85, 3) = 100 'tool max durabillity
ItemIndex(85, 4) = 100 'tool current durrabillity
ItemIndex(85, 5) = 1 'tool type
ItemIndex(85, 6) = 80 'tool strength
ItemIndex(85, 7) = 1 'current stack
ItemIndex(85, 8) = 1 'max stack
ItemIndex(85, 9) = 85 'Item ID
itemindex(85,10) = 1 'imbuable

ItemName(86, 0) = "Cobalt Pickaxe"
ItemName(86, 1) = "Allows you to mine"
ItemIndex(86, 0) = 1 'item type (1 means tool)
ItemIndex(86, 1) = 32 'item texture x cord
ItemIndex(86, 2) = 128'item texture y cord
ItemIndex(86, 3) = 100 'tool max durabillity
ItemIndex(86, 4) = 100 'tool current durrabillity
ItemIndex(86, 5) = 2 'tool type
ItemIndex(86, 6) = 80 'tool strength
ItemIndex(86, 7) = 1 'current stack
ItemIndex(86, 8) = 1 'max stack
ItemIndex(86, 9) = 86 'Item ID
itemindex(86,10) = 1 'imbuable

ItemName(87, 0) = "Cobalt Sword"
ItemName(87, 1) = "Allows you to fight"
ItemIndex(87, 0) = 2 'item type (1 means tool)
ItemIndex(87, 1) = 48 'item texture x cord
ItemIndex(87, 2) = 128 'item texture y cord
ItemIndex(87, 3) = 100 'tool max durabillity
ItemIndex(87, 4) = 100 'tool current durrabillity
ItemIndex(87, 5) = 30 'swing delay
ItemIndex(87, 6) = 5 'attack strength
ItemIndex(87, 7) = 1 'current stack
ItemIndex(87, 8) = 1 'max stack
ItemIndex(87, 9) = 87 'item id
itemindex(87,10) = 1 'imbuable

ItemName(88, 0) = "Cobalt Hoe"
ItemName(88, 1) = "hoe"
ItemIndex(88, 0) = 1 'item type (1 means tool)
ItemIndex(88, 1) = 64 'item texture x cord
ItemIndex(88, 2) = 128 'item texture y cord
ItemIndex(88, 3) = 0 'tool max durabillity
ItemIndex(88, 4) = 1 'tool current durrabillity
ItemIndex(88, 5) = 3 '
ItemIndex(88, 6) = 70 'attack strength
ItemIndex(88, 7) = 1 'current stack
ItemIndex(88, 8) = 1 'max stack
ItemIndex(88, 9) = 88'Item ID
itemindex(88,10) = 1 'imbuable


'89-93 chromium toolset

'94-98 tungsten toolset
 
ItemName(99, 0) = "Advanced Crafting Station"
ItemName(99, 1) = "Placeholder"
ItemIndex(99, 0) = 0 'type
ItemIndex(99, 1) = 96 'ssx
ItemIndex(99, 2) = 64 'ssy
ItemIndex(99, 3) = 22 'tileID
ItemIndex(99, 4) = 1 'layer
ItemIndex(99, 7) = 1 'current stack
ItemIndex(99, 8) = 100 'max stack
ItemIndex(99, 9) = 99 'Item ID


ItemName(100, 0) = "Wood Floor" 'Name of the Item
ItemName(100, 1) = "Placeholder" 'tooltip
ItemIndex(100, 0) = 0 'item type
ItemIndex(100, 1) = 112 'x position on tilesheet
ItemIndex(100, 2) = 64 'y position on tilesheet
ItemIndex(100, 3) = 23 'tile id
ItemIndex(100, 4) = 0 'layer
ItemIndex(100, 7) = 1 'current stack
ItemIndex(100, 8) = 100 'max stack
ItemIndex(100, 9) = 100 'Item ID


ItemName(101, 0) = "Decayed Flesh"
ItemName(101, 1) = "Food Item"
ItemIndex(101, 0) = 4 'item type (4 means consumable)
ItemIndex(101, 1) = 96 'item texture x cord
ItemIndex(101, 2) = 96 'item texture y cord
ItemIndex(101, 3) = 0 'consumable type
ItemIndex(101, 4) = 0 '
ItemIndex(101, 5) = 0 '
ItemIndex(101, 6) = 0 '
ItemIndex(101, 7) = 1 'current stack
ItemIndex(101, 8) = 100 'max stack
ItemIndex(101, 9) = 101 'Item ID


ItemName(102, 0) = "Duck Meat"
ItemName(102, 1) = "Food Item"
ItemIndex(102, 0) = 4 'item type (4 means consumable)
ItemIndex(102, 1) = 80 'item texture x cord
ItemIndex(102, 2) = 96 'item texture y cord
ItemIndex(102, 3) = 0 'consumable type
ItemIndex(102, 4) = 0 '
ItemIndex(102, 5) = 0 '
ItemIndex(102, 6) = 0 '
ItemIndex(102, 7) = 1 'current stack
ItemIndex(102, 8) = 100 'max stack
ItemIndex(102, 9) = 102 'Item ID

'Stone of Refraction (imbuement stone) 103
ItemName(103, 0) = "Imbuement Refraction Core
ItemName(103, 1) = "Crafting Material"
ItemIndex(103, 0) = 3 'item type (1 means tool)
ItemIndex(103, 1) = 96   'item texture x cord
ItemIndex(103, 2) = 80 'item texture y cord
ItemIndex(103, 3) = 0 ' 
ItemIndex(103, 4) = 0 '
ItemIndex(103, 5) = 0 '
ItemIndex(103, 6) = 0 '
ItemIndex(103, 7) = 1 'current stack
ItemIndex(103, 8) = 100 'max stack
ItemIndex(103, 9) = 103 'Item ID

'Aetherian Energy Sphere 103
ItemName(104, 0) = "Aetherian Energy Sphere 
ItemName(104, 1) = "Crafting Material"
ItemIndex(104, 0) = 3 'item type (1 means tool)
ItemIndex(104, 1) = 112   'item texture x cord
ItemIndex(104, 2) = 80 'item texture y cord
ItemIndex(104, 3) = 0 ' 
ItemIndex(104, 4) = 0 '
ItemIndex(104, 5) = 0 '
ItemIndex(104, 6) = 0 '
ItemIndex(104, 7) = 1 'current stack
ItemIndex(104, 8) = 100 'max stack
ItemIndex(104, 9) = 104 'Item ID


'105-112 gemstones
ItemName(105, 0) = "Sapphire
ItemName(105, 1) = "Crafting Material"
ItemIndex(105, 0) = 3 'item type (1 means tool)
ItemIndex(105, 1) = 144   'item texture x cord
ItemIndex(105, 2) = 64 'item texture y cord
ItemIndex(105, 3) = 0 ' 
ItemIndex(105, 4) = 0 '
ItemIndex(105, 5) = 0 '
ItemIndex(105, 6) = 0 '
ItemIndex(105, 7) = 1 'current stack
ItemIndex(105, 8) = 100 'max stack
ItemIndex(105, 9) = 105 'Item ID

ItemName(106, 0) = "Ruby
ItemName(106, 1) = "Crafting Material"
ItemIndex(106, 0) = 3 'item type (1 means tool)
ItemIndex(106, 1) = 160   'item texture x cord
ItemIndex(106, 2) = 64 'item texture y cord
ItemIndex(106, 3) = 0 ' 
ItemIndex(106, 4) = 0 '
ItemIndex(106, 5) = 0 '
ItemIndex(106, 6) = 0 '
ItemIndex(106, 7) = 1 'current stack
ItemIndex(106, 8) = 100 'max stack
ItemIndex(106, 9) = 106 'Item ID

ItemName(107, 0) = "Diamond
ItemName(107, 1) = "Crafting Material"
ItemIndex(107, 0) = 3 'item type (1 means tool)
ItemIndex(107, 1) = 176   'item texture x cord
ItemIndex(107, 2) = 64 'item texture y cord
ItemIndex(107, 3) = 0 ' 
ItemIndex(107, 4) = 0 '
ItemIndex(107, 5) = 0 '
ItemIndex(107, 6) = 0 '
ItemIndex(107, 7) = 1 'current stack
ItemIndex(107, 8) = 100 'max stack
ItemIndex(107, 9) = 107 'Item ID


ItemName(108, 0) = "Emerald
ItemName(108, 1) = "Crafting Material"
ItemIndex(108, 0) = 3 'item type (1 means tool)
ItemIndex(108, 1) = 192   'item texture x cord
ItemIndex(108, 2) = 64 'item texture y cord
ItemIndex(108, 3) = 0 ' 
ItemIndex(108, 4) = 0 '
ItemIndex(108, 5) = 0 '
ItemIndex(108, 6) = 0 '
ItemIndex(108, 7) = 1 'current stack
ItemIndex(108, 8) = 100 'max stack
ItemIndex(108, 9) = 108 'Item ID


ItemName(109, 0) = "Amethyst
ItemName(109, 1) = "Crafting Material"
ItemIndex(109, 0) = 3 'item type (1 means tool)
ItemIndex(109, 1) = 208   'item texture x cord
ItemIndex(109, 2) = 64 'item texture y cord
ItemIndex(109, 3) = 0 ' 
ItemIndex(109, 4) = 0 '
ItemIndex(109, 5) = 0 '
ItemIndex(109, 6) = 0 '
ItemIndex(109, 7) = 1 'current stack
ItemIndex(109, 8) = 100 'max stack
ItemIndex(109, 9) = 109 'Item ID

ItemName(110, 0) = "Topaz
ItemName(110, 1) = "Crafting Material"
ItemIndex(110, 0) = 3 'item type (1 means tool)
ItemIndex(110, 1) = 224   'item texture x cord
ItemIndex(110, 2) = 64 'item texture y cord
ItemIndex(110, 3) = 0 ' 
ItemIndex(110, 4) = 0 '
ItemIndex(110, 5) = 0 '
ItemIndex(110, 6) = 0 '
ItemIndex(110, 7) = 1 'current stack
ItemIndex(110, 8) = 100 'max stack
ItemIndex(110, 9) = 110 'Item ID

ItemName(111, 0) = "Turquoise
ItemName(111, 1) = "Crafting Material"
ItemIndex(111, 0) = 3 'item type (1 means tool)
ItemIndex(111, 1) = 240  'item texture x cord
ItemIndex(111, 2) = 64 'item texture y cord
ItemIndex(111, 3) = 0 ' 
ItemIndex(111, 4) = 0 '
ItemIndex(111, 5) = 0 '
ItemIndex(111, 6) = 0 '
ItemIndex(111, 7) = 1 'current stack
ItemIndex(111, 8) = 100 'max stack
ItemIndex(111, 9) = 111 'Item ID


ItemName(112, 0) = "Aetherian Opal
ItemName(112, 1) = "Specially engineered gemstone by the aetherian race to produce the absolute best imbuement powers"
ItemIndex(112, 0) = 3 'item type (1 means tool)
ItemIndex(112, 1) = 80   'item texture x cord
ItemIndex(112, 2) = 80 'item texture y cord
ItemIndex(112, 3) = 0 ' 
ItemIndex(112, 4) = 0 '
ItemIndex(112, 5) = 0 '
ItemIndex(112, 6) = 0 '
ItemIndex(112, 7) = 1 'current stack
ItemIndex(112, 8) = 100 'max stack
ItemIndex(112, 9) = 112 'Item ID

'113 imbuement station
ItemName(113, 0) = "Imbuement Station
ItemName(113, 1) = "Placeholder"
ItemIndex(113, 0) = 0 'type
ItemIndex(113, 1) = 128 'ssx
ItemIndex(113, 2) = 64 'ssy
ItemIndex(113, 3) = 24 'tileID
ItemIndex(113, 4) = 1 'layer
ItemIndex(113, 7) = 1 'current stack
ItemIndex(113, 8) = 100 'max stack
ItemIndex(113, 9) = 113 'Item ID


'114 Sandstone
ItemName(114, 0) = "Sandstone Wall
ItemName(114, 1) = "Placeholder"
ItemIndex(114, 0) = 0 'type
ItemIndex(114, 1) = 144 'ssx
ItemIndex(114, 2) = 96 'ssy
ItemIndex(114, 3) = 27'tileID
ItemIndex(114, 4) = 1 'layer
ItemIndex(114, 7) = 1 'current stack
ItemIndex(114, 8) = 100 'max stack
ItemIndex(114, 9) = 114 'Item ID

'115 calcite
ItemName(115, 0) = "Calcite Wall
ItemName(115, 1) = "Placeholder"
ItemIndex(115, 0) = 0 'type
ItemIndex(115, 1) = 160 'ssx
ItemIndex(115, 2) = 96 'ssy
ItemIndex(115, 3) = 28 'tileID
ItemIndex(115, 4) = 1 'layer
ItemIndex(115, 7) = 1 'current stack
ItemIndex(115, 8) = 100 'max stack
ItemIndex(115, 9) = 115 'Item ID

'116 Sand
ItemName(116, 0) = "Sand
ItemName(116, 1) = "Placeholder"
ItemIndex(116, 0) = 0 'type
ItemIndex(116, 1) = 128 'ssx
ItemIndex(116, 2) = 96 'ssy
ItemIndex(116, 3) = 29 'tileID
ItemIndex(116, 4) = 0 'layer
ItemIndex(116, 7) = 1 'current stack
ItemIndex(116, 8) = 100 'max stack
ItemIndex(116, 9) = 116 'Item ID

'117 glass
ItemName(117, 0) = "Glass
ItemName(117, 1) = "Placeholder"
ItemIndex(117, 0) = 0 'type
ItemIndex(117, 1) = 176 'ssx
ItemIndex(117, 2) = 96 'ssy
ItemIndex(117, 3) = 30 'tileID
ItemIndex(117, 4) = 1 'layer
ItemIndex(117, 7) = 1 'current stack
ItemIndex(117, 8) = 100 'max stack
ItemIndex(117, 9) = 117 'Item ID

'118 Iron SCUBA Tool

'119 asphault
ItemName(119, 0) = "Asphault
ItemName(119, 1) = "Placeholder"
ItemIndex(119, 0) = 0 'type
ItemIndex(119, 1) = 192 'ssx
ItemIndex(119, 2) = 96 'ssy
ItemIndex(119, 3) = 31 'tileID
ItemIndex(119, 4) = 0 'layer
ItemIndex(119, 7) = 1 'current stack
ItemIndex(119, 8) = 100 'max stack
ItemIndex(119, 9) = 119 'Item ID

'120 torch
ItemName(120, 0) = "Torch
ItemName(120, 1) = "Placeholder"
ItemIndex(120, 0) = 0 'type
ItemIndex(120, 1) = 208 'ssx
ItemIndex(120, 2) = 96 'ssy
ItemIndex(120, 3) = 43 'tileID
ItemIndex(120, 4) = 1 'layer
ItemIndex(120, 7) = 1 'current stack
ItemIndex(120, 8) = 100 'max stack
ItemIndex(120, 9) = 120 'Item ID

ItemName(121, 0) = "Ice Campfire
ItemName(121, 1) = "Placeholder"
ItemIndex(121, 0) = 0 'type
ItemIndex(121, 1) = 224 'ssx
ItemIndex(121, 2) = 96 'ssy
ItemIndex(121, 3) = 44 'tileID
ItemIndex(121, 4) = 1 'layer
ItemIndex(121, 7) = 1 'current stack
ItemIndex(121, 8) = 100 'max stack
ItemIndex(121, 9) = 121 'Item ID

ItemName(122, 0) = "Coal
ItemName(122, 1) = "Crafting Material"
ItemIndex(122, 0) = 3 'item type (1 means tool)
ItemIndex(122, 1) = 240   'item texture x cord
ItemIndex(122, 2) = 96 'item texture y cord
ItemIndex(122, 3) = 0 ' 
ItemIndex(122, 4) = 0 '
ItemIndex(122, 5) = 0 '
ItemIndex(122, 6) = 0 '
ItemIndex(122, 7) = 1 'current stack
ItemIndex(122, 8) = 100 'max stack
ItemIndex(122, 9) = 122 'Item ID
