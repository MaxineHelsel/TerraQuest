$NoPrefix
Option Explicit
On Error GoTo ERRORHANDLER
Randomize Timer
Screen NewImage(640, 480, 32) '40x30
PrintMode KeepBackground
Title "CDF-Quest"


'TODO
'Change all references of multiple repeating sets of the same thing for grass and ice to just 1 thing,
'and make the part where it asks for what tilesheet just have it as a variable and have it set when files are loaded or something

'$include: 'Assets\Sources\VariableDeclaration.bi'

'declare variable names and data types
Dim Shared File As File
Dim Shared Player As Character
Dim Shared Settings As Settings
Dim Shared Sounds As Sounds
Dim Shared Debug As Debug


'Map Variables
Dim Shared GroundTile(40, 30) As Unsigned Integer
Dim Shared WallTile(40, 30) As Unsigned Integer
Dim Shared CeilingTile(40, 30) As Unsigned Integer
Dim Shared TileData(40, 30, 8) As Unsigned Byte
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
Dim Shared map.protected As String
Dim Shared theme As Long
Dim Shared mapversion As String
Dim Shared prevfolder As String 'temp




Type File
    char_file As String
    grass_file As String
    snow_file As String
    interior_file As String
    hudtex_file As String
    char As Long
    grass As Long
    snow As Long
    interior As Long
    hudtex As Long
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
    framerate As Integer
    tickrate As Single
End Type



'$include: 'Assets\Sources\DefaultValues.bi'

'Note: any changes made to this file, and any other source files require a recompile of the game before they are recognized

'Default variables that are required to be set on initial load
Game.Title = "CDF-Quest"
Game.Buildinfo = "Core Mechanic Test"
Game.Version = "Alpha Version 13"

'Default settings values that are saved on first launch to settings.cdf, and on subsequent launches are loaded from that file
Settings.framerate = 60
Settings.tickrate = 1

'File name locations
File.char_file = "Assets\Tiles\character.png"
File.grass_file = "Assets\Tiles\grass2.png"
File.snow_file = "Assets\Tiles\snow.png"
File.interior_file = "Assets\Tiles\interior.png"
File.hudtex_file = "Assets\Tiles\HUD.png"

Sounds.error = "Assets\Sounds\error.wav"

'Debug values that are only set here for testing purposes
Player.health = 8
GameMode = 1
Flag.DebugMode = 1
Flag.NoClip = 1

INITIALIZE


GoTo game
Error 102
ERRORHANDLER: ERRORHANDLER
game:

Do
    SETBG
    SETMAP
    MOVE
    COLDET
    SPSET
    INTER
    ZOOM
    HUD
    DEV
    KeyPressed = KeyHit
    If Flag.FrameRateLock = 0 Then Limit Settings.framerate
    CurrentTick = CurrentTick + Settings.tickrate
    If Flag.ScreenRefreshSkip = 0 Then Display
    Flag.ScreenRefreshSkip = 0
    Cls
Loop



Error 102


Sub SAVESETTINGS

    Open "Assets\SaveData\Settings.cdf" As #1
    Put #1, 1, Settings.framerate
    Put #1, 2, Settings.tickrate
    Close #1

End Sub




Sub LOADSETTINGS

    Open "Assets\SaveData\Settings.cdf" As #1
    Get #1, 1, Settings.framerate
    Get #1, 2, Settings.tickrate
    Close #1

End Sub

Function SavedMap$
    SavedMap = Str$(SavedMapX) + Str$(SavedMapY)
End Function

Function SpawnMap$
    SpawnMap = Str$(SpawnMapX) + Str$(SpawnMapY)
End Function

Function CurrentMap$
    CurrentMap = Str$(MapX) + Str$(MapY)
End Function



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

Sub LOADWORLD
    Dim defaultmap As String

    prevfolder = map.foldername


    Open "Assets\Worlds\" + WorldName + "\Manifest.cdf" As #1



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
    MapX = SavedMapX
    MapY = SavedMapY

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
    Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-0.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            Get #1, iii, GroundTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-1.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            Get #1, iii, WallTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-2.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            Get #1, iii, CeilingTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + file + "-3.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            For iiii = 0 To 8
                Get #1, iii, TileData(ii, i, iiii)
                iii = iii + 1
            Next

        Next
    Next
    Get #1, iii, map.name
    iii = iii + 1
    Get #1, iii, map.theme
    SETTHEME
    Close #1
    iii = 1

    Open "Assets\Worlds\" + WorldName + "\Maps\GlobalData.cdf" As #1
    Close #1

End Sub


