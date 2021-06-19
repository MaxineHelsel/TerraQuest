$NoPrefix
Option Explicit
On Error GoTo ERRORHANDLER
Randomize Timer
Screen NewImage(641, 481, 32) '40x30
PrintMode KeepBackground
DisplayOrder Hardware , Software
Title "CDF-Quest"

'todo make the number of attributes a constant


'$include: 'Assets\Sources\VariableDeclaration.bi'

'$include: 'Assets\Sources\DefaultValues.bi'

'$include: 'Assets\Sources\TileIndex.bi'

'$include: 'Assets\Sources\InventoryIndex.bi'

'$include: 'Assets\Sources\CreativeInventory.bi'

Dim ii, iii, iiii
For ii = 0 To 3
    For iii = 0 To 5
        For iiii = 0 To 9
            Inventory(ii, iii, iiii) = -1
        Next
    Next
Next

INITIALIZE
'TEMPORARY, MAKE A MENU SUBROUTINE OR SOMETHING
CENTERPRINT "Temporary title screen"
Print
Dim InputString As String
Input "(L)oad world, (C)reate new world: ", InputString
If LCase$(InputString) = "l" Then
    Input "World name"; WorldName
    LOADWORLD
End If
If LCase$(InputString) = "c" Then NewWorld

GoTo game
Error 102
ERRORHANDLER: ERRORHANDLER
game:

Do
    SETBG
    SetMap
    CastShadow
    MOVE
    COLDET
    SPSET
    INTER
    ZOOM
    SetLighting
    HUD
    DEV
    ChangeMap
    DayLightCycle
    KeyPressed = KeyHit
    If Flag.FrameRateLock = 0 Then Limit Settings.FrameRate
    CurrentTick = CurrentTick + Settings.TickRate
    If Flag.ScreenRefreshSkip = 0 Then Display
    Flag.ScreenRefreshSkip = 0
    If Flag.OpenCommand = 1 Then Flag.OpenCommand = 2
    Cls
Loop



Error 102

Sub DayLightCycle
    '86400
    GameTime = GameTime + Settings.TickRate
    If GameTime > 43200 Then GameTime = GameTime - 43200: TimeMode = TimeMode + 1
    If TimeMode > 1 Then TimeMode = 0

    Select Case TimeMode
        Case 0
            GlobalLightLevel = 12
            If GameTime > 38200 Then
                GlobalLightLevel = 12 - (((GameTime - 38200) / 1000)) * 2
            End If
        Case 1
            GlobalLightLevel = 2
            If GameTime > 38200 Then
                GlobalLightLevel = 2 + (((GameTime - 38200) / 1000)) * 2
            End If
    End Select
End Sub

Sub InventoryUI

End Sub

Sub ChangeMap
    Static TickDelay
    Static TotalDelay
    Static LightStep
    If LightStep < 12 Then
        Select Case Player.facing
            Case 0
                If Player.y = 0 And Player.x = Player.lastx And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 1
                If Player.y = 480 - 16 And Player.x = Player.lastx And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 2
                If Player.x = 0 And Player.y = Player.lasty And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 3
                If Player.x = 640 - 16 And Player.y = Player.lasty And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate


        End Select
        If TickDelay = 5 Then TickDelay = 0: LightStep = LightStep + 2
    Else
        SAVEMAP
        Select Case Player.facing
            Case 0
                SavedMapY = SavedMapY - 1
                LOADMAP (SavedMap)
                Player.y = 480
            Case 1
                SavedMapY = SavedMapY + 1
                LOADMAP (SavedMap)
                Player.y = 0
            Case 2
                SavedMapX = SavedMapX - 1
                LOADMAP (SavedMap)
                Player.x = 640
            Case 3
                SavedMapX = SavedMapX + 1
                LOADMAP (SavedMap)
                Player.x = 0
        End Select
        LightStep = 0
    End If

    If Player.moving = 0 Then TickDelay = 0: TotalDelay = 0: LightStep = 0
    OverlayLightLevel = LightStep

    'Print Player.x; Player.y; Player.lasty; Player.moving; Player.facing; TickDelay; Settings.TickRate
End Sub

