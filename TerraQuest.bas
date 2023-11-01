$NoPrefix
Option Explicit
On Error GoTo ERRORHANDLE
Randomize Using Timer
Screen NewImage(641, 481, 32) '40x30
PrintMode KeepBackground
DisplayOrder Hardware , Software
Title "TerraQuest"

'$include: 'Assets\Sources\VariableDeclaration.bi'

'$include: 'Assets\Sources\DefaultValues.bi'

'$include: 'Assets\Sources\TileIndex.bi'

'$include: 'Assets\Sources\InventoryIndex.bi'

'$include: 'Assets\Sources\CreativeInventory.bi'

'$include: 'Assets\Sources\SplashText.bi'

Game.Title = "TerraQuest"
Game.Buildinfo = "Beta 1.3 Edge Build 231101A"
Game.Version = "B1.3-231101A"
Game.MapProtocol = 1
Game.ManifestProtocol = 1
Game.Designation = "Edge"
Game.FCV = 1
Game.NetPort = 46290

Dim Shared RefreshOpt As Byte
Dim Shared CurrentRefresh As Byte
Dim Shared ForcedWindowed As Byte

Dim Shared Flag.FullBright As Unsigned Bit
'parse command line arguments
Select Case LCase$(Command$)
    Case "windowed"
        ForcedWindowed = 1
    Case "server"
        ServerInit
        ServerLoop
        End
    Case "server-headless"
        Print "Headless server mode is not supported yet, please use 'server' argument to start in server mode"
        End
    Case "software"
        DefaultRenderMode = 0
        Flag.RenderOverride = 1
    Case "experimental"
        Flag.ExperimentalFeature = 1
End Select

Flag.ExperimentalFeature = 0

temptitle:
INITIALIZE
If Flag.ExperimentalFeature = 0 Then GoTo oldtitle
Do
    Dim Selected
    Cls
    Selected = Menu(0)
    Display
    Select Case Selected
        Case 0
        Case 1
            GoTo oldtitle
        Case 3
            GoTo Settings
    End Select
Loop
Error 102
Settings:
Do
    Cls
    Selected = Menu(1)
    Display
    Select Case Selected
        Case 0
        Case 1

        Case 2
        Case 6
            GoTo oldtitle
    End Select
Loop

oldtitle:
While InKey$ <> "": Wend
'TitleScreen
'TEMPORARY, MAKE A MENU SUBROUTINE OR SOMETHING
CENTERPRINT "Temporary title screen"
CENTERPRINT Game.Buildinfo
Print
Dim InputString As String
Input "(L)oad world, (C)reate new world, (H)ost network game, (J)oin network game, (V)iew WIP Title Screen: ", InputString

Select Case LCase$(InputString)
    Case "l"
        Input "World name"; WorldName
        LOADWORLD

    Case "c"
        NewWorld
        For i = 0 To 31
            For ii = 0 To 41
                UpdateTile ii, i
            Next
        Next

    Case "h"
    Case "j"
    Case "v"
        TitleScreen
    Case Else
        GoTo temptitle
End Select

SpreadLight (1)

GoTo game

Error 102


ERRORHANDLE:
ErrorHandler
Resume Next

DisplayOrder GLRender , Hardware , Software
game:
KeyClear

If DefaultRenderMode = 2 Then
    SwitchRender 0 'these 2 statements are important to prevent a dumb bug
    SwitchRender 1
End If
Flag.FadeIn = 1
Do
    For i = 0 To CurrentEntities
        OnTopEffect i
        InSideEffect i
        UnderEffect i
        Effects 0, "", i
    Next
    If CurrentRefresh <= 0 Then SetBG
    If CurrentRefresh <= 0 Then SetMap
    If CurrentRefresh <= 0 Then CastShadow
    Move
    COLDET (0)
    If CurrentRefresh <= 0 Then RenderEntities (1)
    Entities (0)
    Entities (1)
    TileTickUpdates
    RandomUpdates
    DelayUpdates
    SpreadHeat
    Precip2
    If CurrentRefresh <= 0 Then SetLighting
    INTER
    Hud2
    ContainerUpdate
    ZOOM
    DEV
    ChangeMap 0, 0, 0
    DayLightCycle
    MinMemFix
    GameChat

    If Player.health <= 0 Then Respawn
    If Flag.FadeIn = 1 Then FadeIn
    If WithinBounds = 1 Then
        If TileIndexData(WallTile(FacingX, FacingY), 8) > 0 Then Player.CraftingLevel = TileIndexData(WallTile(FacingX, FacingY), 8) Else Player.CraftingLevel = 2
    End If

    KeyPressed = KeyHit
    If Flag.FrameRateLock = 0 Then Limit Settings.FrameRate
    CurrentTick = CurrentTick + Settings.TickRate
    If Flag.ScreenRefreshSkip = 0 Then
        If CurrentRefresh <= 0 Then
            Display
            CurrentRefresh = RefreshOpt
        Else
            CurrentRefresh = CurrentRefresh - 1
        End If
    End If
    Flag.ScreenRefreshSkip = 0
    If Flag.OpenCommand = 1 Then
        DisplayOrder Hardware , Software
        Flag.OpenCommand = 2
    End If
    If Flag.OpenCommand = 0 Then DisplayOrder GLRender , Hardware , Software
    Cls
Loop

Error 102

Sub ServerInit
    INITIALIZE
End Sub
Sub ServerLoop
End Sub


Sub Textbox (Diag, Opt)
    Dim BoxW
    Dim BoxH

    Dim BoxOffW
    Dim BoxOffH

    Dim W
    Dim H

    'set center dialog box size
    Select Case Diag
        Case 0
            BoxH = 7
            BoxW = 16
        Case 1
            BoxH = 7
            BoxW = 16

    End Select

    'draw box outline
    For W = 0 To BoxW
        If W = 0 Then
            BoxOffW = 0
        ElseIf W = BoxW Then
            BoxOffW = 2
        Else
            BoxOffW = 1
        End If
        For H = 0 To BoxH
            If H = 0 Then
                BoxOffH = 0
            ElseIf H = BoxH Then
                BoxOffH = 2
            Else
                BoxOffH = 1
            End If

            PutImage (CameraPositionX - BoxW * 8, CameraPositionY - BoxH * 8), Texture.HudSprites, , (128 + (BoxW * 8), 0 + (BoxH * 8))-(8 + 128 + (BoxW * 8), 8 + 0 + (BoxH * 8))

        Next
    Next


    Locate (ScreenRezY / 8 / 4) - (BoxH / 2), 1
    Select Case Diag
        Case 0
            CENTERPRINT DiagSel(1, Opt) + "Single Player"
            Print
            CENTERPRINT DiagSel(2, Opt) + "Multi Player"
            Print
            CENTERPRINT DiagSel(3, Opt) + "Settings"


        Case 1
            CENTERPRINT DiagSel(1, Opt) + "Resolution: (" + LTrim$(Str$(ScreenRezX)) + "x" + LTrim$(Str$(ScreenRezY)) + ")"
            Print
            Select Case RenderMode
                Case 0
                    CENTERPRINT DiagSel(2, Opt) + "Hardware Accelerated Rendering: Disabled"
                Case 1
                    CENTERPRINT DiagSel(2, Opt) + "Hardware Accelerated Rendering: Exclusive"
                Case 2
                    CENTERPRINT DiagSel(2, Opt) + "Hardware Accelerated Rendering: Enabled"
            End Select
            Print
            CENTERPRINT DiagSel(3, Opt) + "Fullscreen: Enabled"
            Print
            CENTERPRINT DiagSel(4, Opt) + "Game Tick Rates: TTS:1 RTS:5 "
            Print
            CENTERPRINT DiagSel(5, Opt) + "Sprite Packs"
            Print
            Print
            Print
            CENTERPRINT DiagSel(6, Opt) + "Main Menu"



    End Select
    Display
End Sub

Sub PauseMenu
    Dim Selected
    While InKey$ <> "": Wend
    '    If Flag.RenderOverride = 0 Then SwitchRender (0)
    Do


        '      Selected = Menu(2)
        Select Case Selected
            Case 0
            Case 1

            Case 3

        End Select


        If KeyHit = 27 Then Exit Do
    Loop
    '   SwitchRender (RenderMode)
End Sub


Function DiagSel$ (Cur, Hil)
    If Cur = Hil Then DiagSel = "" Else DiagSel = " "
End Function

Function Menu (MenuNum)
    Static HighlightedOption
    Dim i
    Dim OptCount
    Menu = 0
    Static SplashText, fh
    If fh = 0 Then
        SplashText = Int(Rnd * SplashCount)
        fh = 1
    End If

    Select Case MenuNum
        Case 0 ' Title Screen
            'put title screen icon
            ENDPRINT "(" + Splash(SplashText) + " Edition!)"
            Locate 2, 1
            CENTERPRINT "Terraquest " + Game.Buildinfo
            'put splash text
            'Draw Options buttons

            Textbox 0, HighlightedOption
            OptCount = 3
        Case 1
            'put title screen icon
            ENDPRINT "(" + Splash(SplashText) + " Edition!)"
            Locate 2, 1
            CENTERPRINT "Terraquest " + Game.Buildinfo
            Print
            CENTERPRINT "Settings"
            'put splash text
            'Draw Options buttons

            Textbox 1, HighlightedOption
            OptCount = 5

    End Select
    'check for key input if options is more than 1
    If InventorySelect Then Menu = HighlightedOption
    If InventoryUp Then HighlightedOption = HighlightedOption - 1
    If InventoryDown Then HighlightedOption = HighlightedOption + 1
    If InventoryLeft Then HighlightedOption = HighlightedOption - 1
    If InventoryRight Then HighlightedOption = HighlightedOption + 1
    If HighlightedOption < 1 Then HighlightedOption = OptCount
    If HighlightedOption > OptCount Then HighlightedOption = 1




    'if enter is pressed, then return option number, starting at 1, otherwise return 0
End Function

Sub CENTERPRINT (nam$)
    _PrintMode _KeepBackground
    Dim i As _Byte
    For i = 0 To Int((ScreenRezX / 8 / 2) - (Len(nam$) / 2) - 1)
        Print " ";
    Next
    _PrintMode _FillBackground
    Print nam$
End Sub

Sub ENDPRINT (nam$)
    _PrintMode _KeepBackground
    Dim i As Integer
    For i = 0 To Int((ScreenRezX / 8) - (Len(nam$))) - 1
        Print " ";
    Next
    _PrintMode _FillBackground
    Print nam$
End Sub



Sub TileTickUpdates
    Static WaterDelay
    Dim i, ii
    For i = 1 To 30
        For ii = 1 To 40
            Select Case GroundTile(ii, i)
                Case 13
                    If GroundTile(ii - 1, i) = 0 Then GroundTile(ii - 1, i) = 13: UpdateTile ii - 1, i
                    If GroundTile(ii + 1, i) = 0 Then GroundTile(ii + 1, i) = 13: UpdateTile ii + 1, i
                    If GroundTile(ii, i + 1) = 0 Then GroundTile(ii, i + 1) = 13: UpdateTile ii, i + 1
                    If GroundTile(ii, i - 1) = 0 Then GroundTile(ii, i - 1) = 13: UpdateTile ii, i - 1
            End Select
            Select Case WallTile(ii, i)
            End Select
            Select Case CeilingTile(ii, i)
            End Select
        Next
    Next
End Sub

Sub RandomUpdates

    Static TileCountDown As Long
    Static WaterSpreadCountDown As Long
    Static LongTimeOut As Long
    Static PriorCheck(40, 30)
    Static TileTimeOut
    Dim i, ii
    Dim Rx, Ry As Byte

    ' Const EggplantLTB = 0.35
    'weather
    If WeatherCountDown < 0 Then
        WeatherCountDown = Int(Rnd * 1000000)
        Select Case Int(Rnd * 100)
            Case Is > 50
                PrecipitationLevel = 0
            Case Is < 25
                PrecipitationLevel = 1
            Case Else
                PrecipitationLevel = 2
        End Select

    Else
        WeatherCountDown = WeatherCountDown - RandomTickRate
    End If
    'tile updates
    Do
        Rx = Int(Rnd * 41)
        Ry = Int(Rnd * 31)
        If TileTimeOut = 15 Then
            For ii = 0 To 41
                For i = 0 To 31
                    PriorCheck(ii, i) = 0
                    Exit Do
                Next
            Next
        End If
        TileTimeOut = TileTimeOut + 1
    Loop Until PriorCheck(Rx, Ry) = 0
    PriorCheck(Rx, Ry) = 1
    TileTimeOut = 0


    'delayed tile updates
    If LongTimeOut < 0 Then
        Select Case WallTile(Rx, Ry)
            Case 32
                If LocalTemperature(Rx, Ry) > 0.35 And LocalTemperature(Rx, Ry) < 0.70 Then WallTile(Rx, Ry) = 33
            Case 33
                If LocalTemperature(Rx, Ry) > 0.35 And LocalTemperature(Rx, Ry) < 0.70 Then WallTile(Rx, Ry) = 34
            Case 34
                If LocalTemperature(Rx, Ry) > 0.35 And LocalTemperature(Rx, Ry) < 0.70 Then WallTile(Rx, Ry) = 35
        End Select

        Select Case GroundTile(Rx, Ry)
            Case 4
                If LocalTemperature(Rx, Ry) > 0.3 Then
                    'make only target within bounds
                    If Rx > 0 And Rx < 41 And Ry > 0 And Ry < 31 Then 'to ensure that this doesnt test for out of map tiles
                        If WallTile(Rx, Ry) = 1 Then 'to ensure there is air above
                            If GroundTile(Rx - 1, Ry) = 2 Or GroundTile(Rx + 1, Ry) = 2 Or GroundTile(Rx, Ry - 1) = 2 Or GroundTile(Rx, Ry + 1) = 2 Then GroundTile(Rx, Ry) = 2
                        End If
                    End If
                End If
            Case 3
                If LocalTemperature(Rx, Ry) > 0.3 Then GroundTile(Rx, Ry) = 2
        End Select
        LongTimeOut = 500
    End If


    'quick tile updates

    Select Case GroundTile(Rx, Ry)
        Case 13
            If LocalTemperature(Rx, Ry) < 0.30 Then GroundTile(Rx, Ry) = 14
        Case 14
            If LocalTemperature(Rx, Ry) > 0.30 Then GroundTile(Rx, Ry) = 13
    End Select


    LongTimeOut = LongTimeOut - RandomTickRate
    TileCountDown = TileCountDown - RandomTickRate
    UpdateTile Rx, Ry

End Sub

Sub DelayUpdates
    Static DelayTimer
    Select Case LocalTemperature(PlayerTileX, PlayerTileY)
        Case Is < 0
            Effects 1, "Temperature Freezing", 0
        Case Is > 1
            Effects 1, "Temperature Burning", 0
    End Select
End Sub

Function PlayerTileX
    PlayerTileX = (Int((Player.x + 8) / 16) + 1)
End Function
Function PlayerTileY
    PlayerTileY = (Int((Player.y + 8) / 16) + 1)
End Function

Function MapSeed
    MapSeed = Perlin((SavedMapX * 40) / Gen.HeightScale, (SavedMapY * 30) / Gen.HeightScale, 0, WorldSeed)
End Function

Function BiomeTemperature (Tx, Ty)
    BiomeTemperature = Perlin((Tx + SavedMapX * 40) / Gen.TempScale, (Ty + SavedMapY * 30) / Gen.TempScale, 0, MapSeed)
End Function

Function LocalTemperature (Tx, Ty)
    LocalTemperature = BiomeTemperature(Tx, Ty) + SeasonalOffset + TODoffset + TileThermalOffset(Tx, Ty)
End Function

Function NaturalTemperature (tx, ty)
    NaturalTemperature = BiomeTemperature(tx, ty) + SeasonalOffset + TODoffset
End Function
Function TODoffset
    If TimeMode = 0 Then TODoffset = 0.05 * Sin(2 * Pi * (GameTime + 5000) * (1 / 86400))
    If TimeMode = 1 Then TODoffset = 0.05 * Sin(2 * Pi * (GameTime + 5000) * (1 / 86400)) * -1
End Function

Function SeasonalOffset
    SeasonalOffset = 0.4 * Sin(2 * Pi * CurrentDay * (1 / 120)) - 0.1
End Function

Function TileThermalOffset (Tx, Ty)
    TileThermalOffset = TileThermalMap(Tx, Ty)
End Function



Sub SpreadHeat
    Dim As Byte i, ii
    Static LagDelay

    LagDelay = LagDelay + 1
    If LagDelay > 30 Then LagDelay = 0
    If LagDelay <> 15 Then Exit Sub

    For i = 1 To 30
        For ii = 1 To 40
            TileThermalMap(ii, i) = 0
            TileThermalMap(ii, i) = TileData(ii, i, 16)
        Next
    Next
    SpreadHeat2 (1)
End Sub
Sub SpreadHeat2 (updates)
    Dim As Byte i, ii, iii, iiii
    Static UpdateLimit
    If updates > 0 Then
        updates = 0
        For i = 1 To 30
            For ii = 1 To 40
                iiii = 1
                iii = 0

                If TileThermalMap(ii, i) < 0 Then
                    For iii = 0 To 2

                        If TileThermalMap(ii, i) > TileThermalMap(ii + (iii - 1), i) Then TileThermalMap(ii, i) = TileThermalMap(ii + (iii - 1), i) + 0.01
                        If TileThermalMap(ii, i) > TileThermalMap(ii + (iii - 1), i + (iiii - 1)) + 0.02 Then updates = updates + 1
                    Next

                    iiii = 0
                    iii = 1
                    For iiii = 0 To 2
                        If TileThermalMap(ii, i) > TileThermalMap(ii, i + (iiii - 1)) Then TileThermalMap(ii, i) = TileThermalMap(ii, i + (iiii - 1)) + 0.01

                        If TileThermalMap(ii, i) > TileThermalMap(ii + (iii - 1), i + (iiii - 1)) + 0.02 Then updates = updates + 1
                    Next

                End If
                If TileThermalMap(ii, i) >= 0 Then
                    For iii = 0 To 2

                        If TileThermalMap(ii, i) < TileThermalMap(ii + (iii - 1), i) Then TileThermalMap(ii, i) = TileThermalMap(ii + (iii - 1), i) - 0.01
                        If TileThermalMap(ii, i) < TileThermalMap(ii + (iii - 1), i + (iiii - 1)) - 0.02 Then updates = updates + 1
                    Next

                    iiii = 0
                    iii = 1
                    For iiii = 0 To 2
                        If TileThermalMap(ii, i) < TileThermalMap(ii, i + (iiii - 1)) Then TileThermalMap(ii, i) = TileThermalMap(ii, i + (iiii - 1)) - 0.01

                        If TileThermalMap(ii, i) < TileThermalMap(ii + (iii - 1), i + (iiii - 1)) - 0.02 Then updates = updates + 1
                    Next
                End If
                'LocalLightLevel(ii, i) = TileData(ii, i, 8)
            Next
        Next
        If updates = 0 Then UpdateLimit = UpdateLimit + 1: updates = 1
        If UpdateLimit > 10 Then updates = 0
        ' Print updates, UpdateLimit
        ' Display
        ' Sleep

        SpreadHeat2 (updates)
    Else
        UpdateLimit = 0
    End If
End Sub

Sub spreadlightd (fuck)

End Sub

Sub SpreadLight (updates)

    Dim As Byte i, ii
    For i = 1 To 30
        For ii = 1 To 40
            LocalLightLevel(ii, i) = TileData(ii, i, 8)
        Next
    Next
    SpreadLight2 (updates)
End Sub
Sub SpreadLight2 (updates)
    Dim As Byte i, ii, iii, iiii
    Static UpdateLimit
    If updates > 0 Then
        updates = 0
        For i = 1 To 30
            For ii = 1 To 40
                iiii = 1
                iii = 0

                For iii = 0 To 2

                    If LocalLightLevel(ii, i) < LocalLightLevel(ii + (iii - 1), i) Then LocalLightLevel(ii, i) = LocalLightLevel(ii + (iii - 1), i) - 1
                    If LocalLightLevel(ii, i) < LocalLightLevel(ii + (iii - 1), i + (iiii - 1)) - 2 Then updates = updates + 1
                Next

                iiii = 0
                iii = 1
                For iiii = 0 To 2
                    If LocalLightLevel(ii, i) < LocalLightLevel(ii, i + (iiii - 1)) Then LocalLightLevel(ii, i) = LocalLightLevel(ii, i + (iiii - 1)) - 1

                    If LocalLightLevel(ii, i) < LocalLightLevel(ii + (iii - 1), i + (iiii - 1)) - 2 Then updates = updates + 1
                Next
                'LocalLightLevel(ii, i) = TileData(ii, i, 8)
            Next
        Next
        If updates = 0 Then UpdateLimit = UpdateLimit + 1: updates = 1
        If UpdateLimit > 10 Then updates = 0
        ' Print updates, UpdateLimit
        ' Display
        ' Sleep

        SpreadLight2 (updates)
    Else
        UpdateLimit = 0
    End If

End Sub

Sub Precip2
    Static SnowDelay As Byte
    Static RainDelay As Byte
    Static SnowFrame As Byte
    Static RainFrame As Byte
    Static LocalTempGrab(40, 30)
    Static TempGrabDelay

    Dim i, ii
    SnowDelay = SnowDelay + 1
    RainDelay = RainDelay + 1
    TempGrabDelay = TempGrabDelay + 1
    If TempGrabDelay > 20 Then TempGrabDelay = 0

    Select Case PrecipitationLevel
        Case 0
            SnowDelay = 0
            RainDelay = 0
            SnowFrame = 0
            RainFrame = 0
        Case 1, 2
            If SnowDelay > 13 Then SnowFrame = SnowFrame + 1: SnowDelay = 0
            If RainDelay > 3 Then RainFrame = RainFrame + 1: RainDelay = 0
    End Select
    If RainFrame > 3 Then RainFrame = 0: RainDelay = 0
    If SnowFrame > 3 Then SnowFrame = 0: SnowDelay = 0
    If PrecipitationLevel > 0 Then
        For i = 0 To 30
            For ii = 0 To 40
                If TempGrabDelay = 0 Then LocalTempGrab(ii, i) = NaturalTemperature(ii, i)

                If VisibleCheck(ii, i) = 1 Then
                    If LocalTempGrab(ii, i) < 0.34 Then
                        PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Precipitation, , (0 + (16 * SnowFrame), 0)-(15 + (16 * SnowFrame), 15)
                    End If
                    If LocalTempGrab(ii, i) > 0.34 And LocalTempGrab(ii, i) < 0.90 Then
                        PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Precipitation, , (0 + (16 * RainFrame), 0 + 16)-(15 + (16 * RainFrame), 15 + 16)

                    End If
                End If
            Next
        Next
    End If

End Sub

Sub PrecipOverlay
    Static AnimDelay As Byte
    Static AnimFrame As Byte
    Static PixelOffset As Byte

    AnimDelay = AnimDelay + 1
    Select Case PrecipitationLevel
        Case 0
            AnimFrame = 0
            AnimDelay = 0
        Case 1
            If AnimDelay > 13 Then AnimFrame = AnimFrame + 1: AnimDelay = 0
        Case 2
            If AnimDelay > 3 Then AnimFrame = AnimFrame + 1: AnimDelay = 0
    End Select
    If AnimFrame > 3 Then AnimFrame = 0: AnimDelay = 0
    Dim i, ii As Byte
    AnimDelay = AnimDelay + 1
    If PrecipitationLevel > 0 Then
        For i = 0 To 30
            For ii = 0 To 40
                If VisibleCheck(ii, i) = 1 Then
                    PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Precipitation, , (0 + (16 * AnimFrame), 0 + (16 * (PrecipitationLevel - 1)))-(15 + (16 * AnimFrame), 15 + (16 * (PrecipitationLevel - 1)))
                End If
            Next
        Next
    End If

End Sub

