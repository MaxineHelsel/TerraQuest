
'Note: any changes made to this file, and any other source files require a recompile of the game before they are recognized

'Default variables that are required to be set on initial load
Game.Title = "TerraQuest"
Game.Buildinfo = "Beta Version 1.2 Edge Build 230507A
Game.Version = "b1.2-230507A
Game.MapProtocol = 1
Game.ManifestProtocol = 1
Game.Designation = "Edge"
Game.FCV = 1

'Default settings values that are saved on first launch to settings.cdf, and on subsequent launches are loaded from that file
Settings.FrameRate = 60
Settings.TickRate = 1

'File name locations
File.PlayerSprites = "Assets/Sprites/Entities/character.png"
File.PlayerSheet = "Assets/Sprites/Entities/Player.png"
File.ZombieSheet = "Assets/Sprites/Entities/Zombie.png"
File.DuckSheet = "Assets/Sprites/Entities/Duck.png"
File.TileSheet = "Assets/Sprites/Tiles/Tiles.png"
File.ItemSheet = "Assets/Sprites/Items/Items.png"
File.HudSprites = "Assets/Sprites/Other/HUD.png"
File.Shadows = "Assets/Sprites/Other/Shadows.png"
File.Shadows_Bloodmoon = "Assets/Sprites/Other/Shadows-bloodmoon.png"



Sounds.error = "Assets/Sounds/error.wav"
Sounds.walk_grass = "Assets/Sounds/walk_grass.mp3"
Sounds.damage_bush = "Assets/Sounds/damage_bush.mp3"
Sounds.damage_melee = "Assets/Sounds/damage_melee.mp3
Sounds.walk_water = "Assets/Sounds/walk_water.mp3"
Sounds.bloodmoon_spawn = "Assets/Sounds/bloodmoon_spawn.mp3

'Debug values that are only set here for testing purposes
Player.health = 8
Player.MaxHealth = 0
GameMode = 2
Flag.DebugMode = 0
Flag.NoClip = 0
GlobalLightLevel = 12
Flag.RenderOverride = 0
DefaultRenderMode = 2
bloodmoonspawnrate= 5
entitynatspawnlim=15
Dim ii, iii, iiii
For ii = 0 To 3
    For iii = 0 To 5
        For iiii = 0 To 9
            Inventory(ii, iii, iiii) = -1
        Next
    Next
Next



