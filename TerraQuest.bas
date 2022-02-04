$NoPrefix
Option Explicit
On Error GoTo ERRORHANDLE
Randomize Timer
Screen NewImage(641, 481, 32) '40x30
PrintMode KeepBackground
DisplayOrder Hardware , Software
Title "TerraQuest"

'$include: 'Assets\Sources\VariableDeclaration.bi'

'$include: 'Assets\Sources\DefaultValues.bi'

'$include: 'Assets\Sources\TileIndex.bi'

'$include: 'Assets\Sources\InventoryIndex.bi'

'$include: 'Assets\Sources\CreativeInventory.bi'

Rem'$include: 'Assets\Sources\CraftingIndex.bi'

Rem'$include: 'Assets\Sources\EffectsIndex.bi'


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
For i = 0 To 31
    For ii = 0 To 41
        UpdateTile ii, i
    Next
Next
SpreadLight (1)
GoTo game

Error 102

ERRORHANDLE: ErrorHandler
DisplayOrder GLRender , Hardware , Software
game:

Do
    If Flag.InitialRender = 0 Then 'this section of if and elseif is to prevent the game from giving random bullshit characters and running at 1fps, i have no idea why this works, or what caused it in the first place, but hey.
        SwitchRender 0
        Flag.InitialRender = 1
    ElseIf Flag.InitialRender = 1 Then
        SwitchRender 1
        Flag.InitialRender = 2
    End If

    SETBG
    SetMap
    CastShadow
    Move
    COLDET
    SPSET
    SetLighting
    INTER
    HUD
    ZOOM
    DEV
    ChangeMap 0, 0, 0
    DayLightCycle
    MinMemFix

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
Loop




Error 102

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


Sub Move
    Player.movingx = 0 'sets to 0 and then if a key is being held, sets back to 1 before anyone notices
    Player.movingy = 0 'sets to 0 and then if a key is being held, sets back to 1 before anyone notices
    Player.lastx = Player.x 'these 2 are literally just for the freecammode
    Player.lasty = Player.y


    If MoveUp Then
        Player.vy = Player.vy - TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
        Player.facing = 0
        Player.movingy = 1
    End If
    If MoveDown Then
        Player.vy = Player.vy + TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
        Player.facing = 1
        Player.movingy = 1
    End If
    If MoveLeft Then
        Player.vx = Player.vx - TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
        Player.facing = 2
        Player.movingx = 1
    End If
    If MoveRight Then
        Player.vx = Player.vx + TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
        Player.facing = 3
        Player.movingx = 1
    End If

    If Player.vy > TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) Then Player.vy = TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10)
    If Player.vy < TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) - (TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) * 2) Then Player.vy = TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) - (TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) * 2)

    If Player.vx > TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) Then Player.vx = TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10)
    If Player.vx < TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) - (TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) * 2) Then Player.vx = TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) - (TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 10) * 2)

    If Player.movingy = 0 Then
        If Player.vy > 0 Then
            Player.vy = Player.vy - TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
        End If
        If Player.vy < 0 Then
            Player.vy = Player.vy + TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
            If Player.vy > 0 Then Player.vy = 0
        End If
    End If
    If Player.movingx = 0 Then
        If Player.vx > 0 Then
            Player.vx = Player.vx - TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
        End If
        If Player.vx < 0 Then
            Player.vx = Player.vx + TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, 9)
            If Player.vx > 0 Then Player.vx = 0
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

Sub ContactEffect (Direction As Byte)
End Sub



Sub MinMemFix 'this subroutine is specifically to try to fix a memory leak that occurs when in hardware accelerated mode, and the game is minimized. by simply turning off hardware acceleration.
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
            FacingX = Int((Player.x + 8) / 16) + 1

        Case 1
            FacingX = Int((Player.x + 8) / 16) + 1

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

            FacingY = Int((Player.y + 8) / 16) + 1
        Case 3

            FacingY = Int((Player.y + 8) / 16) + 1
    End Select