Sub UseItem (Slot)
    Static ConsumeCooldown
    Static WeaponCooldown
    Static ToolDelay
    Select Case Inventory(0, Slot, 0)
        Case 0, 5 'Block placing
            If Inventory(0, Slot, 0) = 5 Then
                If GroundTile(FacingX, FacingY) <> 21 Then Exit Sub
            End If
            Select Case Inventory(0, Slot, 4)
                Case 0
                    If GroundTile(FacingX, FacingY) = 0 Or GroundTile(FacingX, FacingY) = 13 Then
                        GroundTile(FacingX, FacingY) = Inventory(0, Slot, 3)
                        TileData(FacingX, FacingY, 4) = 255
                        If GameMode <> 1 Then
                            Inventory(0, Slot, 7) = Inventory(0, Slot, 7) - 1
                            If Inventory(0, Slot, 7) = 0 Then EmptySlot Slot, 0
                        End If
                        UpdateTile FacingX, FacingY
                        SpreadLight (1)
                    End If
                Case 1
                    If WallTile(FacingX, FacingY) = 1 And GroundTile(FacingX, FacingY) <> 0 And GroundTile(FacingX, FacingY) <> 13 Then
                        WallTile(FacingX, FacingY) = Inventory(0, Slot, 3)
                        If TileIndexData(WallTile(FacingX, FacingY), 7) = 1 Then
                            NewContainer SavedMapX, SavedMapY, FacingX, FacingY
                        End If
                        TileData(FacingX, FacingY, 5) = 255
                        If GameMode <> 1 Then
                            Inventory(0, Slot, 7) = Inventory(0, Slot, 7) - 1
                            If Inventory(0, Slot, 7) = 0 Then EmptySlot Slot, 0
                        End If
                        UpdateTile FacingX, FacingY
                        SpreadLight (1)
                    End If
            End Select
        Case 1 'Tools
            Select Case Inventory(0, Slot, 5)
                Case 0 'shovel
                    If GroundTile(FacingX, FacingY) <> 0 Then
                        If TileData(FacingX, FacingY, 4) <= 0 Then
                            If GameMode <> 1 Then
                                If PickUpItem(TileIndex(GroundTile(FacingX, FacingY), 3)) = 1 Then Exit Select
                            End If
                            GroundTile(FacingX, FacingY) = 0
                            TileData(FacingX, FacingY, 4) = 255
                            UpdateTile FacingX, FacingY
                            SpreadLight (1)
                            Exit Select
                        End If
                        ToolDelay = ToolDelay + 1
                        If ToolDelay > 10 Then
                            If TileIndexData(GroundTile(FacingX, FacingY), 4) - Inventory(0, Slot, 6) < 0 Then
                                TileData(FacingX, FacingY, 4) = TileData(FacingX, FacingY, 4) - Inventory(0, Slot, 6)
                                TileData(FacingX, FacingY, 4) = TileData(FacingX, FacingY, 4) + TileIndexData(GroundTile(FacingX, FacingY), 4)
                            End If
                            ToolDelay = 0
                        End If
                        If TileData(FacingX, FacingY, 4) < 0 Then TileData(FacingX, FacingY, 4) = 0
                        If TileData(FacingX, FacingY, 4) > 255 Then TileData(FacingX, FacingY, 4) = 255
                    End If
                Case 1, 2 'axe, pickaxe
                    If TileIndexData(WallTile(FacingX, FacingY), 14) <> Inventory(0, Slot, 5) - 1 Then Exit Select 'to make sure if tile is stone or metal that you are using a pickaxe
                    If WallTile(FacingX, FacingY) <> 1 Then
                        If TileData(FacingX, FacingY, 5) <= 0 Then
                            If GameMode <> 1 Then
                                If TileIndexData(WallTile(FacingX, FacingY), 15) = 1 Then
                                    If PickUpItem(LootTable(1, WallTile(FacingX, FacingY))) = 1 Then Exit Select
                                Else
                                    If PickUpItem(TileIndex(WallTile(FacingX, FacingY), 3)) = 1 Then Exit Select
                                End If
                            End If
                            WallTile(FacingX, FacingY) = 1
                            TileData(FacingX, FacingY, 5) = 255
                            UpdateTile FacingX, FacingY
                            SpreadLight (1)
                            Exit Select
                        End If
                        ToolDelay = ToolDelay + 1
                        If ToolDelay > 10 Then
                            If TileIndexData(WallTile(FacingX, FacingY), 4) - Inventory(0, Slot, 6) < 0 Then
                                TileData(FacingX, FacingY, 5) = TileData(FacingX, FacingY, 5) - Inventory(0, Slot, 6)
                                TileData(FacingX, FacingY, 5) = TileData(FacingX, FacingY, 5) + TileIndexData(WallTile(FacingX, FacingY), 4)
                            End If
                            ToolDelay = 0
                        End If
                        If TileData(FacingX, FacingY, 5) < 0 Then TileData(FacingX, FacingY, 5) = 0
                        If TileData(FacingX, FacingY, 5) > 255 Then TileData(FacingX, FacingY, 5) = 255
                    End If

                Case 3 'hoe
                    If TileIndex(GroundTile(FacingX, FacingY), 4) <> 0 Then
                        If TileData(FacingX, FacingY, 4) <= 0 Then
                            GroundTile(FacingX, FacingY) = TileIndex(GroundTile(FacingX, FacingY), 4)
                            TileData(FacingX, FacingY, 4) = 255
                            UpdateTile FacingX, FacingY
                            SpreadLight (1)
                            Exit Select
                        End If
                        ToolDelay = ToolDelay + 1
                        If ToolDelay > 10 Then
                            TileData(FacingX, FacingY, 4) = TileData(FacingX, FacingY, 4) - Inventory(0, Slot, 6)
                            TileData(FacingX, FacingY, 4) = TileData(FacingX, FacingY, 4) + TileIndexData(GroundTile(FacingX, FacingY), 4)
                            ToolDelay = 0
                        End If
                        If TileData(FacingX, FacingY, 4) < 0 Then TileData(FacingX, FacingY, 4) = 0
                        If TileData(FacingX, FacingY, 4) > 255 Then TileData(FacingX, FacingY, 4) = 255
                    End If

            End Select
        Case 2 'Weapons                  5=cooldown 6=damage
            Dim i
            'check if cooldown has expired
            If CurrentTick >= WeaponCooldown Then
                For i = 1 To CurrentEntities
                    Select Case Player.facing
                        Case 1 'down
                            If entity(i, 4) + 8 > Player.x + 8 - 16 - 8 And entity(i, 4) + 8 < Player.x + 8 + 16 + 8 And entity(i, 5) + 8 > Player.y + 8 + 16 And entity(i, 5) + 8 < Player.y + 8 + 16 + 8 Then DamageEntity (i): Exit Select

                        Case 0 'up
                            If entity(i, 4) + 8 > Player.x + 8 - 16 - 8 And entity(i, 4) + 8 < Player.x + 8 + 16 + 8 And entity(i, 5) + 8 < Player.y + 8 - 16 And entity(i, 5) + 8 > Player.y + 8 - 16 - 8 Then DamageEntity (i): Exit Select
                        Case 2 'left
                            If entity(i, 4) + 8 < Player.x + 8 - 16 And entity(i, 4) + 8 > Player.x + 8 - 16 - 8 And entity(i, 5) + 8 > Player.y + 8 - 16 - 8 And entity(i, 5) + 8 < Player.y + 8 + 16 + 8 Then DamageEntity (i): Exit Select
                        Case 3 'right
                            If entity(i, 4) + 8 > Player.x + 8 + 16 And entity(i, 4) + 8 < Player.x + 8 + 16 + 8 And entity(i, 5) + 8 > Player.y + 8 - 16 - 8 And entity(i, 5) + 8 < Player.y + 8 + 16 + 8 Then DamageEntity (i): Exit Select

                    End Select

                Next
                'apply weapon cooldown
                WeaponCooldown = CurrentTick + Inventory(0, Slot, 5)

            End If


        Case 4 'consumables
            If CurrentTick >= ConsumeCooldown Then
                If EffectIndex("Consume " + ItemName(Inventory(0, Slot, 9), 0), 0) = 3 Then
                    If Player.health >= ((Player.MaxHealth + 1) * 8) Then Exit Select
                End If
                Effects 1, "Consume " + ItemName(Inventory(0, Slot, 9), 0), 0

                If GameMode <> 1 Then
                    Inventory(0, Slot, 7) = Inventory(0, Slot, 7) - 1
                    If Inventory(0, Slot, 7) = 0 Then EmptySlot Slot, 0
                End If

                ConsumeCooldown = CurrentTick + 10
            End If


    End Select

    If TileData(FacingX, FacingY, 7) = 0 And GroundTile(FacingX, FacingY) = 0 Then
        WallTile(FacingX, FacingY) = 1
        UpdateTile FacingX, FacingY
        SpreadLight (1)

    End If
End Sub

Sub DamageEntity (entityID)
    Effects 1, "Melee Damage", entityID
End Sub

Function EFacingX (entityID)
    Select Case Player.facing
        Case 0
            EFacingX = Int((entity(entityID, 4) + 8) / 16) + 1

        Case 1
            EFacingX = Int((entity(entityID, 4) + 8) / 16) + 1

        Case 2
            EFacingX = Int((entity(entityID, 4) + 8 - 16) / 16) + 1

        Case 3
            EFacingX = Int((entity(entityID, 4) + 8 + 16) / 16) + 1

    End Select

End Function

Function EFacingY (entityID)
    Select Case Player.facing
        Case 0

            EFacingY = Int((entity(entityID, 5) + 8 - 16) / 16) + 1
        Case 1

            EFacingY = Int((entity(entityID, 5) + 8 + 16) / 16) + 1
        Case 2

            EFacingY = Int((entity(entityID, 5) + 8) / 16) + 1
        Case 3

            EFacingY = Int((entity(entityID, 5) + 8) / 16) + 1
    End Select

End Function


Sub DebugShowEffects
    Dim i, ii
    For i = 0 To MaxEffects
        For ii = 0 To EffectParameters
            Print EffectArray(i, ii, 0);
        Next
        Print
    Next
End Sub

Sub ContainerUpdate
    Dim i
    Dim ii
    Dim itemcount
    If Flag.ContainerOpen = 1 Then
        If ContainerParams(0) <> SavedMapX Or ContainerParams(1) <> SavedMapY Or ContainerParams(2) <> FacingX Or ContainerParams(3) <> FacingY Then Flag.ContainerOpen = 2
        If Flag.InventoryOpen = 0 Then Flag.ContainerOpen = 2
    End If

    If Flag.ContainerOpen = 0 Then
        If Flag.InventoryOpen = 1 Then
            If TileIndexData(WallTile(FacingX, FacingY), 7) = 1 Then
                OpenContainer SavedMapX, SavedMapY, FacingX, FacingY
                ContainerParams(0) = SavedMapX
                ContainerParams(1) = SavedMapY
                ContainerParams(2) = FacingX
                ContainerParams(3) = FacingY
                Flag.ContainerOpen = 1
            End If
        End If
    End If
    If Flag.ContainerOpen = 2 Then
        If ContainerOTU = 1 Then
            For i = 0 To ContainerSizeX
                For ii = 0 To ContainerSizeY
                    If Container(ii, i, 7) > 0 Then itemcount = itemcount + 1
                Next
            Next
            If itemcount = 0 Then
                WallTile(ContainerParams(2), ContainerParams(3)) = 1
                TileData(ContainerParams(2), ContainerParams(3), 5) = 255
                UpdateTile ContainerParams(2), ContainerParams(3)
                SpreadLight (1)
            End If
        End If

        CloseContainer ContainerParams(0), ContainerParams(1), ContainerParams(2), ContainerParams(3)
        Flag.ContainerOpen = 0
    End If
End Sub


Sub TitleScreen
    Dim i, ii
    Dim InputString As String
    SwitchRender 0 'these 2 statements are important to prevent a dumb bug
    SwitchRender 1

    'load title screen world
    WorldName = "..\Structures\TitleScreen"
    LOADWORLD
    SpreadLight (1)

    'overwrite certain world elements with hard coded values, such as time, entities, etc
    SavedMapX = SpawnMapX
    SavedMapY = SpawnMapY
    SavePointX = SpawnPointX
    SavePointY = SpawnPointY
    CurrentEntities = 0
    Settings.TickRate = 50
    For i = 0 To 5
        CurrentEntities = CurrentEntities + 1
        For ii = 0 To EntityParameters
            entity(CurrentEntities, ii) = SummonEntity(1, ii)
        Next

    Next

    'render world and use modified game engine to run
    Do

        For i = 0 To CurrentEntities
            OnTopEffect i
            Effects 0, "", i
        Next
        SetBG
        SetMap
        CastShadow
        COLDET (0)
        RenderEntities (0)
        Entities (1)
        SetLighting
        INTER
        ZOOM
        DEV
        ChangeMap 0, 0, 0
        DayLightCycle
        MinMemFix
        If GameTime >= 100 And GameTime <= 200 Then
            For i = 0 To 5
                CurrentEntities = CurrentEntities + 1
                For ii = 0 To EntityParameters
                    entity(CurrentEntities, ii) = SummonEntity(1, ii)
                Next

            Next

        End If
        Select Case 4
            Case 1
                Settings.TickRate = 1
                AutoDisplay
                KeyClear
                Input "World Name?", WorldName
                LOADWORLD
                Exit Sub
            Case 2


        End Select
        KeyPressed = KeyHit
        If Flag.FrameRateLock = 0 Then Limit Settings.FrameRate
        CurrentTick = CurrentTick + Settings.TickRate
        If Flag.ScreenRefreshSkip = 0 Then Display
        Flag.ScreenRefreshSkip = 0
        If Flag.OpenCommand = 1 Then
            DisplayOrder Hardware , Software
            Flag.OpenCommand = 2
        End If
        If Flag.OpenCommand = 0 Then DisplayOrder GLRender , Hardware , Software
        Cls

        'show menu for single player, multiplayer, and settings
    Loop
End Sub

Sub SpawnEntity (EntityID)
    Dim i
    If CurrentEntities < EntityNatSpawnLim * (Flag.IsBloodmoon + 1) Then
        CurrentEntities = CurrentEntities + 1
        ' ReDim Preserve Entity(CurrentEntities, EntityParameters)
        For i = 0 To EntityParameters
            entity(CurrentEntities, i) = SummonEntity(EntityID, i)
        Next
    End If

End Sub

Sub Entities (Command As Byte)
    Randomize Timer
    Dim i, ii
    Static EntityDespawnOffset
    Select Case Command
        Case 0 'attempt to summon

            For i = 1 To CurrentEntities
                If Flag.DebugMode = 2 Then
                    Print "Entity: "; i;
                    For ii = 0 To EntityParameters
                        Print entity(i, ii);
                    Next
                    Print "DESPAWN:"; entity(i, 15);
                    Print
                End If

            Next

            Select Case TimeMode
                Case 0 'day time
                    Select Case Ceil(Rnd * 100000)
                        Case 0 To 250 'pig
                            SpawnEntity (1)
                    End Select
                Case 1 'night time
                    Select Case Flag.IsBloodmoon
                        Case 0
                            Select Case Ceil(Rnd * 100000)
                                Case 0 To 120 'zombie
                                    SpawnEntity (2)
                            End Select
                        Case 1
                            Select Case Ceil(Rnd * 50000)
                                Case 0 To 120 'zombie
                                    SpawnEntity (2)
                            End Select


                    End Select

            End Select
            'check if entity is inside of a tile, if so, then either retry or un summon

        Case 1 'Calculate Entity Shit (For all entities on current map
            For i = 1 To CurrentEntities
                Select Case entity(i, 3) 'check ai type
                    Case 0 'passive animal ai
                        If entity(i, 7) <= 0 Then 'check if ready for new command
                            Select Case Int(Rnd * 2)
                                Case 0 'roam
                                    entity(i, 10) = Int(Rnd * 3) - 1
                                    entity(i, 11) = Int(Rnd * 3) - 1
                                    entity(i, 7) = Int(Rnd * 500)
                                    entity(i, 6) = 0
                                Case 1 'sit still and chill
                                    entity(i, 10) = 0
                                    entity(i, 11) = 0
                                    entity(i, 7) = Int(Rnd * 1000)
                                    entity(i, 6) = 1
                            End Select
                        End If
                    Case 1 'zombie ai
                        If entity(i, 7) <= 0 Then 'check if ready for new command
                            Select Case Int(Rnd * 2)
                                Case 0 'roam
                                    entity(i, 10) = Int(Rnd * 3) - 1
                                    entity(i, 11) = Int(Rnd * 3) - 1
                                    entity(i, 7) = Int(Rnd * 500)
                                    entity(i, 6) = 0
                                Case 1 'sit still and chill
                                    entity(i, 10) = 0
                                    entity(i, 11) = 0
                                    entity(i, 7) = Int(Rnd * 1000)
                                    entity(i, 6) = 1
                            End Select
                        5 End If
                        If Abs(Player.x - entity(i, 4)) < 160 And Abs(Player.y - entity(i, 5)) < 160 Then
                            TargetPlayer i
                            entity(i, 6) = 2
                            entity(i, 7) = 0
                        End If
                End Select
                If entity(i, 11) = -1 Then entity(i, 16) = 0
                If entity(i, 11) = 1 Then entity(i, 16) = 1
                If entity(i, 10) = -1 Then entity(i, 16) = 2
                If entity(i, 10) = 1 Then entity(i, 16) = 3


                'if moving add velocity
                If entity(i, 10) = 1 Then entity(i, 8) = entity(i, 8) + TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)
                If entity(i, 11) = 1 Then entity(i, 9) = entity(i, 9) + TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)
                If entity(i, 10) = -1 Then entity(i, 8) = entity(i, 8) - TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)
                If entity(i, 11) = -1 Then entity(i, 9) = entity(i, 9) - TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)

                'if not moving subtract velocity
                If entity(i, 10) = 0 And entity(i, 8) > 0 Then
                    entity(i, 8) = entity(i, 8) - TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)
                    If entity(i, 8) < 0 Then entity(i, 8) = 0
                End If
                If entity(i, 11) = 0 And entity(i, 9) > 0 Then
                    entity(i, 9) = entity(i, 9) - TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)
                    If entity(i, 9) < 0 Then entity(i, 9) = 0
                End If
                If entity(i, 10) = 0 And entity(i, 8) < 0 Then
                    entity(i, 8) = entity(i, 8) + TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)
                    If entity(i, 8) > 0 Then entity(i, 8) = 0
                End If
                If entity(i, 11) = 0 And entity(i, 9) < 0 Then
                    entity(i, 9) = entity(i, 9) + TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 9)
                    If entity(i, 9) > 0 Then entity(i, 9) = 0
                End If

                'if at max velocity for tile then cap it
                If entity(i, 8) > (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2)) Then entity(i, 8) = (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2))
                If entity(i, 9) > (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2)) Then entity(i, 9) = (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2))
                If entity(i, 8) < (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2)) * -1 Then entity(i, 8) = (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2)) * -1
                If entity(i, 9) < (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2)) * -1 Then entity(i, 9) = (TileData(Int((entity(i, 4) + 8) / 16) + 1, Int((entity(i, 5) + 8) / 16) + 1, 10) * entity(i, 2)) * -1

                'apply velocity to position
                entity(i, 4) = entity(i, 4) + entity(i, 8)
                entity(i, 5) = entity(i, 5) + entity(i, 9)

                'make sure entity isnt exceding map boundaries
                If entity(i, 4) > 640 - 16 Then entity(i, 4) = 640 - 16
                If entity(i, 4) < 0 Then entity(i, 4) = 0
                If entity(i, 5) > 480 - 16 Then entity(i, 5) = 480 - 16
                If entity(i, 5) < 0 Then entity(i, 5) = 0

                'check for collisions
                entity(i, 13) = entity(i, 4)
                entity(i, 14) = entity(i, 5)
                COLDET i

                If entity(i, 1) <= 0 Or entity(i, 15) <= 0 Then EntityDespawn i: Exit Sub
                '

                'count down decision timer
                entity(i, 7) = entity(i, 7) - Settings.TickRate
                entity(i, 15) = entity(i, 15) - Settings.TickRate
            Next
            EntityDespawnOffset = 0
    End Select

End Sub

Sub TargetPlayer (i)
    If entity(i, 4) > Player.x Then entity(i, 10) = -1
    If entity(i, 4) < Player.x Then entity(i, 10) = 1
    If entity(i, 4) = Player.x Then entity(i, 10) = 0
    If entity(i, 5) > Player.y Then entity(i, 11) = -1
    If entity(i, 5) < Player.y Then entity(i, 11) = 1
    If entity(i, 5) = Player.y Then entity(i, 11) = 0

    If entity(i, 4) + 16 > Player.x And entity(i, 4) < Player.x + 16 And entity(i, 5) + 16 > Player.y And entity(i, 5) < Player.y + 16 Then Effects 1, "Touch Zombie", 0
End Sub

Function SummonEntity (ID, Parameter)
    Randomize Timer
    Select Case ID
        Case 1 'Pig

            Select Case Parameter
                Case 0 'ID
                    SummonEntity = ID
                Case 1 'Health
                    SummonEntity = 3
                Case 2 'Movement Speed Modifier
                    SummonEntity = .25
                Case 3 'AI type
                    SummonEntity = 0
                Case 4 'x cord
                    SummonEntity = Int(Rnd * 640)
                Case 5 'y cord
                    SummonEntity = Int(Rnd * 480)
                Case 6 'current action
                Case 7 'time left
                Case 8 'velocity x
                Case 9 'velocity y
                Case 10 'ismoving x
                Case 11 'ismoving y
                Case 12 'maxhealth
                    SummonEntity = 3
                Case 13 'LastX
                Case 14 'LastY
                Case 15 'Despawn timer
                    SummonEntity = 36000
                Case 16 'facing direction
                Case 17 'swim offset
            End Select
        Case 2 'Zombie
            Select Case Parameter
                Case 0 'ID
                    SummonEntity = ID
                Case 1 'Health
                    SummonEntity = 8
                Case 2 'Movement Speed Modifier
                    SummonEntity = .25
                Case 3 'AI type
                    SummonEntity = 1
                Case 4 'x cord
                    SummonEntity = Int(Rnd * 640)
                Case 5 'y cord
                    SummonEntity = Int(Rnd * 480)
                Case 6 'current action
                Case 7 'time left
                Case 8 'velocity x
                Case 9 'velocity y
                Case 10 'ismoving x
                Case 11 'ismoving y
                Case 12 'maxhealth
                    SummonEntity = 3
                Case 13 'LastX
                Case 14 'LastY
                Case 15 'Despawn timer
                    SummonEntity = 36000
                Case 16 'facing direction
                Case 17 ' swim offset
            End Select

    End Select
End Function

Function LootTable (tType As Byte, ID As Integer)
    Static RandomCap
    Select Case tType
        Case 1 'tile drops
            Select Case ID
                Case 19 '                low tier stone
                    LootTable = 29 'stone
                    If Int(Rnd * 50) < 5 Then LootTable = 122 'coal
                    If Int(Rnd * 100) < 15 Then LootTable = 38 'tin
                    If Int(Rnd * 100) < 8 Then LootTable = 39 'copper
                Case 28 'calcite
                    LootTable = 29 'stone
                    If Int(Rnd * 100) < 15 Then LootTable = 40 'iron
                    If Int(Rnd * 100) < 8 Then LootTable = 41 'platinum
                    If Int(Rnd * 600) < 5 Then LootTable = 107 'diamond
                    If Int(Rnd * 600) < 5 Then LootTable = 108 'emerald
                    If Int(Rnd * 1000) < 5 Then LootTable = 104 'aetherian energy sphere

                Case 29 'sand
                    LootTable = 116 'sand
                    If Int(Rnd * 400) < 5 Then LootTable = 105 'ruby
                    If Int(Rnd * 400) < 5 Then LootTable = 106 'saphire
                    If Int(Rnd * 1000) < 3 And CurrentDimension = 3 Then LootTable = 103 'Imbuement Refraction Core


            End Select
        Case 2 'mob drops
            Select Case ID
                Case 1
                    LootTable = 102
                    RandomCap = 3
                Case 2
                    LootTable = 101
                    RandomCap = 3

                    If Flag.IsBloodmoon = 1 Then
                        If Int(Rnd * 50) < 3 Then LootTable = 24: RandomCap = 1
                    End If
            End Select
        Case 3 'random quanity
            LootTable = Int(Rnd * RandomCap) + 1


    End Select
End Function

Sub SetGroundItem (ItemID, Amount, X, Y)
    If ItemID = 0 Then Exit Sub
    Dim iii As Byte
    WallTile(X, Y) = 11
    NewContainer SavedMapX, SavedMapY, X, Y
    OpenContainer SavedMapX, SavedMapY, X, Y

    For iii = 0 To InvParameters
        Container(0, 0, iii) = ItemIndex(ItemID, iii)

    Next
    Container(0, 0, 7) = Amount
    CloseContainer SavedMapX, SavedMapY, X, Y


End Sub

Sub EntityDespawn (id)
    Dim i, ii
    'make sure tile to be set on is air

    'set ground item
    SetGroundItem LootTable(2, entity(id, 0)), LootTable(3, entity(id, 0)), Int((entity(id, 4) + 8) / 16) + 1, Int((entity(id, 5) + 8) / 16) + 1

    'shift all entity data down 1 slot over the dead entiyt data
    For i = id To CurrentEntities
        For ii = 0 To EntityParameters
            entity(i, ii) = entity(i + 1, ii)
        Next
    Next

    CurrentEntities = CurrentEntities - 1

End Sub

Sub Respawn
    SAVEMAP
    Player.x = SpawnPointX
    Player.y = SpawnPointY
    SavedMapX = SpawnMapX
    SavedMapY = SpawnMapY
    LOADMAP SavedMap
    Player.health = 8
    Effects 1, "Immunity Respawn", 0
End Sub

Sub UseHotBar
    Static As Byte iii
    Static As Byte flashtimeout
    Static As Integer64 hbtimeout
    Dim As Single HotbarX, HotbarY, HotbarSpace
    Dim As Single ItemSizeOffset

    HotbarX = (ScreenRezX / 4 / 2) - 9
    HotbarY = (ScreenRezY / 4 / 2) + 7
    HotbarSpace = 17
    ItemSizeOffset = 2


    If Flag.InventoryOpen = 0 Then

        If Item1 Then
            CursorHoverX = 0
            UseItem 0
            iii = 0
            hbtimeout = CurrentTick + 10
            flashtimeout = 5

        End If
        If Item2 Then
            CursorHoverX = 1
            UseItem 1
            iii = 1
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item3 Then
            CursorHoverX = 2
            UseItem 2
            iii = 2
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item4 Then
            CursorHoverX = 3
            UseItem 3
            iii = 3
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item5 Then
            CursorHoverX = 4
            UseItem 4
            iii = 4
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item6 Then
            CursorHoverX = 5
            UseItem 5
            iii = 5
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If hbtimeout > CurrentTick And flashtimeout > 0 Then PutImage (CameraPositionX - HotbarX + (HotbarSpace * iii), CameraPositionY + HotbarY - 16)-(CameraPositionX - HotbarX + 16 + (HotbarSpace * iii), CameraPositionY + HotbarY), Texture.HudSprites, , (32, 32)-(63, 63) Else hbtimeout = CurrentTick + 3: flashtimeout = flashtimeout - 1
        If flashtimeout < 0 Then flashtimeout = 0

    End If
End Sub