Sub SAVEMAP (headless)
    Dim i, ii, iiii As Byte
    Dim iii As Integer
    Dim defaultmap As String
    Dim temppw As String
    Dim new As Byte
    iii = 1
    If headless = 0 Then
        Cls
        AutoDisplay
        Input "Map Theme: ", map.theme
    End If

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



    Put #1, 3, Game.Version

    Put #1, 5, SpawnPointX
    Put #1, 6, SpawnPointY
    Put #1, 7, SavePointX
    Put #1, 8, SavePointY
    Put #1, 9, SavedMapX
    Put #1, 10, SavedMapY
    Put #1, 11, SpawnMapX
    Put #1, 12, SpawnMapY




    Close #1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-0.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            Put #1, iii, GroundTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1

    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-1.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            Put #1, iii, WallTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-2.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            Put #1, iii, CeilingTile(ii, i)
            iii = iii + 1
        Next
    Next
    Close #1
    iii = 1


    Open "Assets\Worlds\" + WorldName + "\Maps\" + SavedMap + "-3.cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            For iiii = 0 To 8
                Put #1, iii, TileData(ii, i, iiii)
                iii = iii + 1
            Next
        Next
    Next
    Put #1, iii, map.name
    iii = iii + 1
    Put #1, iii, map.theme
    Close #1
    iii = 1





    badpw:
End Sub

Sub UPDATEMAP
    Dim i, ii As Byte
    Dim iii As Integer
    iii = 1

    If DirExists("Assets\Worlds\" + map.foldername) = 0 GoTo badpw
    If DirExists("Assets\Worlds\" + map.foldername + "\Maps") = 0 GoTo badpw


    Open "Assets\Worlds\" + map.foldername + "\Maps\" + map.filename + ".cdf" As #1
    For i = 0 To 30
        For ii = 0 To 40
            '    PUT #1, iii, tile(ii, i)
            iii = iii + 1
        Next
    Next
    Put #1, iii, map.name
    iii = iii + 1
    Put #1, iii, map.theme
    Close #1
    badpw:

End Sub




Sub PLAYSOUND (nam$)
    _SndPlayFile nam$, , 1
End Sub


Sub SETTHEME
    Select Case map.theme
        Case 0
            theme = File.grass
        Case 1
            theme = File.snow
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
            Select Case tmpheal
                Case 1
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (64, 32)-(95, 63)
                Case 2
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (32, 32)-(63, 63)
                Case 3
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (0, 32)-(31, 63)
                Case 4
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (128, 0)-(159, 31)
                Case 5
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (96, 0)-(127, 31)
                Case 6
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (64, 0)-(95, 31)
                Case 7
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (32, 0)-(63, 31)
                Case 8 TO 255
                    PutImage (CameraPositionX + 88 - 16, CameraPositionY - 52 + (token - 1) * 16)-(CameraPositionX + 88, CameraPositionY - 52 + 16 + (token - 1) * 16), File.hudtex, , (0, 0)-(31, 31)

            End Select
            tmpheal = tmpheal - 8
            token = token + 1
        Wend

        'Hotbar
        For hbpos = 0 To 5
            PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos), CameraPositionY + 68 - 16 - hboffset)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos), CameraPositionY + 68 - hboffset), File.hudtex, , (0, 64)-(31, 95)
        Next

        Select Case GameMode
            Case 1
                For hbpos = 0 To 5
                    PutImage (CameraPositionX - 72 + hboffset + (17 * hbpos) + hbitemsize, CameraPositionY + 68 - 16 - hboffset + hbitemsize)-(CameraPositionX - 72 + 16 + hboffset + (17 * hbpos) - hbitemsize, CameraPositionY + 68 - hboffset - hbitemsize), theme, , (Inventory(1, hbpos + 1) * 16, hbpos * 16)-(Inventory(1, hbpos + 1) * 16 + 15, hbpos * 16 + 15)
                Next



                If KeyDown(49) Then GroundTile(Int((Player.x + 8) \ 16), Int((Player.y + 8) \ 16)) = Inventory(1, 1)

                If KeyDown(50) Then GroundTile(Int((Player.x + 8) \ 16), Int((Player.y + 8) \ 16)) = Inventory(1, 2) + 16

                If KeyDown(51) Then GroundTile(Int((Player.x + 8) \ 16), Int((Player.y + 8) \ 16)) = Inventory(1, 3) + 32

                If KeyDown(52) Then GroundTile(Int((Player.x + 8) \ 16), Int((Player.y + 8) \ 16)) = Inventory(1, 4) + 48

                If KeyDown(53) Then GroundTile(Int((Player.x + 8) \ 16), Int((Player.y + 8) \ 16)) = Inventory(1, 5) + 64

                If KeyDown(54) Then GroundTile(Int((Player.x + 8) \ 16), Int((Player.y + 8) \ 16)) = Inventory(1, 6) + 80

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



        Locate 1, 1
        ENDPRINT "Debug Menu (Press F3 to Close)"
        Print
        ENDPRINT "Version: " + Game.Version
        ENDPRINT "Operating System: " + Game.HostOS
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
        Print "Current Map: "; map.name; " ("; map.filename; "|"; map.foldername; ")"
        Print "World Name: "; map.worldname
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
                Print "POS:"; Player.x; ","; Player.y; "("; Int((Player.x + 8) / 16); ","; Int((Player.y + 8) / 16); ")"
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
                    '   CASE "set-tile", "st"
                    '        LOCATE 28, 1: PRINT "                "
                    '        LOCATE 28, 1: INPUT "Set Tile ID: ", tile(INT((player.x + 8) / 16), INT((player.y + 8) / 16))
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


