$NoPrefix
Option Explicit
On Error GoTo ERRORHANDLER
Randomize Timer
Screen NewImage(641, 481, 32) '40x30
PrintMode KeepBackground
Title "CDF-Quest"


'$include: 'Assets\Sources\VariableDeclaration.bi'

'$include: 'Assets\Sources\DefaultValues.bi'

'$include: 'Assets\Sources\TileIndex.bi'

'$include: 'Assets\Sources\InventoryIndex.bi'


INITIALIZE


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
    HUD
    DEV
    KeyPressed = KeyHit
    If Flag.FrameRateLock = 0 Then Limit Settings.FrameRate
    CurrentTick = CurrentTick + Settings.TickRate
    If Flag.ScreenRefreshSkip = 0 Then Display
    Flag.ScreenRefreshSkip = 0
    Cls
Loop



Error 102



Sub SETTHEME
    Select Case map.theme
        Case 0
            theme = Texture.GrassTiles
        Case 1
            theme = Texture.SnowTiles
    End Select
End Sub


Sub HUD
    If Flag.HudDisplay = 0 Then
        Dim tmpheal As Byte
        Dim token As Byte
        Dim hboffset As Byte
        Dim hbpos As Byte
        Dim hbitemsize As Single

        hboffset = 1
        token = 1
        hbitemsize = 2

        tmpheal = Player.health

        While tmpheal > 0

            If tmpheal <= 8 Then
                PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), Texture.HudSprites, , ((tmpheal - 1) * 32, 0)-((tmpheal - 1) * 32 + 31, 31)
            Else
                PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), Texture.HudSprites, , (7 * 32, 0)-(7 * 32 + 31, 31)
            End If
            tmpheal = tmpheal - 8
            token = token + 1
        Wend

        'Hotbar
        For hbpos = 0 To 5
            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), CameraPositionY + 68 - 16 - hboffset)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), CameraPositionY + 68 - hboffset), Texture.HudSprites, , (0, 32)-(31, 63)
        Next

        Select Case GameMode
            Case 1
                For hbpos = 0 To 5
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, CameraPositionY + 68 - 16 - hboffset + hbitemsize)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, CameraPositionY + 68 - hboffset - hbitemsize), theme, , (Inventory(1, hbpos + 1) * 16, hbpos * 16)-(Inventory(1, hbpos + 1) * 16 + 15, hbpos * 16 + 15)
                Next



                If KeyDown(49) Then GroundTile(Int((Player.x + 8) \ 16) + 1, Int((Player.y + 8) \ 16) + 1) = Inventory(1, 1)

                If KeyDown(50) Then GroundTile(Int((Player.x + 8) \ 16) + 1, Int((Player.y + 8) \ 16) + 1) = Inventory(1, 2) + 16

                If KeyDown(51) Then GroundTile(Int((Player.x + 8) \ 16) + 1, Int((Player.y + 8) \ 16) + 1) = Inventory(1, 3) + 32

                If KeyDown(52) Then GroundTile(Int((Player.x + 8) \ 16) + 1, Int((Player.y + 8) \ 16) + 1) = Inventory(1, 4) + 48

                If KeyDown(53) Then GroundTile(Int((Player.x + 8) \ 16) + 1, Int((Player.y + 8) \ 16) + 1) = Inventory(1, 5) + 64

                If KeyDown(54) Then GroundTile(Int((Player.x + 8) \ 16) + 1, Int((Player.y + 8) \ 16) + 1) = Inventory(1, 6) + 80

                Select Case KeyPressed
                    Case 33
                        Inventory(1, 1) = Inventory(1, 1) + 1
                        If Inventory(1, 1) > 4 Then Inventory(1, 1) = 0
                    Case 64
                        Inventory(1, 2) = Inventory(1, 2) + 1
                        If Inventory(1, 2) > 4 Then Inventory(1, 2) = 0
                    Case 35
                        Inventory(1, 3) = Inventory(1, 3) + 1
                        If Inventory(1, 3) > 3 Then Inventory(1, 3) = 0
                    Case 36
                        Inventory(1, 4) = Inventory(1, 4) + 1
                        If Inventory(1, 4) > 9 Then Inventory(1, 4) = 0
                    Case 37
                        Inventory(1, 5) = Inventory(1, 5) + 1
                        If Inventory(1, 5) > 4 Then Inventory(1, 5) = 0
                    Case 94
                        Inventory(1, 6) = Inventory(1, 6) + 1
                        If Inventory(1, 6) > 1 Then Inventory(1, 6) = 0

                End Select

        End Select

    End If

End Sub