Sub DisplayLables
    Dim As Byte i, ii, iii, iiii
    Dim As Single HealthTextX, HealthTextY
    Dim As Single HotbarTextX, HotbarTextY, HotbarTextSpace
    Dim As Single HotbarTitlex, HotbarTitley
    Dim As Single InventoryTitleX, InventoryTitleY
    Dim As Single InventoryTextOffset
    Dim As Single CraftingTextX, CraftingTextY
    Dim As Single CraftingTitleX, CraftingTitleY
    Dim As Single ContainerTitleX, ContainerTitleY
    Static As Single ContainerTextX, ContainerTextY


    InventoryTextOffset = 83

    HealthTextX = ScreenRezX - 60
    HealthTextY = 0

    HotbarTextX = 5
    HotbarTextY = ScreenRezY - 61
    HotbarTextSpace = 68
    2
    HotbarTitlex = 6
    HotbarTitley = ScreenRezY - 85

    InventoryTitleX = 6
    InventoryTitleY = ScreenRezY - 305


    ContainerTextX = 5
    ContainerTextY = 22

    ContainerTitleX = 6
    ContainerTitleY = 0

    CraftingTextX = ScreenRezX - 67
    CraftingTextY = ScreenRezY + 23

    CraftingTitleX = ScreenRezX - 84 - 50 - (68 * (Player.CraftingLevel - 2))
    CraftingTitleY = ScreenRezY - 103 - 50 - (68 * (Player.CraftingLevel - 2))



    Color RGB(0, 0, 0)
    For i = 0 To 2
        For ii = 0 To 2

            PrintString (HealthTextX + (i - 1), HealthTextY + (ii - 1)), "Health:"
            PrintString (HotbarTitlex + (i - 1), HotbarTitley + (ii - 1)), "Hotbar:"
            If Flag.InventoryOpen = 1 Then
                PrintString (InventoryTitleX + (i - 1), InventoryTitleY + (ii - 1)), "Inventory:"
                PrintString (CraftingTitleX + (i - 1), CraftingTitleY + (ii - 1)), "Crafting:"
                If Flag.ContainerOpen = 1 Then PrintString (ContainerTitleX + (i - 1), ContainerTitleY + (ii - 1)), "Container:"
            End If

            For iii = 0 To 5
                If Inventory(0, iii, 7) > 1 Then PrintString ((HotbarTextX) + (HotbarTextSpace * iii) + i - 1, HotbarTextY + ii - 1), Str$(Inventory(0, iii, 7))
                For iiii = 0 To 2
                    If Flag.InventoryOpen = 1 And Inventory(iiii + 1, iii, 7) > 1 And GameMode <> 1 Then PrintString ((0 + HotbarTextX) + (HotbarTextSpace * iii) + i - 1, (HotbarTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset + ii - 1), Str$(Inventory(iiii + 1, iii, 7))
                    '
                Next
            Next
            For iii = Player.CraftingLevel - 1 To 0 Step -1
                For iiii = Player.CraftingLevel - 1 To 0 Step -1
                    If Flag.InventoryOpen = 1 And CraftingGrid(iiii, iii, 7) > 1 Then PrintString ((0 + CraftingTextX) - (HotbarTextSpace * iii) + i - 1, (CraftingTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset + ii - 1), Str$(CraftingGrid(iiii, iii, 7))
                    '
                Next
            Next
            For iii = 0 To ContainerSizeX
                5 For iiii = 0 To ContainerSizeY
                    'TODO Fix container item labels
                    If Flag.ContainerOpen = 1 And Flag.InventoryOpen = 1 And Container(iiii, iii, 7) > 1 Then PrintString ((0 + ContainerTextX) + (HotbarTextSpace * iii) + i - 1, (ContainerTextY) + (HotbarTextSpace * iiii + 1) + ii - 1), Str$(Container(iiii, iii, 7))
                Next
            Next
            iiii = 0
            iii = Player.CraftingLevel
            If Flag.InventoryOpen = 1 And CraftingGrid(iiii, iii, 7) > 1 Then PrintString ((0 + CraftingTextX) - (HotbarTextSpace * iii) + i - 1, (CraftingTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset + ii - 1), Str$(CraftingGrid(iiii, iii, 7))
        Next
    Next

    Color RGB(255, 255, 255)

    PrintString (HealthTextX, HealthTextY), "Health:"
    PrintString (HotbarTitlex, HotbarTitley), "Hotbar:"
    If Flag.InventoryOpen = 1 Then
        PrintString (InventoryTitleX, InventoryTitleY), "Inventory:"
        PrintString (CraftingTitleX, CraftingTitleY), "Crafting:"
        If Flag.ContainerOpen = 1 Then PrintString (ContainerTitleX, ContainerTitleY), "Container:"
    End If
    For iii = 0 To 5

        If Inventory(0, iii, 7) > 1 Then PrintString ((HotbarTextX) + (HotbarTextSpace * iii), HotbarTextY), Str$(Inventory(0, iii, 7))
        For iiii = 0 To 2
            If Flag.InventoryOpen = 1 And Inventory(iiii + 1, iii, 7) > 1 And GameMode <> 1 Then PrintString ((HotbarTextX) + (HotbarTextSpace * iii), (HotbarTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset), Str$(Inventory(iiii + 1, iii, 7))
        Next

    Next
    For iii = 0 To ContainerSizeX
        For iiii = 0 To ContainerSizeY
            If Flag.ContainerOpen And Flag.InventoryOpen = 1 And Container(iiii, iii, 7) > 1 Then PrintString ((0 + ContainerTextX) + (HotbarTextSpace * iii), (ContainerTextY) + (HotbarTextSpace * iiii + 1)), Str$(Container(iiii, iii, 7))
        Next
    Next

    For iii = Player.CraftingLevel - 1 To 0 Step -1
        For iiii = Player.CraftingLevel - 1 To 0 Step -1
            If Flag.InventoryOpen = 1 And CraftingGrid(iiii, iii, 7) > 1 Then PrintString ((0 + CraftingTextX) - (HotbarTextSpace * iii), (CraftingTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset), Str$(CraftingGrid(iiii, iii, 7))
        Next
    Next
    iiii = 0
    iii = Player.CraftingLevel
    If Flag.InventoryOpen = 1 And CraftingGrid(iiii, iii, 7) > 1 Then PrintString ((0 + CraftingTextX) - (HotbarTextSpace * iii), (CraftingTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset), Str$(CraftingGrid(iiii, iii, 7))
End Sub '192,32   224,32

Sub DisplayHealth
    Dim As Byte i, ii, iii
    Dim As Integer Token, TMPHeal, rToken
    Dim As Single HealthX, HealthY
    Dim As Single FullWheels
    Dim As Byte BonusWheel
    Dim As Byte BigHealOffset
    Dim healthtextx, healthtexty
    Dim ThermOffset
    Token = 1
    BigHealOffset = 0
    HealthX = (ScreenRezX / 4 / 2) + 8
    HealthY = (ScreenRezY / 4 / 2) - 11

    TMPHeal = Player.health

    If Player.BodyTemp = 1 Then ThermOffset = 96
    If Player.BodyTemp = 2 Then ThermOffset = 128

    If ImmunityFlash = 0 Then
        Select Case GameMode
            Case 1
                PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (4 * 32, 32)-(4 * 32 + 31, 63)
            Case 2
                If Player.MaxHealth * 16 + 8 > HealthY * 2 Then

                    If Player.health > 8 Then BigHealOffset = 0
                    'draw full health wheel
                    For i = 0 To BigHealOffset
                        PutImage (CameraPositionX + HealthX - 16, CameraPositionY + i - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + i - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (3 * 32 + ThermOffset, 32)-(3 * 32 + 31 + ThermOffset, 63)
                        PutImage (CameraPositionX + HealthX - 16, CameraPositionY + i - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + i - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (7 * 32, 0 + HealthWheelOffset)-(7 * 32 + 31, 31 + HealthWheelOffset)
                    Next
                    'print full wheel text "wheels (points)"
                    If Player.health > 8 Then
                        healthtextx = ScreenRezX - 35 - Len(Str$(Int((Player.health - 1) / 8)) + " (" + Trim$(Str$(Int((Player.health - 1) / 8) * 8)) + ")") * 4
                        healthtexty = 75 - 15
                        Color RGB(0, 0, 0)
                        For i = 0 To 2
                            For ii = 0 To 2
                                If Player.health - 8 <= Player.MaxHealth * 8 Then
                                    PrintString (healthtextx + (i - 1), healthtexty + (ii - 1)), Str$(Int((Player.health - 1) / 8)) + " (" + Trim$(Str$(Int((Player.health - 1) / 8) * 8)) + ")"
                                Else
                                    PrintString (healthtextx + (i - 1), healthtexty + (ii - 1)), Str$(Int((Player.health - 8 - 1) / 8)) + " (" + Trim$(Str$(Int((Player.health - 8 - 1) / 8) * 8)) + ")"
                                End If
                            Next
                        Next
                        Color RGB(255, 255, 255)

                        If Player.health - 8 <= Player.MaxHealth * 8 Then
                            PrintString (healthtextx, healthtexty), Str$(Int((Player.health - 1) / 8)) + " (" + Trim$(Str$(Int((Player.health - 1) / 8) * 8)) + ")"
                        Else
                            PrintString (healthtextx, healthtexty), Str$(Int((Player.health - 8 - 1) / 8)) + " (" + Trim$(Str$(Int((Player.health - 8 - 1) / 8) * 8)) + ")"
                        End If

                    End If

                    Token = Token + 1
                    If Player.health <= 8 Then Token = Token - 1

                    'draw current wheel     (honestly, idk how i managed to get this shit to work, but it does, DONT FUCKING TOUCH IT
                    PutImage (CameraPositionX + HealthX - 16, CameraPositionY + BigHealOffset - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + BigHealOffset - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (3 * 32 + ThermOffset, 32)-(3 * 32 + 31 + ThermOffset, 63)
                    TMPHeal = TMPHeal - 8 * Int(Player.health / 8)
                    If Player.health > (Player.MaxHealth + 1) * 8 Then TMPHeal = 8: BonusWheel = 1
                    If TMPHeal > 8 Then TMPHeal = 8
                    If TMPHeal > 0 And TMPHeal < 8 Then PutImage (CameraPositionX + HealthX - 16, CameraPositionY + BigHealOffset - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + BigHealOffset - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , ((TMPHeal - 1) * 32, 0 + HealthWheelOffset)-((TMPHeal - 1) * 32 + 31, 31 + HealthWheelOffset)
                    If TMPHeal = 0 Or TMPHeal = 8 Then PutImage (CameraPositionX + HealthX - 16, CameraPositionY + BigHealOffset - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + BigHealOffset - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (7 * 32, 0 + HealthWheelOffset)-(7 * 32 + 31, 31 + HealthWheelOffset)
                    Token = Token + 1

                    'if empty wheel then
                    '   draw empty wheel
                    If Player.health - 1 < Player.MaxHealth * 8 Then
                        PutImage (CameraPositionX + HealthX - 16, CameraPositionY + BigHealOffset - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + BigHealOffset - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (3 * 32 + ThermOffset, 32)-(3 * 32 + 31 + ThermOffset, 63)

                        '   print empty wheel text
                        healthtextx = ScreenRezX - 35 - Len(Str$(Player.MaxHealth - Ceil(Player.health / 8) + 1) + " (" + Trim$(Str$((Player.MaxHealth - Ceil(Player.health / 8) + 1) * 8)) + ")") * 4
                        If Player.health > 8 Then healthtexty = 188 Else healthtexty = 123
                        Color RGB(0, 0, 0)
                        For i = 0 To 2
                            For ii = 0 To 2
                                PrintString (healthtextx + (i - 1), healthtexty + (ii - 1)), Str$(Player.MaxHealth - Ceil(Player.health / 8) + 1) + " (" + Trim$(Str$((Player.MaxHealth - Ceil(Player.health / 8) + 1) * 8)) + ")"
                            Next
                        Next
                        Color RGB(255, 255, 255)

                        PrintString (healthtextx, healthtexty), Str$(Player.MaxHealth - Ceil(Player.health / 8) + 1) + " (" + Trim$(Str$((Player.MaxHealth - Ceil(Player.health / 8) + 1) * 8)) + ")"

                    End If

                    'endif

                    'draw bonus wheels as normal
                    Token = 3
                    TMPHeal = Player.health - (Player.MaxHealth + 1) * 8
                    While TMPHeal > 0
                        PutImage (CameraPositionX + HealthX - 16, CameraPositionY + BigHealOffset - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + BigHealOffset - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (5 * 32, 32)-(5 * 32 + 31, 63)
                        If TMPHeal <= 8 Then
                            PutImage (CameraPositionX + HealthX - 16, CameraPositionY + BigHealOffset - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + BigHealOffset - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , ((TMPHeal - 1) * 32, 0 + HealthWheelOffset)-((TMPHeal - 1) * 32 + 31, 31 + HealthWheelOffset)
                        Else
                            PutImage (CameraPositionX + HealthX - 16, CameraPositionY + BigHealOffset - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY + BigHealOffset - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (7 * 32, 0 + HealthWheelOffset)-(7 * 32 + 31, 31 + HealthWheelOffset)
                        End If
                        TMPHeal = TMPHeal - 8
                        Token = Token + 1
                    Wend


                Else
                    For i = 0 To Player.MaxHealth
                        PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (3 * 32 + ThermOffset, 32)-(3 * 32 + 31 + ThermOffset, 63)
                        Token = Token + 1
                    Next
                    Token = 1
                    While TMPHeal > 0
                        If Token > Player.MaxHealth + 1 Then PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (5 * 32, 32)-(5 * 32 + 31, 63)
                        If TMPHeal <= 8 Then
                            PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , ((TMPHeal - 1) * 32, 0 + HealthWheelOffset)-((TMPHeal - 1) * 32 + 31, 31 + HealthWheelOffset)
                        Else
                            PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (7 * 32, 0 + HealthWheelOffset)-(7 * 32 + 31, 31 + HealthWheelOffset)
                        End If
                        TMPHeal = TMPHeal - 8
                        Token = Token + 1
                    Wend
                End If




        End Select
    End If
End Sub

Sub DisplayHotbar
    Dim As Byte i, ii, iii
    Dim As Single HotbarX, HotbarY, HotbarSpace
    Dim As Single ItemSizeOffset
    HotbarX = (ScreenRezX / 4 / 2) - 9
    HotbarY = (ScreenRezY / 4 / 2) + 7
    HotbarSpace = 17
    ItemSizeOffset = 2

    For iii = 0 To 5
        PutImage (CameraPositionX - HotbarX + (HotbarSpace * iii), CameraPositionY + HotbarY - 16)-(CameraPositionX - HotbarX + 16 + (HotbarSpace * iii), CameraPositionY + HotbarY), Texture.HudSprites, , (0, 32)-(31, 63)
        PutImage (CameraPositionX - HotbarX + (HotbarSpace * iii) + ItemSizeOffset, CameraPositionY + HotbarY - 16 + ItemSizeOffset)-(CameraPositionX - HotbarX + 16 + (HotbarSpace * iii) - ItemSizeOffset, CameraPositionY + HotbarY - ItemSizeOffset), Texture.ItemSheet, , (Inventory(0, iii, 1), Inventory(0, iii, 2))-(Inventory(0, iii, 1) + 15, Inventory(0, iii, 2) + 15)

        If Inventory(0, iii, 10) > 1 Then
            PutImage (CameraPositionX - HotbarX + (HotbarSpace * iii) + ItemSizeOffset, CameraPositionY + HotbarY - 16 + ItemSizeOffset)-(CameraPositionX - HotbarX + 16 + (HotbarSpace * iii) - ItemSizeOffset, CameraPositionY + HotbarY - ItemSizeOffset), Texture.ItemSheet, , (128 + (16 * (Inventory(0, iii, 10) - 2)), 80)-(128 + (16 * (Inventory(0, iii, 10) - 2)) + 15, 80 + 15)
        End If

        If Flag.InventoryOpen = 1 Then
            If CursorHoverPage = 1 And CursorHoverX = iii Then PutImage (CameraPositionX - HotbarX + (HotbarSpace * iii), CameraPositionY + HotbarY - 16)-(CameraPositionX - HotbarX + 16 + (HotbarSpace * iii), CameraPositionY + HotbarY), Texture.HudSprites, , (32, 32)-(63, 63)
            If CursorSelectedPage = 1 And CursorSelectedX = iii And CursorMode = 1 Then PutImage (CameraPositionX - HotbarX + (HotbarSpace * iii), CameraPositionY + HotbarY - 16)-(CameraPositionX - HotbarX + 16 + (HotbarSpace * iii), CameraPositionY + HotbarY), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)
        End If
    Next

End Sub

Sub DisplayInventory (CreativePage As Integer)
    Dim As Byte i, ii, iii, iiii
    Dim As Single InventoryX, InventoryY, InventorySpace, InventoryOffset
    Dim As Single itemsizeoffset

    InventoryX = (ScreenRezX / 4 / 2) - 9
    InventoryY = (ScreenRezY / 4 / 2) + 2
    InventorySpace = 17
    InventoryOffset = 1
    itemsizeoffset = 2


    For iii = 0 To 5
        For iiii = 0 To 2
            PutImage (CameraPositionX - InventoryX + (InventorySpace * iii), (CameraPositionY + InventoryY - 16) - (16 * (iiii + 1) + InventoryOffset * iiii))-(CameraPositionX - InventoryX + 16 + (17 * iii), (CameraPositionY + InventoryY) - (16 * (iiii + 1) + InventoryOffset * iiii)), Texture.HudSprites, , (0, 32)-(31, 63)
            If CursorHoverPage = 0 And CursorHoverX = iii And CursorHoverY = iiii Then PutImage (CameraPositionX - InventoryX + (InventorySpace * iii), (CameraPositionY + InventoryY - 16) - (16 * (iiii + 1) + InventoryOffset * iiii))-(CameraPositionX - InventoryX + 16 + (17 * iii), (CameraPositionY + InventoryY) - (16 * (iiii + 1) + InventoryOffset * iiii)), Texture.HudSprites, , (32, 32)-(63, 63)
            If CursorSelectedPage = 0 And CursorSelectedX = iii And CursorSelectedY = iiii And CursorMode = 1 Then PutImage (CameraPositionX - InventoryX + (InventorySpace * iii), (CameraPositionY + InventoryY - 16) - (16 * (iiii + 1) + InventoryOffset * iiii))-(CameraPositionX - InventoryX + 16 + (17 * iii), (CameraPositionY + InventoryY) - (16 * (iiii + 1) + InventoryOffset * iiii)), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)


            Select Case GameMode
                Case 1
                    PutImage (CameraPositionX - InventoryX + (InventorySpace * iii) + itemsizeoffset, (CameraPositionY + InventoryY - 16) - (16 * (iiii + 1) + InventoryOffset * iiii) + itemsizeoffset)-(CameraPositionX - InventoryX + 16 + (17 * iii) - itemsizeoffset, (CameraPositionY + InventoryY) - (16 * (iiii + 1) + InventoryOffset * iiii) - itemsizeoffset), Texture.ItemSheet, , (CreativeInventory(iiii, iii, 1, CreativePage), CreativeInventory(iiii, iii, 2, CreativePage))-(CreativeInventory(iiii, iii, 1, CreativePage) + 15, CreativeInventory(iiii, iii, 2, CreativePage) + 15)

                Case 2
                    PutImage (CameraPositionX - InventoryX + (InventorySpace * iii) + itemsizeoffset, (CameraPositionY + InventoryY - 16) - (16 * (iiii + 1) + InventoryOffset * iiii) + itemsizeoffset)-(CameraPositionX - InventoryX + 16 + (17 * iii) - itemsizeoffset, (CameraPositionY + InventoryY) - (16 * (iiii + 1) + InventoryOffset * iiii) - itemsizeoffset), Texture.ItemSheet, , (Inventory(iiii + 1, iii, 1), Inventory(iiii + 1, iii, 2))-(Inventory(iiii + 1, iii, 1) + 15, Inventory(iiii + 1, iii, 2) + 15)
                    If Inventory(iiii + 1, iii, 10) > 1 Then
                        PutImage (CameraPositionX - InventoryX + (InventorySpace * iii) + itemsizeoffset, (CameraPositionY + InventoryY - 16) - (16 * (iiii + 1) + InventoryOffset * iiii) + itemsizeoffset)-(CameraPositionX - InventoryX + 16 + (17 * iii) - itemsizeoffset, (CameraPositionY + InventoryY) - (16 * (iiii + 1) + InventoryOffset * iiii) - itemsizeoffset), Texture.ItemSheet, , (128 + (16 * (Inventory(iiii + 1, iii, 10) - 2)), 80)-(128 + (16 * (Inventory(iiii + 1, iii, 10) - 2)) + 15, 80 + 15)
                    End If
            End Select
        Next
    Next

End Sub

Sub DisplayCrafting
    Dim i, ii, iii, iiii
    Dim As Single CraftingX, CraftingY, CraftingSpace, CraftingOffset, CraftingResultX, CraftingResultY
    Dim As Single ItemSizeOffset

    ItemSizeOffset = 2
    CraftingX = (ScreenRezX / 4 / 2) - 9
    CraftingY = (ScreenRezY / 4 / 2) - 9
    CraftingSpace = 17
    CraftingOffset = 1

    Crafting

    Select Case Player.CraftingLevel
        Case 0 To 5
            For iii = 0 To Player.CraftingLevel - 1
                For iiii = 0 To Player.CraftingLevel - 1
                    PutImage (CameraPositionX + CraftingX - (CraftingSpace * iii), CameraPositionY + CraftingY - (CraftingSpace * iiii))-(CameraPositionX + CraftingX - (CraftingSpace * iii) + 16, CameraPositionY + CraftingY - (CraftingSpace * iiii) + 16), Texture.HudSprites, , (0, 32)-(31, 63)
                    PutImage (CameraPositionX + CraftingX - (CraftingSpace * iii) + ItemSizeOffset, CameraPositionY + CraftingY - (CraftingSpace * iiii) + ItemSizeOffset)-(CameraPositionX + CraftingX - (CraftingSpace * iii) + 16 - ItemSizeOffset, CameraPositionY + CraftingY - (CraftingSpace * iiii) + 16 - ItemSizeOffset), Texture.ItemSheet, , (CraftingGrid(iiii, iii, 1), CraftingGrid(iiii, iii, 2))-(CraftingGrid(iiii, iii, 1) + 15, CraftingGrid(iiii, iii, 2) + 15)

                    If CraftingGrid(iiii, iii, 10) > 1 Then
                        PutImage (CameraPositionX + CraftingX - (CraftingSpace * iii) + ItemSizeOffset, CameraPositionY + CraftingY - (CraftingSpace * iiii) + ItemSizeOffset)-(CameraPositionX + CraftingX - (CraftingSpace * iii) + 16 - ItemSizeOffset, CameraPositionY + CraftingY - (CraftingSpace * iiii) + 16 - ItemSizeOffset), Texture.ItemSheet, , (128 + (16 * (CraftingGrid(iiii, iii, 10) - 2)), 80)-(128 + (16 * (CraftingGrid(iiii, iii, 10) - 2)) + 15, 80 + 15) '            (128 + (8 * (Inventory(iiii + 1, iii, 10) - 2)), 80)-(128 + (8 * (Inventory(iiii + 1, iii, 10) - 2)) + 15, 80 + 15)
                    End If

                    If CursorHoverPage = 3 And CursorHoverX = iii And CursorHoverY = iiii Then PutImage (CameraPositionX + CraftingX - (CraftingSpace * iii), CameraPositionY + CraftingY - (CraftingSpace * iiii))-(CameraPositionX + CraftingX - (CraftingSpace * iii) + 16, CameraPositionY + CraftingY - (CraftingSpace * iiii) + 16), Texture.HudSprites, , (32, 32)-(63, 63)
                    If CursorSelectedPage = 3 And CursorSelectedX = iii And CursorSelectedY = iiii And CursorMode = 1 Then PutImage (CameraPositionX + CraftingX - (CraftingSpace * iii), CameraPositionY + CraftingY - (CraftingSpace * iiii))-(CameraPositionX + CraftingX - (CraftingSpace * iii) + 16, CameraPositionY + CraftingY - (CraftingSpace * iiii) + 16), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)

                Next
            Next

            PutImage (CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)), CameraPositionY + CraftingY)-(CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)) + 16, CameraPositionY + CraftingY + 16), Texture.HudSprites, , (0, 32)-(31, 63)
            PutImage (CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)) + ItemSizeOffset, CameraPositionY + CraftingY + ItemSizeOffset)-(CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)) + 16 - ItemSizeOffset, CameraPositionY + CraftingY + 16 - ItemSizeOffset), Texture.ItemSheet, , (CraftingGrid(0, Player.CraftingLevel, 1), CraftingGrid(0, Player.CraftingLevel, 2))-(CraftingGrid(0, Player.CraftingLevel, 1) + 15, CraftingGrid(0, Player.CraftingLevel, 2) + 15)

            If CursorHoverPage = 3 And CursorHoverX = Player.CraftingLevel Then PutImage (CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)), CameraPositionY + CraftingY)-(CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)) + 16, CameraPositionY + CraftingY + 16), Texture.HudSprites, , (32, 32)-(63, 63)
            If CursorSelectedPage = 3 And CursorSelectedX = Player.CraftingLevel And CursorMode = 1 Then PutImage (CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)), CameraPositionY + CraftingY)-(CameraPositionX + CraftingX - (CraftingSpace * (Player.CraftingLevel)) + 16, CameraPositionY + CraftingY + 16), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)


    End Select
End Sub

Sub DisplayContainer
    Dim i, ii, iii, iiii
    Dim As Single CraftingX, CraftingY, CraftingSpace, CraftingOffset
    Dim As Single ItemSizeOffset
    ItemSizeOffset = 2
    CraftingX = (ScreenRezX / 4 / 2) - 9
    CraftingY = (ScreenRezY / 4 / 2) - 12
    CraftingSpace = 17
    CraftingOffset = 1

    If Flag.ContainerOpen = 1 Then
        'draw background, itsm, and cursor
        For iii = 0 To ContainerSizeX
            For iiii = 0 To ContainerSizeY
                PutImage (CameraPositionX - CraftingX + (CraftingSpace * iii), CameraPositionY - CraftingY + (CraftingSpace * iiii))-(CameraPositionX - CraftingX + (CraftingSpace * iii) + 16, CameraPositionY - CraftingY + (CraftingSpace * iiii) + 16), Texture.HudSprites, , (0, 32)-(31, 63)
                PutImage (CameraPositionX - CraftingX + (CraftingSpace * iii) + ItemSizeOffset, CameraPositionY - CraftingY + (CraftingSpace * iiii) + ItemSizeOffset)-(CameraPositionX - CraftingX + (CraftingSpace * iii) + 16 - ItemSizeOffset, CameraPositionY - CraftingY + (CraftingSpace * iiii) + 16 - ItemSizeOffset), Texture.ItemSheet, , (Container(iiii, iii, 1), Container(iiii, iii, 2))-(Container(iiii, iii, 1) + 15, Container(iiii, iii, 2) + 15)

                If CursorHoverPage = 2 And CursorHoverX = iii And CursorHoverY = iiii Then PutImage (CameraPositionX - CraftingX + (CraftingSpace * iii), CameraPositionY - CraftingY + (CraftingSpace * iiii))-(CameraPositionX - CraftingX + (CraftingSpace * iii) + 16, CameraPositionY - CraftingY + (CraftingSpace * iiii) + 16), Texture.HudSprites, , (32, 32)-(63, 63)
                If CursorSelectedPage = 2 And CursorSelectedX = iii And CursorSelectedY = iiii And CursorMode = 1 Then PutImage (CameraPositionX - CraftingX + (CraftingSpace * iii), CameraPositionY - CraftingY + (CraftingSpace * iiii))-(CameraPositionX - CraftingX + (CraftingSpace * iii) + 16, CameraPositionY - CraftingY + (CraftingSpace * iiii) + 16), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)

            Next
        Next
    End If
End Sub


