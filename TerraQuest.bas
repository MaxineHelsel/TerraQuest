$NoPrefix
Option Explicit
'On Error GoTo ERRORHANDLE
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

Rem'$include: 'Assets\Sources\CraftingIndex.bi'

Const MaxCraftLevel = 5
Dim Shared CursorHoverX, CursorHoverY, CursorHoverPage, CursorSelectedX, CursorSelectedY, CursorSelectedPage, CursorMode

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
SwitchRender 0 'these 2 statements are important to prevent a dumb bug
SwitchRender 1
Do

    OnTopEffect
    Effects 0, ""
    SetBG
    SetMap
    CastShadow
    Move
    COLDET
    SPSET
    SetLighting
    INTER
    If KeyDown(15360) = 0 Then Hud2
    If KeyDown(15360) Then HUD


    ZOOM
    DEV
    ChangeMap 0, 0, 0
    DayLightCycle
    MinMemFix

    If Player.health <= 0 Then Respawn

    If WithinBounds = 1 Then
        If TileIndexData(WallTile(FacingX, FacingY), 8) > 0 Then Player.CraftingLevel = TileIndexData(WallTile(FacingX, FacingY), 8) Else Player.CraftingLevel = 2
    End If

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

Sub Respawn
    SAVEMAP
    Player.x = SpawnPointX
    Player.y = SpawnPointY
    SavedMapX = SpawnMapX
    SavedMapY = SpawnMapY
    LOADMAP SavedMap
    Player.health = 8
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
            UseItem 0
            iii = 0
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item2 Then
            UseItem 1
            iii = 1
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item3 Then
            UseItem 2
            iii = 2
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item4 Then
            UseItem 3
            iii = 3
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item5 Then
            UseItem 4
            iii = 4
            hbtimeout = CurrentTick + 10
            flashtimeout = 5
        End If
        If Item6 Then
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

    InventoryTextOffset = 83

    HealthTextX = ScreenRezX - 60
    HealthTextY = 0

    HotbarTextX = 5
    HotbarTextY = ScreenRezY - 61
    HotbarTextSpace = 68

    HotbarTitlex = 6
    HotbarTitley = ScreenRezY - 85

    InventoryTitleX = 6
    InventoryTitleY = ScreenRezY - 305

    CraftingTextX = ScreenRezX - 66
    CraftingTextY = ScreenRezY + 23


    Color RGB(0, 0, 0)
    For i = 0 To 2
        For ii = 0 To 2

            PrintString (HealthTextX + (i - 1), HealthTextY + (ii - 1)), "Health:"
            PrintString (HotbarTitlex + (i - 1), HotbarTitley + (ii - 1)), "Hotbar:"
            If Flag.InventoryOpen = 1 Then
                PrintString (InventoryTitleX + (i - 1), InventoryTitleY + (ii - 1)), "Inventory:"
                'PrintString (Craftingtitlex + (i - 1), CraftingTitleY + (ii - 1)), "Crafting:"
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
            iiii = 0
            iii = Player.CraftingLevel
            If Flag.InventoryOpen = 1 And CraftingGrid(iiii, iii, 7) > 1 Then PrintString ((0 + CraftingTextX) - (HotbarTextSpace * iii) + i - 1, (CraftingTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset + ii - 1), Str$(CraftingGrid(iiii, iii, 7))
        Next
    Next

    Color RGB(255, 255, 255)

    PrintString (HealthTextX, HealthTextY), "Health:"
    PrintString (HotbarTitlex, HotbarTitley), "Hotbar:"
    If Flag.InventoryOpen = 1 Then PrintString (InventoryTitleX, InventoryTitleY), "Inventory:"
    'PrintString (Craftingtitlex + (i - 1), CraftingTitleY + (ii - 1)), "Crafting:"
    For iii = 0 To 5

        If Inventory(0, iii, 7) > 1 Then PrintString ((HotbarTextX) + (HotbarTextSpace * iii), HotbarTextY), Str$(Inventory(0, iii, 7))
        For iiii = 0 To 2
            If Flag.InventoryOpen = 1 And Inventory(iiii + 1, iii, 7) > 1 And GameMode <> 1 Then PrintString ((HotbarTextX) + (HotbarTextSpace * iii), (HotbarTextY) - (HotbarTextSpace * iiii + 1) - InventoryTextOffset), Str$(Inventory(iiii + 1, iii, 7))
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
End Sub

Sub DisplayHealth
    Dim As Byte i, ii, iii
    Dim As Byte Token, TMPHeal
    Dim As Single HealthX, HealthY
    Token = 1
    HealthX = (ScreenRezX / 4 / 2) + 8
    HealthY = (ScreenRezY / 4 / 2) - 11

    TMPHeal = Player.health

    Select Case GameMode
        Case 1
            PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (4 * 32, 32)-(4 * 32 + 31, 63)
        Case 2
            For i = 0 To Player.MaxHealth
                PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (3 * 32, 32)-(3 * 32 + 31, 63)
                Token = Token + 1
            Next
            Token = 1
            While TMPHeal > 0
                If Token > Player.MaxHealth + 1 Then PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (5 * 32, 32)-(5 * 32 + 31, 63)
                If TMPHeal <= 8 Then
                    PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , ((TMPHeal - 1) * 32, 0)-((TMPHeal - 1) * 32 + 31, 31)
                Else
                    PutImage (CameraPositionX + HealthX - 16, CameraPositionY - HealthY + (Token - 1) * 16)-(CameraPositionX + HealthX, CameraPositionY - HealthY + 16 + (Token - 1) * 16), Texture.HudSprites, , (7 * 32, 0)-(7 * 32 + 31, 31)
                End If
                TMPHeal = TMPHeal - 8
                Token = Token + 1
            Wend
    End Select
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
            End Select
        Next
    Next

End Sub

Sub DisplayCrafting
    Dim i, ii, iii, iiii
    Dim As Single CraftingX, CraftingY, CraftingSpace, CraftingOffset, CraftingResultX, CraftingResultY
    Dim As Single ItemSizeOffset

    '5    Player.CraftingLevel = 4
    ItemSizeOffset = 2
    CraftingX = (ScreenRezX / 4 / 2) - 9
    CraftingY = (ScreenRezY / 4 / 2) - 9
    CraftingSpace = 17
    CraftingOffset = 1

    Crafting

    Select Case Player.CraftingLevel
        Case 0 TO 5
            For iii = 0 To Player.CraftingLevel - 1
                For iiii = 0 To Player.CraftingLevel - 1
                    PutImage (CameraPositionX + CraftingX - (CraftingSpace * iii), CameraPositionY + CraftingY - (CraftingSpace * iiii))-(CameraPositionX + CraftingX - (CraftingSpace * iii) + 16, CameraPositionY + CraftingY - (CraftingSpace * iiii) + 16), Texture.HudSprites, , (0, 32)-(31, 63)
                    PutImage (CameraPositionX + CraftingX - (CraftingSpace * iii) + ItemSizeOffset, CameraPositionY + CraftingY - (CraftingSpace * iiii) + ItemSizeOffset)-(CameraPositionX + CraftingX - (CraftingSpace * iii) + 16 - ItemSizeOffset, CameraPositionY + CraftingY - (CraftingSpace * iiii) + 16 - ItemSizeOffset), Texture.ItemSheet, , (CraftingGrid(iiii, iii, 1), CraftingGrid(iiii, iii, 2))-(CraftingGrid(iiii, iii, 1) + 15, CraftingGrid(iiii, iii, 2) + 15)

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
End Sub


Sub NewStack (ItemID, StackNumber)
    Dim i, ii, iii
    Select Case CursorHoverPage


        Case 0 And 1
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

        Case 2
        Case 3
            'no splitting in craftingUI
    End Select
    Complete:
End Sub

Sub ItemSwap
    Dim As Byte i, ii, iii, CraftComplete
    Dim SwapItem1(InvParameters), Swapitem2(InvParameters)

    'set the empty slots to -1
    For i = 0 To InvParameters
        SwapItem1(i) = -1
        Swapitem2(i) = -1
    Next


    'Put the source and destination in to dummy arrays to make it easier to work with
    For i = 0 To InvParameters
        Select Case CursorSelectedPage
            Case 0
                Swapitem2(i) = Inventory(CursorSelectedY + 1, CursorSelectedX, i)
            Case 1
                Swapitem2(i) = Inventory(0, CursorSelectedX, i)
            Case 3
                Swapitem2(i) = CraftingGrid(CursorSelectedY, CursorSelectedX, i)

        End Select

        Select Case CursorHoverPage
            Case 0
                SwapItem1(i) = Inventory(CursorHoverY + 1, CursorHoverX, i)
            Case 1
                SwapItem1(i) = Inventory(0, CursorHoverX, i)
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
            If SwapItem1(0) <> -1 Then Exit Sub Else CraftComplete = 1
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
                Inventory(CursorSelectedY + 1, CursorSelectedX, i) = Swapitem2(i)
            Case 1
                Inventory(0, CursorSelectedX, i) = Swapitem2(i)
            Case 3
                CraftingGrid(CursorSelectedY, CursorSelectedX, i) = Swapitem2(i)


        End Select

        Select Case CursorHoverPage
            Case 0
                Inventory(CursorHoverY + 1, CursorHoverX, i) = SwapItem1(i)
            Case 1
                Inventory(0, CursorHoverX, i) = SwapItem1(i)
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

    If InventorySplit Then
        Select Case CursorHoverPage
            Case 0
                If Inventory(CursorHoverY + 1, CursorHoverX, 7) > 1 Then
                    NewStack Inventory(CursorHoverY + 1, CursorHoverX, 9), Int(Inventory(CursorHoverY + 1, CursorHoverX, 7) / 2)
                    Inventory(CursorHoverY + 1, CursorHoverX, 7) = Ceil(Inventory(CursorHoverY + 1, CursorHoverX, 7) / 2)
                End If
        End Select
    End If

    If InventoryUp Then
        CursorHoverY = CursorHoverY + 1

    End If
    If InventoryDown Then
        CursorHoverY = CursorHoverY - 1

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
            If CursorHoverX > 5 Then CursorHoverX = 0
            If CursorHoverX < 0 Then CursorHoverX = 5
            If CursorHoverY > 2 Then CursorHoverY = 0
            If CursorHoverY < 0 Then CursorHoverY = 2
        Case 1 'Hotbar
            If CursorHoverX > 5 Then CursorHoverX = 0
            If CursorHoverX < 0 Then CursorHoverX = 5
            CursorHoverY = 0
        Case 2 'Container
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
        Dim As Byte i, ii, iii, iiii
        Static CreativePage
        'Print CursorHoverPage, CursorHoverX, CursorHoverY

        DisplayHealth
        DisplayHotbar
        If Flag.InventoryOpen = 1 Then
            DisplayInventory CreativePage
            DisplayCrafting
            DisplayContainer
            InputCursor
        End If
        UseHotBar
        DisplayLables

    End If
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

    Select Case recipe
        Case "-1 -1 -1 |-1 5 -1 |-1 -1 -1 |" 'bush to raw wood
            For i = 0 To InvParameters
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(19, i)
            Next
            CraftingGrid(0, Player.CraftingLevel, 7) = 4
        Case "19 19 |19 19 |" 'crafting station
            For i = 0 To InvParameters
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(21, i)
            Next
        Case "-1 -1 -1 |-1 5 -1 |19 19 19 |" 'Campfire
            For i = 0 To InvParameters
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(10, i)
            Next
        Case "19 19 19 |19 19 19 |19 19 19 |" 'Wood Wall
            For i = 0 To InvParameters
                CraftingGrid(0, Player.CraftingLevel, i) = ItemIndex(8, i)
            Next
            CraftingGrid(0, Player.CraftingLevel, 7) = 9

    End Select
    Print recipe
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

Function CraftSpace (level)
    Select Case level
        Case 0
            CraftSpace = 8.5
        Case 1
            CraftSpace = 0
    End Select
End Function

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
    5 ElseIf KeyDown(18432) = 0 Then SingleHit = 0
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




Sub SPSET
    Static anim As Byte
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

    anim = anim + Settings.TickRate
    If KeyDown(100306) = 0 Then anim = anim + Settings.TickRate
    If anim > 59 Then anim = 0
End Sub

Function WithinBounds
    If Player.x > 0 And Player.y > 0 And Player.x < 640 - 16 And Player.y < 480 - 16 Then WithinBounds = 1 Else WithinBounds = 0
End Function

Sub ContactEffect (Direction As Byte)
    If WithinBounds = 1 Then
        Select Case Direction
            Case 1
                Effects 1, "Contact " + TileName(WallTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8 - 16) / 16) + 1), 0)
                'Print "Contact " + TileName(WallTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8 - 16) / 16) + 1), 0)
            Case 2
                Effects 1, "Contact " + TileName(WallTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8 + 16) / 16) + 1), 0)
                'Print "Contact " + TileName(WallTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8 + 16) / 16) + 1), 0)
            Case 3
                Effects 1, "Contact " + TileName(WallTile(Int((Player.x + 8 - 16) / 16) + 1, Int((Player.y + 8) / 16) + 1), 0)
                'Print "Contact " + TileName(WallTile(Int((Player.x + 8 - 16) / 16) + 1, Int((Player.y + 8) / 16) + 1), 0)
            Case 4
                Effects 1, "Contact " + TileName(WallTile(Int((Player.x + 8 + 16) / 16) + 1, Int((Player.y + 8) / 16) + 1), 0)
                'Print "Contact " + TileName(WallTile(Int((Player.x + 8 + 16) / 16) + 1, Int((Player.y + 8) / 16) + 1), 0)
        End Select
    End If
