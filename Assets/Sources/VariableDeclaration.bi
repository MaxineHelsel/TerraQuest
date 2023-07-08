
'declare variable names and data types
Dim Shared Texture As Texture
Dim Shared File As File
Dim Shared Player As Character
Dim Shared Settings As Settings
Dim Shared Sounds As Sounds
Dim Shared Debug As Debug

'Constants
const TileParameters=17
const InvParameters=13
const EffectParameters=4
const MaxEffects=20
Const MaxCraftLevel = 5
const CreativePages = 10
Const ChatHistory = 1000
Const logparameters = 2



Const EntityID = 0
Const EntityHealth = 1
Const EntitySpeedMod = 2
Const EntityAI = 3
Const EntityX = 4
Const EntityY = 5
Const EntityAction = 6
Const EntityTimerAct = 7
Const EntityVX = 8
Const EntityVY = 9
Const EntityMX = 10 'These 2 values are redundant, could just be calculated if vx and vy != 0
Const EntityMY = 11
Const EntityMaxHealth = 12
Const EntityLX = 13
Const EntityLY = 14
Const EntityTimerDespawn = 15
Const EntityFacing = 16
Const EntitySpOffY = 17

Const TileLayer = 0
Const TileSX = 1
Const TileSY = 2
Const TileItemID = 3

Const TileDataCollision = 0
Const TileDataCastShadow = 1
Const TileDataBlockShadow = 2
Const TileDataIntShadow = 3
Const TileDataResistance = 4
Const TileDataSolid = 5
Const TileDataLightCast = 6
Const TileDataContainer = 7
Const TileDataCraftingLevel = 8
Const TileDataFriction = 9
Const TileDataMaxSpeed = 10




'constants to make code more readable

'things to throw into the include files that im too lazy to do right now
Dim Shared Gen.HeightScale
Dim Shared Gen.TempScale
Dim Shared CurrentDay


Dim Shared ChatLastMessage

Dim Shared ChatLog(ChatHistory, logparameters) As String


Dim Shared RandomTickRate As Integer



Dim Shared TileThermalMap(41, 31)



'Map Variables
Dim Shared GroundTile(41, 31) As Unsigned Integer
Dim Shared WallTile(41, 31) As Unsigned Integer
Dim Shared CeilingTile(41, 31) As Unsigned Integer
Dim Shared TileData(41, 31, tileparameters) As single
Dim Shared SpawnPointX As Single
Dim Shared SpawnPointY As Single
Dim Shared SavePointX As Single
Dim Shared SavePointY As Single
dim shared WeatherCountDown As Long

dim shared Container(20,20,invparameters)
Dim Shared CursorHoverX, CursorHoverY, CursorHoverPage, CursorSelectedX, CursorSelectedY, CursorSelectedPage, CursorMode

Dim Shared ContainerSizeX, ContainerSizeY, ContainerOTU
Dim Shared ContainerParams(4)

dim shared ImmunityFlash as unsigned bit



Dim Shared SavedMapX As Integer64
Dim Shared SavedMapY As Integer64
Dim Shared SpawnMapX As Integer64
Dim Shared SpawnMapY As Integer64

Dim Shared MapX As Integer64
Dim Shared MapY As Integer64

Dim Shared WorldName As String
dim shared WorldSeed as integer64

Dim Shared GlobalLightLevel as byte
dim shared LocalLightLevel(41,31) as byte
dim shared OverlayLightLevel as byte

                                         dim shared GameTime as long
                                         dim shared TimeMode as byte

dim shared ScreenRezX
dim shared ScreenRezY

Dim Shared CurrentTick As Unsigned Integer64

dim shared OGLFPS as single

Dim Shared CameraPositionX As Single
Dim Shared CameraPositionY As Single

Dim Shared KeyPressed As Long

Dim Shared GameMode As Byte
Dim Shared DefaultRenderMode as Byte