Sub NewContainer (MapX, Mapy, Tilex, Tiley)
    Dim total As Integer
    Dim i, ii, iii, empty
    Dim containertype
    containertype = WallTile(Tilex, Tiley)
    empty = -1
    total = 1
    If DirExists("Assets\Worlds\" + WorldName + "\Containers") = 0 Then MkDir "Assets\Worlds\" + WorldName + "\Containers"
    Open "Assets\Worlds\" + WorldName + "\Containers\" + Str$(MapX) + Str$(Mapy) + Str$(Tilex) + Str$(Tiley) + Str$(CurrentDimension) + ".cdf" As #1
    Put #1, total, ContainerData(containertype, 0): total = total + 1
    Put #1, total, ContainerData(containertype, 1): total = total + 1
    Put #1, total, ContainerData(containertype, 2): total = total + 1
    For i = 0 To ContainerData(containertype, 1)
        For ii = 0 To ContainerData(containertype, 0)
            For iii = 0 To InvParameters
                Put #1, total, empty: total = total + 1
            Next
        Next
    Next
    Close #1
End Sub

Sub OpenContainer (MapX, Mapy, Tilex, Tiley)
    Dim total As Integer
    Dim i, ii, iii, empty
    empty = -1
    total = 1
    Open "Assets\Worlds\" + WorldName + "\Containers\" + Str$(MapX) + Str$(Mapy) + Str$(Tilex) + Str$(Tiley) + Str$(CurrentDimension) + ".cdf" As #1
    Get #1, total, ContainerSizeX: total = total + 1
    Get #1, total, ContainerSizeY: total = total + 1
    Get #1, total, ContainerOTU: total = total + 1
    For i = 0 To ContainerSizeY
        For ii = 0 To ContainerSizeX
            For iii = 0 To InvParameters
                Get #1, total, Container(i, ii, iii): total = total + 1
            Next
        Next
    Next
    Close #1
End Sub

Sub CloseContainer (MapX, Mapy, Tilex, Tiley)
    Dim total As Integer
    Dim i, ii, iii, empty
    empty = -1
    total = 1
    Open "Assets\Worlds\" + WorldName + "\Containers\" + Str$(MapX) + Str$(Mapy) + Str$(Tilex) + Str$(Tiley) + Str$(CurrentDimension) + ".cdf" As #1
    Put #1, total, ContainerSizeX: total = total + 1
    Put #1, total, ContainerSizeY: total = total + 1
    Put #1, total, ContainerOTU: total = total + 1
    For i = 0 To ContainerSizeY
        For ii = 0 To ContainerSizeX
            For iii = 0 To InvParameters

                Put #1, total, Container(i, ii, iii): total = total + 1
            Next
        Next
    Next
    Close #1

End Sub








Sub NewStack (ItemID, StackNumber)
    Dim i, ii, iii
    Select Case CursorHoverPage


        Case 0 To 1
            For i = 0 To 3
                For ii = 0 To 5
                    If Inventory(i, ii, 9) = -1 Then
                        For iii = 0 To InvParameters
                            Inventory(i, ii, iii) = ItemIndex(ItemID, iii)
                        Next
                        Inventory(i, ii, 7) = StackNumber
                        Exit Sub
                    End If
                Next
            Next

        Case 2
        Case 3
            For i = 0 To Player.CraftingLevel - 1
                For ii = 0 To Player.CraftingLevel - 1
                    If CraftingGrid(i, ii, 9) = -1 Then
                        For iii = 0 To InvParameters
                            CraftingGrid(i, ii, iii) = ItemIndex(ItemID, iii)
                        Next
                        CraftingGrid(i, ii, 7) = StackNumber
                        Exit Sub
                    End If

                Next
            Next
    End Select
End Sub

Sub ItemSwap
    Dim As Byte i, ii, iii, CraftComplete
    Dim SwapItem1(InvParameters), Swapitem2(InvParameters)

    'prevent duplicating items by just attemting to swap an item with itself
    If CursorHoverX = CursorSelectedX And CursorHoverY = CursorSelectedY And CursorHoverPage = CursorSelectedPage Then Exit Sub

    'set the empty slots to -1
    For i = 0 To InvParameters
        SwapItem1(i) = -1
        Swapitem2(i) = -1
    Next


    'Put the source and destination in to dummy arrays to make it easier to work with
    For i = 0 To InvParameters
        Select Case CursorSelectedPage
            Case 0
                If GameMode = 1 Then
                    Swapitem2(i) = CreativeInventory(CursorSelectedY, CursorSelectedX, i, CreativePage)
                Else
                    Swapitem2(i) = Inventory(CursorSelectedY + 1, CursorSelectedX, i)
                End If
            Case 1
                Swapitem2(i) = Inventory(0, CursorSelectedX, i)
            Case 2
                Swapitem2(i) = Container(CursorSelectedY, CursorSelectedX, i)
            Case 3
                Swapitem2(i) = CraftingGrid(CursorSelectedY, CursorSelectedX, i)

        End Select

        Select Case CursorHoverPage
            Case 0
                If GameMode = 1 Then
                    SwapItem1(i) = CreativeInventory(CursorHoverY, CursorHoverX, i, CreativePage)
                Else
                    SwapItem1(i) = Inventory(CursorHoverY + 1, CursorHoverX, i)
                End If
            Case 1
                SwapItem1(i) = Inventory(0, CursorHoverX, i)
            Case 2
                SwapItem1(i) = Container(CursorHoverY, CursorHoverX, i)

            Case 3
                SwapItem1(i) = CraftingGrid(CursorHoverY, CursorHoverX, i)


        End Select
    Next

    'check and see if it involves the crafting table result
    If CursorHoverPage = 3 Then
        If CursorHoverX = Player.CraftingLevel Then
            If Swapitem2(0) <> -1 Then Exit Sub Else CraftComplete = 1
        End If
    End If
    If CursorSelectedPage = 3 Then
        If CursorSelectedX = Player.CraftingLevel Then
            If SwapItem1(0) <> -1 And SwapItem1(9) <> Swapitem2(9) Then Exit Sub Else CraftComplete = 1
        End If
    End If

    'swap the items, or stack if able
    If SwapItem1(9) = Swapitem2(9) Then
        SwapItem1(7) = SwapItem1(7) + Swapitem2(7)
        Swapitem2(7) = 0

        If SwapItem1(7) > SwapItem1(8) Then
            Swapitem2(7) = Swapitem2(7) + (SwapItem1(7) - SwapItem1(8))
            SwapItem1(7) = SwapItem1(8)
        End If

        If Swapitem2(7) = 0 Then
            For ii = 0 To InvParameters
                Swapitem2(ii) = -1
            Next
        End If

    Else
        For i = 0 To InvParameters
            Swap SwapItem1(i), Swapitem2(i)
        Next
    End If


    'rewrite the dummy variables to the source and dest
    For i = 0 To InvParameters
        Select Case CursorSelectedPage
            Case 0
                If GameMode = 1 Then

                Else
                    Inventory(CursorSelectedY + 1, CursorSelectedX, i) = Swapitem2(i)
                End If
            Case 1
                Inventory(0, CursorSelectedX, i) = Swapitem2(i)
            Case 2
                Container(CursorSelectedY, CursorSelectedX, i) = Swapitem2(i)

            Case 3
                CraftingGrid(CursorSelectedY, CursorSelectedX, i) = Swapitem2(i)
        End Select

        Select Case CursorHoverPage
            Case 0
                If GameMode = 1 Then

                Else
                    Inventory(CursorHoverY + 1, CursorHoverX, i) = SwapItem1(i)
                End If


            Case 1
                Inventory(0, CursorHoverX, i) = SwapItem1(i)
            Case 2
                Container(CursorHoverY, CursorHoverX, i) = SwapItem1(i)

            Case 3
                CraftingGrid(CursorHoverY, CursorHoverX, i) = SwapItem1(i)

        End Select
    Next

    'if the result was pulled from the crafting table, remove the table items
    If CraftComplete = 1 Then
        CraftComplete = 0
        For i = 0 To Player.CraftingLevel - 1
            For ii = 0 To Player.CraftingLevel - 1
                CraftingGrid(ii, i, 7) = CraftingGrid(ii, i, 7) - 1
                If CraftingGrid(ii, i, 7) <= 0 Then

                    For iii = 0 To InvParameters
                        CraftingGrid(ii, i, iii) = -1
                    Next
                End If
            Next
        Next
    End If
End Sub



Sub EmptySlot (slot, row)
    Dim i
    For i = 0 To InvParameters
        Inventory(row, slot, i) = -1
    Next
End Sub

Sub InputCursor
    Dim As Byte i, ii, iii

    If InventorySelect Then
        If CursorMode = 0 Then
            CursorSelectedX = CursorHoverX
            CursorSelectedY = CursorHoverY
            CursorSelectedPage = CursorHoverPage
            CursorMode = 1
        ElseIf CursorMode = 1 Then
            CursorMode = 0
            ItemSwap
        End If
    End If

    If InventoryTab Then
        CursorHoverPage = CursorHoverPage + 1
        If Flag.ContainerOpen = 0 And CursorHoverPage = 2 Then CursorHoverPage = 3
        If Flag.ContainerOpen = 0 And CursorSelectedPage = 2 Then CursorMode = 0
        If CursorHoverPage > 3 Then CursorHoverPage = 0

    End If
    If InventoryShiftTab Then
        CursorHoverPage = CursorHoverPage - 1
        If Flag.ContainerOpen = 0 And CursorHoverPage = 2 Then CursorHoverPage = 1
        If Flag.ContainerOpen = 0 And CursorSelectedPage = 2 Then CursorMode = 0
        If CursorHoverPage < 0 Then CursorHoverPage = 3

    End If

    If InventoryDrop Then
        'check if tile is air
        If WallTile(Int((Player.x + 8) / 16), Int((Player.y + 8) / 16)) = 1 Then
            'place grounditem tile

            'put cursorhover contents in ground item
        Else
            'play error sound
        End If
    End If


    If InventorySplit Then
        Select Case CursorHoverPage
            Case 0
                If Inventory(CursorHoverY + 1, CursorHoverX, 7) > 1 Then
                    NewStack Inventory(CursorHoverY + 1, CursorHoverX, 9), Int(Inventory(CursorHoverY + 1, CursorHoverX, 7) / 2)
                    Inventory(CursorHoverY + 1, CursorHoverX, 7) = Ceil(Inventory(CursorHoverY + 1, CursorHoverX, 7) / 2)
                End If
            Case 1
                If Inventory(CursorHoverY, CursorHoverX, 7) > 1 Then
                    NewStack Inventory(CursorHoverY, CursorHoverX, 9), Int(Inventory(CursorHoverY, CursorHoverX, 7) / 2)
                    Inventory(CursorHoverY, CursorHoverX, 7) = Ceil(Inventory(CursorHoverY, CursorHoverX, 7) / 2)
                End If
            Case 2
                If Container(CursorHoverY, CursorHoverX, 7) > 1 Then
                    NewStack Container(CursorHoverY, CursorHoverX, 9), Int(Container(CursorHoverY, CursorHoverX, 7) / 2)
                    Container(CursorHoverY, CursorHoverX, 7) = Ceil(Container(CursorHoverY, CursorHoverX, 7) / 2)
                End If

            Case 3
                If CraftingGrid(CursorHoverY, CursorHoverX, 7) > 1 Then
                    NewStack CraftingGrid(CursorHoverY, CursorHoverX, 9), Int(CraftingGrid(CursorHoverY, CursorHoverX, 7) / 2)
                    CraftingGrid(CursorHoverY, CursorHoverX, 7) = Ceil(CraftingGrid(CursorHoverY, CursorHoverX, 7) / 2)
                End If


        End Select
    End If

    If InventoryUp Then
        CursorHoverY = CursorHoverY + 1
        If CursorHoverPage = 2 Then CursorHoverY = CursorHoverY - 2

    End If
    If InventoryDown Then
        CursorHoverY = CursorHoverY - 1
        If CursorHoverPage = 2 Then CursorHoverY = CursorHoverY + 2
    End If
    If InventoryLeft Then
        CursorHoverX = CursorHoverX - 1
        If CursorHoverPage = 3 Then CursorHoverX = CursorHoverX + 2
    End If
    If InventoryRight Then
        CursorHoverX = CursorHoverX + 1
        If CursorHoverPage = 3 Then CursorHoverX = CursorHoverX - 2
    End If
    If InventoryUse And CursorHoverPage = 1 Then
        UseItem CursorHoverX
    End If

    Select Case CursorHoverPage
        Case 0 'Inventory
            If CursorHoverX > 5 Then CursorHoverX = 0: CreativePage = CreativePage + 1
            If CursorHoverX < 0 Then CursorHoverX = 5: CreativePage = CreativePage - 1
            If CreativePage > CreativePages Then CreativePage = 0
            If CreativePage < 0 Then CreativePage = CreativePages
            If CursorHoverY > 2 Then CursorHoverY = 0
            If CursorHoverY < 0 Then CursorHoverY = 2
        Case 1 'Hotbar
            If CursorHoverX > 5 Then CursorHoverX = 0
            If CursorHoverX < 0 Then CursorHoverX = 5
            CursorHoverY = 0
        Case 2 'Container
            If CursorHoverX > ContainerSizeX Then CursorHoverX = 0
            If CursorHoverX < 0 Then CursorHoverX = ContainerSizeX
            If CursorHoverY > ContainerSizeY Then CursorHoverY = 0
            If CursorHoverY < 0 Then CursorHoverY = ContainerSizeY
        Case 3 'Crafting
            If CursorHoverX > Player.CraftingLevel Then CursorHoverX = 0
            If CursorHoverX < 0 Then CursorHoverX = Player.CraftingLevel
            If CursorHoverY > Player.CraftingLevel - 1 Then CursorHoverY = 0
            If CursorHoverY < 0 Then CursorHoverY = Player.CraftingLevel - 1
            If CursorHoverX = Player.CraftingLevel Then CursorHoverY = 0

    End Select



End Sub

Sub Hud2
    If Flag.HudDisplay = 0 Then


        DisplayHealth
        DisplayHotbar
        If Flag.InventoryOpen = 1 Then
            DisplayInventory CreativePage
            DisplayCrafting
            DisplayContainer
            InputCursor
        End If

        DisplayLables

    End If
    UseHotBar
End Sub

Sub ClearTable
    Dim i, ii, iii As Byte
    For i = 0 To InvParameters
        For ii = 0 To 5
            For iii = 0 To 5
                CraftingGrid(i, ii, iii) = -1
            Next
        Next
    Next
End Sub


Function Item1
    Item1 = KeyDown(49)
End Function

Function Item2
    Item2 = KeyDown(50)
End Function

Function Item3
    Item3 = KeyDown(51)
End Function

Function Item4
    Item4 = KeyDown(52)
End Function

Function Item5
    Item5 = KeyDown(53)
End Function

Function Item6
    Item6 = KeyDown(54)
End Function



Function MoveUp
    MoveUp = KeyDown(119)
End Function

Function MoveDown
    MoveDown = KeyDown(115)
End Function

Function MoveLeft
    MoveLeft = KeyDown(97)
End Function

Function MoveRight
    MoveRight = KeyDown(100)
End Function


Function InventoryUp
    Static SingleHit As Byte
    If KeyDown(18432) And SingleHit <> 1 Then
        InventoryUp = KeyDown(18432)
        SingleHit = 1
    ElseIf KeyDown(18432) = 0 Then SingleHit = 0
    End If


End Function

Function InventoryDown
    Static SingleHit As Byte
    If KeyDown(20480) And SingleHit <> 1 Then
        InventoryDown = KeyDown(20480)
        SingleHit = 1
    ElseIf KeyDown(20480) = 0 Then SingleHit = 0
    End If
End Function

Function InventoryLeft
    Static SingleHit As Byte
    If KeyDown(19200) And SingleHit <> 1 Then
        InventoryLeft = KeyDown(19200)
        SingleHit = 1
    ElseIf KeyDown(19200) = 0 Then SingleHit = 0
    End If
End Function

Function InventoryRight
    Static SingleHit As Byte
    If KeyDown(19712) And SingleHit <> 1 Then
        InventoryRight = KeyDown(19712)
        SingleHit = 1
    ElseIf KeyDown(19712) = 0 Then SingleHit = 0
    End If


End Function

Function InventoryTab
    Static SingleHit As Byte
    If KeyDown(9) And SingleHit <> 1 Then
        InventoryTab = KeyDown(9)
        SingleHit = 1
    ElseIf KeyDown(9) = 0 Then SingleHit = 0
    End If
End Function

Function InventoryShiftTab
    Static SingleHit As Byte
    If KeyDown(100304) And SingleHit <> 1 Then
        InventoryShiftTab = KeyDown(100304)
        SingleHit = 1
    Else If KeyDown(100304) = 0 Then SingleHit = 0
    End If
End Function


Function InventorySelect
    Static SingleHit As Byte
    If KeyDown(13) And SingleHit <> 1 Then
        InventorySelect = KeyDown(13)
        SingleHit = 1
    ElseIf KeyDown(13) = 0 Then SingleHit = 0
    End If
End Function
Function InventorySplit
    Static SingleHit As Byte
    If KeyDown(92) And SingleHit <> 1 Then
        InventorySplit = KeyDown(92)
        SingleHit = 1
    ElseIf KeyDown(92) = 0 Then SingleHit = 0
    End If
End Function

Function InventoryUse
    InventoryUse = KeyDown(32)
End Function

Function InventoryDrop
    InventoryDrop = KeyDown(113)
End Function



Sub EntityDraw (PlayerRender As Byte)
    Static AnimationFrame As Byte
    Dim i
    Dim SpriteSheet As Long
    For i = 0 To CurrentEntities
        If i > 0 Then
            Select Case entity(i, 0)
                Case 0
                    SpriteSheet = Texture.DuckSheet
                Case 1
                    SpriteSheet = Texture.ZombieSheet
            End Select
            'set player and entity values to one set
        End If

    Next
End Sub

Sub tmp (playerrender)
    Dim dx, dy, anim
    If playerrender = 1 Then
        Select Case Player.facing
            Case 0
                dx = 16: dy = 0
                If Player.movingy = 1 Then
                    If anim < 15 Then dx = 0 Else If anim > 29 And anim < 45 Then dx = 32
                End If
            Case 1
                dx = 16: dy = 36
                If Player.movingy = 1 Then
                    If anim < 15 Then dx = 0 Else If anim > 29 And anim < 45 Then dx = 32
                End If
            Case 2
                dx = 16: dy = 54
                If Player.movingx = 1 Then
                    If anim < 15 Then dx = 0 Else If anim > 29 And anim < 45 Then dx = 32
                End If
            Case 3
                dx = 16: dy = 18
                If Player.movingx = 1 Then
                    If anim < 15 Then dx = 0 Else If anim > 29 And anim < 45 Then dx = 32
                End If
        End Select
        PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (dx, dy)-Step(15, 17 - SwimOffset)
    End If

End Sub
Sub SPSET (PlayerRender As Byte)
    Exit Sub
    Static anim As Byte
    Dim i
    'TEMP




    For i = 1 To CurrentEntities
        PutImage (Int(entity(i, 4)), Int(entity(i, 5)) - 2)-((Int(entity(i, 4))) + 16, (Int(entity(i, 5)) - 2) + 16), Texture.PlayerSprites, , (16, 18)-(31, 35)
    Next
    If PlayerRender = 1 Then
        Select Case Player.facing
            Case 0
                If Player.movingy = 1 Then
                    If anim < 15 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (0, 0)-(15, 17 - SwimOffset)
                    If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 0)-(31, 17 - SwimOffset)
                    If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (32, 0)-(47, 17 - SwimOffset)
                    If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 0)-(31, 17 - SwimOffset)
                Else
                    PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 0)-(31, 17 - SwimOffset)
                End If
            Case 1
                If Player.movingy = 1 Then
                    If anim < 15 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (0, 36)-(15, 54 - SwimOffset)
                    If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 36)-(31, 53 - SwimOffset)
                    If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (32, 36)-(47, 53 - SwimOffset)
                    If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 36)-(31, 53 - SwimOffset)
                Else
                    PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 36)-(31, 53 - SwimOffset)
                End If

            Case 2
                If Player.movingx = 1 Then
                    If anim < 15 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (0, 54)-(15, 71 - SwimOffset)
                    If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 54)-(31, 71 - SwimOffset)
                    If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (32, 54)-(47, 71 - SwimOffset)
                    If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 54)-(31, 71 - SwimOffset)
                Else
                    PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 54)-(31, 71 - SwimOffset)
                End If

            Case 3
                If Player.movingx = 1 Then
                    If anim < 15 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (0, 18)-(15, 35 - SwimOffset)
                    If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 18)-(31, 35 - SwimOffset)
                    If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (32, 18)-(47, 35 - SwimOffset)
                    If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 18)-(31, 35 - SwimOffset)
                Else
                    PutImage (Int(Player.x), Int(Player.y + SwimOffset) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), Texture.PlayerSprites, , (16, 18)-(31, 35 - SwimOffset)
                End If
        End Select
    End If

    anim = anim + Settings.TickRate
    If KeyDown(100306) = 0 Then anim = anim + Settings.TickRate
    If anim > 59 Then anim = 0

End Sub

Sub RenderEntities (PlayerRender As Byte)
    Dim i
    Dim PosX, PosY, Swim, Facing, MovingY, MovingX
    Dim CharacterSheet As Long
    Static Anim
    For i = 0 To CurrentEntities
        'mainly just for title screen to not render the player
        If PlayerRender = 0 And i = 0 Then i = 1

        'set variables properly because i still havent migrated player values to the entity array
        If i = 0 Then
            PosX = Player.x: PosY = Player.y: Swim = SwimOffset: Facing = Player.facing: MovingY = Player.movingy: MovingX = Player.movingx
        Else
            PosX = entity(i, 4): PosY = entity(i, 5): Swim = entity(i, 17): Facing = entity(i, 16): MovingX = entity(i, 10): MovingY = entity(i, 11)
        End If
        CharacterSheet = EntitySheet&(entity(i, 0))


        'im tired and too lazy to actually rewrite this properly so im just saying fuck it and pasting the shitty code i already had with a few tweeks, if you feel like rewriting this utter garbage properly, suit yourself
        Select Case Facing
            Case 0
                If MovingY <> 0 Then
                    If Anim < 15 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (0, 0)-(15, 17 - Swim)
                    If Anim > 14 And Anim < 30 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 0)-(31, 17 - Swim)
                    If Anim > 29 And Anim < 45 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (32, 0)-(47, 17 - Swim)
                    If Anim > 44 And Anim < 60 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 0)-(31, 17 - Swim)
                Else
                    PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 0)-(31, 17 - Swim)
                End If
            Case 1
                If MovingY <> 0 Then
                    If Anim < 15 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (0, 36)-(15, 54 - Swim)
                    If Anim > 14 And Anim < 30 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 36)-(31, 53 - Swim)
                    If Anim > 29 And Anim < 45 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (32, 36)-(47, 53 - Swim)
                    If Anim > 44 And Anim < 60 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 36)-(31, 53 - Swim)
                Else
                    PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 36)-(31, 53 - Swim)
                End If

            Case 2
                If MovingX <> 0 Then
                    If Anim < 15 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (0, 54)-(15, 71 - Swim)
                    If Anim > 14 And Anim < 30 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 54)-(31, 71 - Swim)
                    If Anim > 29 And Anim < 45 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (32, 54)-(47, 71 - Swim)
                    If Anim > 44 And Anim < 60 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 54)-(31, 71 - Swim)
                Else
                    PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 54)-(31, 71 - Swim)
                End If

            Case 3
                If MovingX <> 0 Then
                    If Anim < 15 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (0, 18)-(15, 35 - Swim)
                    If Anim > 14 And Anim < 30 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 18)-(31, 35 - Swim)
                    If Anim > 29 And Anim < 45 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (32, 18)-(47, 35 - Swim)
                    If Anim > 44 And Anim < 60 Then PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 18)-(31, 35 - Swim)
                Else
                    PutImage (Int(PosX), Int(PosY + Swim) - 2)-((Int(PosX)) + 16, (Int(PosY) - 2) + 16), CharacterSheet, , (16, 18)-(31, 35 - Swim)
                End If
        End Select


    Next
    Anim = Anim + Settings.TickRate + 1
    If Anim > 59 Then Anim = 0

End Sub

Function EntitySheet& (ID)
    Select Case ID
        Case 0
            EntitySheet& = Texture.PlayerSheet
        Case 1
            EntitySheet& = Texture.DuckSheet
        Case 2
            EntitySheet& = Texture.ZombieSheet
        Case Else
            End

    End Select
End Function

Function WithinBounds
    If Player.x > 0 And Player.y > 0 And Player.x < 640 - 16 And Player.y < 480 - 16 Then WithinBounds = 1 Else WithinBounds = 0
End Function


Sub ContactEffect (Direction As Byte, Entity As Single)
    Dim PosX, PosY
    If WithinBounds = 1 Then

        If Entity = 0 Then PosX = Player.x: PosY = Player.y Else PosX = entity(Entity, 4): PosY = entity(Entity, 5)
        Select Case Direction
            Case 1
                Effects 1, "Contact " + TileName(WallTile(Int((PosX + 8) / 16) + 1, Int((PosY + 8 - 16) / 16) + 1), 0), Entity
                'Print "Contact " + TileName(WallTile(playertilex, Int((Player.y + 8 - 16) / 16) + 1), 0)
            Case 2
                Effects 1, "Contact " + TileName(WallTile(Int((PosX + 8) / 16) + 1, Int((PosY + 8 + 16) / 16) + 1), 0), Entity
                'Print "Contact " + TileName(WallTile(playertilex, Int((Player.y + 8 + 16) / 16) + 1), 0)
            Case 3
                Effects 1, "Contact " + TileName(WallTile(Int((PosX + 8 - 16) / 16) + 1, Int((PosY + 8) / 16) + 1), 0), Entity
                'Print "Contact " + TileName(WallTile(Int((Player.x + 8 - 16) / 16) + 1, playertiley), 0)
            Case 4
                Effects 1, "Contact " + TileName(WallTile(Int((PosX + 8 + 16) / 16) + 1, Int((PosY + 8) / 16) + 1), 0), Entity
                'Print "Contact " + TileName(WallTile(Int((Player.x + 8 + 16) / 16) + 1, playertiley), 0)
        End Select

    End If

End Sub

Sub OnTopEffect (Entity As Single)
    Dim As Single posx, posy
    If WithinBounds = 1 Then

        If Entity = 0 Then posx = Player.x: posy = Player.y Else posx = entity(Entity, 4): posy = entity(Entity, 5)

        Effects 1, "OnTop " + TileName(GroundTile(Int((posx + 8) / 16) + 1, Int((posy + 8) / 16) + 1), 0), Entity
    End If
End Sub
Sub InSideEffect (entity As Single)
    Dim As Single posx, posy
    If WithinBounds = 1 Then

        If entity = 0 Then posx = Player.x: posy = Player.y Else posx = entity(entity, 4): posy = entity(entity, 5)

        Effects 1, "Inside " + TileName(WallTile(Int((posx + 8) / 16) + 1, Int((posy + 8) / 16) + 1), 0), entity
    End If
End Sub
Sub UnderEffect (entity As Single)
    Dim As Single posx, posy
    If WithinBounds = 1 Then

        If entity = 0 Then posx = Player.x: posy = Player.y Else posx = entity(entity, 4): posy = entity(entity, 5)

        Effects 1, "Under " + TileName(CeilingTile(Int((posx + 8) / 16) + 1, Int((posy + 8) / 16) + 1), 0), entity
    End If
End Sub




