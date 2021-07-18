'Note: any changes made to this file, and any other source files require a recompile of the game before they are recognized

'Default variables that are required to be set on initial load
Game.Title = "CDF-Quest"
Game.Buildinfo = "Survival Test"
Game.Version = "Alpha Version 21"
Game.Designation = "Edge"

'Default settings values that are saved on first launch to settings.cdf, and on subsequent launches are loaded from that file
Settings.FrameRate = 60
Settings.TickRate = 1

'File name locations
File.PlayerSprites = "Assets\Sprites\Entities\character.png"
File.TileSheet = "Assets\Sprites\Tiles\Tiles.png"
File.ItemSheet = "Assets\Sprites\Items\Items.png
File.HudSprites = "Assets\Sprites\Other\HUD.png"
File.Shadows = "Assets\Sprites\Other\Shadows.png"

Sounds.error = "Assets\Sounds\error.wav"

'Debug values that are only set here for testing purposes
Player.health = 8
GameMode = 2
Flag.DebugMode =1
Flag.NoClip = 0
GlobalLightLevel = 12
flag.renderoverride=0
defaultrendermode=2
      Dim ii, iii, iiii
For ii = 0 To 3
    For iii = 0 To 5
        For iiii = 0 To 9
            Inventory(ii, iii, iiii) = -1
        Next
    Next
Next