Dim Shared Inventory(3, 5,invparameters)
dim shared CreativeInventory(2,5,invparameters,CreativePages)
dim shared CraftingGrid(5, 5,invparameters)
dim shared CraftingResult(invparameters)

                                           dim shared BloodmoonSpawnrate as integer
                                           dim shared EntityNatSpawnLim

Dim Shared Game.Title As String
Dim Shared Game.Version As String
Dim Shared Game.Buildinfo As String
Dim Shared Game.FCV As integer
Dim Shared Game.HostOS As String
Dim Shared Game.Designation As String
Dim Shared Game.32Bit as unsigned bit
dim shared Game.MapProtocol as integer
dim shared Game.ManifestProtocol as integer
dim shared Game.NetPort as integer

Dim Shared perlin_octaves As Single, perlin_amp_falloff As Single

Dim Shared ImmunityTimer
Dim Shared CreativePage As Byte
Dim Shared WorldReadOnly As Byte
Dim Shared HealthWheelOffset
dim shared CurrentDimension as byte

Const EntityLimit = 1560
Const EntityParameters = 20

Dim Shared CurrentEntities
Dim Shared entity(EntityLimit, EntityParameters) as single
dim shared EffectArray(maxeffects,EffectParameters,EntityLimit) as single


'Flags
Dim Shared Flag.DebugMode As Unsigned Bit
Dim Shared Flag.ScreenRefreshSkip As Unsigned Bit
Dim Shared Flag.StillCam As Unsigned Bit
Dim Shared Flag.FullCam As Unsigned Bit
Dim Shared Flag.FreeCam As Unsigned Bit
Dim Shared Flag.NoClip As Unsigned Bit
Dim Shared Flag.FrameRateLock As Unsigned Bit
Dim Shared Flag.HudDisplay As Unsigned Bit
dim shared Flag.InventoryOpen as unsigned bit
dim shared Flag.CastShadows as unsigned bit
dim shared Flag.OpenCommand as byte
dim shared Flag.RenderOverride as unsigned bit
dim shared Flag.InitialRender as byte
dim shared Flag.ContainerOpen as byte
dim shared Flag.FullRender as unsigned bit
dim shared Flag.IsBloodmoon as unsigned bit
dim shared Flag.FadeIn as unsigned bit
dim shared Flag.ExperimentalFeature as unsigned bit


dim shared    PrecipitationLevel as byte
Dim Shared BGDraw As Unsigned Bit
dim shared RenderMode as byte


Dim Shared new As Unsigned Bit 'has not been updated, because might not exist


                             dim shared SwimOffset as byte


Type Debug
    Tracking As String
End Type


Type Virus
    Status As Byte
End Type
Dim Shared Virus As Virus



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
    PlayerSheet as string
    ZombieSheet as string
    DuckSheet as string
    TileSheet As String
    ItemSheet as string
    HudSprites As String
    Shadows As String
    Shadows_Bloodmoon as string
    Precipitation as string
End Type

Type Texture
    PlayerSprites As Long
    PlayerSheet as long
    ZombieSheet as long
    DuckSheet as long
    TileSheet As Long
    ItemSheet as long
    HudSprites As Long
    Shadows As Long
    Shadows_Bloodmoon as long
    Precipitation as long
End Type

Type Sounds
    error As String
    walk_grass as string
    damage_bush as string
    damage_melee as string
    walk_water as string
    bloodmoon_spawn as string
End Type



Type Character
    x As Single
    y As Single
    lastx As Single
    lasty As Single
    vx as single
    vy as single
       name as string
    tile As Byte
    tilefacing As Byte
    facing As Byte
    movingx As Byte
    movingy as byte
    type As Byte
    tilecontact as byte

    CraftingLevel as byte

    MaxHealth as integer
    BodyTemp as byte

    level As Byte
    health As integer
    points As Byte
    experience As Long
    gold As Long

End Type



Type Settings
    FrameRate As Integer
    TickRate As Single
    FullScreen as byte
End Type