Sub UpdateTile (TileX, TileY)
    If TileIndexData(GroundTile(TileX, TileY), 0) = 1 Or TileIndexData(WallTile(TileX, TileY), 0) = 1 Then TileData(TileX, TileY, 0) = 1 Else TileData(TileX, TileY, 0) = 0
    If TileIndexData(GroundTile(TileX, TileY), 1) = 1 Or TileIndexData(WallTile(TileX, TileY), 1) = 1 Then TileData(TileX, TileY, 1) = 1 Else TileData(TileX, TileY, 1) = 0
    If TileIndexData(GroundTile(TileX, TileY), 2) = 1 Or TileIndexData(WallTile(TileX, TileY), 2) = 1 Then TileData(TileX, TileY, 2) = 1 Else TileData(TileX, TileY, 2) = 0
    If TileIndexData(GroundTile(TileX, TileY), 3) = 1 And TileIndexData(WallTile(TileX, TileY), 2) = 0 Then TileData(TileX, TileY, 3) = 1 Else TileData(TileX, TileY, 3) = 0
    TileData(TileX, TileY, 4) = TileIndexData(GroundTile(TileX, TileY), 4)
    TileData(TileX, TileY, 5) = TileIndexData(WallTile(TileX, TileY), 4)
    TileData(TileX, TileY, 6) = TileIndexData(CeilingTile(TileX, TileY), 4)
    TileData(TileX, TileY, 7) = TileIndexData(WallTile(TileX, TileY), 5)

End Sub

Sub UseItem (Slot)
    Dim FacingX As Integer
    Dim FacingY As Integer
    Select Case Player.facing
        Case 0
            FacingX = Int((Player.x + 8) / 16) + 1
            FacingY = Int((Player.y + 8 - 16) / 16) + 1
        Case 1
            FacingX = Int((Player.x + 8) / 16) + 1
            FacingY = Int((Player.y + 8 + 16) / 16) + 1
        Case 2
            FacingX = Int((Player.x + 8 - 16) / 16) + 1
            FacingY = Int((Player.y + 8) / 16) + 1
        Case 3
            FacingX = Int((Player.x + 8 + 16) / 16) + 1
            FacingY = Int((Player.y + 8) / 16) + 1
    End Select

    Select Case Inventory(0, Slot, 0)
        Case 0
            Select Case Inventory(0, Slot, 4)
                Case 0
                    GroundTile(FacingX, FacingY) = Inventory(0, Slot, 3)
                    UpdateTile FacingX, FacingY
                Case 1
                    WallTile(FacingX, FacingY) = Inventory(0, Slot, 3)
                    UpdateTile FacingX, FacingY

            End Select
        Case 1
            Select Case Inventory(0, Slot, 5)
                Case 0
                    If TileData(FacingX, FacingY, 4) <= 0 Then
                        GroundTile(FacingX, FacingY) = 0
                        UpdateTile FacingX, FacingY
                    End If
                    TileData(FacingX, FacingY, 4) = TileData(FacingX, FacingY, 4) - Inventory(0, Slot, 6) + TileIndexData(GroundTile(FacingX, FacingY), 4)
                Case 1
                    If TileData(FacingX, FacingY, 5) <= 0 Then
                        WallTile(FacingX, FacingY) = 1
                        UpdateTile FacingX, FacingY
                    End If
                    TileData(FacingX, FacingY, 5) = TileData(FacingX, FacingY, 5) - Inventory(0, Slot, 6) + TileIndexData(WallTile(FacingX, FacingY), 5)

            End Select

    End Select
    If TileData(FacingX, FacingY, 7) = 0 And GroundTile(FacingX, FacingY) = 0 Then
        WallTile(FacingX, FacingY) = 1
        UpdateTile FacingX, FacingY

    End If
End Sub

Sub INTER
    Select Case KeyPressed
        Case 15616
            Flag.DebugMode = Flag.DebugMode + 1
        Case 15104
            Flag.HudDisplay = Flag.HudDisplay + 1
        Case 101
            Flag.InventoryOpen = Flag.InventoryOpen + 1


    End Select
End Sub



Sub SetLighting
    Dim i As Byte
    Dim ii As Byte
    Dim TotalLightLevel
    TotalLightLevel = (GlobalLightLevel - LocalLightLevel(ii, i) - OverlayLightLevel)
    If TotalLightLevel > 12 Then TotalLightLevel = 12
    If TotalLightLevel < 0 Then TotalLightLevel = 0
    For i = 0 To 30
        For ii = 0 To 40
            PutImage (ii * 16, i * 16)-((ii * 16) + 15.75, (i * 16) + 15.75), Texture.Shadows, , (TotalLightLevel * 16, 16)-((16 * TotalLightLevel) + 15, 31)
        Next
    Next
End Sub



