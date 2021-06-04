Dim Shared TileIndex(1000, 9)
Dim Shared TileIndexData(1000, 8)
Dim Shared TileName(1000, 3) As String

TileName(0, 0) = "Grass" 'Name of the tile
TileName(0, 1) = "placeholderplaceholderplaceholder" 'tooltip
TileIndex(0, 0) = 0 'layer definition
TileIndex(0, 1) = 0 'x position on tilesheet
TileIndex(0, 2) = 0 'y position on tilesheet
TileIndexData(0, 0) = 0 'collision
TileIndexData(0, 1) = 0 'casts shadow
TileIndexData(0, 2) = 0 'blocks shadow

TileName(1, 0) = "Wood Wall" 'Name of the tile
TileName(1, 1) = "placeholderplaceholderplaceholder" 'tooltip
TileIndex(1, 0) = 1 'layer definition
TileIndex(0, 1) = 16 'x position on tilesheet
TileIndex(0, 2) = 0 'y position on tilesheet
TileIndexData(1, 0) = 1 'collision
TileIndexData(1, 1) = 1 'casts shadow
TileIndexData(1, 2) = 1 'blocks shadow