End Function
Sub UseItem (Slot)
    Select Case Inventory(0, Slot, 0)
        Case 0 'Block placing
            Select Case Inventory(0, Slot, 4)
                Case 0
                    If GroundTile(FacingX, FacingY) = 0 Then
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
                    If WallTile(FacingX, FacingY) = 1 Then
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
                Case 0
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
                        TileData(FacingX, FacingY, 4) = TileData(FacingX, FacingY, 4) - Inventory(0, Slot, 6)
                        TileData(FacingX, FacingY, 4) = TileData(FacingX, FacingY, 4) + TileIndexData(GroundTile(FacingX, FacingY), 4)
                        If TileData(FacingX, FacingY, 4) < 0 Then TileData(FacingX, FacingY, 4) = 0
                        If TileData(FacingX, FacingY, 4) > 255 Then TileData(FacingX, FacingY, 4) = 255
                    End If
                Case 1
                    If WallTile(FacingX, FacingY) <> 1 Then
                        If TileData(FacingX, FacingY, 5) <= 0 Then
                            If GameMode <> 1 Then
                                If PickUpItem(TileIndex(WallTile(FacingX, FacingY), 3)) = 1 Then Exit Select
                            End If
                            WallTile(FacingX, FacingY) = 1
                            TileData(FacingX, FacingY, 5) = 255
                            UpdateTile FacingX, FacingY
                            SpreadLight (1)
                            Exit Select
                        End If
                        TileData(FacingX, FacingY, 5) = TileData(FacingX, FacingY, 5) - Inventory(0, Slot, 6)
                        TileData(FacingX, FacingY, 5) = TileData(FacingX, FacingY, 5) + TileIndexData(WallTile(FacingX, FacingY), 4)
                        If TileData(FacingX, FacingY, 5) < 0 Then TileData(FacingX, FacingY, 5) = 0
                        If TileData(FacingX, FacingY, 5) > 255 Then TileData(FacingX, FacingY, 5) = 255
                    End If

            End Select

    End Select
    If TileData(FacingX, FacingY, 7) = 0 And GroundTile(FacingX, FacingY) = 0 Then
        WallTile(FacingX, FacingY) = 1
        UpdateTile FacingX, FacingY
        SpreadLight (1)

    End If
End Sub


Sub InvSwap (Slot, Mode, ItemSelectX, ItemSelectY, CreativePage)
    'Dim Shared Inventory(3, 5,9) As Integer
    'dim shared CreativeInventory(2,5,9,1)
    Dim i
    For i = 0 To InvParameters
        Select Case Mode
            Case 0
                Swap CreativeInventory(ItemSelectY, ItemSelectX, i, CreativePage), Inventory(0, Slot, i)
            Case 1
                Swap Inventory(ItemSelectY + 1, ItemSelectX, i), Inventory(CreativePage + 1, Slot, i)
        End Select
    Next
End Sub


Sub ChangeMap (Command, CommandMapX, CommandMapY)
    Static TickDelay
    Static TotalDelay
    Static LightStep
    Dim i, ii
    If LightStep < 12 Then
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


    End Select
End Sub



Sub NewStack (ItemID, StackNumber)
    Dim i, ii, iii
    For i = 0 To 3
        For ii = 0 To 5
            If Inventory(i, ii, InvParameters) = -1 Then
                For iii = 0 To 9
                    Inventory(i, ii, iii) = ItemIndex(ItemID, iii)
                Next
                Inventory(i, ii, 7) = StackNumber
                GoTo Complete
            End If
        Next
    Next
    Complete:
End Sub