End Sub

Sub OnTopEffect
    If WithinBounds = 1 Then
        Effects 1, "OnTop " + TileName(GroundTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1), 0)
    End If
End Sub


Sub EffectExecute (ID As Integer, Val1 As Single)
    Select Case ID
        Case 1 'Instant Damage
            If GameMode <> 1 Then Player.health = Player.health - Val1
            PlaySound Sounds.damage_bush
        Case 2
            SwimOffset = Val1
    End Select


End Sub

Function EffectIndex (Sources As String, Value As Single)
    Select Case Sources
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
        Case Else
            EffectIndex = 0
    End Select
End Function

Sub EffectEnd (EffectID As Integer, EffectSlot As Integer)
    Dim i As Byte
    Select Case EffectID
        Case 1
            For i = 0 To EffectParameters
                EffectArray(EffectSlot, i) = 0
            Next
        Case 2
            For i = 0 To EffectParameters
                EffectArray(EffectSlot, i) = 0
            Next
            SwimOffset = 0
    End Select
End Sub

Sub Effects (Command As Byte, Sources As String)
    Dim As Byte i, ii
    Dim Null As Byte
    Dim EffectSources(MaxEffects) As String

    Select Case Command
        Case 0 'count down and execute effect
            For i = 0 To MaxEffects
                If EffectArray(i, 1) > 0 Then EffectArray(i, 1) = EffectArray(i, 1) - Settings.TickRate
                If EffectArray(i, 2) > 0 Then EffectArray(i, 2) = EffectArray(i, 2) - Settings.TickRate
                If EffectArray(i, 1) > 0 Then
                    EffectExecute EffectArray(i, 0), EffectArray(i, 3)
                End If
                If EffectArray(i, 1) <= 0 And EffectArray(i, 2) <= 0 Then
                    EffectEnd EffectArray(i, 0), i
                End If
            Next
        Case 1 ' apply new effect
            For i = 0 To MaxEffects
                If EffectArray(i, 0) = 0 Then
                    For ii = 0 To EffectParameters
                        EffectArray(i, ii) = EffectIndex(Sources, ii)
                    Next
                    Exit Case
                End If
                If EffectArray(i, 0) = EffectIndex(Sources, 0) Then
                    If EffectArray(i, 2) <= 0 Then
                        For ii = 0 To EffectParameters
                            EffectArray(i, ii) = EffectIndex(Sources, ii)
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

    If Player.movingx = 1 Or Player.movingy = 1 Then SoundCooldown = SoundCooldown - 1

    If SoundCooldown <= 0 Then
        If WithinBounds = 1 Then
            If GroundTile(Int((Player.x + 8) / 16) + 1, Int((Player.y + 8) / 16) + 1) = 13 Then
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
        Print "Map Seed:"; Val(Str$(SavedMapX)) + Val(Str$(SavedMapY)) + Val(Str$(WorldSeed))
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
                Case "craft"
                    Dim testx, testy, testitem
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Teleport x: ", testx
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Teleport x: ", testy
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Teleport x: ", testitem

                    For i = 0 To InvParameters
                        CraftingGrid(testx, testy, i) = ItemIndex(testitem, i)
                    Next

                Case "res", "resolution"
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Resolution X: ", ScreenRezX
                    Locate 28, 1: Print "               "
                    Locate 28, 1: Input "Resolution Y: ", ScreenRezY
                    Screen NewImage(ScreenRezX + 1, ScreenRezY + 1, 32)



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
                Case "genmap"
                    GenerateMap
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
    Dim As Byte i, ii, iii
    ScreenRezX = DesktopWidth
    ScreenRezY = DesktopHeight
    Screen NewImage(ScreenRezX + 1, ScreenRezY + 1, 32)
    FullScreen SquarePixels

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

    OSPROBE

    SwitchRender (DefaultRenderMode)
    RenderMode = DefaultRenderMode


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
'$include: 'Assets\Sources\EffectFunctions.bm'
'$include: 'Assets\Sources\WorldGeneration.bm'
'$include: 'Assets\Sources\LegacyHUD.bm'