Sub EffectExecute (ID As Integer, Val1 As Single, Entity As Single)

    Select Case ID
        Case 1 'Instant Damage
            If Entity = 0 Then
                If GameMode <> 1 And ImmunityTimer = 0 Then Player.health = Player.health - Val1
                'possibly move damage sound here, and play a different sound for entity??
            Else
                entity(Entity, 1) = entity(Entity, 1) - Val1
            End If
            If ImmunityTimer = 0 Then PlaySound Sounds.damage_bush
        Case 2 'Swimming
            If Entity = 0 Then
                SwimOffset = Val1
            Else
                entity(Entity, 17) = Val1
            End If

        Case 3 'Instant Health
            If GameMode <> 1 Then
                If Player.health < (Player.MaxHealth + 1) * 8 Then
                    Player.health = Player.health + Val1
                End If
            End If
        Case 4 'max health increase
            Player.MaxHealth = Player.MaxHealth + Val1
        Case 5 'Immunity
            ImmunityTimer = ImmunityTimer + 1
            If ImmunityTimer > Val1 + 1 Then ImmunityTimer = 1: ImmunityFlash = ImmunityFlash + 1
        Case 6 'poison
            If Entity = 0 Then
                HealthWheelOffset = 64
                If GameMode <> 1 And ImmunityTimer = 0 Then Player.health = Player.health - Val1
            Else
                entity(Entity, 1) = entity(Entity, 1) - Val1
            End If

        Case 7 'regen
            If Entity = 0 Then
                HealthWheelOffset = 96
                If GameMode <> 1 Then
                    If Player.health < (Player.MaxHealth + 1) * 8 Then
                        Player.health = Player.health + Val1
                    End If
                End If

            Else
            End If
        Case 8 'Melee damage
            If Entity = 0 Then
                If GameMode <> 1 And ImmunityTimer = 0 Then Player.health = Player.health - Val1
                'possibly move damage sound here, and play a different sound for entity??
            Else
                entity(Entity, 1) = entity(Entity, 1) - Val1
            End If
            If ImmunityTimer = 0 Then PlaySound Sounds.damage_melee
        Case 9
            If Entity = 0 Then
                If GameMode <> 1 And ImmunityTimer = 0 Then Player.health = Player.health - Val1
                Player.BodyTemp = 2
            Else
                entity(Entity, 1) = entity(Entity, 1) - Val1
            End If

        Case 10
            If Entity = 0 Then
                If GameMode <> 1 And ImmunityTimer = 0 Then Player.health = Player.health - Val1
                Player.BodyTemp = 1
            Else
                entity(Entity, 1) = entity(Entity, 1) - Val1
            End If

        Case 11
            If WallTile(PlayerTileX, PlayerTileY) = 16 Then
                If Entity = 0 Then
                    SAVEMAP
                    CurrentDimension = CurrentDimension + 1
                    LOADMAP SavedMap
                    GroundTile(PlayerTileX, PlayerTileY) = 16
                    UpdateTile PlayerTileX, PlayerTileY
                    SpreadLight 10
                    Exit Select


                End If

            End If
            If GroundTile(PlayerTileX, PlayerTileY) = 16 Then
                If Entity = 0 Then
                    SAVEMAP
                    CurrentDimension = CurrentDimension - 1
                    LOADMAP SavedMap
                    WallTile(PlayerTileX, PlayerTileY) = 16
                    UpdateTile PlayerTileX, PlayerTileY
                    SpreadLight 10
                    Exit Select
                End If

            End If


    End Select


End Sub

Function EffectIndex (Sources As String, Value As Single)
    Select Case Sources
        Case "Temperature Freezing"
            Select Case Value
                Case 0
                    EffectIndex = 9 'effectid
                Case 1
                    EffectIndex = 2 'frame duration
                Case 2
                    EffectIndex = 120 'frame cooldown
                Case 3
                    EffectIndex = 1 'damage
            End Select

        Case "Temperature Burning"
            Select Case Value
                Case 0
                    EffectIndex = 10 'effectid
                Case 1
                    EffectIndex = 2 'frame duration
                Case 2
                    EffectIndex = 120 'frame cooldown
                Case 3
                    EffectIndex = 1 'damage
            End Select

        Case "Melee Damage"
            Select Case Value
                Case 0
                    EffectIndex = 8
                Case 1
                    EffectIndex = 2
                Case 2
                    EffectIndex = 0
                Case 3
                    EffectIndex = Inventory(0, CursorHoverX, 6)
            End Select

        Case "Immunity Respawn"
            Select Case Value
                Case 0
                    EffectIndex = 5
                Case 1
                    EffectIndex = 180
                Case 2
                    EffectIndex = 0
                Case 3
                    EffectIndex = 15
            End Select
        Case "Contact Campfire"
            Select Case Value
                Case 0
                    EffectIndex = 1 'effectid
                Case 1
                    EffectIndex = 2 'frame duration
                Case 2
                    EffectIndex = 15 'frame cooldown
                Case 3
                    EffectIndex = 2 'damage
            End Select

        Case "Contact Berry Bush"
            Select Case Value
                Case 0
                    EffectIndex = 1 'effectid
                Case 1
                    EffectIndex = 2 'frame duration
                Case 2
                    EffectIndex = 30 'frame cooldown
                Case 3
                    EffectIndex = 1 'damage
            End Select

        Case "Touch Zombie"
            Select Case Value
                Case 0
                    EffectIndex = 1 'effectid
                Case 1
                    EffectIndex = 2 'frame duration
                Case 2
                    EffectIndex = 30 'frame cooldown
                Case 3
                    EffectIndex = 1 'damage

            End Select


        Case "OnTop Water"
            Select Case Value
                Case 0
                    EffectIndex = 2
                Case 1
                    EffectIndex = 2
                Case 2
                    EffectIndex = 0
                Case 3
                    EffectIndex = 7
            End Select
        Case "OnTop Wooden Ladder"
            Select Case Value
                Case 0
                    EffectIndex = 11 'effectid
                Case 1
                    EffectIndex = 2 'frame duration
                Case 2
                    EffectIndex = 600 'frame cooldown
                Case 3
                    EffectIndex = 0

            End Select
        Case "Inside Wooden Ladder"
            Select Case Value
                Case 0
                    EffectIndex = 11 'effectid
                Case 1
                    EffectIndex = 2 'frame duration
                Case 2
                    EffectIndex = 600 'frame cooldown
                Case 3
                    EffectIndex = 0

            End Select


        Case "Consume Red Berries"
            Select Case Value
                Case 0
                    EffectIndex = 3 'effectid
                Case 1
                    EffectIndex = 2 'frameduration
                Case 2
                    EffectIndex = 0 'framecooldown
                Case 3
                    EffectIndex = 1 'value
            End Select
        Case "Consume Health Wheel"
            Select Case Value
                Case 0
                    EffectIndex = 4 'effectid
                Case 1
                    EffectIndex = 2 'frameduration
                Case 2
                    EffectIndex = 0 '18000 'framecooldown
                Case 3
                    EffectIndex = 1 'value
            End Select
        Case "Consume Carrot"
            Select Case Value
                Case 0
                    EffectIndex = 3 'effectid
                Case 1
                    EffectIndex = 2 'frameduration
                Case 2
                    EffectIndex = 0 'framecooldown
                Case 3
                    EffectIndex = 3 'value
            End Select
        Case "Consume Eggplant"
            Select Case Value
                Case 0
                    EffectIndex = 7 'effectid
                Case 1
                    EffectIndex = 482 'frameduration
                Case 2
                    EffectIndex = 482 'framecooldown
                Case 3
                    EffectIndex = 1 'value
                Case 4
                    EffectIndex = 120 'framedelay
            End Select
        Case "Consume Decayed Flesh"
            Select Case Value
                Case 0
                    EffectIndex = 6 'effectid
                Case 1
                    EffectIndex = 242 'frameduration
                Case 2
                    EffectIndex = 242 'framecooldown
                Case 3
                    EffectIndex = 1 'value
                Case 4
                    EffectIndex = 120 'framedelay
            End Select
        Case "Consume Duck Meat"
            Select Case Value
                Case 0
                    EffectIndex = 7 'effectid
                Case 1
                    EffectIndex = 242 'frameduration
                Case 2
                    EffectIndex = 242 'framecooldown
                Case 3
                    EffectIndex = 1 'value
                Case 4
                    EffectIndex = 120 'framedelay
            End Select



        Case Else
            EffectIndex = 0
    End Select
End Function

Sub EffectEnd (EffectID As Integer, EffectSlot As Integer, Entity As Single)
    Dim i As Byte

    Select Case EffectID
        Case 1
        Case 2
            If Entity = 0 Then SwimOffset = 0 Else entity(Entity, 17) = 0
        Case 3
        Case 4
        Case 5
            ImmunityTimer = 0: ImmunityFlash = 0
        Case 6, 7
            HealthWheelOffset = 0
        Case 9, 10
            Player.BodyTemp = 0
    End Select

    For i = 0 To EffectParameters
        EffectArray(EffectSlot, i, Entity) = 0
    Next

End Sub



Sub Effects (Command As Byte, Sources As String, Entity As Single)
    Dim As Byte i, ii
    Dim EffectSources(MaxEffects) As String

    Select Case Command
        Case 0 'count down and execute effect
            For i = 0 To MaxEffects
                If EffectArray(i, 1, Entity) > 0 Then EffectArray(i, 1, Entity) = EffectArray(i, 1, Entity) - Settings.TickRate
                If EffectArray(i, 2, Entity) > 0 Then EffectArray(i, 2, Entity) = EffectArray(i, 2, Entity) - Settings.TickRate
                If EffectArray(i, 1, Entity) > 0 Then
                    If EffectArray(i, 4, Entity) > 0 Then
                        If EffectArray(i, 1, Entity) Mod EffectArray(i, 4, Entity) = 0 Then
                            EffectExecute EffectArray(i, 0, Entity), EffectArray(i, 3, Entity), Entity
                        End If
                    Else
                        EffectExecute EffectArray(i, 0, Entity), EffectArray(i, 3, Entity), Entity
                    End If
                End If
                If EffectArray(i, 1, Entity) <= 0 And EffectArray(i, 2, Entity) <= 0 Then
                    EffectEnd EffectArray(i, 0, Entity), i, Entity
                End If
            Next
        Case 1 ' apply new effect
            For i = 0 To MaxEffects
                If EffectArray(i, 0, Entity) = 0 Then
                    For ii = 0 To EffectParameters
                        EffectArray(i, ii, Entity) = EffectIndex(Sources, ii)
                    Next
                    Exit Case
                End If
                If EffectArray(i, 0, Entity) = EffectIndex(Sources, 0) Then
                    If EffectArray(i, 2, Entity) <= 0 Or EffectArray(i, 4, Entity) = 1 Then
                        For ii = 0 To EffectParameters
                            EffectArray(i, ii, Entity) = EffectIndex(Sources, ii)
                        Next
                    End If
                    Exit Case
                End If
            Next
    End Select
End Sub





Sub Move
    Static SoundCooldown As Byte
    Player.movingx = 0 'sets to 0 and then if a key is being held, sets back to 1 before anyone notices
    Player.movingy = 0 'sets to 0 and then if a key is being held, sets back to 1 before anyone notices
    Player.lastx = Player.x 'these 2 are literally just for the freecammode EDIT: SIKE THIS IS ACTUALLY FUCKING USED FOR COLLISION CALCULATION TOO
    Player.lasty = Player.y


    If MoveUp Then
        Player.vy = Player.vy - TileData(PlayerTileX, PlayerTileY, 9)
        Player.facing = 0
        Player.movingy = 1
    End If
    If MoveDown Then
        Player.vy = Player.vy + TileData(PlayerTileX, PlayerTileY, 9)
        Player.facing = 1
        Player.movingy = 1

    End If
    If MoveLeft Then
        Player.vx = Player.vx - TileData(PlayerTileX, PlayerTileY, 9)
        Player.facing = 2
        Player.movingx = 1
    End If
    If MoveRight Then
        Player.vx = Player.vx + TileData(PlayerTileX, PlayerTileY, 9)
        Player.facing = 3
        Player.movingx = 1
    End If

    If Player.vy > TileData(PlayerTileX, PlayerTileY, 10) Then Player.vy = TileData(PlayerTileX, PlayerTileY, 10)
    If Player.vy < TileData(PlayerTileX, PlayerTileY, 10) - (TileData(PlayerTileX, PlayerTileY, 10) * 2) Then Player.vy = TileData(PlayerTileX, PlayerTileY, 10) - (TileData(PlayerTileX, PlayerTileY, 10) * 2)

    If Player.vx > TileData(PlayerTileX, PlayerTileY, 10) Then Player.vx = TileData(PlayerTileX, PlayerTileY, 10)
    If Player.vx < TileData(PlayerTileX, PlayerTileY, 10) - (TileData(PlayerTileX, PlayerTileY, 10) * 2) Then Player.vx = TileData(PlayerTileX, PlayerTileY, 10) - (TileData(PlayerTileX, PlayerTileY, 10) * 2)

    If Player.movingy = 0 Then
        If Player.vy > 0 Then
            Player.vy = Player.vy - TileData(PlayerTileX, PlayerTileY, 9)
        End If
        If Player.vy < 0 Then
            Player.vy = Player.vy + TileData(PlayerTileX, PlayerTileY, 9)
            If Player.vy > 0 Then Player.vy = 0
        End If
    End If
    If Player.movingx = 0 Then
        If Player.vx > 0 Then
            Player.vx = Player.vx - TileData(PlayerTileX, PlayerTileY, 9)
        End If
        If Player.vx < 0 Then
            Player.vx = Player.vx + TileData(PlayerTileX, PlayerTileY, 9)
            If Player.vx > 0 Then Player.vx = 0
        End If
    End If

    If Player.movingx = 1 Or Player.movingy = 1 Then SoundCooldown = SoundCooldown - 1

    If SoundCooldown <= 0 Then
        If WithinBounds = 1 Then
            If GroundTile(PlayerTileX, PlayerTileY) = 13 Then
                SoundCooldown = 60
                PlaySound Sounds.walk_water

            Else
                SoundCooldown = 15
                PlaySound Sounds.walk_grass
            End If
        End If
    End If

    Player.x = Player.x + Player.vx
    Player.y = Player.y + Player.vy

    'stops the player from going out of bounds
    If Player.x <= 0 Then Player.x = 0
    If Player.y <= 0 Then Player.y = 0
    If Player.x >= 640 - 16 Then Player.x = 640 - 16
    If Player.y >= 480 - 16 Then Player.y = 480 - 16

    'self explanitory, but if you must know its to control the camera in freecam mode
    If Flag.FreeCam = 1 Then
        Player.x = Player.lastx
        Player.y = Player.lasty
        If Player.movingx = 1 Or Player.movingy = 1 Then
            Select Case Player.facing
                Case 0
                    CameraPositionY = CameraPositionY - 1
                Case 1
                    CameraPositionY = CameraPositionY + 1
                Case 2
                    CameraPositionX = CameraPositionX - 1
                Case 3
                    CameraPositionX = CameraPositionX + 1
            End Select
            Player.movingx = 0
            Player.movingy = 0
        End If
    End If

End Sub


Sub MinMemFix 'this subroutine is specifically to try to fix a memory leak that occurs when in hardware accelerated mode, and the game is minimized. by simply turning off hardware acceleration.
    'Exit Sub
    Static Last
    Select Case ScreenIcon
        Case -1
            If Last = -1 Then Exit Select
            SwitchRender 0
            Last = -1
        Case 0
            If Last = 0 Then Exit Select
            SwitchRender 1
            Last = 0

    End Select
End Sub

Function PickUpItem (ItemID)
    Static PickupDelay As Single
    If PickupDelay > CurrentTick Then
        PickUpItem = 1
        Exit Function
    End If
    If ItemID = -1 Then Exit Function
    Dim i, ii, iii
    For i = 0 To 3
        For ii = 0 To 5
            If Inventory(i, ii, 9) = ItemID Then
                Inventory(i, ii, 7) = Inventory(i, ii, 7) + 1
                If Inventory(i, ii, 7) > Inventory(i, ii, 8) Then Inventory(i, ii, 7) = Inventory(i, ii, 8): GoTo FullStack
                GoTo PickedUp
                FullStack:
            End If
        Next
    Next
    NewStack:
    For i = 0 To 3
        For ii = 0 To 5
            If Inventory(i, ii, 9) = -1 Then
                For iii = 0 To InvParameters
                    Inventory(i, ii, iii) = ItemIndex(ItemID, iii)
                Next
                GoTo PickedUp
            End If
        Next
    Next
    Alert 0, "Could not pick up item, Inventory full."
    PickUpItem = 1
    PickupDelay = CurrentTick + 60
    Exit Function
    PickedUp:
    PickUpItem = 0
End Function
Function FacingX
    Select Case Player.facing
        Case 0
            FacingX = PlayerTileX

        Case 1
            FacingX = PlayerTileX

        Case 2
            FacingX = Int((Player.x + 8 - 16) / 16) + 1

        Case 3
            FacingX = Int((Player.x + 8 + 16) / 16) + 1

    End Select

End Function

Function FacingY
    Select Case Player.facing
        Case 0

            FacingY = Int((Player.y + 8 - 16) / 16) + 1
        Case 1

            FacingY = Int((Player.y + 8 + 16) / 16) + 1
        Case 2

            FacingY = PlayerTileY
        Case 3

            FacingY = PlayerTileY
    End Select

End Function

Sub FadeIn
    Static FadeStep
    Static StepDelay

    'incriment per frame
    StepDelay = StepDelay + 1

    'repeat basically what the fade out is doing, but fade in
    If StepDelay > 5 Then
        StepDelay = 0
        FadeStep = FadeStep + 2
    End If
    'set light level
    OverlayLightLevel = 12 - FadeStep

    'see if fully faded in
    If FadeStep >= 12 Then Flag.FadeIn = 0: FadeStep = 0: StepDelay = 0

End Sub

Sub ChangeMap (Command, CommandMapX, CommandMapY)
    Static TickDelay
    Static TotalDelay
    Static LightStep
    Dim i, ii
    If LightStep <= 12 Then
        Select Case Player.facing
            Case 0
                If Player.y <= 0 And Player.x = Player.lastx And Player.movingy = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 1
                If Player.y >= 480 - 16 And Player.x = Player.lastx And Player.movingy = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 2
                If Player.x <= 0 And Player.y = Player.lasty And Player.movingx = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 3
                If Player.x >= 640 - 16 And Player.y = Player.lasty And Player.movingx = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate


        End Select
        If Command = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
        If TickDelay = 5 Then TickDelay = 0: LightStep = LightStep + 2
        If Command = 1 Then ChangeMap 1, CommandMapX, CommandMapY
    Else
        SAVEMAP
        CurrentEntities = 0
        If Command = 0 Then
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
        End If
        If Command = 1 Then
            SavedMapX = CommandMapX
            SavedMapY = CommandMapY
            LOADMAP (SavedMap)
        End If
        For i = 0 To 31
            For ii = 0 To 41
                UpdateTile ii, i
            Next
        Next
        SpreadLight (1)
        Flag.FadeIn = 1
        LightStep = 0
    End If

    If Player.movingx = 0 And Player.movingy = 0 And Command = 0 Then TickDelay = 0: TotalDelay = 0: LightStep = 0
    OverlayLightLevel = LightStep

    'Print Player.x; Player.y; Player.lasty; Player.moving; Player.facing; TickDelay; Settings.TickRate
End Sub

Sub UpdateTile (TileX, TileY)
    Dim i, ii
    If TileIndexData(GroundTile(TileX, TileY), 0) = 1 Or TileIndexData(WallTile(TileX, TileY), 0) = 1 Then TileData(TileX, TileY, 0) = 1 Else TileData(TileX, TileY, 0) = 0
    If TileIndexData(GroundTile(TileX, TileY), 1) = 1 Or TileIndexData(WallTile(TileX, TileY), 1) = 1 Then TileData(TileX, TileY, 1) = 1 Else TileData(TileX, TileY, 1) = 0
    If TileIndexData(GroundTile(TileX, TileY), 2) = 1 Or TileIndexData(WallTile(TileX, TileY), 2) = 1 Then TileData(TileX, TileY, 2) = 1 Else TileData(TileX, TileY, 2) = 0
    If TileIndexData(GroundTile(TileX, TileY), 3) = 1 And TileIndexData(WallTile(TileX, TileY), 2) = 0 Then TileData(TileX, TileY, 3) = 1 Else TileData(TileX, TileY, 3) = 0
    '  TileData(TileX, TileY, 4) = TileIndexData(GroundTile(TileX, TileY), 4)
    '  TileData(TileX, TileY, 5) = TileIndexData(WallTile(TileX, TileY), 4)
    '  TileData(TileX, TileY, 6) = TileIndexData(CeilingTile(TileX, TileY), 4)
    TileData(TileX, TileY, 7) = TileIndexData(WallTile(TileX, TileY), 5)
    For i = 1 To 30
        For ii = 1 To 40
            TileData(TileX, TileY, 8) = 0
        Next
    Next

    If TileIndexData(GroundTile(TileX, TileY), 6) > TileData(TileX, TileY, 8) Then TileData(TileX, TileY, 8) = TileIndexData(GroundTile(TileX, TileY), 6)
    If TileIndexData(WallTile(TileX, TileY), 6) > TileData(TileX, TileY, 8) Then TileData(TileX, TileY, 8) = TileIndexData(WallTile(TileX, TileY), 6)
    If TileIndexData(CeilingTile(TileX, TileY), 6) > TileData(TileX, TileY, 8) Then TileData(TileX, TileY, 8) = TileIndexData(CeilingTile(TileX, TileY), 6)
    TileData(TileX, TileY, 9) = TileIndexData(GroundTile(TileX, TileY), 9)
    TileData(TileX, TileY, 10) = TileIndexData(GroundTile(TileX, TileY), 10)
    TileData(TileX, TileY, 16) = TileIndexData(GroundTile(TileX, TileY), 16) + TileIndexData(WallTile(TileX, TileY), 16) + TileIndexData(CeilingTile(TileX, TileY), 16)

End Sub
'For i = TileData(TileX, TileY, 8) To 0 Step -1

'Next

Sub Alert (img, message As String)
    Static timeout
    timeout = timeout + Settings.TickRate
    Locate 20, 1
    ENDPRINT message
    If timeout < 60 Then Alert img, message Else timeout = 0
End Sub

Sub INTER
    Select Case KeyPressed
        Case 15616
            Flag.DebugMode = Flag.DebugMode + 1
        Case 15104
            Flag.HudDisplay = Flag.HudDisplay + 1
        Case 101
            Flag.InventoryOpen = Flag.InventoryOpen + 1
        Case 27
            PauseMenu

    End Select
End Sub


Sub Crafting
    Dim recipe As String
    Dim i, ii, iii As Byte

    For i = Player.CraftingLevel - 1 To 0 Step -1
        For ii = Player.CraftingLevel - 1 To 0 Step -1
            recipe = recipe + Trim$(Str$(CraftingGrid(i, ii, 9))) + " "
        Next
        recipe = recipe + "|"
    Next
    For i = 0 To InvParameters
        CraftingGrid(0, Player.CraftingLevel, i) = -1
    Next
    For i = 0 To InvParameters
        Select Case recipe
            Case "-1 -1 -1 |-1 5 -1 |-1 -1 -1 |" 'raw wood
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(19, i)
                CraftingGrid(0, Player.CraftingLevel, 7) = 4

            Case "19 19 |19 19 |" 'crafting station
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(21, i)

            Case "-1 -1 -1 |-1 5 -1 |19 19 19 |" 'Campfire
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(10, i)

            Case "19 19 19 |19 19 19 |19 19 19 |" 'Wood Wall
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(8, i)
                CraftingGrid(0, Player.CraftingLevel, 7) = 9

            Case "-1 19 -1 |-1 22 -1 |-1 22 -1 |" 'wooden shovel
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(15, i)

            Case "19 19 -1 |19 22 -1 |-1 22 -1 |" 'wooden axe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(16, i)

            Case "-1 19 -1 |-1 19 -1 |-1 22 -1 |" 'wooden sword
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(18, i)

            Case "19 19 19 |-1 22 -1 |-1 22 -1 |" 'wooden pickaxe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(17, i)

            Case "19 19 -1 |-1 22 -1 |-1 22 -1 |" 'wooden hoe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(30, i)


            Case "-1 29 -1 |-1 22 -1 |-1 22 -1 |" 'stone shovel
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(31, i)

            Case "29 29 -1 |29 22 -1 |-1 22 -1 |" 'stone axe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(32, i)

            Case "29 29 29 |-1 22 -1 |-1 22 -1 |" 'stonepickaxe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(33, i)

            Case "-1 29 -1 |-1 29 -1 |-1 22 -1 |" 'stone sword
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(34, i)

            Case "29 29 -1 |-1 22 -1 |-1 22 -1 |" 'stone hoe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(35, i)


            Case "-1 46 -1 |-1 22 -1 |-1 22 -1 |" 'tin shovel
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(59, i)

            Case "46 46 -1 |46 22 -1 |-1 22 -1 |" 'tin axe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(60, i)

            Case "46 46 46 |-1 22 -1 |-1 22 -1 |" 'tin pickaxe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(61, i)

            Case "-1 46 -1 |-1 46 -1 |-1 22 -1 |" 'tin sword
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(62, i)

            Case "46 46 -1 |-1 22 -1 |-1 22 -1 |" 'tin hoe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(63, i)


            Case "-1 47 -1 |-1 22 -1 |-1 22 -1 |" 'copper shovel
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(64, i)

            Case "47 47 -1 |47 22 -1 |-1 22 -1 |" 'copper axe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(65, i)

            Case "47 47 47 |-1 22 -1 |-1 22 -1 |" 'copper pickaxe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(66, i)

            Case "-1 47 -1 |-1 47 -1 |-1 22 -1 |" 'copper sword
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(67, i)

            Case "47 47 -1 |-1 22 -1 |-1 22 -1 |" 'copper hoe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(68, i)


            Case "-1 48 -1 |-1 22 -1 |-1 22 -1 |" 'irom shovel
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(69, i)

            Case "48 48 -1 |48 22 -1 |-1 22 -1 |" 'iron axe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(70, i)

            Case "48 48 48 |-1 22 -1 |-1 22 -1 |" 'iron pickaxe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(71, i)

            Case "-1 48 -1 |-1 48 -1 |-1 22 -1 |" 'iron sword
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(72, i)

            Case "48 48 -1 |-1 22 -1 |-1 22 -1 |" 'iron hoe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(73, i)


            Case "-1 49 -1 |-1 54 -1 |-1 54 -1 |" 'platinum shovel
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(74, i)

            Case "49 49 -1 |49 54 -1 |-1 54 -1 |" 'platinum axe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(75, i)

            Case "49 49 49 |-1 54 -1 |-1 54 -1 |" 'platinum pickaxe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(76, i)

            Case "-1 49 -1 |-1 49 -1 |-1 54 -1 |" 'platinum sword
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(77, i)

            Case "49 49 -1 |-1 54 -1 |-1 54 -1 |" 'platinum hoe
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(78, i)

            Case "-1 -1 -1 |19 19 19 |19 19 19 |" 'Wooden Floor
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(100, i)
                CraftingGrid(0, Player.CraftingLevel, 7) = 6

            Case "29 29 29 |29 29 29 |29 29 29 |" 'cobblestone Wall
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(7, i)
                CraftingGrid(0, Player.CraftingLevel, 7) = 9

            Case "-1 -1 -1 |-1 19 -1 |-1 19 -1 |" 'Tool Handle
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(22, i)

            Case "-1 48 -1 |48 22 48 |-1 48 -1 |" 'Iron Handle
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(54, i)


            Case "19 19 19 |19 -1 19 |19 19 19 |" 'Chest
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(6, i)


            Case "-1 -1 -1 |-1 20 -1 |-1 -1 -1 |" 'Red Berries
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(23, i)
                CraftingGrid(0, Player.CraftingLevel, 7) = 4



            Case "48 48 48 |48 103 48 |48 48 48 |" 'imbuement station
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(113, i)

            Case "48 48 48 |48 104 48 |48 48 48 |" 'advanced crafting station
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(99, i)
            Case "-1 -1 -1 -1 |-1 116 29 -1 |-1 29 116 -1 |-1 -1 -1 -1 |" 'asphault
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(119, i)

            Case "-1 -1 -1 |-1 36 -1 |-1 -1 -1 |" 'eggplant seeds
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(37, i)
                CraftingGrid(0, Player.CraftingLevel, 7) = 2

            Case "-1 -1 -1 |-1 122 -1 |-1 22 -1 |" 'torch
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(120, i)
                CraftingGrid(0, Player.CraftingLevel, 7) = 2



                'temp ore refinement recipe till furnace
            Case "-1 -1 -1 |-1 38 -1 |-1 -1 -1 |"
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(46, i)
            Case "-1 -1 -1 |-1 39 -1 |-1 -1 -1 |"
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(47, i)
            Case "-1 -1 -1 |-1 40 -1 |-1 -1 -1 |"
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(48, i)
            Case "-1 -1 -1 |-1 41 -1 |-1 -1 -1 |"
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(49, i)
            Case "-1 -1 -1 |-1 116 -1 |-1 -1 -1 |"
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(117, i)

            Case "48 48 48 |48 117 48 |48 -1 48 |" 'iron scuba tool
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(118, i)
        End Select
    Next