Sub SETMAP
    Dim i As Byte
    Dim ii As Byte
    Dim tileposx As Integer
    Dim tileposy As Integer
    For i = 0 To 30

        For ii = 0 To 40

            tileposx = GroundTile(ii, i) * 16
            tileposy = 0
            While tileposx >= 256
                tileposx = tileposx - 256
                tileposy = tileposy + 16
            Wend
            PutImage (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), theme, , (tileposx, tileposy)-(tileposx + 15, tileposy + 15)
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

Sub COLDET
    '   Player.tile = GroundTile(Int((Player.x + 8) / 16), Int((Player.y + 8) / 16))
    '   Select Case Player.facing
    '       Case 0
    '           If Player.y - 8 <= 0 Then Exit Select
    '           Player.tilefacing = GroundTile(Int((Player.x + 8) / 16), Int((Player.y + 8 - 16) / 16))
    '       Case 1
    '           If Player.y + 8 + 16 >= 480 Then Exit Select
    '           Player.tilefacing = GroundTile(Int((Player.x + 8) / 16), Int((Player.y + 8 + 16) / 16))
    '       Case 2
    '           If Player.x - 8 <= 0 Then Exit Select
    '           Player.tilefacing = GroundTile(Int((Player.x + 8 - 16) / 16), Int((Player.y + 8) / 16))
    '       Case 3
    '           If Player.x + 8 + 16 >= 640 Then Exit Select
    '           Player.tilefacing = GroundTile(Int((Player.x + 8 + 16) / 16), Int((Player.y + 8) / 16))
    '   End Select



    If Flag.NoClip = 0 Then
        Select Case TileData(Int((Player.x + 1) / 16), Int((Player.y) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
                GoTo col2
        End Select

        Select Case TileData(Int((Player.x + 1) / 16), Int((Player.y + 14) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
        End Select

        Select Case TileData(Int((Player.x + 14) / 16), Int((Player.y + 1) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
                GoTo col2
        End Select

        Select Case TileData(Int((Player.x + 14) / 16), Int((Player.y + 14) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
        End Select

        col2:

        Select Case TileData(Int((Player.x + 1) / 16), Int((Player.y + 1) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
                Player.x = Player.lastx
        End Select

        Select Case TileData(Int((Player.x + 14) / 16), Int((Player.y + 1) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
                Player.x = Player.lastx
        End Select

        Select Case TileData(Int((Player.x + 1) / 16), Int((Player.y + 14) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
                Player.x = Player.lastx
        End Select

        Select Case TileData(Int((Player.x + 14) / 16), Int((Player.y + 14) / 16), 0)
            Case 1
                Swap Player.y, Player.lasty
                Player.x = Player.lastx
        End Select
    End If
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

    File.char = LoadImage(File.char_file)
    File.grass = LoadImage(File.grass_file)
    File.snow = LoadImage(File.snow_file)
    File.interior = LoadImage(File.interior_file)
    File.hudtex = LoadImage(File.hudtex_file)




    WorldName = "Hub"
    LOADWORLD
    SETTHEME

End Sub
Sub CENTERPRINT (nam$)
    _PrintMode _KeepBackground
    Dim i As _Byte
    For i = 0 To Int(40 - (Len(nam$) / 2) - 1)
        Print " ";
    Next
    _PrintMode _FillBackground
    Print nam$
End Sub

Sub ENDPRINT (nam$)
    _PrintMode _KeepBackground
    Dim i As _Byte
    For i = 0 To Int(80 - (Len(nam$))) - 1
        Print " ";
    Next
    _PrintMode _FillBackground
    Print nam$
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
                    Open "Assets\Worlds\" + prevfolder + "\Manifest.cdf" As #1
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


Sub OSPROBE
    Select Case _OS$
        Case "[WINDOWS][64BIT]"
            Game.HostOS = "Windows"
        Case "[LINUX][64BIT]"
            Game.HostOS = "Linux"
        Case "[MACOSX][64BIT][LINUX]"
            Game.HostOS = "Mac OS"
        Case Else
            Game.HostOS = "Unknown OS"
    End Select
End Sub


Sub SPSET
    Static anim As Byte
    Select Case Player.facing
        Case 0
            If Player.moving = 1 Then
                If anim < 15 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (0, 0)-(15, 17)
                If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 0)-(31, 17)
                If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (32, 0)-(47, 17)
                If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 0)-(31, 17)
            Else
                PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 0)-(31, 17)
            End If
        Case 1
            If Player.moving = 1 Then
                If anim < 15 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (0, 36)-(15, 54)
                If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 36)-(31, 53)
                If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (32, 36)-(47, 53)
                If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 36)-(31, 53)
            Else
                PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 36)-(31, 53)
            End If

        Case 2
            If Player.moving = 1 Then
                If anim < 15 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (0, 54)-(15, 71)
                If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 54)-(31, 71)
                If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (32, 54)-(47, 71)
                If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 54)-(31, 71)
            Else
                PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 54)-(31, 71)
            End If

        Case 3
            If Player.moving = 1 Then
                If anim < 15 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (0, 18)-(15, 35)
                If anim > 14 And anim < 30 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 18)-(31, 35)
                If anim > 29 And anim < 45 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (32, 18)-(47, 35)
                If anim > 44 And anim < 60 Then PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 18)-(31, 35)
            Else
                PutImage (Int(Player.x), Int(Player.y) - 2)-((Int(Player.x)) + 16, (Int(Player.y) - 2) + 16), File.char, , (16, 18)-(31, 35)
            End If
    End Select

    anim = anim + Settings.tickrate
    If KeyDown(100306) = 0 Then anim = anim + Settings.tickrate
    If anim > 59 Then anim = 0
End Sub



Sub MOVE
    Player.moving = 0
    Player.lastx = Player.x
    Player.lasty = Player.y
    If KeyDown(119) Then
        Player.y = Player.y - .5
        Player.facing = 0
        Player.moving = 1
        If KeyDown(100306) = 0 Then Player.y = Player.y - .5
    End If
    If KeyDown(115) Then
        Player.y = Player.y + .5
        Player.facing = 1
        Player.moving = 1
        If KeyDown(100306) = 0 Then Player.y = Player.y + .5
    End If
    If KeyDown(97) Then
        Player.x = Player.x - .5
        Player.facing = 2
        Player.moving = 1
        If KeyDown(100306) = 0 Then Player.x = Player.x - .5
    End If
    If KeyDown(100) Then
        Player.x = Player.x + .5
        Player.facing = 3
        Player.moving = 1
        If KeyDown(100306) = 0 Then Player.x = Player.x + .5
    End If
    If Player.x <= 0 Then Player.x = 0
    If Player.y <= 0 Then Player.y = 0
    If Player.x >= 640 - 16 Then Player.x = 640 - 16
    If Player.y >= 480 - 16 Then Player.y = 480 - 16
    If Flag.FreeCam = 1 Then
        Player.x = Player.lastx
        Player.y = Player.lasty
        If Player.moving = 1 Then
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
            Player.moving = 0
        End If
    End If
End Sub


Sub SETBG
    If bgdraw = 0 Then
        Dim i As Byte
        Dim ii As Byte
        For i = 0 To 30
            For ii = 0 To 40
                PutImage (ii * 16, i * 16)-((ii * 16) + 16, (i * 16) + 16), theme, , (0, 0)-(15, 15)
            Next
        Next
    End If
End Sub




Sub ZOOM
    If Flag.StillCam = 0 And Flag.FreeCam = 0 Then
        CameraPositionX = Player.x
        CameraPositionY = Player.y
    End If
    If CameraPositionX - 72 < 0 Then CameraPositionX = 72
    If CameraPositionY - 52 < 0 Then CameraPositionY = 52
    If CameraPositionX + 88 > 640 Then CameraPositionX = 552
    If CameraPositionY + 68 > 480 Then CameraPositionY = 412

    If Flag.FullCam = 0 Then Window Screen(CameraPositionX - 72, CameraPositionY - 52)-(CameraPositionX + 88, CameraPositionY + 68) Else Window
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