Sub DEV
    If Flag.DebugMode = 1 Then
        PrintMode FillBackground
        Dim comin As String
        Dim dv As Single
        Dim dummystring As String
        Dim databit As Byte



        Locate 1, 1
        ENDPRINT "Debug Menu (Press F3 to Close)"
        Print
        ENDPRINT "Version: " + Game.Version
        ENDPRINT "Version Designation: " + Game.Designation
        ENDPRINT "Operating System: " + Game.HostOS
        If Game.32Bit = 1 Then ENDPRINT "32-Bit Compatability Mode"
        Print
        ENDPRINT "Flags:"
        If Flag.StillCam = 1 Then ENDPRINT "Still Camera Enabled"
        If Flag.FreeCam = 1 Then ENDPRINT "Free Camera Enabled"
        If Flag.FullCam = 1 Then ENDPRINT "Full Camera Enabled"
        If Flag.NoClip = 1 Then ENDPRINT "No Clip Enabled"
        If bgdraw = 1 Then ENDPRINT "Background Drawing Disabled"


        Locate 1, 1
        Print Game.Title; " ("; Game.Buildinfo; ")"
        Print
        Print "FPS:" + Str$(FRAMEPS) + " /" + Str$(CurrentTick)
        Print "Window:"; CameraPositionX; ","; CameraPositionY
        Print "Current World: "; WorldName; " (" + SavedMap + ")"
        Print "Gamemode: ";
        Select Case GameMode
            Case 0
                Print "Debug Mode"
            Case 1
                Print "Map Editor"
            Case 2
                Print "Explorer"
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
            Case Else
                Print "Unrecognized Tile or Entity"
        End Select

        If KeyDown(47) Then
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
                    Locate 28, 1: Print "                              "
                    Locate 28, 1: Input "Simulate error number: ", dv
                    Error dv
                Case "gamemode", "gm"
                    Locate 28, 1: Print "                         "
                    Locate 28, 1: Input "Change Gamemode to: ", GameMode
                Case "health"
                    Locate 28, 1: Print "                      "
                    Locate 28, 1: Input "Set Health to: ", Player.health
                Case "track", "tr"
                    Locate 28, 1: Print "                               "
                    Locate 28, 1: Input "Track Entity ID or Tile ID: ", Debug.Tracking
                Case "framerate-unlock", "fru"
                    Flag.FrameRateLock = Flag.FrameRateLock + 1
                Case "save"
                    SAVEMAP (0)
                Case "save1"
                    SAVEMAP (1)
                Case "load"
                    Locate 28, 1: Print "                                "
                    Locate 28, 1: Input "Name of Map File to load: ", map.filename
                    LOADMAP (map.filename)
                Case "loadworld"
                    Locate 28, 1: Print "                                "
                    Locate 28, 1: Input "Name of World Folder to load: ", WorldName
                    LOADWORLD

                Case "theme"
                    Locate 28, 1: Print "                "
                    Locate 28, 1: Input "Set Theme ID: ", map.theme
                    SETTHEME
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
                Case "update", "up"
                    UPDATEMAP

                Case "new"
                    NewWorld


                Case Else
            End Select
            Flag.ScreenRefreshSkip = 1

        End If
        PrintMode KeepBackground
    End If
End Sub


Sub SetMap
    Dim i As Byte
    Dim ii As Byte
    Dim tileposx As Integer
    Dim tileposy As Integer
    For i = 1 To 30
        For ii = 1 To 40
            tileposx = GroundTile(ii, i) * 16
            tileposy = 0
            While tileposx >= 256
                tileposx = tileposx - 256
                tileposy = tileposy + 16
            Wend
            PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), theme, , (tileposx, tileposy)-(tileposx + 15, tileposy + 15)


            tileposx = WallTile(ii, i) * 16
            tileposy = 0
            While tileposx >= 256
                tileposx = tileposx - 256
                tileposy = tileposy + 16
            Wend
            PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), theme, , (tileposx, tileposy)-(tileposx + 15, tileposy + 15)


            tileposx = CeilingTile(ii, i) * 16
            tileposy = 0
            While tileposx >= 256
                tileposx = tileposx - 256
                tileposy = tileposy + 16
            Wend
            PutImage ((ii - 1) * 16, (i - 1) * 16)-(((ii - 1) * 16) + 15.75, ((i - 1) * 16) + 15.75), theme, , (tileposx, tileposy)-(tileposx + 15, tileposy + 15)


        Next
    Next
End Sub

Sub CastShadow
    Dim i, ii As Byte
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


        Next
    Next
End Sub


Sub INTER
    Select Case KeyPressed
        Case -15616
            Flag.DebugMode = Flag.DebugMode + 1
        Case -15104
            Flag.HudDisplay = Flag.HudDisplay + 1
    End Select
End Sub


Sub INITIALIZE

    If DirExists("Assets") Then
        If DirExists("Assets\Tiles") = 0 Then Error 100
        If DirExists("Assets\Music") = 0 Then Error 100
        If DirExists("Assets\Sounds") = 0 Then Error 100
        If DirExists("Assets\Worlds") = 0 Then Error 100
        If DirExists("Assets\SaveData") = 0 Then MkDir "Assets\SaveData": new = 1
    Else Error 100
    End If



    If new = 1 Then SAVESETTINGS
    LOADSETTINGS

    OSPROBE

    Texture.PlayerSprites = LoadImage(File.PlayerSprites)
    Texture.GrassTiles = LoadImage(File.GrassTiles)
    Texture.SnowTiles = LoadImage(File.SnowTiles)
    Texture.InteriorTiles = LoadImage(File.InteriorTiles)
    Texture.HudSprites = LoadImage(File.HudSprites)
    Texture.Shadows = LoadImage(File.Shadows)




    WorldName = "Hub"
    LOADWORLD
    SETTHEME

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
                PutImage (ii * 16, i * 16)-((ii * 16) + 15.75, (i * 16) + 15.75), theme, , (16, 0)-(31, 15)
            Next
        Next
    End If
End Sub







Sub NewWorld

    Cls
    KeyClear
    AutoDisplay
    Input "World Name?", WorldName
    SavedMapX = 0
    SavedMapY = 0
    Player.x = 320
    Player.y = 200
    SAVEMAP (0)
    LOADWORLD

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