End Sub


Sub COLDET (entity)
    Dim ColU, ColD, ColL, ColR
    Dim StuckFix As _Byte 'why???, $option noprefix is enabled why the fuck does this have an underscore, also where is this used?
    Dim i
    Dim PosX, PosY, LastX, LastY

    If entity = 0 Then
        PosX = Player.x
        PosY = Player.y
        LastX = Player.lastx
        LastY = Player.lasty
    Else
        PosX = entity(entity, 4)
        PosY = entity(entity, 5)
        LastX = entity(entity, 13)
        LastY = entity(entity, 14)

    End If

    Player.tile = GroundTile(PlayerTileX, PlayerTileY)
    Select Case Player.facing
        Case 0
            If Player.y - 8 <= 0 Then Exit Select
            Player.tilefacing = GroundTile(PlayerTileX, Int((Player.y + 8 - 16) / 16) + 1)
        Case 1
            If Player.y + 8 + 16 >= 480 Then Exit Select
            Player.tilefacing = GroundTile(PlayerTileX, Int((Player.y + 8 + 16) / 16) + 1)
        Case 2
            If Player.x - 8 <= 0 Then Exit Select
            Player.tilefacing = GroundTile(Int((Player.x + 8 - 16) / 16) + 1, PlayerTileY)
        Case 3
            If Player.x + 8 + 16 >= 640 Then Exit Select
            Player.tilefacing = GroundTile(Int((Player.x + 8 + 16) / 16) + 1, PlayerTileY)
    End Select




    If Flag.NoClip = 0 Then
        Select Case TileData(Int((PosX + 1) / 16) + 1, Int((PosY + 1) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY

                ColU = 1
                GoTo col2

        End Select

        Select Case TileData(Int((PosX + 1) / 16) + 1, Int((PosY + 14) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY

                ColD = 1
        End Select

        Select Case TileData(Int((PosX + 14) / 16) + 1, Int((PosY + 1) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY

                ColU = 1
                GoTo col2

        End Select

        Select Case TileData(Int((PosX + 14) / 16) + 1, Int((PosY + 14) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY

                ColD = 1
        End Select

        col2:

        Select Case TileData(Int((PosX + 1) / 16) + 1, Int((PosY + 1) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY
                PosX = LastX

                ColU = 0
                ColD = 0
                ColL = 1
        End Select

        Select Case TileData(Int((PosX + 14) / 16) + 1, Int((PosY + 1) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY
                PosX = LastX

                ColU = 0
                ColD = 0
                ColR = 1
        End Select

        Select Case TileData(Int((PosX + 1) / 16) + 1, Int((PosY + 14) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY
                PosX = LastX

                ColU = 0
                ColD = 0

                ColL = 1
        End Select

        Select Case TileData(Int((PosX + 14) / 16) + 1, Int((PosY + 14) / 16) + 1, 0)
            Case 1
                Swap PosY, LastY
                PosX = LastX
                ColU = 0
                ColD = 0
                ColR = 1
        End Select
    End If

    'push player outside of tile if inside

    If Flag.NoClip = 0 Then
        Select Case TileData(Int((PosX + 7) / 16) + 1, Int((PosY + 1) / 16) + 1, 0)
            Case 1
                PosY = PosY + 1
                '  Print " Colision 3,1"
        End Select

        Select Case TileData(Int((PosX + 7) / 16) + 1, Int((PosY + 14) / 16) + 1, 0)
            Case 1
                ' Swap posy, poslasty
                PosY = PosY - 1
                '  Print " Colision 3,2"
        End Select

        Select Case TileData(Int((PosX + 1) / 16) + 1, Int((PosY + 7) / 16) + 1, 0)
            Case 1

                PosX = PosX + 1
                ' Print " Colision 3,3"
        End Select

        Select Case TileData(Int((PosX + 14) / 16) + 1, Int((PosY + 7) / 16) + 1, 0)
            Case 1
                PosX = PosX - 1
                ' Print " Colision 3,4"
        End Select
    End If

    If ColU = 1 Or ColD = 1 Then
        If entity = 0 Then Player.vy = 0 Else entity(entity, 8) = 0

    End If
    If ColL = 1 Or ColR = 1 Then
        If entity = 0 Then Player.vx = 0 Else entity(entity, 9) = 0
    End If

    If entity = 0 Then
        Player.x = PosX
        Player.y = PosY
        Player.lastx = LastX
        Player.lasty = LastY
    Else
        entity(entity, 4) = PosX
        entity(entity, 5) = PosY
        entity(entity, 13) = LastX
        entity(entity, 14) = LastY

    End If

    If entity = 0 Then
        If ColU = 1 Then ContactEffect 1, 0: 'Print "COLISION"
        If ColD = 1 Then ContactEffect 2, 0: 'Print "COLISION"
        If ColL = 1 Then ContactEffect 3, 0: 'Print "COLISION"
        If ColR = 1 Then ContactEffect 4, 0: 'Print "COLISION"
    Else
        If ColU = 1 Then ContactEffect 1, entity: 'Print "COLISION"
        If ColD = 1 Then ContactEffect 2, entity: 'Print "COLISION"
        If ColL = 1 Then ContactEffect 3, entity: 'Print "COLISION"
        If ColR = 1 Then ContactEffect 4, entity: 'Print "COLISION"

    End If

End Sub





Sub DEV
    'Exit Sub
    If Flag.DebugMode = 1 Or CurrentTick < 1 Then
        PrintMode FillBackground
        Color , RGBA(0, 0, 0, 128)
        Dim comin As String
        Dim dv As Single
        Dim dummystring As String
        Dim databit As Byte
        Dim i, ii As Integer
        Dim DMapX, DMapY As Integer64
        Dim fillx, filly, fillid As Single

        Locate 1, 1
        ENDPRINT "Debug Menu (Press F3 to Close)"
        Print
        ENDPRINT "Version: " + Game.Buildinfo
        ENDPRINT "Version Designation: " + Game.Designation
        ENDPRINT "Operating System: " + Game.HostOS
        If RenderMode = 0 Then ENDPRINT "Render Mode: Software"
        If RenderMode = 1 Then ENDPRINT "Render Mode: Hardware Exclusive"
        If RenderMode = 2 Then ENDPRINT "Render Mode: Hardware"
        If Game.32Bit = 1 Then ENDPRINT "32-Bit Compatability Mode"
        If RefreshOpt > 0 Then ENDPRINT "FrameSkip Enabled (" + Str$(RefreshOpt) + " fpf)"
        ENDPRINT "Screen Resolution:" + Str$(ScreenRezX) + " x" + Str$(ScreenRezY)
        Print
        ENDPRINT "Facing tile data:"
        If Player.x >= 0 And Player.x <= 640 - 16 And Player.y >= 0 And Player.y <= 480 - 16 Then

            For i = 0 To TileParameters
                dummystring = dummystring + Str$(TileData(FacingX, FacingY, i))
            Next
            ENDPRINT dummystring
            ENDPRINT Str$(GroundTile(FacingX, FacingY)) + Str$(WallTile(FacingX, FacingY)) + Str$(CeilingTile(FacingX, FacingY))
        End If


        ENDPRINT "Flags:"
        If Flag.StillCam = 1 Then ENDPRINT "Still Camera Enabled"
        If Flag.FreeCam = 1 Then ENDPRINT "Free Camera Enabled"
        If Flag.FullCam = 1 Then ENDPRINT "Full Camera Enabled"
        If Flag.NoClip = 1 Then ENDPRINT "No Clip Enabled"
        If BGDraw = 1 Then ENDPRINT "Background Drawing Disabled"
        If Flag.InventoryOpen = 1 Then ENDPRINT "Inventory Open"
        If Flag.CastShadows = 1 Then ENDPRINT "Shadows Disabled"
        If Flag.FrameRateLock = 1 Then ENDPRINT "Engine Tickrate Unlocked"
        If Flag.FullRender = 1 Then ENDPRINT "Render Optimizations Disabled"
        If Flag.IsBloodmoon = 1 Then ENDPRINT "Blood Moon is Active"
        If Flag.FullBright = 1 Then ENDPRINT "Fullbright is Active"


        Locate 1, 1
        Print Game.Title; " ("; Game.Version; ")"
        Print
        Print "FPS:" + Str$(OGLFPS) + " / TPS:" + Str$(FRAMEPS) + " / Tick:" + Str$(CurrentTick)
        Print "Window:"; CameraPositionX; ","; CameraPositionY
        Print "Current World: "; WorldName; " (" + SavedMap + Str$(CurrentDimension) + ")";
        If WorldReadOnly = 1 Then Print "(R/O)"
        If WorldReadOnly = 0 Then Print
        Print "World Seed:"; WorldSeed
        Print "Current Time:"; GameTime + (TimeMode * 43200);
        Print "(Day:" + Str$(CurrentDay) + ")"
        Print "Light Level: (G:"; GlobalLightLevel; ", L:"; LocalLightLevel((Player.x + 8) / 16, (Player.y + 8) / 16); ", O:"; OverlayLightLevel; ")"
        Print "Current Entities: "; CurrentEntities


        ' Do While MouseInput
        ' Loop
        ' Print MouseX, MouseY, MouseButton(1), MouseWheel
        ' Print entity(1, 4), entity(1, 5), entity(1, 4) / 16, entity(1, 5) / 16


        Print "Gamemode: ";
        Select Case GameMode
            Case 0
                Print "Title Screen"
            Case 1
                Print "Creative"
            Case 2
                Print "Survival"
            Case 3
                Print "Camera"
            Case 4
                Print "Spectator"
        End Select

        Print
        Print "Data Viewer: ";
        Select Case Debug.Tracking
            Case ""
                Print "None Selected"
                Print "Start tracking an entity to view its data"
            Case "player", "1"
                Print "Player"
                Print "POS:"; Player.x; ","; Player.y; "("; PlayerTileX; ","; PlayerTileY; ")"
                Print "GlobalPOS"; "("; PlayerTileX + (SavedMapX * 40); ","; PlayerTileY + (SavedMapY * 30); ")"
                Print "Velocity:"; Player.vx; Player.vy
                Print "Facing:"; Player.facing
                Print "Motion:"; Player.movingx; Player.movingy
                Print "Health:"; Player.health
            Case "inv", "inventory", "2"
                Print "Inventory Data"
                If CursorHoverPage = 1 Then
                    Select Case Inventory(CursorHoverY, CursorHoverX, 0)
                        Case 0
                            Print "Tile: "; Trim$((ItemName(Inventory(CursorHoverY, CursorHoverX, 9), 0))); " | SS:"; Str$(Inventory(CursorHoverY, CursorHoverX, 1)); ","; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 2))); " | TileID:"; Str$(Inventory(CursorHoverY, CursorHoverX, 3)); " | Layer:"; Str$(Inventory(CursorHoverY, CursorHoverX, 4)); " | "; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 5))) + Str$(Inventory(CursorHoverY, CursorHoverX, 6)); " | Stack:"; Str$(Inventory(CursorHoverY, CursorHoverX, 7)); "/"; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 8))); " | ID:"; Str$(Inventory(CursorHoverY, CursorHoverX, 9)); ""
                        Case 1
                            Print "Tool: "; Trim$(ItemName(Inventory(CursorHoverY, CursorHoverX, 9), 0)); " | SS:"; Str$(Inventory(CursorHoverY, CursorHoverX, 1)); ","; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 2))); " | Durabillity:"; Str$(Inventory(CursorHoverY, CursorHoverX, 3)); "/"; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 4))); " | Type:"; Str$(Inventory(CursorHoverY, CursorHoverX, 5)); " | Strength:"; Str$(Inventory(CursorHoverY, CursorHoverX, 6)); " | Stack:"; Str$(Inventory(CursorHoverY, CursorHoverX, 7)); "/"; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 8))); " | ID:"; Str$(Inventory(CursorHoverY, CursorHoverX, 9)); ""
                        Case 2
                            Print "Sword: "; Trim$(ItemName(Inventory(CursorHoverY, CursorHoverX, 9), 0)); " | SS:"; Str$(Inventory(CursorHoverY, CursorHoverX, 1)); ","; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 2))); " | Durabillity:"; Str$(Inventory(CursorHoverY, CursorHoverX, 3)); "/"; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 4))); " | Delay:"; Str$(Inventory(CursorHoverY, CursorHoverX, 5)); " | Damage:"; Str$(Inventory(CursorHoverY, CursorHoverX, 6)); " | Stack:"; Str$(Inventory(CursorHoverY, CursorHoverX, 7)); "/"; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 8))); " | ID:"; Str$(Inventory(CursorHoverY, CursorHoverX, 9)); " | Range"; Str$(Inventory(CursorHoverY, CursorHoverX, 10)); " | Speed:"; Str$(Inventory(CursorHoverY, CursorHoverX, 11));
                        Case 3
                            Print "Crafting Ingredient: "; Trim$(ItemName(Inventory(CursorHoverY, CursorHoverX, 9), 0)); " | SS:"; Str$(Inventory(CursorHoverY, CursorHoverX, 1)); ","; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 2))); " |"; Str$(Inventory(CursorHoverY, CursorHoverX, 3)) + Str$(Inventory(CursorHoverY, CursorHoverX, 4)) + Str$(Inventory(CursorHoverY, CursorHoverX, 5)) + Str$(Inventory(CursorHoverY, CursorHoverX, 6)); " | Stack:"; Str$(Inventory(CursorHoverY, CursorHoverX, 7)); "/"; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 8))); " | ID:"; Str$(Inventory(CursorHoverY, CursorHoverX, 9)); ""
                        Case Else
                            Print "Unknown";
                            If Inventory(CursorHoverY, CursorHoverX, 9) > -1 Then Print ": "; Trim$(ItemName(Inventory(CursorHoverY, CursorHoverX, 9), 0));
                            Print ; " | SS:"; Str$(Inventory(CursorHoverY, CursorHoverX, 1)); ","; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 2))); " |"; Str$(Inventory(CursorHoverY, CursorHoverX, 3)) + Str$(Inventory(CursorHoverY, CursorHoverX, 4)) + Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 5))) + Str$(Inventory(CursorHoverY, CursorHoverX, 6)); " | Stack:"; Str$(Inventory(CursorHoverY, CursorHoverX, 7)); "/"; Trim$(Str$(Inventory(CursorHoverY, CursorHoverX, 8))); " | ID:"; Str$(Inventory(CursorHoverY, CursorHoverX, 9)); ""
                    End Select
                End If
                'For i = 0 To InvParameters
                '    Print Inventory(0, 0, i);
                'Next
            Case "3"
                Print "Entity Data"
                For i = 1 To CurrentEntities
                    Print i;
                    For ii = 0 To EntityParameters
                        Print entity(i, ii);
                    Next
                    Print
                Next
            Case "4"
                Print "Status Effect Data"
                For i = 0 To MaxEffects
                    Print i;
                    For ii = 0 To EffectParameters
                        Print EffectArray(i, ii, 0);
                    Next
                    Print
                Next
            Case "4a"
                Print "Status Effect Data (Active)"
                For i = 0 To MaxEffects
                    While EffectArray(i, 0, 0) = 0
                        i = i + 1
                        If i > 20 Then Exit Case
                    Wend
                    Print i;
                    For ii = 0 To EffectParameters
                        Print EffectArray(i, ii, 0);
                    Next
                    Print
                Next
            Case "5"
                Print "Mouse Data Tracker"
                Do While MouseInput: Loop
                Print "Mouse Coordinates:" + Trim$(Str$(MouseX)) + ","; Trim$(Str$(MouseY))
                If MouseButton(1) Then Print "Left Click"
                If MouseButton(2) Then Print "Right Click"
                If MouseButton(3) Then Print "Middle Click"
                If MouseWheel = -1 Then Print "Scroll Down"
                If MouseWheel = 1 Then Print "Scroll Up"
            Case "6"
                Print "Novaflux Virus Status:"
                Select Case Virus.Status
                    Case 0
                        Print "Dormant Novaflux Present"
                    Case 1
                        Print "Novaflux-X1 Present"
                    Case 2
                        Print "Novaflux-X2 Present"
                    Case 3
                        Print "Novaflux Virus Cured and Eradicated"
                End Select
                ' Print entity(1, 4), entity(1, 5), entity(1, 4) / 16, entity(1, 5) / 16
            Case "7"
                Print "World Data Viewer"
                Print "Height Scale(Current Tile):" + Str$(Perlin((PlayerTileX + (SavedMapX * 40)) / Gen.HeightScale, (PlayerTileY + (SavedMapY * 30)) / Gen.HeightScale, 0, WorldSeed))
                Print "Biome Scale(Current Tile):"; BiomeTemperature((PlayerTileX), (PlayerTileY))
                Print "Temperature (Biome+SeasonOffset+TOD+TTO):"; LocalTemperature((PlayerTileX), (PlayerTileY))
                Print "Temperature Factors:"; BiomeTemperature(PlayerTileX, PlayerTileY); ","; SeasonalOffset; ","; TODoffset; ","; TileThermalOffset(PlayerTileX, PlayerTileY)
            Case "7h"
                Print "World Data Viewer (Human Readable)"
                Print "Height Scale(Current Tile):" + Str$(Perlin((PlayerTileX + (SavedMapX * 40)) / Gen.HeightScale, (PlayerTileY + (SavedMapY * 30)) / Gen.HeightScale, 0, WorldSeed))
                Print "Biome Scale(Current Tile):"; BiomeTemperature((PlayerTileX), (PlayerTileY))
                Print "Temperature (Biome+SeasonOffset+TOD+TTO):"; Int(LocalTemperature((PlayerTileX), (PlayerTileY)) * 100)
                Print "Temperature Factors:"; Int(BiomeTemperature(PlayerTileX, PlayerTileY) * 100); ","; Int(SeasonalOffset * 100); ","; Int(TODoffset * 100); ","; Int(TileThermalOffset(PlayerTileX, PlayerTileY) * 100)




            Case Else
                Print "Unrecognized Tile or Entity"
        End Select



        If KeyDown(47) Then
            Flag.OpenCommand = 1
            If Flag.RenderOverride = 0 Then SwitchRender (0)
        End If
        If Flag.OpenCommand = 2 Then
            KeyClear
            Locate 28, 1: Input "Command:", comin
            Select Case comin
                Case "cd"
                    SAVEMAP
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Change Dimension to", CurrentDimension
                    LOADMAP SavedMap
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


                Case "res", "resolution"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Resolution X: ", ScreenRezX
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Resolution Y: ", ScreenRezY
                    Screen NewImage(ScreenRezX + 1, ScreenRezY + 1, 32)
                Case "viruslevel", "vl"
                    Locate 28, 1: Print "                     "
                    Locate 28, 1: Input "Virus Status Level: ", Virus.Status

                Case "cv01"
                    Error 104
                Case "togglebloodmoon", "tbm"
                    Flag.IsBloodmoon = Flag.IsBloodmoon + 1
                    Swap Texture.Shadows, Texture.Shadows_Bloodmoon
                    If Flag.IsBloodmoon = 1 Then PlaySound Sounds.bloodmoon_spawn
                Case "weather"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Precipitation Level: ", PrecipitationLevel
                Case "rts"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Random Tick Speed: ", RandomTickRate
                Case "day"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Set Current Day: ", CurrentDay

                Case "fs"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Set Frame Skip Level: ", RefreshOpt


                Case "bdtmp"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Set Body Temp mode: ", Player.BodyTemp

                Case "stillcam", "sc"
                    Flag.StillCam = Flag.StillCam + 1
                Case "fullcam", "fc"
                    Flag.FullCam = Flag.FullCam + 1
                Case "freecam", "frc"
                    Flag.FreeCam = Flag.FreeCam + 1
                Case "noclip", "nc"
                    Flag.NoClip = Flag.NoClip + 1
                Case "fullrender", "fr"
                    Flag.FullRender = Flag.FullRender + 1
                Case "fullbright", "fb"
                    Flag.FullBright = Flag.FullBright + 1
                Case "exit"
                    System
                Case "error"
                    Locate 28, 1: Input "Simulate error number: ", dv
                    Error dv
                Case "gamemode", "gm"
                    Locate 28, 1: Input "Change Gamemode to: ", GameMode
                Case "health"
                    Locate 28, 1: Input "Set Health to: ", Player.health
                Case "maxhealth"
                    Locate 28, 1: Input "Set MaxHealth to: ", Player.MaxHealth
                Case "track", "tr"
                    Locate 28, 1: Print "                               "
                    Locate 28, 1: Input "Track Entity ID or Tile ID: ", Debug.Tracking
                Case "framerate-unlock", "fru"
                    Flag.FrameRateLock = Flag.FrameRateLock + 1
                Case "save"
                    SAVEMAP
                    SAVESETTINGS
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
                    Locate 28, 1: Input "Set GroundTile ID: ", GroundTile(PlayerTileX, PlayerTileY)
                Case "walltile", "wt"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Set WallTile ID: ", WallTile(PlayerTileX, PlayerTileY)
                Case "ceilingtile", "ct"
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Set CeilingTile ID: ", CeilingTile(PlayerTileX, PlayerTileY)
                Case "fillwalltile", "fillwt", "fwt"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "WallTile ID: ", fillid
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "X Tile from pos: ", fillx
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Y Tile from pos: ", filly

                    For i = 0 To fillx Step Sgn(fillx)
                        For ii = 0 To filly Step Sgn(filly)
                            WallTile(PlayerTileX + i, PlayerTileY + ii) = fillid
                        Next
                    Next
                Case "spl"
                    SpreadLight (1)
                Case "sph"
                    SpreadHeat

                Case "fillgroundtile", "fillgt", "fgt"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "GroundTile ID: ", fillid
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "X Tile from pos: ", fillx
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Y Tile from pos: ", filly

                    For i = 0 To fillx Step Sgn(fillx)
                        For ii = 0 To filly Step Sgn(filly)
                            GroundTile(PlayerTileX + i, PlayerTileY + ii) = fillid
                        Next
                    Next
                Case "fillceilingtile", "fillct", "fct"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "WallTile ID: ", fillid
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "X Tile from pos: ", fillx
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Y Tile from pos: ", filly

                    For i = 0 To fillx Step Sgn(fillx)
                        For ii = 0 To filly Step Sgn(filly)
                            CeilingTile(PlayerTileX + i, PlayerTileY + ii) = fillid
                        Next
                    Next

                Case "tiledata", "td"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Select Data Bit: ", databit
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Select Data Value: ", TileData(PlayerTileX, PlayerTileY, databit)

                Case "itemdata", "id"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Select Data Bit: ", databit
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Select Data Value: ", Inventory(0, CursorHoverX, databit)



                Case "bgdraw"
                    BGDraw = BGDraw + 1
                Case "shadowcast", "sh"
                    Flag.CastShadows = Flag.CastShadows + 1

                Case "new"
                    NewWorld

                Case "lightlevel", "ll"
                    Locate 28, 1: Print "                    "
                    Locate 28, 1: Input "Select Light Level:  ", GlobalLightLevel
                Case "rendermode", "rm"
                    Locate 28, 1: Print "         "
                    Locate 28, 1: Input "Mode:  ", RenderMode
                    If RenderMode = 2 Then Flag.RenderOverride = 0
                    If RenderMode = 0 Then Flag.RenderOverride = 1: SwitchRender (0)
                    If RenderMode = 1 Then Flag.RenderOverride = 1: SwitchRender (1)
                Case "updatemap", "um"
                    For i = 0 To 31
                        For ii = 0 To 41
                            UpdateTile ii, i
                        Next
                    Next

                    SpreadLight (1)
                Case "tickrate", "tk"
                    Locate 28, 1: Print "          "
                    Locate 28, 1: Input "TickRate:  ", Settings.TickRate
                Case "time"
                    Locate 28, 1: Print "          "
                    Locate 28, 1: Input "Set time:  ", GameTime
                Case "maptp"
                    Locate 28, 1: Print "              "
                    Locate 28, 1: Input "MapX Cord", DMapX
                    Locate 28, 1: Print "              "
                    Locate 28, 1: Input "MapY Cord", DMapY
                    ChangeMap 1, DMapX, DMapY
                Case "genmap"
                    GenerateMap 0
                Case "masstp"
                    For i = 0 To CurrentEntities
                        entity(i, 4) = Player.x
                        entity(i, 5) = Player.y
                    Next
                Case "give", "item"
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "ItemID to give ", DMapX
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Ammount ", DMapY

                    NewStack DMapX, DMapY
                Case "summon"
                    Dim temp As Integer
                    Dim cord As Byte
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "EntityID to summon ", DMapX
                    Locate 28, 1: Print "                                            "
                    Locate 28, 1: Input "Number of this entity to spawn ", temp
                    Locate 28, 1: Print "                                            "
                    Locate 28, 1: Input "Rand(0) or Set(1) Cords ", cord
                    If cord = 1 Then
                        Dim entx, enty
                        Locate 28, 1: Print "                              "
                        Locate 28, 1: Input "X Cord ", entx
                        Locate 28, 1: Print "                                            "
                        Locate 28, 1: Input "Y Cord ", enty
                    End If


                    '  For DMapY = 0 To 100

                    For ii = 0 To temp
                        CurrentEntities = CurrentEntities + 1
                        For i = 0 To EntityParameters
                            entity(CurrentEntities, i) = SummonEntity(DMapX, i)
                        Next
                        If cord = 1 Then
                            entity(CurrentEntities, 4) = entx
                            entity(CurrentEntities, 5) = enty
                        End If
                    Next
                    ' Next
                Case "kill"
                    Locate 28, 1: Print "                      "
                    Locate 28, 1: Input "EntityNumber to Kill ", DMapX
                    EntityDespawn DMapX

                Case "effect"

                    For i = 0 To MaxEffects
                        If EffectArray(i, 0, 0) = 0 Then
                            For ii = 0 To EffectParameters
                                Locate 28, 1: Print "                               "
                                Locate 28, 1: Print "Effect Value", ii, "to apply ";: Input ; DMapX

                                EffectArray(i, ii, 0) = DMapX
                            Next
                            Exit For
                        End If
                    Next
                Case "effectsource", "es"
                    Dim CommandString As String
                    Locate 28, 1: Print "                      "
                    Locate 28, 1: Input "Effect source to apply", CommandString

                    Effects 1, CommandString, 0
                Case "togglewriteprotect"
                    WorldReadOnly = WorldReadOnly + 1
                    If WorldReadOnly > 1 Then WorldReadOnly = 0
                    Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
                    Put #1, 4, WorldReadOnly
                    Close #1

                Case "nec", "newcommand"
                    Locate 28, 1: Input comin
                    SendChat (comin)
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