Sub HUD
    If Flag.HudDisplay = 0 Then
        Dim i, ii, iii
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
        Static ItemSelectedX As Byte
        Static ItemSelectedY As Byte
        Static hbtimeout As Integer64
        Static adjustspace, adjustx, adjusty, invgap
        Static CursorMode As Byte
        Static ContainerOpened As Byte
        Static ContainerParams(4) As Single
        Static ActiveCursor As Byte
        Static ContainerItem As Byte
        Static SwapInitiated As Byte
        Static ContainerSelected As Byte
        adjustx = 5
        adjusty = -45
        adjustspace = 68
        invgap = 83
        invoffset = 1
        invheight = 5
        hboffset = 1
        token = 1
        hbitemsize = 2
        If GameMode = 2 Then CreativePage = -1
        If GameMode = 1 And CreativePage < 0 Then CreativePage = 0

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
            If Inventory(0, hbpos, 7) > 1 Then
                Color RGB(0, 0, 0)
                For i = 0 To 2
                    For ii = 0 To 2
                        PrintString ((0 + adjustx) + (adjustspace * hbpos) + i - 1, 480 - 16 + adjusty + ii - 1), Str$(Inventory(0, hbpos, 7))
                    Next
                Next
                Color RGB(255, 255, 255)
                PrintString ((0 + adjustx) + (adjustspace * hbpos), 480 - 16 + adjusty), Str$(Inventory(0, hbpos, 7))
            End If
        Next


        'Inventory Display
        If Flag.InventoryOpen = 1 Then
            If ContainerOpened = 1 Then
                If ContainerParams(0) <> SavedMapX Or ContainerParams(1) <> SavedMapY Or ContainerParams(2) <> FacingX Or ContainerParams(3) <> FacingY Then
                    'make check for if container is empty, and if it is set to delete on empty, then if it is, delete it
                    CloseContainer ContainerParams(0), ContainerParams(1), ContainerParams(2), ContainerParams(3)
                    ContainerOpened = 0
                End If
            End If
            If TileIndexData(WallTile(FacingX, FacingY), 7) = 1 Then
                If ContainerOpened = 0 Then
                    OpenContainer SavedMapX, SavedMapY, FacingX, FacingY
                    ContainerParams(0) = SavedMapX
                    ContainerParams(1) = SavedMapY
                    ContainerParams(2) = FacingX
                    ContainerParams(3) = FacingY
                    ContainerOpened = 1
                End If
                hbpos = 0
                invrow = 0
                Dim ContainerX
                Dim ContainerY
                Dim ContainerSelectedX
                Dim ContainerSelectedY
                ContainerX = ContainerItem
                While ContainerX > 5
                    ContainerX = ContainerX - 6
                Wend
                ContainerY = Int(ContainerItem / 6)

                ContainerSelectedX = ContainerSelected
                While ContainerSelectedX > 5
                    ContainerSelectedX = ContainerSelectedX - 6
                Wend
                ContainerSelectedY = Int(ContainerSelected / 6)

                For i = 0 To Container(18, 0)
                    'background
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2), Texture.HudSprites, , (0, 32)-(31, 63)
                    'cursor
                    If ActiveCursor = 1 Then
                        Select Case CursorMode
                            Case 0
                                If invrow = ContainerY And hbpos = ContainerX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2), Texture.HudSprites, , (32, 32)-(63, 63)
                            Case 1
                                If SwapInitiated = 1 Then
                                    If invrow = ContainerSelectedY And hbpos = ContainerSelectedX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2), Texture.HudSprites, , (32, 32)-(63, 63)
                                End If
                                If invrow = ContainerY And hbpos = ContainerX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)

                        End Select
                    End If
                    If ActiveCursor = 0 Then
                        If CursorMode = 1 Then
                            If SwapInitiated = 1 Then
                                If invrow = ContainerSelectedY And hbpos = ContainerSelectedX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2), Texture.HudSprites, , (32, 32)-(63, 63)
                            End If
                        End If
                    End If
                    'item image
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, (CameraPositionY + 68 - 16 - hboffset + hbitemsize) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, (CameraPositionY + 68 - hboffset - hbitemsize) - (16 * (invrow + 4) + invoffset * invrow) - invheight * 2), Texture.ItemSheet, , (Container(i, 1), Container(i, 2))-(Container(i, 1) + 15, Container(i, 2) + 15)
                    'item quanity
                    If Container(i, 7) > 1 Then
                        Color RGB(0, 0, 0)
                        For iii = 0 To 2
                            For ii = 0 To 2
                                PrintString ((0 + adjustx) + (adjustspace * hbpos) + iii - 1, (480 - 16 + adjusty) - (adjustspace * (invrow + 3) + 9) - invgap + ii - 1), Str$(Container(i, 7))
                            Next
                        Next
                        Color RGB(255, 255, 255)
                        PrintString ((0 + adjustx) + (adjustspace * hbpos), (480 - 16 + adjusty) - (adjustspace * (invrow + 3) + 9) - invgap), Str$(Container(i, 7))
                    End If

                    hbpos = hbpos + 1
                    If hbpos > 5 Then invrow = invrow + 1: hbpos = 0
                Next
            Else

            End If
            For invrow = 0 To 2
                For hbpos = 0 To 5

                    'place background squares
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (0, 32)-(31, 63)

                    'place cursor
                    If ActiveCursor = 0 Then
                        Select Case CursorMode
                            Case 0
                                If invrow = ItemSelectY And hbpos = ItemSelectX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32, 32)-(63, 63)
                            Case 1
                                If SwapInitiated = 0 Then
                                    If invrow = ItemSelectedY And hbpos = ItemSelectedX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32, 32)-(63, 63)
                                End If
                                If invrow = ItemSelectY And hbpos = ItemSelectX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)
                        End Select
                    End If
                    If ActiveCursor = 1 Then
                        If CursorMode = 1 Then
                            If SwapInitiated = 0 Then
                                If invrow = ItemSelectedY And hbpos = ItemSelectedX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32, 32)-(63, 63)
                            End If
                        End If
                    End If
                    'display inventory contents
                    Select Case GameMode
                        Case 1
                            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, (CameraPositionY + 68 - 16 - hboffset + hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, (CameraPositionY + 68 - hboffset - hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.ItemSheet, , (CreativeInventory(invrow, hbpos, 1, CreativePage), CreativeInventory(invrow, hbpos, 2, CreativePage))-(CreativeInventory(invrow, hbpos, 1, CreativePage) + 15, CreativeInventory(invrow, hbpos, 2, CreativePage) + 15)
                        Case 2
                            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, (CameraPositionY + 68 - 16 - hboffset + hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, (CameraPositionY + 68 - hboffset - hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.ItemSheet, , (Inventory(invrow + 1, hbpos, 1), Inventory(invrow + 1, hbpos, 2))-(Inventory(invrow + 1, hbpos, 1) + 15, Inventory(invrow + 1, hbpos, 2) + 15)
                            If Inventory(invrow + 1, hbpos, 7) > 1 Then
                                Color RGB(0, 0, 0)
                                For i = 0 To 2
                                    For ii = 0 To 2
                                        PrintString ((0 + adjustx) + (adjustspace * hbpos) + i - 1, (480 - 16 + adjusty) - (adjustspace * invrow + 1) - invgap + ii - 1), Str$(Inventory(invrow + 1, hbpos, 7))
                                    Next
                                Next
                                Color RGB(255, 255, 255)
                                PrintString ((0 + adjustx) + (adjustspace * hbpos), (480 - 16 + adjusty) - (adjustspace * invrow + 1) - invgap), Str$(Inventory(invrow + 1, hbpos, 7))
                            End If
                    End Select
                Next
            Next

            Select Case KeyPressed
                Case 9
                    ActiveCursor = ActiveCursor + 1
                    If ActiveCursor > 1 Then ActiveCursor = 0

            End Select
            If ActiveCursor = 0 Then
                Select Case KeyPressed
                    Case 92
                        If Inventory(ItemSelectY + 1, ItemSelectX, 7) > 1 Then
                            NewStack Inventory(ItemSelectY + 1, ItemSelectX, 9), Int(Inventory(ItemSelectY + 1, ItemSelectX, 7) / 2)
                            Inventory(ItemSelectY + 1, ItemSelectX, 7) = Ceil(Inventory(ItemSelectY + 1, ItemSelectX, 7) / 2)
                        End If
                    Case 13
                        Select Case CursorMode
                            Case 0
                                CursorMode = 1
                                ItemSelectedX = ItemSelectX
                                ItemSelectedY = ItemSelectY
                                SwapInitiated = 0
                                Exit Select
                            Case 1
                                CursorMode = 0
                                If SwapInitiated = 0 Then
                                    If ItemSelectX = ItemSelectedX And ItemSelectY = ItemSelectedY Then Exit Select
                                    If Inventory(ItemSelectY + 1, ItemSelectX, 9) = Inventory(ItemSelectedY + 1, ItemSelectedX, 9) Then
                                        Inventory(ItemSelectY + 1, ItemSelectX, 7) = Inventory(ItemSelectY + 1, ItemSelectX, 7) + Inventory(ItemSelectedY + 1, ItemSelectedX, 7)
                                        If Inventory(ItemSelectY + 1, ItemSelectX, 7) > Inventory(ItemSelectY + 1, ItemSelectX, 8) Then
                                            Inventory(ItemSelectedY + 1, ItemSelectedX, 7) = Inventory(ItemSelectY + 1, ItemSelectX, 7) - Inventory(ItemSelectY + 1, ItemSelectX, 8)
                                            Inventory(ItemSelectY + 1, ItemSelectX, 7) = Inventory(ItemSelectY + 1, ItemSelectX, 8)
                                        Else
                                            EmptySlot ItemSelectedX, ItemSelectedY + 1
                                        End If
                                    Else
                                        InvSwap ItemSelectedX, GameMode - 1, ItemSelectX, ItemSelectY, ItemSelectedY
                                    End If
                                    Exit Select
                                End If
                                If SwapInitiated = 1 Then

                                    ConSwap ContainerSelected, ItemSelectX, ItemSelectY + 1, 1
                                End If

                        End Select
                    Case 49
                        InvSwap 0, GameMode - 1, ItemSelectX, ItemSelectY, CreativePage
                    Case 50
                        InvSwap 1, GameMode - 1, ItemSelectX, ItemSelectY, CreativePage
                    Case 51
                        InvSwap 2, GameMode - 1, ItemSelectX, ItemSelectY, CreativePage
                    Case 52
                        InvSwap 3, GameMode - 1, ItemSelectX, ItemSelectY, CreativePage
                    Case 53
                        InvSwap 4, GameMode - 1, ItemSelectX, ItemSelectY, CreativePage
                    Case 54
                        InvSwap 5, GameMode - 1, ItemSelectX, ItemSelectY, CreativePage
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
            If ActiveCursor = 1 Then
                Select Case KeyPressed
                    Case 92
                        'alert cannot split in container
                    Case 13
                        Select Case CursorMode
                            Case 0
                                CursorMode = 1
                                ContainerSelected = ContainerItem
                                SwapInitiated = 1
                                Exit Select

                            Case 1
                                CursorMode = 0
                                If SwapInitiated = 1 Then
                                    If ContainerItem = ContainerSelected Then Exit Select
                                    If Container(ContainerItem, 9) = Container(ContainerSelected, 9) Then
                                        Container(ContainerItem, 7) = Container(ContainerItem, 7) + Container(ContainerSelected, 7)
                                        If Container(ContainerItem, 7) > Container(ContainerItem, 8) Then
                                            Container(ContainerSelected, 7) = Container(ContainerItem, 7) - Container(ContainerItem, 8)
                                            Container(ContainerItem, 7) = Container(ContainerItem, 8)
                                        Else
                                            EmptyContainerSlot ContainerItem
                                        End If
                                    Else
                                        ConSwap ContainerItem, ContainerSelected, 0, 0
                                    End If
                                End If
                                If SwapInitiated = 0 Then
                                    ConSwap ContainerItem, ItemSelectedX, ItemSelectedY + 1, 1
                                End If
                                Exit Select
                        End Select
                    Case 18432

                        ContainerItem = ContainerItem + 6
                    Case 20480

                        ContainerItem = ContainerItem - 6
                    Case 19200
                        ContainerItem = ContainerItem - 1
                    Case 19712
                        ContainerItem = ContainerItem + 1

                End Select
                If ContainerItem < 0 Then ContainerItem = Container(18, 0)
                If ContainerItem > Container(18, 0) Then ContainerItem = 0

            End If
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

Sub ConSwap (ContainerItem, ContainerSelected, InventoryY, Mode)
    'Dim Shared Inventory(3, 5,9) As Integer
    'dim shared CreativeInventory(2,5,9,1)
    Dim i
    For i = 0 To InvParameters
        Select Case Mode
            Case 0
                Swap Container(ContainerItem, i), Container(ContainerSelected, i)
            Case 1
                Swap Container(ContainerItem, i), Inventory(InventoryY, ContainerSelected, i)
        End Select
    Next
End Sub

Sub EmptyContainerSlot (slot)
    Dim i
    For i = 0 To InvParameters
        Container(slot, i) = -1
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
        Print
        ENDPRINT "Facing tile data:"
        If Player.x >= 0 And Player.x <= 640 - 16 And Player.y >= 0 And Player.y <= 480 - 16 Then

            For i = 0 To TileParameters
                dummystring = dummystring + Str$(TileData(FacingX, FacingY, i))
            Next
            ENDPRINT dummystring
            ENDPRINT Str$(GroundTile(FacingX, FacingY)) + Str$(WallTile(FacingX, FacingY)) + Str$(CeilingTile(FacingX, FacingY))
        End If
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
        Print Game.Title; " ("; Game.Version; ")"
        Print
        Print "FPS:" + Str$(OGLFPS) + " / TPS:" + Str$(FRAMEPS) + " / Tick:" + Str$(CurrentTick)
        Print "Window:"; CameraPositionX; ","; CameraPositionY
        Print "Current World: "; WorldName; " (" + SavedMap + ")"
        Print "World Seed:"; WorldSeed
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
                Print "GlobalPOS"; "("; Int((Player.x + 8) / 16) + 1 + (SavedMapX * 40); ","; Int((Player.y + 8) / 16) + 1 + (SavedMapY * 30); ")"
                Print "Velocity:"; Player.vx; Player.vy
                Print "Facing:"; Player.facing
                Print "Motion:"; Player.movingx; Player.movingy
                Print Player.lastx; Player.lasty
            Case "inv", "inventory", "2"
                Print "Inventory Slot 1 Data"
                Select Case Inventory(0, 0, 0)
                    Case 0
                        Print "Tile: "; Trim$((ItemName(Inventory(0, 0, 9), 0))); " | SS:"; Str$(Inventory(0, 0, 1)); ","; Trim$(Str$(Inventory(0, 0, 2))); " | TileID:"; Str$(Inventory(0, 0, 3)); " | Layer:"; Str$(Inventory(0, 0, 4)); " | "; Trim$(Str$(Inventory(0, 0, 5))) + Str$(Inventory(0, 0, 6)); " | Stack:"; Str$(Inventory(0, 0, 7)); "/"; Trim$(Str$(Inventory(0, 0, 8))); " | ID:"; Str$(Inventory(0, 0, 9)); ""
                    Case 1
                        Print "Tool: "; Trim$(ItemName(Inventory(0, 0, 9), 0)); " | SS:"; Str$(Inventory(0, 0, 1)); ","; Trim$(Str$(Inventory(0, 0, 2))); " | Durabillity:"; Str$(Inventory(0, 0, 3)); "/"; Trim$(Str$(Inventory(0, 0, 4))); " | Type:"; Str$(Inventory(0, 0, 5)); " | Strength:"; Str$(Inventory(0, 0, 6)); " | Stack:"; Str$(Inventory(0, 0, 7)); "/"; Trim$(Str$(Inventory(0, 0, 8))); " | ID:"; Str$(Inventory(0, 0, 9)); ""
                    Case 2
                        Print "Sword: "; Trim$(ItemName(Inventory(0, 0, 9), 0)); " | SS:"; Str$(Inventory(0, 0, 1)); ","; Trim$(Str$(Inventory(0, 0, 2))); " | Durabillity:"; Str$(Inventory(0, 0, 3)); "/"; Trim$(Str$(Inventory(0, 0, 4))); " | Delay:"; Str$(Inventory(0, 0, 5)); " | Damage:"; Str$(Inventory(0, 0, 6)); " | Stack:"; Str$(Inventory(0, 0, 7)); "/"; Trim$(Str$(Inventory(0, 0, 8))); " | ID:"; Str$(Inventory(0, 0, 9)); " | Range"; Str$(Inventory(0, 0, 10)); " | Speed:"; Str$(Inventory(0, 0, 11));
                    Case 3
                        Print "Crafting Ingredient: "; Trim$(ItemName(Inventory(0, 0, 9), 0)); " | SS:"; Str$(Inventory(0, 0, 1)); ","; Trim$(Str$(Inventory(0, 0, 2))); " |"; Str$(Inventory(0, 0, 3)) + Str$(Inventory(0, 0, 4)) + Str$(Inventory(0, 0, 5)) + Str$(Inventory(0, 0, 6)); " | Stack:"; Str$(Inventory(0, 0, 7)); "/"; Trim$(Str$(Inventory(0, 0, 8))); " | ID:"; Str$(Inventory(0, 0, 9)); ""
                    Case Else
                        Print "Unknown: "; Trim$(ItemName(Inventory(0, 0, 9), 0)); " | SS:"; Str$(Inventory(0, 0, 1)); ","; Trim$(Str$(Inventory(0, 0, 2))); " |"; Str$(Inventory(0, 0, 3)) + Str$(Inventory(0, 0, 4)) + Trim$(Str$(Inventory(0, 0, 5))) + Str$(Inventory(0, 0, 6)); " | Stack:"; Str$(Inventory(0, 0, 7)); "/"; Trim$(Str$(Inventory(0, 0, 8))); " | ID:"; Str$(Inventory(0, 0, 9)); ""
                End Select
                'For i = 0 To InvParameters
                '    Print Inventory(0, 0, i);
                'Next
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
                Case "fillwalltile", "fillwt", "fwt"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "WallTile ID: ", fillid
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "X ñ from pos: ", fillx
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Y ñ from pos: ", filly

                    For i = 0 To fillx Step Sgn(fillx)
                        For ii = 0 To filly Step Sgn(filly)
                            WallTile(Int((Player.x + 8) / 16) + 1 + i, Int((Player.y + 8) / 16) + 1 + ii) = fillid
                        Next
                    Next

                Case "fillgroundtile", "fillgt", "fgt"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "GroundTile ID: ", fillid
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "X ñ from pos: ", fillx
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Y ñ from pos: ", filly

                    For i = 0 To fillx Step Sgn(fillx)
                        For ii = 0 To filly Step Sgn(filly)
                            GroundTile(Int((Player.x + 8) / 16) + 1 + i, Int((Player.y + 8) / 16) + 1 + ii) = fillid
                        Next
                    Next
                Case "fillceilingtile", "fillct", "fct"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "WallTile ID: ", fillid
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "X ñ from pos: ", fillx
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Y ñ from pos: ", filly

                    For i = 0 To fillx Step Sgn(fillx)
                        For ii = 0 To filly Step Sgn(filly)
                            CeilingTile(Int((Player.x + 8) / 16) + 1 + i, Int((Player.y + 8) / 16) + 1 + ii) = fillid
                        Next
                    Next

                Case "tiledata", "td"
                    Locate 28, 1: Print "                 "
                    Locate 28, 1: Input "Select Data Bit: ", databit
                    Locate 28, 1: Print "                   "
                    Locate 28, 1: Input "Select Data Value: ", TileData(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1, databit)


                Case "bgdraw"
                    bgdraw = bgdraw + 1
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





Sub INITIALIZE

    If DirExists("Assets") Then
        If DirExists("Assets\Sprites") = 0 Then Error 100
        If DirExists("Assets\Sprites\Entities") = 0 Then Error 100
        If DirExists("Assets\Sprites\Items") = 0 Then Error 100
        If DirExists("Assets\Sprites\Other") = 0 Then Error 100
        If DirExists("Assets\Sprites\Tiles") = 0 Then Error 100
        If DirExists("Assets\Music") = 0 Then Error 100
        If DirExists("Assets\Sounds") = 0 Then Error 100
        If DirExists("Assets\Worlds") = 0 Then MkDir "Assets\Worlds"
        If DirExists("Assets\SaveData") = 0 Then MkDir "Assets\SaveData": new = 1
    Else Error 100
    End If



    If new = 1 Then SAVESETTINGS
    LOADSETTINGS

    OSPROBE

    SwitchRender (DefaultRenderMode)
    RenderMode = DefaultRenderMode


End Sub

Sub SwitchRender (mode As Byte)
    Static FirstSkip As Byte
    If mode <> 0 And mode <> 1 Then Exit Sub

    If FirstSkip = 1 Then 'this is to prevent the game from crashing if the files arent loaded yet, because this is also run to initially load the files
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




Sub NewWorld '(worldname as string, worldseed as integer64)
    Dim i, ii, iii
    Cls
    KeyClear
    AutoDisplay

    Input "World Name?", WorldName
    Input "World Seed? (0 for random)", WorldSeed

    If WorldSeed = 0 Then
        Randomize Timer
        WorldSeed = Ceil(Rnd * 18446744073709551615) - 9223372036854775807
    End If

    SavedMapX = -1
    SavedMapY = 0
    Player.x = 320
    Player.y = 200

    SAVEMAP 'necessary for at least 1 map to be saved before running generate map, because savemap is also responsible for creating the file structure for the world
    GenerateMap 'generates -1,0 so that its not just saving a completely empty map
    SAVEMAP 'saves that generated map

    Do 'generates the map that the player will actually spawn in, also checks to see if the player CAN even spawn in this map and is not in some ocean, if not it will try the next map over, the reason map -1,0 is generated first is so that this loop is cleaner
        SavedMapX = SavedMapX + 1
        GenerateMap
    Loop Until GroundTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1) <> 13

    SAVEMAP 'saves only the map that the player will spawn on, why waste write cycles
    LOADWORLD
End Sub

Sub GenerateMap
    Dim i, ii, iii
    Dim PerlinTile As Double


    'if map is layer 0
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
            PerlinTile = Perlin((ii + (SavedMapX * 40)) / 100, (i + (SavedMapY * 30)) / 100, 0, WorldSeed)
            Select Case PerlinTile
                Case Is < 0.35
                    GroundTile(ii, i) = 13
            End Select
        Next
    Next
    Randomize Val(Str$(MapX) + Str$(MapY) + Str$(WorldSeed)) 'TODO, include world layer in this too
    For i = 0 To 31
        For ii = 0 To 41


            If GroundTile(ii, i) <> 13 Then

                'generate bushes
                If Ceil(Rnd * 10) = 5 Then
                    WallTile(ii, i) = 5
                End If

                'generate ground wood items
                If Ceil(Rnd * 100) = 50 Then
                    WallTile(ii, i) = 11
                    NewContainer SavedMapX, SavedMapY, ii, i
                    OpenContainer SavedMapX, SavedMapY, ii, i
                    For iii = 0 To InvParameters
                        Container(0, iii) = ItemIndex(19, iii)
                    Next
                    Container(0, 7) = Ceil(Rnd * 3)
                    CloseContainer SavedMapX, SavedMapY, ii, i
                End If

                'generate berry bushes
                If Ceil(Rnd * 500) = 250 Then
                    WallTile(ii, i) = 12
                End If
            End If

            'update set tiles
            UpdateTile ii, i
        Next
    Next
End Sub

Sub NewContainer (MapX, Mapy, Tilex, Tiley)
    Dim total As Integer
    Dim i, ii, empty
    Dim containertype
    containertype = WallTile(Tilex, Tiley)
    empty = -1
    total = 1
    If DirExists("Assets\Worlds\" + WorldName + "\Containers") = 0 Then MkDir "Assets\Worlds\" + WorldName + "\Containers"
    Open "Assets\Worlds\" + WorldName + "\Containers\" + Str$(MapX) + Str$(Mapy) + Str$(Tilex) + Str$(Tiley) + ".cdf" As #1
    Put #1, total, ContainerData(containertype, 0): total = total + 1
    Put #1, total, ContainerData(containertype, 1): total = total + 1
    For i = 0 To ContainerData(containertype, 0)
        For ii = 0 To InvParameters
            Put #1, total, empty: total = total + 1
        Next
    Next
    Close #1
End Sub

Sub OpenContainer (MapX, Mapy, Tilex, Tiley)
    Dim total As Integer
    Dim i, ii, empty
    Dim ContainerSize
    Dim ContainerBreak
    empty = -1
    total = 1
    Open "Assets\Worlds\" + WorldName + "\Containers\" + Str$(MapX) + Str$(Mapy) + Str$(Tilex) + Str$(Tiley) + ".cdf" As #1
    Get #1, total, Container(18, 0): total = total + 1
    Get #1, total, Container(19, 0): total = total + 1
    For i = 0 To ContainerSize
        For ii = 0 To InvParameters
            Get #1, total, Container(i, ii): total = total + 1
        Next
    Next
    Close #1
End Sub

Sub CloseContainer (MapX, Mapy, Tilex, Tiley)
    Dim total As Integer
    Dim i, ii, empty
    Dim ContainerSize
    Dim ContainerBreak
    empty = -1
    total = 1
    Open "Assets\Worlds\" + WorldName + "\Containers\" + Str$(MapX) + Str$(Mapy) + Str$(Tilex) + Str$(Tiley) + ".cdf" As #1
    Put #1, total, Container(18, 0): total = total + 1
    Put #1, total, Container(19, 0): total = total + 1
    For i = 0 To ContainerSize
        For ii = 0 To InvParameters
            Put #1, total, Container(i, ii): total = total + 1
        Next
    Next
    Close #1

End Sub



'$include: 'Assets\Sources\InventoryManagement.bm'
'$include: 'Assets\Sources\ShadowCast.bm'
'$include: 'Assets\Sources\DayNightCycle.bm'
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
'$include: 'Assets\Sources\PerlinNoise.bm'


