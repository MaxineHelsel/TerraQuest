
'declare variable names and data types
Dim Shared Texture As Texture
Dim Shared File As File
Dim Shared Player As Character
Dim Shared Settings As Settings
Dim Shared Sounds As Sounds
Dim Shared Debug As Debug


'Map Variables
Dim Shared GroundTile(41, 31) As Unsigned Integer
Dim Shared WallTile(41, 31) As Unsigned Integer
Dim Shared CeilingTile(41, 31) As Unsigned Integer
Dim Shared TileData(41, 31, 8) As Unsigned Byte
Dim Shared SpawnPointX As Single
Dim Shared SpawnPointY As Single
Dim Shared SavePointX As Single
Dim Shared SavePointY As Single



Dim Shared SavedMapX As Integer64
Dim Shared SavedMapY As Integer64
Dim Shared SpawnMapX As Integer64
Dim Shared SpawnMapY As Integer64

Dim Shared MapX As Integer64
Dim Shared MapY As Integer64

Dim Shared WorldName As String



Dim Shared CurrentTick As Unsigned Integer64

Dim Shared CameraPositionX As Single
Dim Shared CameraPositionY As Single

Dim Shared KeyPressed As Long

Dim Shared GameMode As Byte

Dim Shared Inventory(4, 6) As Integer

Dim Shared Game.Title As String
Dim Shared Game.Version As String
Dim Shared Game.Buildinfo As String
Dim Shared Game.HostOS As String
Dim Shared Game.Designation As String
Dim Shared Game.32Bit as unsigned bit



'Flags
Dim Shared Flag.DebugMode As Unsigned Bit
Dim Shared Flag.ScreenRefreshSkip As Unsigned Bit
Dim Shared Flag.StillCam As Unsigned Bit
Dim Shared Flag.FullCam As Unsigned Bit
Dim Shared Flag.FreeCam As Unsigned Bit
Dim Shared Flag.NoClip As Unsigned Bit
Dim Shared Flag.FrameRateLock As Unsigned Bit
Dim Shared Flag.HudDisplay As Unsigned Bit
Dim Shared bgdraw As Unsigned Bit


Dim Shared new As Unsigned Bit 'has not been updated, because might not exist





Type Debug
    Tracking As String
End Type





Dim Shared map.name As String
Dim Shared map.theme As Byte
Dim Shared map.foldername As String
Dim Shared map.filename As String
Dim Shared map.worldname As String
Dim Shared theme As Long
Dim Shared mapversion As String
Dim Shared prevfolder As String 'temp


Type File
    PlayerSprites As String
    GrassTiles As String
    SnowTiles As String
    InteriorTiles As String
    HudSprites As String
    Shadows As String
End Type

Type Texture
    PlayerSprites As Long
    GrassTiles As Long
    SnowTiles As Long
    InteriorTiles As Long
    HudSprites As Long
    Shadows As Long
End Type

Type Sounds
    error As String
End Type



Type Character
    x As Single
    y As Single
    lastx As Single
    lasty As Single

    tile As Byte
    tilefacing As Byte
    facing As Byte
    moving As Byte
    type As Byte

    level As Byte
    health As Byte
    points As Byte
    experience As Long
    gold As Long

End Type



Type Settings
    FrameRate As Integer
    TickRate As Single
End Type