Sub SendChat (ChatMessage As String)
    'this set up is a bit weird, this sub is ONLY to format and send messages to the chatlog array, which when i get networking working
    'will be a dynamic array that will be set to the log size of the server or something so it doesnt crash but at the same time i dont have to
    'do stupid shit

    'messages sent by other players, recieved by client will be added to the array somewhere else
    'i might repurpose the chr21 header to refer to client only messages idk

    'chat messages sent by non player methods, or just shouldnt have a [player] headder should have this value
    Dim noPlayerTag

    'check if message has a no player name headder
    If Left$(ChatMessage, 1) = Chr$(21) Then
        ChatMessage = Mid$(ChatMessage, 2)
        noPlayerTag = 1
    End If

    'check if message is a command, and execute if it is
    If Left$(ChatMessage, 1) = "/" And noPlayerTag = 0 Then
        WorldCommands (ChatMessage)
        Exit Sub
    End If


    If noPlayerTag = 0 Then
        ChatMessage = "[" + Player.name + "] " + ChatMessage
    End If
    If noPlayerTag = 1 Then
        noPlayerTag = 0
    End If



    ChatLastMessage = ChatLastMessage + 1
    ChatLog(ChatLastMessage, 0) = ChatMessage
    ChatLog(ChatLastMessage, 1) = "500"

End Sub

Sub GameChat
    PrintMode FillBackground
    Color , RGBA(0, 0, 0, 128)

    Dim i
    Dim ChatStart
    Dim ChatCount
    ChatStart = (ScreenRezY / 16) - 7
    For i = ChatLastMessage To 0 Step -1
        If Val(ChatLog(i, 1)) >= 0 Then
            '  Locate 1, 1: Print ChatStart, ChatCount, ChatLastMessage, ChatLog(ChatLastMessage, 0)
            Locate ChatStart - ChatCount, 1: Print ChatLog(i, 0)
            ChatCount = ChatCount + 1
            ChatLog(i, 1) = Str$(Val(ChatLog(i, 1)) - 1)
        End If
    Next
    PrintMode KeepBackground
    Color , RGBA(0, 0, 0, 0)

End Sub



Sub WorldCommands (CommandString As String)

    Dim CommandBase As String
    Dim Parameters(10) As String
    Dim LastPos
    Dim i, ii


    CommandString = CommandString + " " 'adds an aditional space to the end of the command string so the parameter parse function can actually grab the last parameter
    CommandBase = LCase$(Trim$(Left$(CommandString, InStr(CommandString, " ")))) 'parses out the base command into a seperate string
    LastPos = InStr(CommandString, " ") 'pulls the start position of the first parameter (assuming only 1 space before the parameter, awaiting testing for various garbage inputs and thing not expected

    'parses command parameters into an array to make managing a bit easier
    For i = 0 To 10

        Parameters(i) = LCase$(Trim$(Mid$(CommandString, LastPos, InStr(LastPos, CommandString, " "))))
        LastPos = InStr(LastPos + 1, CommandString, " ")
        If Parameters(i) = CommandBase Then Exit For 'kills looping for additional parameters that dont exist and eventually just pulling the command as parameters... not that it really matters, nor does this actually work
    Next

    Select Case CommandBase
        Case "/help"
            SendChat Chr$(21) + "Showing command help list"
            SendChat Chr$(21) + "/resolution (short: /res) [x] [y] alters the games resolution"
            SendChat Chr$(21) + "/weather [mode] changes current weather mode"
            SendChat Chr$(21) + "/settile (short:/st) [layer] [tile] {x} {y}"
            SendChat Chr$(21) + "/viruslevel (short:/vl) [virus level] changes the current NovaFlux-Xx world infection level"
            SendChat Chr$(21) + "/filltile (short:/ft) [layer] [tile] {x1} {y1} [x2] [y2]"
        Case "/res", "/resolution"
            ScreenRezX = Val(Parameters(0))
            ScreenRezY = Val(Parameters(1))
            Screen NewImage(ScreenRezX + 1, ScreenRezY + 1, 32)
            SendChat Chr$(21) + "Resolution set to " + Trim$(Str$(ScreenRezX)) + "x" + Trim$(Str$(ScreenRezY))
        Case "/vl", "/viruslevel"
            Virus.Status = Val(Parameters(0))
            SendChat Chr$(21) + "Virus level updated"
        Case "/tbm", "/togglebloodmoon"
            Flag.IsBloodmoon = Flag.IsBloodmoon + 1
            Swap Texture.Shadows, Texture.Shadows_Bloodmoon
            If Flag.IsBloodmoon = 1 Then PlaySound Sounds.bloodmoon_spawn
            SendChat Chr$(21) + "Blood moon has been toggled"
        Case "/ctp", "/coordinate"
            Player.x = Val(Parameters(0))
            Player.y = Val(Parameters(1))
        Case "/tp"
            Player.x = Val(Parameters(0)) * 16
            Player.y = Val(Parameters(1)) * 16
        Case "/weather"
            PrecipitationLevel = Val(Parameters(0))
        Case "/rts"
            RandomTickRate = Val(Parameters(0))
        Case "/day"
            CurrentDay = Val(Parameters(0))
        Case "/gm", "/gamemode"
            GameMode = Val(Parameters(0))


        Case "/stillcam", "/sc"
            Flag.StillCam = Flag.StillCam + 1
        Case "/fullcam", "/fc"
            Flag.FullCam = Flag.FullCam + 1
        Case "/freecam", "/frc"
            Flag.FreeCam = Flag.FreeCam + 1
        Case "/noclip", "/nc"
            Flag.NoClip = Flag.NoClip + 1
        Case "/fullrender", "/fr"
            Flag.FullRender = Flag.FullRender + 1
        Case "/framerate-unlock", "/fru"
            Flag.FrameRateLock = Flag.FrameRateLock + 1



        Case "/exit"
            System
        Case "/error"
            Error Val(Parameters(0))


        Case "/health"
            Player.health = Val(Parameters(0))
        Case "/maxhealth"
            Player.MaxHealth = Val(Parameters(0))

        Case "/tr", "/track"
            Debug.Tracking = Parameters(0)

        Case "/save"
            SAVEMAP
            SAVESETTINGS

        Case "/st", "/settile"
            Parameters(2) = Str$(PlayerTileX): Parameters(3) = Str$(PlayerTileY)
            Select Case Val(Parameters(0))
                Case 0
                    GroundTile(Val(Parameters(2)), Val(Parameters(3))) = Val(Parameters(1))
                Case 1
                    WallTile(Val(Parameters(2)), Val(Parameters(3))) = Val(Parameters(1))
                Case 2
                    CeilingTile(Val(Parameters(2)), Val(Parameters(3))) = Val(Parameters(1))
            End Select
            SendChat Chr$(21) + "Tile Placed"
        Case "/ft", "/filltile"
            SendChat Chr$(21) + "this command is broked at the moment"
            If Parameters(4) = "" And Parameters(5) = "" Then
                Parameters(4) = Parameters(2)
                Parameters(5) = Parameters(3)

                Parameters(2) = Str$(PlayerTileX)
                Parameters(3) = Str$(PlayerTileY)
            End If
            '  If Val(Parameters(2)) > Val(Parameters(4)) Then Swap Parameters(2), Parameters(4)
            '    If Val(Parameters(3)) > Val(Parameters(5)) Then Swap Parameters(3), Parameters(5)

            For i = Val(Parameters(2)) To Val(Parameters(4))
                For ii = Val(Parameters(3)) To Val(Parameters(5))
                    Select Case Val(Parameters(0))
                        Case 0
                            GroundTile(i, ii) = Val(Parameters(1))
                        Case 1
                            WallTile(i, ii) = Val(Parameters(1))
                        Case 2
                            CeilingTile(i, ii) = Val(Parameters(1))


                    End Select

                Next
            Next
        Case "/um", "/updatemap"
            For i = 0 To 31
                For ii = 0 To 41
                    UpdateTile ii, i
                Next
            Next

            SpreadLight (1)
            SendChat Chr$(21) + "Map Tile Update Preformed"
        Case Else
            SendChat Chr$(21) + "Command " + Chr$(34) + CommandBase + Chr$(34) + " Not Found."

    End Select


    Exit Sub

    Dim dv, fillid, fillx, filly, databit, dmapx, dmapy
    Select Case CommandString




        Case "load"
            Locate 28, 1: Print "                                "
            Locate 28, 1: Input "Name of Map File to load: ", map.filename
            LOADMAP (map.filename)
        Case "loadworld"
            Locate 28, 1: Print "                                "
            Locate 28, 1: Input "Name of World Folder to load: ", WorldName
            LOADWORLD
        Case "spl"
            SpreadLight (1)
        Case "sph"
            SpreadHeat


        Case "network"

            Locate 28, 2: Input "Test Network Multiplayer: ", fillid





        Case "tiledata", "td"
            Locate 28, 1: Print "                 "
            Locate 28, 1: Input "Select Data Bit: ", databit
            Locate 28, 1: Print "                   "
            Locate 28, 1: Input "Select Data Value: ", TileData(PlayerTileX, PlayerTileY, databit)

        Case "itemdata", "id"
            Locate 28, 1: Print "                 "
            Locate 28, 1: Input "Select Data Bit: ", databit
            Locate 28, 1: Print "                   "
            Locate 28, 1: Input "Select Data Value: ", Inventory(0, CursorHoverX, databit)



        Case "bgdraw"
            BGDraw = BGDraw + 1
        Case "shadowcast", "sh"
            Flag.CastShadows = Flag.CastShadows + 1

        Case "new"
            NewWorld

        Case "lightlevel", "ll"
            Locate 28, 1: Print "                    "
            Locate 28, 1: Input "Select Light Level:  ", GlobalLightLevel
        Case "rendermode", "rm"
            Locate 28, 1: Print "         "
            Locate 28, 1: Input "Mode:  ", RenderMode
            If RenderMode = 2 Then Flag.RenderOverride = 0
            If RenderMode = 0 Then Flag.RenderOverride = 1: SwitchRender (0)
            If RenderMode = 1 Then Flag.RenderOverride = 1: SwitchRender (1)
        Case "tickrate", "tk"
            Locate 28, 1: Print "          "
            Locate 28, 1: Input "TickRate:  ", Settings.TickRate
        Case "time"
            Locate 28, 1: Print "          "
            Locate 28, 1: Input "Set time:  ", GameTime
        Case "maptp"
            Locate 28, 1: Print "              "
            Locate 28, 1: Input "MapX Cord", dmapx
            Locate 28, 1: Print "              "
            Locate 28, 1: Input "MapY Cord", dmapy
            ChangeMap 1, dmapx, dmapy
        Case "genmap"
            GenerateMap 0
        Case "masstp"
            For i = 0 To CurrentEntities
                entity(i, 4) = Player.x
                entity(i, 5) = Player.y
            Next
        Case "give", "item"
            Locate 28, 1: Print "                   "
            Locate 28, 1: Input "ItemID to give ", dmapx
            Locate 28, 1: Print "                   "
            Locate 28, 1: Input "Ammount ", dmapy

            NewStack dmapx, dmapy
        Case "summon"
            Dim temp As Integer
            Dim cord As Byte
            Locate 28, 1: Print "                   "
            Locate 28, 1: Input "EntityID to summon ", dmapx
            Locate 28, 1: Print "                                            "
            Locate 28, 1: Input "Number of this entity to spawn ", temp
            Locate 28, 1: Print "                                            "
            Locate 28, 1: Input "Rand(0) or Set(1) Cords ", cord
            If cord = 1 Then
                Dim entx, enty
                Locate 28, 1: Print "                              "
                Locate 28, 1: Input "X Cord ", entx
                Locate 28, 1: Print "                                            "
                Locate 28, 1: Input "Y Cord ", enty
            End If


            '  For DMapY = 0 To 100

            For ii = 0 To temp
                CurrentEntities = CurrentEntities + 1
                For i = 0 To EntityParameters
                    entity(CurrentEntities, i) = SummonEntity(dmapx, i)
                Next
                If cord = 1 Then
                    entity(CurrentEntities, 4) = entx
                    entity(CurrentEntities, 5) = enty
                End If
            Next
            ' Next
        Case "kill"
            Locate 28, 1: Print "                      "
            Locate 28, 1: Input "EntityNumber to Kill ", dmapx
            EntityDespawn dmapx

        Case "effect"

            For i = 0 To MaxEffects
                If EffectArray(i, 0, 0) = 0 Then
                    For ii = 0 To EffectParameters
                        Locate 28, 1: Print "                               "
                        Locate 28, 1: Print "Effect Value", ii, "to apply ";: Input ; dmapx

                        EffectArray(i, ii, 0) = dmapx
                    Next
                    Exit For
                End If
            Next
        Case "effectsource", "es"
            '  Dim CommandString As String
            Locate 28, 1: Print "                      "
            Locate 28, 1: Input "Effect source to apply", CommandString

            Effects 1, CommandString, 0
        Case "togglewriteprotect"
            WorldReadOnly = WorldReadOnly + 1
            If WorldReadOnly > 1 Then WorldReadOnly = 0
            Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
            Put #1, 4, WorldReadOnly
            Close #1

        Case Else
    End Select

End Sub




Sub SAVESETTINGS
    Dim As Byte zero, one
    zero = 0
    one = 1

    Open "Assets\SaveData\Settings.cdf" As #1
    Put #1, 1, Settings.FrameRate
    Put #1, 2, Settings.TickRate
    Put #1, 3, ScreenRezX
    Put #1, 4, ScreenRezY
    If FullScreen = 0 Then Put #1, 5, zero
    If FullScreen = 2 Then Put #1, 5, one
    Close #1

End Sub




Sub LOADSETTINGS

    Open "Assets\SaveData\Settings.cdf" As #1
    Get #1, 1, Settings.FrameRate
    Get #1, 2, Settings.TickRate
    Get #1, 3, ScreenRezX
    Get #1, 4, ScreenRezY
    Get #1, 5, Settings.FullScreen

    Close #1

End Sub

Function SavedMap$
    SavedMap = Str$(SavedMapX) + Str$(SavedMapY)
End Function


Function SpawnMap$
    SpawnMap = Str$(SpawnMapX) + Str$(SpawnMapY)
End Function