Sub HUD
    If Flag.HudDisplay = 0 Then

        Dim tmpheal As Byte
        Dim token As Byte
        Dim hboffset As Byte
        Dim hbpos As Byte
        Static hbhpos As Byte
        Static FlashTimeout As Byte
        Dim hbitemsize As Single
        Dim invrow As Byte
        Dim invoffset As Byte
        Dim invheight As Byte
        Static CreativePage As Byte
        Static ItemSelectX As Byte
        Static ItemSelectY As Byte
        Static hbtimeout As Integer64

        invoffset = 1
        invheight = 5
        hboffset = 1
        token = 1
        hbitemsize = 2

        tmpheal = Player.health

        'Health Display
        While tmpheal > 0
            If tmpheal <= 8 Then
                PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), Texture.HudSprites, , ((tmpheal - 1) * 32, 0)-((tmpheal - 1) * 32 + 31, 31)
            Else
                PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), Texture.HudSprites, , (7 * 32, 0)-(7 * 32 + 31, 31)
            End If
            tmpheal = tmpheal - 8
            token = token + 1
        Wend


        'Hotbar Display
        For hbpos = 0 To 5
            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), CameraPositionY + 68 - 16 - hboffset)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), CameraPositionY + 68 - hboffset), Texture.HudSprites, , (0, 32)-(31, 63)
            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, CameraPositionY + 68 - 16 - hboffset + hbitemsize)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, CameraPositionY + 68 - hboffset - hbitemsize), Texture.ItemSheet, , (Inventory(0, hbpos, 1), Inventory(0, hbpos, 2))-(Inventory(0, hbpos, 1) + 15, Inventory(0, hbpos, 2) + 15)
        Next


        'Inventory Display
        If Flag.InventoryOpen = 1 Then
            For invrow = 0 To 2
                For hbpos = 0 To 5
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (0, 32)-(31, 63)
                    If invrow = ItemSelectY And hbpos = ItemSelectX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32, 32)-(63, 63)
                    Select Case GameMode
                        Case 1
                            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, (CameraPositionY + 68 - 16 - hboffset + hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, (CameraPositionY + 68 - hboffset - hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.ItemSheet, , (CreativeInventory(invrow, hbpos, 1, CreativePage), CreativeInventory(invrow, hbpos, 2, CreativePage))-(CreativeInventory(invrow, hbpos, 1, CreativePage) + 15, CreativeInventory(invrow, hbpos, 2, CreativePage) + 15)
                        Case 2
                            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, (CameraPositionY + 68 - 16 - hboffset + hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, (CameraPositionY + 68 - hboffset - hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.ItemSheet, , (Inventory(1, hbpos + 1, 1), Inventory(1, hbpos + 1, 2))-(Inventory(invrow + 2, hbpos + 1, 1) + 15, Inventory(invrow + 2, hbpos + 1, 2) + 15)
                    End Select
                Next
            Next

            Select Case KeyPressed

                Case 49
                    InvSwap 0, 0, ItemSelectX, ItemSelectY, CreativePage
                Case 50
                    InvSwap 1, 0, ItemSelectX, ItemSelectY, CreativePage
                Case 51
                    InvSwap 2, 0, ItemSelectX, ItemSelectY, CreativePage
                Case 52
                    InvSwap 3, 0, ItemSelectX, ItemSelectY, CreativePage
                Case 53
                    InvSwap 4, 0, ItemSelectX, ItemSelectY, CreativePage
                Case 54
                    InvSwap 5, 0, ItemSelectX, ItemSelectY, CreativePage
                Case 18432
                    ItemSelectY = ItemSelectY + 1
                Case 20480
                    ItemSelectY = ItemSelectY - 1
                Case 19200
                    ItemSelectX = ItemSelectX - 1
                Case 19712
                    ItemSelectX = ItemSelectX + 1

            End Select

            If ItemSelectX > 5 Then ItemSelectX = 0
            If ItemSelectX < 0 Then ItemSelectX = 5
            If ItemSelectY > 2 Then ItemSelectY = 0
            If ItemSelectY < 0 Then ItemSelectY = 2

        End If

        If Flag.InventoryOpen = 0 Then

            If KeyDown(49) Then
                UseItem 0
                hbhpos = 0
                hbtimeout = CurrentTick + 10
                FlashTimeout = 5
            End If
            If KeyDown(50) Then
                UseItem 1
                hbhpos = 1
                hbtimeout = CurrentTick + 10
                FlashTimeout = 5
            End If
            If KeyDown(51) Then
                UseItem 2
                hbhpos = 2
                hbtimeout = CurrentTick + 10
                FlashTimeout = 5
            End If
            If KeyDown(52) Then
                UseItem 3
                hbhpos = 3
                hbtimeout = CurrentTick + 10
                FlashTimeout = 5
            End If
            If KeyDown(53) Then
                UseItem 4
                hbhpos = 4
                hbtimeout = CurrentTick + 10
                FlashTimeout = 5
            End If
            If KeyDown(54) Then
                UseItem 5
                hbhpos = 5
                hbtimeout = CurrentTick + 10
                FlashTimeout = 5
            End If
            If hbtimeout > CurrentTick And FlashTimeout > 0 Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbhpos), (CameraPositionY + 68 - 16 - hboffset))-(CameraPositionX - 72 + 16 + hboffset + (17 * hbhpos), (CameraPositionY + 68 - hboffset)), Texture.HudSprites, , (32, 32)-(63, 63) Else hbtimeout = CurrentTick + 3: FlashTimeout = FlashTimeout - 1
            If FlashTimeout < 0 Then FlashTimeout = 0



        End If
    End If

End Sub

Sub InvSwap (Slot, Mode, ItemSelectX, ItemSelectY, CreativePage)
    'Dim Shared Inventory(3, 5,9) As Integer
    'dim shared CreativeInventory(2,5,9,1)
    Dim i
    For i = 0 To 9
        Select Case Mode
            Case 0
                Swap CreativeInventory(ItemSelectY, ItemSelectX, i, CreativePage), Inventory(0, Slot, i)
            Case 1
                Swap Inventory(ItemSelectY, ItemSelectX, i), Inventory(0, Slot, i)
        End Select
    Next
End Sub




Sub DEV
    If Flag.DebugMode = 1 Then
        PrintMode FillBackground
        Color , RGBA(0, 0, 0, 128)
        Dim comin As String
        Dim dv As Single
        Dim dummystring As String
        Dim databit As Byte
        Dim i, ii As Byte
        Static RenderMode As Byte
        Dim FacingX As Integer
        Dim FacingY As Integer


        Select Case Player.facing
            Case 0
                FacingX = Int((Player.x + 8) / 16) + 1
                FacingY = Int((Player.y + 8 - 16) / 16) + 1
            Case 1
                FacingX = Int((Player.x + 8) / 16) + 1
                FacingY = Int((Player.y + 8 + 16) / 16) + 1
            Case 2
                FacingX = Int((Player.x + 8 - 16) / 16) + 1
                FacingY = Int((Player.y + 8) / 16) + 1
            Case 3
                FacingX = Int((Player.x + 8 + 16) / 16) + 1
                FacingY = Int((Player.y + 8) / 16) + 1
        End Select


        Locate 1, 1
        ENDPRINT "Debug Menu (Press F3 to Close)"
        Print
        ENDPRINT "Version: " + Game.Version
        ENDPRINT "Version Designation: " + Game.Designation
        ENDPRINT "Operating System: " + Game.HostOS
        If RenderMode = 0 Then ENDPRINT "Render Mode: Software"
        If RenderMode = 1 Then ENDPRINT "Render Mode: Hardware Exclusive"
        If RenderMode = 2 Then ENDPRINT "Render Mode: Hardware"
        If Game.32Bit = 1 Then ENDPRINT "32-Bit Compatability Mode"
        Print
        ENDPRINT "Facing tile data:"
        For i = 0 To 9
            dummystring = dummystring + Str$(TileData(FacingX, FacingY, i))
        Next
        ENDPRINT dummystring
        ENDPRINT Str$(GroundTile(FacingX, FacingY)) + Str$(WallTile(FacingX, FacingY)) + Str$(CeilingTile(FacingX, FacingY))
        Print
        ENDPRINT "Flags:"
        If Flag.StillCam = 1 Then ENDPRINT "Still Camera Enabled"
        If Flag.FreeCam = 1 Then ENDPRINT "Free Camera Enabled"
        If Flag.FullCam = 1 Then ENDPRINT "Full Camera Enabled"
        If Flag.NoClip = 1 Then ENDPRINT "No Clip Enabled"
        If bgdraw = 1 Then ENDPRINT "Background Drawing Disabled"
        If Flag.InventoryOpen = 1 Then ENDPRINT "Inventory Open"
        If Flag.CastShadows = 1 Then ENDPRINT "Shadows Disabled"


        Locate 1, 1
        Print Game.Title; " ("; Game.Buildinfo; ")"
        Print
        Print "FPS:" + Str$(FRAMEPS) + " /" + Str$(CurrentTick)
        Print "Window:"; CameraPositionX; ","; CameraPositionY
        Print "Current World: "; WorldName; " (" + SavedMap + ")"
        Print "Current Time:"; GameTime + (TimeMode * 43200)
        Print "Light Level: (G:"; GlobalLightLevel; ", L:"; LocalLightLevel((Player.x + 8) / 16, (Player.y + 8) / 16); ", O:"; OverlayLightLevel; ")"
        Print "Gamemode: ";
        Select Case GameMode
            Case 0
                Print "Legacy Map Editor"
            Case 1
                Print "Creative"
            Case 2
                Print "Survival"
            Case 3
                Print "Combat"
            Case 4
                Print "Hub"
        End Select

        Print
        Print "Data Viewer: ";
        Select Case Debug.Tracking
            Case ""
                Print "None Selected"
                Print "Start tracking an entity to view its data"
            Case "player", "1"
                Print "Player"
                Print "POS:"; Player.x; ","; Player.y; "("; Int((Player.x + 8) / 16) + 1; ","; Int((Player.y + 8) / 16) + 1; ")"
                Print "Facing:"; Player.facing
                Print "Motion:"; Player.moving
                Print "Contacted Tile ID:"; Player.tile; "(" + Hex$(Player.tile) + ")"
                Print "Facing Tile ID:"; Player.tilefacing; "(" + Hex$(Player.tilefacing) + ")"
                Print Player.lastx; Player.lasty
            Case Else
                Print "Unrecognized Tile or Entity"
        End Select

        If KeyDown(47) Then
            Flag.OpenCommand = 1
            If Flag.RenderOverride = 0 Then SwitchRender (0)
        End If

        If Flag.OpenCommand = 2 Then
            KeyClear
            Locate 28, 1: Input "/", comin
            Select Case comin
                Case "teleport", "tp"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Teleport x: ", Player.x
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Teleport y: ", Player.y
                Case "tileport", "tip"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Teleport x: ", dv
                    Player.x = dv * 16
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Teleport y: ", dv
                    Player.y = dv * 16

                Case "stillcam", "sc"
                    Flag.StillCam = Flag.StillCam + 1
                Case "fullcam", "fc"
                    Flag.FullCam = Flag.FullCam + 1
                Case "freecam", "frc"
                    Flag.FreeCam = Flag.FreeCam + 1
                Case "noclip", "nc"
                    Flag.NoClip = Flag.NoClip + 1
                Case "exit"
                    System
                Case "error"
                    Locate 28, 1: Input "Simulate error number: ", dv
                    Error dv
                Case "gamemode", "gm"
                    Locate 28, 1: Input "Change Gamemode to: ", GameMode
                Case "health"
                    Locate 28, 1: Input "Set Health to: ", Player.health
                Case "track", "tr"
                    Locate 28, 1: Print "                               "
                    Locate 28, 1: Input "Track Entity ID or Tile ID: ", Debug.Tracking
                Case "framerate-unlock", "fru"
                    Flag.FrameRateLock = Flag.FrameRateLock + 1
                Case "save"
                    SAVEMAP
                Case "load"
                    Locate 28, 1: Print "                                "
                    Locate 28, 1: Input "Name of Map File to load: ", map.filename
                    LOADMAP (map.filename)
                Case "loadworld"
                    Locate 28, 1: Print "                                "
                    Locate 28, 1: Input "Name of World Folder to load: ", WorldName
                    LOADWORLD
                Case "groundtile", "gt"
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Set GroundTile ID: ", GroundTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1)
                Case "walltile", "wt"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Set WallTile ID: ", WallTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1)
                Case "ceilingtile", "ct"
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Set CeilingTile ID: ", CeilingTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1)
                Case "tiledata", "td"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Select Data Bit: ", databit
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Select Data Value: ", TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, databit)


                Case "bgdraw"
                    bgdraw = bgdraw + 1
                Case "shadowcast", "sh"
                    Flag.CastShadows = Flag.CastShadows + 1
                Case "update", "up"
                    UPDATEMAP

                Case "new"
                    NewWorld

                Case "lightlevel", "ll"
                    Locate 28, 1: Print "                    "
                    Locate 28, 1: Input "Select Light Level  ", GlobalLightLevel
                Case "rendermode", "rm"
                    Locate 28, 1: Print "         "
                    Locate 28, 1: Input "Mode  ", RenderMode
                    If RenderMode = 2 Then Flag.RenderOverride = 0
                    If RenderMode = 0 Then Flag.RenderOverride = 1: SwitchRender (0)
                    If RenderMode = 1 Then Flag.RenderOverride = 1: SwitchRender (1)
                Case "updatemap", "um"
                    For i = 0 To 31
                        For ii = 0 To 41
                            UpdateTile ii, i
                        Next
                    Next
                Case "tickrate", "tk"
                    Locate 28, 1: Print "          "
                    Locate 28, 1: Input "TickRate  ", Settings.TickRate
                Case Else
            End Select
            KeyClear
            Flag.ScreenRefreshSkip = 1
            Flag.OpenCommand = 0
            If Flag.RenderOverride = 0 Then SwitchRender (1)
        End If
        Color , RGBA(0, 0, 0, 0)
        PrintMode KeepBackground
    End If
End Sub


Sub SetMap
    Dim i As Byte
    Dim ii As Byte
    For i = 1 To 30
        For ii = 1 To 40
            PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.TileSheet, , (TileIndex(GroundTile(ii, i), 1), TileIndex(GroundTile(ii, i), 2))-(TileIndex(GroundTile(ii, i), 1) + 15, TileIndex(GroundTile(ii, i), 2) + 15)
            PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.TileSheet, , (TileIndex(WallTile(ii, i), 1), TileIndex(WallTile(ii, i), 2))-(TileIndex(WallTile(ii, i), 1) + 15, TileIndex(WallTile(ii, i), 2) + 15)
            PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.TileSheet, , (TileIndex(CeilingTile(ii, i), 1), TileIndex(CeilingTile(ii, i), 2))-(TileIndex(CeilingTile(ii, i), 1) + 15, TileIndex(CeilingTile(ii, i), 2) + 15)
        Next
    Next
End Sub

Sub CastShadow
    If Flag.CastShadows = 0 Then
        Dim i As Byte
        Dim ii As Byte
        For i = 1 To 30
            For ii = 1 To 40

                If TileData(ii, i + 1, 1) = 1 And TileData(ii, i, 2) = 0 Then
                    PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (0, 0)-(15, 15)
                End If

                If TileData(ii + 1, i, 1) = 1 And TileData(ii, i, 2) = 0 Then
                    PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (16, 0)-(31, 15)
                End If

                If TileData(ii - 1, i, 1) = 1 And TileData(ii, i, 2) = 0 Then
                    PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (32, 0)-(47, 15)
                End If

                If TileData(ii, i - 1, 1) = 1 And TileData(ii, i, 2) = 0 Then
                    PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (48, 0)-(63, 15)
                End If

                If TileData(ii, i, 3) = 1 Then

                    If TileData(ii, i + 1, 3) = 0 Then
                        PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (0, 0)-(15, 15)
                    End If

                    If TileData(ii + 1, i, 3) = 0 Then
                        PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (16, 0)-(31, 15)
                    End If

                    If TileData(ii - 1, i, 3) = 0 Then
                        PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (32, 0)-(47, 15)
                    End If

                    If TileData(ii, i - 1, 3) = 0 Then
                        PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (48, 0)-(63, 15)
                    End If

                End If
            Next
        Next
    End If
End Sub



Sub INITIALIZE

    If DirExists("Assets") Then
        If DirExists("Assets\Sprites") = 0 Then Error 100
        If DirExists("Assets\Sprites\Entities") = 0 Then Error 100
        If DirExists("Assets\Sprites\Items") = 0 Then Error 100
        If DirExists("Assets\Sprites\Other") = 0 Then Error 100
        If DirExists("Assets\Sprites\Tiles") = 0 Then Error 100
        If DirExists("Assets\Music") = 0 Then Error 100
        If DirExists("Assets\Sounds") = 0 Then Error 100
        If DirExists("Assets\Worlds") = 0 Then Error 100
        If DirExists("Assets\SaveData") = 0 Then MkDir "Assets\SaveData": new = 1
    Else Error 100
    End If



    If new = 1 Then SAVESETTINGS
    LOADSETTINGS

    OSPROBE

    SwitchRender (DefaultRenderMode)


End Sub

Sub SwitchRender (mode As Byte)
    Static FirstSkip As Byte
    If mode <> 0 And mode <> 1 Then Exit Sub

    If FirstSkip = 1 Then
        FreeImage Texture.PlayerSprites
        FreeImage Texture.TileSheet
        FreeImage Texture.ItemSheet
        FreeImage Texture.HudSprites
        FreeImage Texture.Shadows
    End If

    Texture.PlayerSprites = LoadImage(File.PlayerSprites, mode + 32)
    Texture.TileSheet = LoadImage(File.TileSheet, mode + 32)
    Texture.ItemSheet = LoadImage(File.ItemSheet, mode + 32)
    Texture.HudSprites = LoadImage(File.HudSprites, mode + 32)
    Texture.Shadows = LoadImage(File.Shadows, mode + 32)
    FirstSkip = 1

End Sub


Sub ERRORHANDLER
    AutoDisplay
    Cls
    PLAYSOUND Sounds.error
    Delay 0.5
    KeyClear
    Locate 1, 1
    CENTERPRINT "CDF ERROR HANDLER"
    Print "Error Code:"; Err
    Locate 2, 1
    ENDPRINT "Error Line:" + Str$(ErrorLine)
    Print "--------------------------------------------------------------------------------"
    Print
    '       PRINT "--------------------------------------------------------------------------------"
    Select Case Err
        Case 100
            Print "Assets folder is incomplete, this error can be triggered by one or more of the"
            Print "following conditions:"
            Print
            Print
            Print "     The assets folder is missing"
            Print
            Print "     Sub-directories in the Assets folder are missing"
            Print
            Print "     The contents of assets, or the directory itself is corrupted"
            Print
            Print "     You do not have proper permissions to access the assets directory"
            Print
            Print
            Print "Make sure the entireity of the assets folder is present and accessible to your"
            Print "user account and, if necessary, redownload the assets folder."
            Print
            Print "The assets folder, and its contents are necessary for the game to load, as it"
            Print "contains all sprite and texture files, sounds and music, user saved data, and"
            Print "world files. Without these, the game will not play correctly. It is advised to"
            Print "not continue."
            CONTPROMPT

        Case 101
            Print "This is a legacy error code, and should never be triggered in game, if it has"
            Print "been triggered, not due to the /error command, please contact the developer"
            CONTPROMPT

        Case 102
            Print "Invalid Code Position, This error occurs when the program flow enters an area"
            Print "that it should not be, This is most likely a programming issue, and not an end"
            Print "user issue."
            Print ""
            Print "There is no user solution to this issue, please file a bug report to the"
            Print "developers, including the line number and what you were doing when it occured."
            CONTPROMPT

        Case 103
            Print "This world was not made for this version of "; Game.Title; ". This means one of"
            Print "the following cases is true:"
            Print
            Print
            Print "     You are attempting to load an out of date world"
            Print
            Print "     You are attempting to load a world designed for a newer version of"
            Print "     "; Game.Title
            Print
            Print "     Your world manifest is corrupted"
            Print
            Print
            Print "Double check the world version and game version."
            Print "World: ("; mapversion; ") Game: ("; Game.Version; ")"
            Print
            Print "If you are certain that this is a mistake, you may try to update the manifest"
            Print "here. Note that this does not update old worlds, just broken manifest files"
            Print "Otherwise you can try to load a different world. "; Game.Title; ""
            Print "does not support loading out of version worlds."
            Print
            Print
            CENTERPRINT "(U)pdate manifest, (R)eturn to existing map, (Q)uit to desktop."
            Do
                If KeyDown(113) Then System
                If KeyDown(114) Then Exit Do
                If KeyDown(117) Then
                    Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
                    Put #1, 3, Game.Version
                    Close #1

                    Exit Do

                End If
            Loop


        Case Else
            Print "Unrecognized error, contact developers"
            CONTPROMPT

    End Select

    KeyClear
    Cls
    Resume Next
End Sub

Sub CONTPROMPT
    Print
    Print

    CENTERPRINT "(I)gnore this error and continue anyway, (Q)uit to desktop"
    Do
        If KeyDown(113) Then System
        If KeyDown(105) Then Exit Do
    Loop
End Sub





Sub SETBG
    If bgdraw = 0 Then
        Dim i As Byte
        Dim ii As Byte
        For i = 0 To 30
            For ii = 0 To 40
                PutImage (ii * 16, i * 16)-((ii * 16) + 15.75, (i * 16) + 15.75), Texture.TileSheet, , (16, 0)-(31, 15)
            Next
        Next
    End If
End Sub







Sub NewWorld
    Dim i, ii, iii
    Cls
    KeyClear
    AutoDisplay
    Input "World Name?", WorldName
    'Input "World Seed?", WorldSeed
    'Randomize WorldSeed
    SavedMapX = 0
    SavedMapY = 0
    Player.x = 320
    Player.y = 200
    GenerateMap
    SAVEMAP
    LOADWORLD
End Sub

Sub GenerateMap
    Dim i, ii, iii
    For i = 0 To 31
        For ii = 0 To 41
            GroundTile(ii, i) = 2
            WallTile(ii, i) = 1
            CeilingTile(ii, i) = 1
            If CInt(Rnd * 10) = 5 Then WallTile(ii, i) = 5
            UpdateTile ii, i
        Next
    Next
End Sub


Sub SAVESETTINGS

    Open "Assets\SaveData\Settings.cdf" As #1
    Put #1, 1, Settings.FrameRate
    Put #1, 2, Settings.TickRate
    Close #1

End Sub




Sub LOADSETTINGS

    Open "Assets\SaveData\Settings.cdf" As #1
    Get #1, 1, Settings.FrameRate
    Get #1, 2, Settings.TickRate
    Close #1

End Sub

Function SavedMap$
    SavedMap = Str$(SavedMapX) + Str$(SavedMapY)
End Function

Function SpawnMap$
    SpawnMap = Str$(SpawnMapX) + Str$(SpawnMapY)
End Function



Sub LOADWORLD
    Dim defaultmap As String

    prevfolder = map.foldername


    Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1

    Get #1, 1, GameTime

    Get #1, 3, mapversion
    If mapversion <> Game.Version Then
        Close #1
        Error 103
    End If

    Get #1, 5, SpawnPointX
    Get #1, 6, SpawnPointY
    Get #1, 7, SavePointX
    Get #1, 8, SavePointY
    Get #1, 9, SavedMapX
    Get #1, 10, SavedMapY
    Get #1, 11, SpawnMapX
    Get #1, 12, SpawnMapY

    Player.x = SavePointX
    Player.y = SavePointY

    'GET #1, 4, map.protected
    Close #1
    LOADMAP (SavedMap)
End Sub


Sub LOADMAP (file As String)
    Dim i, ii As Byte
    Dim iii As Integer
    Dim iiii As Byte

    iii = 1


    'TODO add error checking to see if map file exists

    'TODO make this a sub with 2 parameters, 1
    If FileExists("Assets\Worlds\" + WorldName + "\Maps\" + file + ".cdf") Then
        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-0.cdf" As #1
        For i = 1 To 30
            For ii = 1 To 40
                Get #1, iii, GroundTile(ii, i)
                iii = iii + 1
            Next
        Next
        Close #1
        iii = 1

        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-1.cdf" As #1
        For i = 1 To 30
            For ii = 1 To 40
                Get #1, iii, WallTile(ii, i)
                iii = iii + 1
            Next
        Next
        Close #1
        iii = 1


        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-2.cdf" As #1
        For i = 1 To 30
            For ii = 1 To 40
                Get #1, iii, CeilingTile(ii, i)
                iii = iii + 1
            Next
        Next
        Close #1
        iii = 1


        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-3.cdf" As #1
        For i = 1 To 30
            For ii = 1 To 40
                For iiii = 0 To 9
                    Get #1, iii, TileData(ii, i, iiii)
                    iii = iii + 1
                Next

            Next
        Next
        Get #1, iii, map.name
        Close #1
        iii = 1

        Open "Assets\Worlds\" + WorldName + "\Maps\GlobalData.cdf" As #1
        Close #1
    Else
        GenerateMap
        SAVEMAP
    End If

End Sub


Sub SAVEMAP
    Dim i, ii, iiii As Byte
    Dim iii As Integer
    Dim defaultmap As String
    Dim temppw As String
    Dim new As Byte
    iii = 1
    'update this
    If DirExists("Assets\Worlds\" + WorldName) = 0 Then
        MkDir "Assets\Worlds\" + WorldName: new = 1
        MkDir "Assets\Worlds\" + WorldName + "\Maps"
    End If


    Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
    If new = 0 Then
    End If


    SavePointX = Player.x
    SavePointY = Player.y
    If TimeMode = 1 Then GameTime = GameTime + 43200
    Put #1, 1, GameTime

    Put #1, 3, Game.Version

    Put #1, 5, SpawnPointX
    Put #1, 6, SpawnPointY
    Put #1, 7, SavePointX
    Put #1, 8, SavePointY
    Put #1, 9, SavedMapX
    Put #1, 10, SavedMapY
    Put #1, 11, SpawnMapX
    Put #1, 12, SpawnMapY

    If TimeMode = 1 Then GameTime = GameTime - 43200



    Close #1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-0.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            Put #1, iii, GroundTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-1.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            Put #1, iii, WallTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-2.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            Put #1, iii, CeilingTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-3.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            For iiii = 0 To 9
                Put #1, iii, TileData(ii, i, iiii)
                iii = iii + 1
            Next
        Next
    Next
    Put #1, iii, map.name
    Close #1
    iii = 1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + ".cdf" As #1: Close #1





    badpw:
End Sub

Sub UPDATEMAP
    Dim i, ii As Byte
    Dim iii As Integer
    iii = 1

    If DirExists("Assets\Worlds\" + map.foldername) = 0 GoTo badpw
    If DirExists("Assets\Worlds\" + map.foldername + "\Maps") = 0 GoTo badpw


    Open "Assets\Worlds\" + map.foldername + "\Maps\" + map.filename + ".cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            '    PUT #1, iii, tile(ii, i)
            iii = iii + 1
        Next
    Next
    Put #1, iii, map.name
    Close #1
    badpw:

End Sub





'$include: 'Assets\Sources\Initialization.bm'
'$include: 'Assets\Sources\FileAccess.bm'
'$include: 'Assets\Sources\TextControl.bm'
'$include: 'Assets\Sources\ErrorHandler.bm'
'$include: 'Assets\Sources\FrameRate.bm'
'$include: 'Assets\Sources\OsProbe.bm'
'$include: 'Assets\Sources\CollisionDetection.bm'
'$include: 'Assets\Sources\SpriteAnimation.bm'
'$include: 'Assets\Sources\PlayerControl.bm'
'$include: 'Assets\Sources\MapDraw.bm'
'$include: 'Assets\Sources\ScreenZoom.bm'
'$include: 'Assets\Sources\AudioControl.bm'



