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

ERRORHANDLER: ErrorHandler
DisplayOrder GLRender , Hardware , Software
game:

Do
    SETBG
    SetMap
    CastShadow
    MOVE
    COLDET
    SPSET
    SetLighting
    INTER
    HUD
    ZOOM
    DEV
    ChangeMap
    DayLightCycle
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


Sub PickUpItem (ItemID)
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
                For iii = 0 To 9
                    Inventory(i, ii, iii) = ItemIndex(ItemID, iii)
                Next
                GoTo PickedUp
            End If
        Next
    Next
    Alert 0, "Could not pick up item, Inventory full."
    PickedUp:
End Sub
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
                                PickUpItem (TileIndex(GroundTile(FacingX, FacingY), 3))
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
                                PickUpItem (TileIndex(WallTile(FacingX, FacingY), 3))
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
    For i = 0 To 9
        Select Case Mode
            Case 0
                Swap CreativeInventory(ItemSelectY, ItemSelectX, i, CreativePage), Inventory(0, Slot, i)
            Case 1
                Swap Inventory(ItemSelectY + 1, ItemSelectX, i), Inventory(CreativePage + 1, Slot, i)
        End Select
    Next
End Sub


Sub ChangeMap
    Static TickDelay
    Static TotalDelay
    Static LightStep
    Dim i, ii
    If LightStep < 12 Then
        Select Case Player.facing
            Case 0
                If Player.y <= 0 And Player.x = Player.lastx And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 1
                If Player.y >= 480 - 16 And Player.x = Player.lastx And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 2
                If Player.x <= 0 And Player.y = Player.lasty And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate
            Case 3
                If Player.x >= 640 - 16 And Player.y = Player.lasty And Player.moving = 1 Then TickDelay = TickDelay + Settings.TickRate: TotalDelay = TotalDelay + Settings.TickRate


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
        For i = 0 To 31
            For ii = 0 To 41
                UpdateTile ii, i
            Next
        Next
        SpreadLight (1)

        LightStep = 0
    End If

    If Player.moving = 0 Then TickDelay = 0: TotalDelay = 0: LightStep = 0
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

End Sub
'For i = TileData(TileX, TileY, 8) To 0 Step -1

'Next

Sub Alert (img, message As String)
    Static timeout
    timeout = timeout + Settings.TickRate
    Locate 20, 1
    ENDPRINT message
    If timeout < 60 * 5 Then Alert img, message Else timeout = 0
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
            If Inventory(i, ii, 9) = -1 Then
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
        Dim i, ii
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
            If TileIndexData(WallTile(FacingX, FacingY), 7) = 1 Then
                OpenContainer SavedMapX, SavedMapY, FacingX, FacingY
                hbpos = 0
                invrow = 0
                For i = 0 To Container(18, 0)
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (0, 32)-(31, 63)
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, (CameraPositionY + 68 - 16 - hboffset + hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, (CameraPositionY + 68 - hboffset - hbitemsize) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.ItemSheet, , (Container(i, 1), Container(i, 2))-(Container(i, 1) + 15, Container(i, 2) + 15)
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

                    hbpos = hbpos + 1
                    If hbpos > 5 Then invrow = invrow + 1: hbpos = 0
                Next
            End If
            For invrow = 0 To 2
                For hbpos = 0 To 5

                    'place background squares
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (0, 32)-(31, 63)

                    'place cursor
                    Select Case CursorMode
                        Case 0
                            If invrow = ItemSelectY And hbpos = ItemSelectX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32, 32)-(63, 63)
                        Case 1
                            If invrow = ItemSelectedY And hbpos = ItemSelectedX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32, 32)-(63, 63)
                            If invrow = ItemSelectY And hbpos = ItemSelectX Then PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), (CameraPositionY + 68 - 16 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), (CameraPositionY + 68 - hboffset) - (16 * (invrow + 1) + invoffset * invrow) - invheight), Texture.HudSprites, , (32 + 32, 32)-(63 + 32, 63)
                    End Select

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
                            Exit Select
                        Case 1
                            CursorMode = 0
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
        If Player.x >= 0 And Player.x <= 640 - 16 And Player.y >= 0 And Player.y <= 480 - 16 Then

            For i = 0 To 9
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
        Print Game.Title; " ("; Game.Buildinfo; ")"
        Print
        If RenderMode = 0 Then Print "FPS:" + Str$(FRAMEPS) + " / Tick:" + Str$(CurrentTick)
        If RenderMode > 0 Then Print "FPS:" + Str$(OGLFPS) + " / TPS:" + Str$(FRAMEPS) + " / Tick:" + Str$(CurrentTick)
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
                ' Print "Contacted Tile ID:"; Player.tile; "(" + Hex$(Player.tile) + ")"
                ' Print "Facing Tile ID:"; Player.tilefacing; "(" + Hex$(Player.tilefacing) + ")"
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
    SAVEMAP
    GenerateMap
    SAVEMAP
    LOADWORLD
End Sub

Sub GenerateMap
    Dim i, ii, iii
    For i = 0 To 31
        For ii = 0 To 41
            GroundTile(ii, i) = 2
            TileData(ii, i, 4) = 255
            WallTile(ii, i) = 1
            TileData(ii, i, 5) = 255
            CeilingTile(ii, i) = 1
            TileData(ii, i, 6) = 255
            If Ceil(Rnd * 10) = 5 Then WallTile(ii, i) = 5
            If Ceil(Rnd * 100) = 50 Then
                WallTile(ii, i) = 11
                NewContainer SavedMapX, SavedMapY, ii, i
                OpenContainer SavedMapX, SavedMapY, ii, i
                For iii = 0 To 9
                    Container(0, iii) = ItemIndex(19, iii)
                Next
                Container(0, 7) = Ceil(Rnd * 3)


            End If
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
        For ii = 0 To 9
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
        For ii = 0 To 9
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
        For ii = 0 To 9
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