Sub LOADWORLD
    Print "began loading world"
    Dim defaultmap As String
    Dim As Byte i, ii
    Dim As Integer iii
    Dim total
    Dim MapProtocol As Integer
    Dim ManifestProtocol As Integer
    prevfolder = map.foldername
    Print "dimmed local values"
    Print "opening manifest"
    If FileExists("Assets\Worlds\" + WorldName + "\Manifest.cdf") Then
        Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
    Else
        Error 105
    End If
    Print "successful, reading manifest data"
    Get #1, 1, GameTime
    Get #1, 2, ManifestProtocol
    If ManifestProtocol < Game.ManifestProtocol Then Close #1: ConvertManifest (ManifestProtocol): Exit Sub
    Get #1, 3, mapversion
    Get #1, 4, WorldReadOnly
    Get #1, 5, SpawnPointX
    Get #1, 6, SpawnPointY
    Get #1, 7, SavePointX
    Get #1, 8, SavePointY
    Get #1, 9, SavedMapX
    Get #1, 10, SavedMapY
    Get #1, 11, SpawnMapX
    Get #1, 12, SpawnMapY
    Get #1, 13, WorldSeed
    Get #1, 14, CurrentDay
    Get #1, 15, WeatherCountDown
    Get #1, 16, PrecipitationLevel

    Close #1
    Print "Opening player"
    Open "Assets\Worlds\" + WorldName + "\Player.cdf" As #1
    total = 1
    i = 0
    ii = 0
    iii = 0
    Print "Loading player"
    While i < 4
        Get #1, total, Inventory(i, ii, iii)
        iii = iii + 1
        If iii > InvParameters Then iii = 0: ii = ii + 1
        If ii > 5 Then ii = 0: i = i + 1
        total = total + 1
    Wend
    Get #1, total, GameMode: total = total + 1
    Get #1, total, Player.facing: total = total + 1
    Get #1, total, Player.level: total = total + 1
    Get #1, total, Player.health: total = total + 1
    Get #1, total, Player.points: total = total + 1
    Get #1, total, Player.experience: total = total + 1
    Get #1, total, Player.gold: total = total + 1
    Get #1, total, Player.MaxHealth: total = total + 1
    Close #1

    Player.x = SavePointX
    Player.y = SavePointY

    'GET #1, 4, map.protected
    Print "World data loaded, loading local map"
    LOADMAP (SavedMap)
End Sub


Sub LOADMAP (file As String)
    Dim i, ii As Byte
    Dim iii As Single
    Dim iiii As Single
    Dim MapProtocol As Integer

    iii = 1
    Print "locating existing map data"
    'TODO make this a sub with 2 parameterss, 1
    If FileExists("Assets\Worlds\" + WorldName + "\Maps\" + file + Str$(CurrentDimension) + ".cdf") Then
        Print "loading map data"
        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + Str$(CurrentDimension) + ".cdf" As #1
        Get #1, 1, MapProtocol
        Close #1
        If MapProtocol <> Game.MapProtocol Then ConvertMap MapProtocol, file: Exit Sub
        Print "0%"
        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + Str$(CurrentDimension) + "-0.cdf" As #1
        For i = 1 To 30
            For ii = 1 To 40
                Get #1, iii, GroundTile(ii, i)
                iii = iii + 1
            Next
        Next
        Close #1
        iii = 1
        Print "20%"
        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + Str$(CurrentDimension) + "-1.cdf" As #1
        For i = 1 To 30
            For ii = 1 To 40
                Get #1, iii, WallTile(ii, i)
                iii = iii + 1
            Next
        Next
        Close #1
        iii = 1
        Print "40%"

        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + Str$(CurrentDimension) + "-2.cdf" As #1
        For i = 1 To 30
            For ii = 1 To 40
                Get #1, iii, CeilingTile(ii, i)
                iii = iii + 1
            Next
        Next
        Close #1
        iii = 1

        Print "60%"
        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + Str$(CurrentDimension) + "-3.cdf" As #1
        Print "61%"
        For i = 1 To 30
            For ii = 1 To 40
                For iiii = 0 To TileParameters
                    '      Print "61." + Trim$(Str$(iii))
                    Get #1, iii, TileData(ii, i, iiii)
                    '     Print "62." + Trim$(Str$(iii))
                    iii = iii + 1
                Next

            Next
        Next
        Print "70%"
        Get #1, iii, map.name
        Print "71%"
        Close #1
        Print "72%"
        iii = 1
        Print "80%"
        Open "Assets\Worlds\" + WorldName + "\Maps\" + file + Str$(CurrentDimension) + "-E.cdf" As #1
        Get #1, 1, CurrentEntities
        iii = iii + 1
        For i = 1 To CurrentEntities
            For ii = 0 To EntityParameters
                Get #1, iii, entity(i, ii)
                iii = iii + 1
            Next
        Next
        Close #1
        iii = 1
        Print "100%"
        Print "Finished loading, starting game"


    Else
        GenerateMap CurrentDimension
        SAVEMAP
    End If

End Sub

Sub ConvertManifest (OldVersion As Integer)
    Print "Converting Manifest from Protocol"; OldVersion; "To"; Game.ManifestProtocol
    Select Case OldVersion
        Case 0
            Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
            Put #1, 4, WorldReadOnly
            Close #1
            OldVersion = 1
        Case 1
            Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
            Put #1, 14, CurrentDay
            Put #1, 15, WeatherCountDown
            Put #1, 16, PrecipitationLevel

            Close #1
            OldVersion = 2


        Case Else
            Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
            Put #1, 2, OldVersion
            Close #1
            LOADWORLD
            Exit Sub
    End Select
    ConvertManifest OldVersion
End Sub

Sub ConvertMap (OldVersion As Integer, MapCord As String)
    Print "Converting Map from Protocol"; OldVersion; "To"; Game.MapProtocol
    Dim i, ii, iii, iiii
    Dim j, jj, jjj
    Dim total
    Dim NewX, NewY

    Select Case OldVersion
        Case 0
            'Load Necessary map files to edit
            iii = 1
            Open "Assets\Worlds\" + WorldName + "\Maps\" + MapCord + "-1.cdf" As #1
            For i = 1 To 30
                For ii = 1 To 40
                    Get #1, iii, WallTile(ii, i)
                    iii = iii + 1
                Next
            Next
            Close #1
            iii = 1


            'Convert Map files
            For i = 0 To 30
                For ii = 0 To 40

                    'Convert Containers
                    If TileIndexData(WallTile(ii, i), 7) = 1 Then
                        'load old container data into memory
                        Open "Assets\Worlds\" + WorldName + "\Containers\" + MapCord + Str$(ii) + Str$(i) + ".cdf" As #1
                        total = 1
                        Get #1, total, Container(18, 0, 0): total = total + 1
                        Get #1, total, Container(19, 0, 0): total = total + 1
                        For j = 0 To Container(18, 0, 0)
                            For jj = 0 To 11
                                Get #1, total, Container(j, jj, 0): total = total + 1
                            Next
                        Next

                        'convert to new format
                        NewX = 0
                        NewY = 0
                        While Container(18, 0, 0) > 5
                            NewY = NewY + 1
                            Container(18, 0, 0) = Container(18, 0, 0) - 6
                        Wend
                        NewX = Container(18, 0, 0)
                        total = 1

                        'save new container data overtop of old file
                        Put #1, total, NewX: total = total + 1
                        Put #1, total, NewY: total = total + 1
                        Put #1, total, Container(19, 0, 0): total = total + 1

                        For j = 0 To NewY
                            For jj = 0 To NewX
                                For jjj = 0 To InvParameters
                                    Put #1, total, Container(j + jj, jjj, 0): total = total + 1
                                Next
                            Next
                        Next
                        Close #1
                    End If
                Next
            Next
            Close #1
            Close #2
            OldVersion = 1
        Case 1
            Open "Assets\Worlds\" + WorldName + "\Maps\" + MapCord + "-3.cdf" As #1
            For i = 1 To 30
                For ii = 1 To 40
                    For iiii = 0 To 13
                        Get #1, iii, TileData(ii, i, iiii)
                        iii = iii + 1
                    Next

                Next
            Next

            Get #1, iii, map.name
            Close #1
            iii = 1
            SAVEMAP
            '            OldVersion = 2

        Case 2

        Case Else
            Open "Assets\Worlds\" + WorldName + "\Maps\" + MapCord + ".cdf" As #1
            Put #1, 1, OldVersion
            Close #1

            LOADWORLD
            Exit Sub
    End Select
    ConvertMap OldVersion, MapCord
End Sub


Sub SAVEMAP
    Dim i, ii, iiii As Byte
    Dim iii As Integer
    Dim defaultmap As String
    Dim temppw As String
    Dim new As Byte
    Dim total
    iii = 1
    'update this
    If DirExists("Assets\Worlds\" + WorldName) = 0 Then
        MkDir "Assets\Worlds\" + WorldName: new = 1
        MkDir "Assets\Worlds\" + WorldName + "\Maps"
        MkDir "Assets\Worlds\" + WorldName + "\Containers"
    End If


    Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1
    If new = 0 And WorldReadOnly = 1 Then
        Close #1
        Exit Sub
    End If


    SavePointX = Player.x
    SavePointY = Player.y
    If TimeMode = 1 Then GameTime = GameTime + 43200
    Put #1, 1, GameTime
    Put #1, 2, Game.ManifestProtocol

    Put #1, 3, Game.Version
    Put #1, 5, SpawnPointX
    Put #1, 6, SpawnPointY
    Put #1, 7, SavePointX
    Put #1, 8, SavePointY
    Put #1, 9, SavedMapX
    Put #1, 10, SavedMapY
    Put #1, 11, SpawnMapX
    Put #1, 12, SpawnMapY
    Put #1, 13, WorldSeed
    Put #1, 14, CurrentDay
    Put #1, 15, WeatherCountDown
    Put #1, 16, PrecipitationLevel
    Put #1, 17, CurrentDimension
    Close #1
    Open "Assets\Worlds\" + WorldName + "\Player.cdf" As #1
    total = 1
    i = 0
    ii = 0
    iii = 0

    While i < 4
        Put #1, total, Inventory(i, ii, iii)
        iii = iii + 1
        If iii > InvParameters Then iii = 0: ii = ii + 1
        If ii > 5 Then ii = 0: i = i + 1
        total = total + 1
    Wend
    If TimeMode = 1 Then GameTime = GameTime - 43200
    Put #1, total, GameMode: total = total + 1
    Put #1, total, Player.facing: total = total + 1
    Put #1, total, Player.level: total = total + 1
    Put #1, total, Player.health: total = total + 1
    Put #1, total, Player.points: total = total + 1
    Put #1, total, Player.experience: total = total + 1
    Put #1, total, Player.gold: total = total + 1
    Put #1, total, Player.MaxHealth: total = total + 1
    Close #1
    iii = 1
    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + Str$(CurrentDimension) + "-0.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            Put #1, iii, GroundTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + Str$(CurrentDimension) + "-1.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            Put #1, iii, WallTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + Str$(CurrentDimension) + "-2.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            Put #1, iii, CeilingTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + Str$(CurrentDimension) + "-3.cdf" As #1
    For i = 1 To 30
        For ii = 1 To 40
            For iiii = 0 To TileParameters
                Put #1, iii, TileData(ii, i, iiii)
                iii = iii + 1
            Next
        Next
    Next
    Put #1, iii, map.name
    Close #1
    iii = 1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + Str$(CurrentDimension) + "-E.cdf" As #1
    Put #1, iii, CurrentEntities
    iii = iii + 1
    For i = 1 To CurrentEntities
        For ii = 0 To EntityParameters
            Put #1, iii, entity(i, ii)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1
    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + Str$(CurrentDimension) + ".cdf" As #1
    Put #1, 1, Game.MapProtocol
    Close #1



    badpw:
End Sub




Sub CastShadow
    If Flag.CastShadows = 0 Then
        Dim i As Byte
        Dim ii As Byte
        For i = 1 To 30
            For ii = 1 To 40
                If VisibleCheck(ii, i) = 1 Then
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
                End If
            Next
        Next
    End If
End Sub




Sub SetLighting
    Dim i As Byte
    Dim ii As Byte
    Dim TotalLightLevel
    For i = 0 To 31
        For ii = 0 To 41

            If GlobalLightLevel < LocalLightLevel(ii, i) Then
                TotalLightLevel = LocalLightLevel(ii, i)
            Else
                TotalLightLevel = GlobalLightLevel
            End If
            'If PrecipitationLevel = 2 Then TotalLightLevel = TotalLightLevel - 2


            'map change overlay mainly
            TotalLightLevel = TotalLightLevel - OverlayLightLevel


            If TotalLightLevel > 12 Then TotalLightLevel = 12
            If TotalLightLevel < 1 Then TotalLightLevel = 1

            PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (TotalLightLevel * 16, 16)-((16 * TotalLightLevel) + 15, 31)
        Next
    Next
End Sub



Sub DayLightCycle
    '86400
    GameTime = GameTime + Settings.TickRate
    If GameTime > 43200 Then
        GameTime = GameTime - 43200: TimeMode = TimeMode + 1
        If TimeMode = 1 Then
            If Int(Rnd * 100) < BloodmoonSpawnrate Then
                Flag.IsBloodmoon = 1
                Swap Texture.Shadows, Texture.Shadows_Bloodmoon
                PlaySound Sounds.bloodmoon_spawn
            End If
        Else
            If Flag.IsBloodmoon = 1 Then
                Flag.IsBloodmoon = 0
                Swap Texture.Shadows, Texture.Shadows_Bloodmoon
            End If
        End If
    End If
    If TimeMode > 1 Then TimeMode = 0: CurrentDay = CurrentDay + 1

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
    GlobalLightLevel = GlobalLightLevel - (Int(PrecipitationLevel / 2) * 2)
    'change global light level based on current dimension
    Select Case CurrentDimension
        Case 0
        Case -1, Is < 0
            GlobalLightLevel = 0
        Case 1, Is > 0
            GlobalLightLevel = 0
    End Select
    If Flag.FullBright = 1 Then GlobalLightLevel = 12
End Sub


Sub INITIALIZE
    Dim As Byte i, ii, iii
    ScreenRezX = DesktopWidth
    ScreenRezY = DesktopHeight
    'ScreenRezX = 640
    'ScreenRezY = 480
    Screen NewImage(ScreenRezX + 1, ScreenRezY + 1, 32)
    FullScreen SquarePixels
    If ForcedWindowed = 1 Then ScreenRezX = 640: ScreenRezY = 480: FullScreen Off

    If DirExists("Assets") Then
        If DirExists("Assets\Sprites") = 0 Then Error 100
        If DirExists("Assets\Sprites\Entities") = 0 Then Error 100
        If DirExists("Assets\Sprites\Items") = 0 Then Error 100
        If DirExists("Assets\Sprites\Other") = 0 Then Error 100
        If DirExists("Assets\Sprites\Tiles") = 0 Then Error 100
        If DirExists("Assets\Music") = 0 Then Error 100
        If DirExists("Assets\Sounds") = 0 Then Error 100
        If DirExists("Assets\Structures") = 0 Then Error 100
        If DirExists("Assets\Worlds") = 0 Then MkDir "Assets\Worlds"
        If DirExists("Assets\SaveData") = 0 Then MkDir "Assets\SaveData": new = 1
        If FileExists("Assets\SaveData\Settings.cdf") = 0 Then new = 1
    Else Error 100
    End If

    'this was put here for debugging, idk if its actually important and im to lazy to check
    For i = 0 To MaxCraftLevel
        For ii = 0 To MaxCraftLevel
            For iii = 0 To InvParameters
                CraftingGrid(ii, i, iii) = -1
            Next
        Next
    Next


    If new = 1 Then SAVESETTINGS
    LOADSETTINGS
    Screen NewImage(ScreenRezX + 1, ScreenRezY + 1, 32)
    If Settings.FullScreen = 1 Then FullScreen SquarePixels
    If Settings.FullScreen = 0 Then FullScreen Off
    If ForcedWindowed = 1 Then ScreenRezX = 640: ScreenRezY = 480: FullScreen Off
    Print "Loading Assets"
    OSPROBE
    SwitchRender (DefaultRenderMode)
    RenderMode = DefaultRenderMode
    If new = 1 Then FirstRun


End Sub

Sub FirstRun
    Dim i
    CENTERPRINT "Welcome to TerraQuest"
    Print
    For i = 0 To Int((ScreenRezX / 8) - 1): Print "-";: Next
    Print
    CENTERPRINT "Please choose a username"
End Sub


Sub ErrorHandler
    AutoDisplay
    Cls
    PlaySound Sounds.error
    Delay 0.5
    KeyClear
    Locate 1, 1
    CENTERPRINT "CDF ERROR HANDLER"
    Print "Error Code:"; Err
    Locate 2, 1
    ENDPRINT "Error Line:" + Str$(ErrorLine)
    Dim i
    For i = 0 To Int((ScreenRezX / 8) - 1): Print "-";: Next
    '    Print "--------------------------------------------------------------------------------"
    Print
    '       PRINT "--------------------------------------------------------------------------------"
    Select Case Err
        Case 100
            CENTERPRINT "Assets folder is incomplete, this error can be triggered by one or more of the"
            CENTERPRINT "following conditions:"
            CENTERPRINT ""
            CENTERPRINT ""
            CENTERPRINT "The assets folder is missing"
            CENTERPRINT ""
            CENTERPRINT "Sub-directories in the Assets folder are missing"
            CENTERPRINT ""
            CENTERPRINT "The contents of assets, or the directory itself is corrupted"
            CENTERPRINT ""
            CENTERPRINT "You do not have proper permissions to access the assets directory"
            CENTERPRINT ""
            CENTERPRINT ""
            CENTERPRINT "Make sure the entireity of the assets folder is present and accessible to your"
            CENTERPRINT "user account and, if necessary, redownload the assets folder."
            CENTERPRINT ""
            CENTERPRINT "The assets folder, and its contents are necessary for the game to load, as it"
            CENTERPRINT "contains all sprite and texture files, sounds and music, user saved data, and"
            CENTERPRINT "world files. Without these, the game will not play correctly. It is advised to"
            CENTERPRINT "not continue."
            CONTPROMPT

        Case 101
            CENTERPRINT "This is a legacy error code, and should never be triggered in game, if it has"
            CENTERPRINT "been triggered, not due to the /error command, please contact the developer"
            CONTPROMPT

        Case 102
            CENTERPRINT "Invalid Code Position, This error occurs when the program flow enters an area"
            CENTERPRINT "that it should not be, This is most likely a programming issue, and not an end"
            CENTERPRINT "user issue."
            CENTERPRINT ""
            CENTERPRINT "There is no user solution to this issue, if this is reproducable, please file"
            CENTERPRINT "a bug report to the github, including the line number and what you were doing"
            CENTERPRINT "when it occured."
            CONTPROMPT
        Case 258
            CENTERPRINT "Invalid handle, An handle used for an image, sound, font etc. was invalid."
            CENTERPRINT "Be sure to check the return values of functions like _LOADFONT and _LOADIMAGE."
            CONTPROMPT
        Case 103
            CENTERPRINT "This world was not made for this version of " + Game.Title + ". This means one of"
            CENTERPRINT "the following cases is true:"
            CENTERPRINT ""
            CENTERPRINT ""
            CENTERPRINT "You are attempting to load an out of date world"
            CENTERPRINT ""
            CENTERPRINT "You are attempting to load a world designed for a newer version of " + Game.Title
            CENTERPRINT ""
            CENTERPRINT "Your world manifest is corrupted"
            CENTERPRINT ""
            CENTERPRINT ""
            CENTERPRINT "Double check the world version and game version."
            CENTERPRINT "World: (" + mapversion + ") Game: (" + Game.Version + ")"
            CENTERPRINT ""
            CENTERPRINT "If you are certain that this is a mistake, you may try to update the manifest"
            CENTERPRINT "here. Note that this does not update old worlds, just broken manifest files"
            CENTERPRINT "Otherwise you can try to load a different world. " + Game.Title + ""
            CENTERPRINT "does not support loading out of version worlds."
            CENTERPRINT ""
            CENTERPRINT ""
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
        Case 104
            CENTERPRINT "_"
            CENTERPRINT "/   \"
            CENTERPRINT "/       \"
            CENTERPRINT "/     o     \"
            CENTERPRINT "/             \"
            CENTERPRINT "/_______________\"
            CENTERPRINT "|                 |"
            CENTERPRINT "|    HATSUNE      |"
            CENTERPRINT "|      MIKU       |"
            CENTERPRINT "|_________________|"
            CENTERPRINT "/                   \"
            CENTERPRINT "/                     \"
            CENTERPRINT "/                       \"
            CENTERPRINT "/_________________________\"
            CONTPROMPT
        Case 105
            CENTERPRINT "This world is missing files, unable to load world."
            CENTERPRINT ""
            CENTERPRINT "This is currently a fatal error, pres (q) to exit to desktop."
            Do
                If KeyDown(113) Then System
            Loop


        Case 2
            CENTERPRINT "Syntax error, READ attempted to read a number but could not parse the next"
            CENTERPRINT "DATA item."
            CENTERPRINT ""
            CONTPROMPT
        Case 3
            CENTERPRINT "RETURN without GOSUB, The RETURN statement was encounted without first"
            CENTERPRINT " executing a corresponding GOSUB."
            CENTERPRINT ""
            CONTPROMPT
        Case 4
            CENTERPRINT "Out of DATA, The READ statement has read past the end of a DATA block."
            CENTERPRINT " Use RESTORE to change the current data item if necessary."
            CENTERPRINT ""
            CONTPROMPT

        Case 9
            CENTERPRINT "Subscript out of range, this error occurs when an array exceeds its bounds"
            CENTERPRINT "This is most likely a programming error, please let the developer know."
            CENTERPRINT ""
            CONTPROMPT


        Case Else
            CENTERPRINT "Unrecognized error, contact developers"
            CONTPROMPT

    End Select

    KeyClear
    Cls
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


Function FRAMEPS
    Static ps As Byte
    Static cs As Byte
    Static frame As Integer
    Static frps As Integer
    ps = cs
    cs = Val(Mid$(Time$, 7, 2))
    If cs = ps Then frame = frame + 1 Else frps = frame: frame = 0
    FRAMEPS = frps + 1
End Function


Sub _GL
    'If Flag.RenderOverride <> 0 Then Exit Sub
    OpenGLFPS
End Sub

Sub OpenGLFPS
    Static ps As Byte
    Static cs As Byte
    Static frame As Integer
    Static frps As Integer

    ps = cs
    cs = Val(Mid$(Time$, 7, 2))
    If cs = ps Then frame = frame + 1 Else frps = frame: frame = 0
    OGLFPS = frps + 1
End Sub


Sub SetBG
    If BGDraw = 0 Then
        Dim i As Integer
        Dim ii As Integer
        For i = 0 To 30
            For ii = 0 To 40
                If VisibleCheck(ii, i) = 1 Then
                    PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.TileSheet, , (16, 0)-(31, 15)
                End If
            Next
        Next
    End If
End Sub


Sub SetMap
    Dim i As Integer
    Dim ii As Integer
    For i = 1 To 30
        For ii = 1 To 40
            If VisibleCheck(ii, i) = 1 Then
                PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.TileSheet, , (TileIndex(GroundTile(ii, i), 1), TileIndex(GroundTile(ii, i), 2))-(TileIndex(GroundTile(ii, i), 1) + 15, TileIndex(GroundTile(ii, i), 2) + 15)
                PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (Int(TileData(ii, i, 4) / 32) * 16, 32)-((Int(TileData(ii, i, 4) / 32) * 16) + 15, 47)
                PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.TileSheet, , (TileIndex(WallTile(ii, i), 1), TileIndex(WallTile(ii, i), 2))-(TileIndex(WallTile(ii, i), 1) + 15, TileIndex(WallTile(ii, i), 2) + 15)
                PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (Int(TileData(ii, i, 5) / 32) * 16, 32)-((Int(TileData(ii, i, 5) / 32) * 16) + 15, 47)
                PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.TileSheet, , (TileIndex(CeilingTile(ii, i), 1), TileIndex(CeilingTile(ii, i), 2))-(TileIndex(CeilingTile(ii, i), 1) + 15, TileIndex(CeilingTile(ii, i), 2) + 15)
                PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), Texture.Shadows, , (Int(TileData(ii, i, 6) / 32) * 16, 32)-((Int(TileData(ii, i, 6) / 32) * 16) + 15, 47)
            End If
        Next
    Next
End Sub

Function VisibleCheck (TileX As Integer, TileY As Integer)

    VisibleCheck = 1
    If Flag.FullRender = 1 Then Exit Function
    If TileX * 16 > (CameraPositionX + (ScreenRezX / 4 / 2)) + 16 + 8 Then VisibleCheck = 0
    If TileX * 16 < (CameraPositionX - (ScreenRezX / 4 / 2)) - 0 Then VisibleCheck = 0
    If TileY * 16 > (CameraPositionY + (ScreenRezY / 4 / 2)) + 16 + 8 Then VisibleCheck = 0
    If TileY * 16 < (CameraPositionY - (ScreenRezY / 4 / 2)) - 0 Then VisibleCheck = 0

End Function

Sub SwitchRender (mode As Byte)
    Static FirstSkip As Byte
    If mode <> 0 And mode <> 1 Then Exit Sub

    If FirstSkip = 1 Then 'this is to prevent the game from crashing if the files arent loaded yet, because this is also run to initially load the files
        FreeImage Texture.PlayerSprites
        FreeImage Texture.PlayerSheet
        FreeImage Texture.ZombieSheet
        FreeImage Texture.DuckSheet
        FreeImage Texture.TileSheet
        FreeImage Texture.ItemSheet
        FreeImage Texture.HudSprites
        FreeImage Texture.Shadows
        FreeImage Texture.Shadows_Bloodmoon
        FreeImage Texture.Precipitation

    End If

    Texture.Shadows = 0
    Texture.Shadows_Bloodmoon = 0

    Texture.PlayerSprites = LoadImage(File.PlayerSprites, mode + 32)
    Texture.PlayerSheet = LoadImage(File.PlayerSheet, mode + 32)
    Texture.ZombieSheet = LoadImage(File.ZombieSheet, mode + 32)
    Texture.DuckSheet = LoadImage(File.DuckSheet, mode + 32)
    Texture.TileSheet = LoadImage(File.TileSheet, mode + 32)
    Texture.ItemSheet = LoadImage(File.ItemSheet, mode + 32)
    Texture.HudSprites = LoadImage(File.HudSprites, mode + 32)
    Texture.Shadows = LoadImage(File.Shadows, mode + 32)
    Texture.Shadows_Bloodmoon = LoadImage(File.Shadows_Bloodmoon, mode + 32)
    Texture.Precipitation = LoadImage(File.Precipitation, mode + 32)

    If Flag.IsBloodmoon = 1 Then Swap Texture.Shadows, Texture.Shadows_Bloodmoon

    FirstSkip = 1

End Sub

Sub ZOOM
    If Flag.StillCam = 0 And Flag.FreeCam = 0 Then
        CameraPositionX = Player.x
        CameraPositionY = Player.y
    End If

    If CameraPositionX - (ScreenRezX / 4 / 2) + 8 < 0 Then CameraPositionX = (ScreenRezX / 4 / 2) - 8
    If CameraPositionY - (ScreenRezY / 4 / 2) + 8 < 0 Then CameraPositionY = (ScreenRezY / 4 / 2) - 8
    If CameraPositionX + (ScreenRezX / 4 / 2) + 8 > 640 Then CameraPositionX = 640 - ((ScreenRezX / 4 / 2) + 8)
    If CameraPositionY + (ScreenRezY / 4 / 2) + 8 > 480 Then CameraPositionY = 480 - ((ScreenRezY / 4 / 2) + 8)

    If Flag.FullCam = 0 Then Window Screen(CameraPositionX - ((ScreenRezX / 4 / 2) - 8), CameraPositionY - ((ScreenRezY / 4 / 2) - 8))-(CameraPositionX + ((ScreenRezX / 4 / 2) + 8), CameraPositionY + ((ScreenRezY / 4 / 2) + 8)) Else Window
End Sub

Sub PlaySound (nam$)
    Dim sndhnd As Long
    sndhnd = SndOpen(nam$)
    SndPlay sndhnd
End Sub




Sub NewWorld '(worldname as string, worldseed as integer64)
    Dim i, ii, iii
    Cls
    KeyClear
    AutoDisplay

    Input "World Name?", WorldName
    Input "World Seed? (0 for random)", WorldSeed

    If WorldSeed = 0 Then
        Randomize Using Timer
        WorldSeed = Ceil(Rnd * 18446744073709551615) - 9223372036854775807
    End If

    SavedMapX = -1
    SavedMapY = 0
    Player.x = 320
    Player.y = 200
    CurrentDimension = 0

    SAVEMAP 'necessary for at least 1 map to be saved before running generate map, because savemap is also responsible for creating the file structure for the world
    GenerateMap 0 'generates -1,0 so that its not just saving a completely empty map
    SAVEMAP 'saves that generated map

    Do 'generates the map that the player will actually spawn in, also checks to see if the player CAN even spawn in this map and is not in some ocean, if not it will try the next map over, the reason map -1,0 is generated first is so that this loop is cleaner
        SavedMapX = SavedMapX + 1
        GenerateMap 0
    Loop Until WallTile(PlayerTileX, PlayerTileY) = 1

    SpawnPointX = Player.x
    SpawnPointY = Player.y
    SpawnMapX = SavedMapX
    SpawnMapY = SavedMapY
    SAVEMAP 'saves only the map that the player will spawn on, why waste write cycles
    Print "map generated, loading world"
    Delay 0.5
    WorldSeed = 0
    LOADWORLD
End Sub

Function ValidSpawn

End Function

Function Cave1DimSeed
    Cave1DimSeed = Perlin(((SavedMapX * 40)) / Gen.TempScale, ((SavedMapY * 30)) / Gen.TempScale, 0, Perlin((1 + SavedMapX * 40) / Gen.HeightScale, (1 + SavedMapY * 30) / Gen.HeightScale, 0, WorldSeed))
End Function

Sub GenerateMap (Dimension As Byte)
    Dim i, ii, iii
    Dim PerlinTile As Double
    Dim DimensionSeed As Double

    Select Case Dimension
        Case 0
            'generate overworld
            For i = 0 To 31
                For ii = 0 To 41

                    'generate base tiles
                    GroundTile(ii, i) = 2
                    TileData(ii, i, 4) = 255
                    WallTile(ii, i) = 1
                    TileData(ii, i, 5) = 255
                    CeilingTile(ii, i) = 1
                    TileData(ii, i, 6) = 255


                    'generate terrain
                    PerlinTile = Perlin((ii + (SavedMapX * 40)) / Gen.HeightScale, (i + (SavedMapY * 30)) / Gen.HeightScale, 0, WorldSeed)
                    Select Case PerlinTile

                        Case Is < 0.35
                            GroundTile(ii, i) = 13
                        Case 0.35 To 0.4
                            GroundTile(ii, i) = 29
                        Case Is > 0.7
                            GroundTile(ii, i) = 4
                            WallTile(ii, i) = 28

                        Case Is > 0.6
                            GroundTile(ii, i) = 4
                            WallTile(ii, i) = 19
                    End Select

                    'generate structures


                Next
            Next

            'generate biomes
            For i = 0 To 31
                For ii = 0 To 41
                    PerlinTile = Perlin((ii + (SavedMapX * 40)) / Gen.TempScale, (i + (SavedMapY * 30)) / Gen.TempScale, 0, Perlin((SavedMapX * 40) / Gen.HeightScale, (SavedMapY * 30) / Gen.HeightScale, 0, WorldSeed))
                    Select Case PerlinTile

                        Case Is < 0.25
                            'permafrost (being in this biome will damage you
                        Case 0.25 To 0.35
                            'snowy
                            Select Case GroundTile(ii, i)
                                Case 13
                                    GroundTile(ii, i) = 14

                            End Select
                        Case 0.35 To 0.55
                            'planes
                        Case 0.55 To 0.65
                            'forrest
                            '   Case Is > 0.75
                            'lava    (needless to say being here will damage you, but even on land
                        Case Is > 0.75
                            'desert
                            Select Case GroundTile(ii, i)
                                Case Is <> 13
                                    GroundTile(ii, i) = 29
                            End Select


                    End Select

                Next
            Next

            'set feature seed
            Randomize Using Perlin((SavedMapX * 40) / Gen.HeightScale, (SavedMapY * 30) / Gen.HeightScale, 0, WorldSeed)

            'generate features
            For i = 0 To 31
                For ii = 0 To 41


                    If GroundTile(ii, i) = 2 And WallTile(ii, i) = 1 Then

                        If Ceil(Rnd * 10) = 5 Then
                            WallTile(ii, i) = 5
                        End If

                        'generate ground wood items
                        If Ceil(Rnd * 150) = 50 Then
                            WallTile(ii, i) = 11
                            NewContainer SavedMapX, SavedMapY, ii, i
                            OpenContainer SavedMapX, SavedMapY, ii, i
                            For iii = 0 To InvParameters
                                Container(0, 0, iii) = ItemIndex(19, iii)
                            Next
                            Container(0, 0, 7) = Ceil(Rnd * 3)
                            CloseContainer SavedMapX, SavedMapY, ii, i
                        End If

                        'generate ground Stone items
                        If Ceil(Rnd * 300) = 50 Then
                            WallTile(ii, i) = 11
                            NewContainer SavedMapX, SavedMapY, ii, i
                            OpenContainer SavedMapX, SavedMapY, ii, i
                            For iii = 0 To InvParameters
                                Container(0, 0, iii) = ItemIndex(29, iii)
                            Next
                            Container(0, 0, 7) = Ceil(Rnd * 2)
                            CloseContainer SavedMapX, SavedMapY, ii, i
                        End If


                        'generate berry bushes
                        If Ceil(Rnd * 250) = 125 Then
                            WallTile(ii, i) = 12
                        End If

                        'generate carrots
                        If Ceil(Rnd * 600) = 300 Then
                            WallTile(ii, i) = 17
                        End If


                    End If

                    'update set tiles
                    UpdateTile ii, i
                Next
            Next
            'generate cave entrance
            For i = 0 To 31
                For ii = 0 To 41

                    Select Case Perlin((ii + (SavedMapX * 40)) / Gen.HeightScale, (i + (SavedMapY * 30)) / Gen.HeightScale, 0, Cave1DimSeed)
                        Case Is > 0.73 'connect vshaft to above layer
                            WallTile(ii, i) = 1
                            GroundTile(ii, i) = 26


                        Case Is > 0.69 'lol
                            WallTile(ii, i) = 1


                        Case Is < 0.23 'connect vshaft to above layer
                            WallTile(ii, i) = 14
                            GroundTile(ii, i) = 26


                        Case Is < 0.27 'fill in vshaft
                            WallTile(ii, i) = 1

                    End Select

                Next
            Next
            'add a way for generatemap to save to its specific dimension file, and for genmap to actually know what dimension its generating
            'essentially make genmap have its own saving function or some shit idk

        Case -1 'caves

            'set Cave1 seed
            DimensionSeed = Cave1DimSeed
            'generate cave1

            For i = 0 To 31
                For ii = 0 To 41

                    'generate base tiles
                    GroundTile(ii, i) = 4 '47
                    TileData(ii, i, 4) = 255
                    WallTile(ii, i) = 19
                    TileData(ii, i, 5) = 255
                    CeilingTile(ii, i) = 1
                    TileData(ii, i, 6) = 255


                    'generate hShafts
                    Select Case Perlin((ii + (SavedMapX * 40)) / Gen.HeightScale, (i + (SavedMapY * 30)) / Gen.HeightScale, 10, DimensionSeed)
                        Case 0.27 To 0.3 'low val cave
                            WallTile(ii, i) = 1
                        Case 0.5 To 0.56 'high val cave
                            WallTile(ii, i) = 1
                    End Select

                    'generate vShafts

                    Select Case Perlin((ii + (SavedMapX * 40)) / Gen.HeightScale, (i + (SavedMapY * 30)) / Gen.HeightScale, 0, DimensionSeed)
                        Case Is > 0.73 'connect vshaft to above layer
                            WallTile(ii, i) = 1
                            GroundTile(ii, i) = 48


                        Case Is > 0.69 'lol
                            WallTile(ii, i) = 1

                        Case Is < 0.23 'connect vshaft to above layer
                            WallTile(ii, i) = 14
                            GroundTile(ii, i) = 48


                        Case Is < 0.27 'fill in vshaft
                            WallTile(ii, i) = 1

                    End Select



                    'generate structures

                    UpdateTile ii, i
                Next
            Next


            'generate vShaft
            'connect vShaft to above layer

            'generate hShaft

            'set features

        Case 1 'aquifer

    End Select
End Sub





Function Perlin (x As Single, y As Single, z As Single, seed As Single) 'i did not write this function
    Randomize seed

    Static p5NoiseSetup As _Byte
    Static perlini() As Single
    Static PERLIN_YWRAPB As Single, PERLIN_YWRAP As Single
    Static PERLIN_ZWRAPB As Single, PERLIN_ZWRAP As Single
    Static PERLIN_SIZE As Single

    If Not p5NoiseSetup Then
        p5NoiseSetup = -1

        PERLIN_YWRAPB = 4
        PERLIN_YWRAP = Int(1 * (2 ^ PERLIN_YWRAPB))
        PERLIN_ZWRAPB = 8
        PERLIN_ZWRAP = Int(1 * (2 ^ PERLIN_ZWRAPB))
        PERLIN_SIZE = 4095

        perlin_octaves = 4
        perlin_amp_falloff = 0.5

        ReDim perlini(PERLIN_SIZE + 1) As Single
        Dim i As Single
        For i = 0 To PERLIN_SIZE + 1
            perlini(i) = Rnd
        Next
    End If

    x = Abs(x)
    y = Abs(y)
    z = Abs(z)

    Dim xi As Single, yi As Single, zi As Single
    xi = Int(x)
    yi = Int(y)
    zi = Int(z)

    Dim xf As Single, yf As Single, zf As Single
    xf = x - xi
    yf = y - yi
    zf = z - zi

    Dim r As Single, ampl As Single, o As Single
    r = 0
    ampl = .5

    For o = 1 To perlin_octaves
        Dim of As Single, rxf As Single
        Dim ryf As Single, n1 As Single, n2 As Single, n3 As Single
        of = xi + Int(yi * (2 ^ PERLIN_YWRAPB)) + Int(zi * (2 ^ PERLIN_ZWRAPB))

        rxf = 0.5 * (1.0 - Cos(xf * _Pi))
        ryf = 0.5 * (1.0 - Cos(yf * _Pi))

        n1 = perlini(of And PERLIN_SIZE)
        n1 = n1 + rxf * (perlini((of + 1) And PERLIN_SIZE) - n1)
        n2 = perlini((of + PERLIN_YWRAP) And PERLIN_SIZE)
        n2 = n2 + rxf * (perlini((of + PERLIN_YWRAP + 1) And PERLIN_SIZE) - n2)
        n1 = n1 + ryf * (n2 - n1)

        of = of + PERLIN_ZWRAP
        n2 = perlini(of And PERLIN_SIZE)
        n2 = n2 + rxf * (perlini((of + 1) And PERLIN_SIZE) - n2)
        n3 = perlini((of + PERLIN_YWRAP) And PERLIN_SIZE)
        n3 = n3 + rxf * (perlini((of + PERLIN_YWRAP + 1) And PERLIN_SIZE) - n3)
        n2 = n2 + ryf * (n3 - n2)

        n1 = n1 + (0.5 * (1.0 - Cos(zf * _Pi))) * (n2 - n1)

        r = r + n1 * ampl
        ampl = ampl * perlin_amp_falloff
        xi = Int(xi * (2 ^ 1))
        xf = xf * 2
        yi = Int(yi * (2 ^ 1))
        yf = yf * 2
        zi = Int(zi * (2 ^ 1))
        zf = zf * 2

        If xf >= 1.0 Then xi = xi + 1: xf = xf - 1
        If yf >= 1.0 Then yi = yi + 1: yf = yf - 1
        If zf >= 1.0 Then zi = zi + 1: zf = zf - 1
    Next
    Perlin = r
End Function

'$include:'Assets\Sources\OSprobe.bm'
