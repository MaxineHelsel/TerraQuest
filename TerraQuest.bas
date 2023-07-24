$NoPrefix
ScreenHide
Option Explicit
'On Error GoTo ErrorHandle
Const GameName = "TerraQuest"
Const VerName = "Beta 1.3 Networking Test 230717A"
Const VerNum = "B1.3-230717A"
Title GameName


'Lines Slated for Variable Declaration File
Dim Shared GameFlags As GameFlags
Dim Shared Net As Net
Dim Shared GamePars As GamePars
Dim Shared Text As Text
Dim Shared Client As Client

Type GamePars
    ResX As Single
    ResY As Single
    VerName As String
    VerNum As String
    GameName As String
    FullScreen As Byte
    HostOS As String
    Bit32 As Byte
End Type


Type Net
    IP As String
    Port As String
    Mode As Byte
    ClientHandle As Long
    HostHandle As Long
    WorldName As String
    MaxPlayers As Byte
    CurrentPlayers As Byte
    HostMode As Byte
End Type


Type GameFlags
    Headless As Byte
    OperationMode As Byte
    FirstRun As Byte
End Type

Type Client
    Username As String

End Type


Type Text
    NewInput As Byte
End Type

Const AbsMaxPlayers = 255

Dim Shared PlayerData(255, 10)
Dim Shared PlayerName(255) As String

'Lines Slated For Default Values

GamePars.VerName = VerName
GamePars.VerNum = VerNum
GamePars.GameName = GameName
Net.Port = "46290"
Net.MaxPlayers = 10


'$include: 'Assets\Sources\VariableDeclaration.bi'

'$include: 'Assets\Sources\DefaultValues.bi'

'$include: 'Assets\Sources\Headers\TileIndex.bi'

'$include: 'Assets\Sources\Headers\InventoryIndex.bi'

'$include: 'Assets\Sources\Headers\CreativeInventory.bi'

'$include: 'Assets\Sources\Headers\SplashText.bi'



ParseCLA
Initialize
If GameFlags.OperationMode = 0 Then TitleScreen
If GameFlags.OperationMode = 1 Then
    OpenServer Net.WorldName
End If

Error 102
ErrorHandle:
ErrorHandlerOld
Resume Next

Sub ClientGameLoop
    DisplayOrder GLRender , Hardware , Software
    KeyClear
    Do

    Loop
End Sub

Sub ServerGameLoop
    KeyClear
    Do
        If Net.CurrentPlayers = 0 Or Net.HostMode = 0 Then SearchForPlayers


    Loop
End Sub

Sub SearchForPlayers
    PlayerData(Net.CurrentPlayers, 0) = OpenConnection(Net.HostHandle)
    If PlayerData(Net.CurrentPlayers, 0) <> 0 Then
        Get PlayerData(Net.CurrentPlayers, 0), , PlayerName(Net.CurrentPlayers)
        'send chat log player has joined the game
        Print PlayerName(Net.CurrentPlayers) + " has joined the game"
        Net.CurrentPlayers = Net.CurrentPlayers + 1
    End If
End Sub



Sub OpenServer (WorldName As String)
    While Net.HostHandle = 0
        If Net.HostHandle = 0 Then Net.HostHandle = OpenHost("TCP/IP:" + Net.Port)
    Wend
    LoadWorld WorldName
    ServerGameLoop
End Sub

Sub LoadWorld (WorldName As String)

End Sub

Sub CreateWorld (WorldName As String)

End Sub

Sub JoinServer (IP As String, Port As String)
    Dim TimeOut
    While Net.ClientHandle = 0
        Net.ClientHandle = OpenClient("TCP/IP:" + Port + ":" + IP)
        TimeOut = TimeOut + 1
        Print TimeOut
        'if timeout > 600 error time out
    Wend
    Put Net.ClientHandle, , Client.Username
    ClientGameLoop
End Sub

Sub StartLocalServer (Worldname As String)
    Select Case GamePars.HostOS

        Case "Linux"
            '    Shell DontWait "./TerraQuest server " + Worldname + " 1"
    End Select
End Sub

Sub StartSinglePlayer (WorldName As String)
    StartLocalServer WorldName
    JoinServer "localhost", "46290"
End Sub


Sub TitleScreen 'this is temporary to get the game working, hopefully its just temporary
    Dim InputOption As String
    Print GamePars.VerNum
    CENTERPRINT GamePars.GameName + " " + GamePars.VerName
    Print
    top:
    Input "(S)ingle player, (M)ultiplayer, (O)ptions", InputOption

    Select Case InputOption
        Case "s", "S"
            Input "(C)reate world, (L)oad World", InputOption
            Select Case InputOption
                Case "c", "C"
                    Input "World Name?", InputOption
                    CreateWorld InputOption
                    StartSinglePlayer InputOption
                    Error 102
                Case "l", "L"
                    Input "World Name?", InputOption
                    StartSinglePlayer InputOption
                    Error 102
            End Select
        Case "m", "M"
            'join server, host server
            'host server will change client mode to server host and join host
        Case "o", "O"
        Case Else
            GoTo top

    End Select
End Sub

Sub ParseCLA 'parse the command line arguments and set game function values accordingly
    Dim ArgNum, i

    ArgNum = CommandCount

    'runs through all provided arguments sequentially
    For i = 0 To ArgNum
        Select Case LCase$(Command$(i))
            Case "server"
                GameFlags.Headless = 1
                GameFlags.OperationMode = 1
                Net.WorldName = Command$(ArgNum + 1)
                Net.HostMode = Val(Command$(ArgNum + 2))
            Case "server-gui"
                GameFlags.OperationMode = 1
                Net.WorldName = Command$(ArgNum + 1)
                Net.HostMode = Val(Command$(ArgNum + 2))
            Case "software"

            Case "experimental"

        End Select
    Next

    'start a display with a basic 640 480 res until the screen res gets read and set,
    'the reason the actual res isnt set here is 480 is a resolution supported by most configurations
    'and the default resolution that the game might pull may cause problems, so 480 will be used by
    'first run to confirm working settings before using actual resolution
    If GameFlags.Headless = 0 Then ScreenShow: Screen NewImage(641, 481, 32)
End Sub


Sub LiveTextDemo
    Print
    Print
    GameFlags.OperationMode = 0
    Dim hosthandle, clienthandle, conhandle, con2 As Single
    Dim texty As String
    Dim textyy As String
    Screen NewImage(641, 481, 32)
    start:
    If GameFlags.OperationMode = 1 Then
        If hosthandle = 0 Then hosthandle = OpenHost("TCP/IP:25565")
        If conhandle = 0 Then conhandle = OpenConnection(hosthandle)
        'Print ConnectionAddress(hosthandle)
        Do While conhandle <> 0
            If con2 = 0 Then con2 = OpenConnection(hosthandle)

            Cls
            Print "h:"; hosthandle
            Print "c:"; clienthandle
            Print "con:"; conhandle
            Print "pre:"; texty
            Get conhandle, , texty
            If con2 <> 0 Then Get con2, , textyy
            Print texty
            Print textyy
            Display
            Limit 20
        Loop
    End If
    If GameFlags.OperationMode = 0 Then
        If clienthandle = 0 Then clienthandle = OpenClient("TCP/IP:25565:localhost")


        Do While clienthandle <> 0
            Cls
            texty = TextInput
            Print "h:"; hosthandle
            Print "c:"; clienthandle
            Print "con:"; conhandle
            Print "pre:"; texty

            Put clienthandle, , texty
            Print texty
            Display
            Limit 20
        Loop

    End If
    GoTo start
End Sub



Function TextInput$ 'writing this part with 0 sleep, been up for almost 24 hours send help EDIT: holyshit this somehow actually works
    Static LiveString As String
    Dim ActionKey As String

    'clear old input buffer
    If Text.NewInput = 1 Then
        LiveString = ""
        Text.NewInput = 0
    End If

    'set the inkey to a variable so we only have to grab it once to avoid missing key hits
    ActionKey = InKey$

    'see if any special keys were hit
    Select Case ActionKey
        Case Chr$(8) 'backspace
            LiveString = Left$(LiveString, Len(LiveString) - 1)
        Case Chr$(13) 'enter
        Case Else
            LiveString = LiveString + ActionKey
    End Select
    TextInput = LiveString
End Function


Sub Initialize
    Randomize Timer

    'Check for first run and run first run sub
    If FileExists("Assets\SaveData\Settings.cdf") = 0 Or DirExists("Assets\SaveData") = 0 Then GameFlags.FirstRun = 1
    If GameFlags.FirstRun = 1 Then FirstRun

    'Load user saved data for settings
    LoadSettings

    'initilize display if headless is disabled
    If GameFlags.Headless = 0 Then Screen NewImage(GamePars.ResX + 1, GamePars.ResY + 1, 32)

    'Set splash text in title bar
    Title "TerraQuest: " + Splash(Int(Rnd * SplashCount)) + " Edition"


    OSPROBE
End Sub

Sub LoadSettings

    Open "Assets\SaveData\Settings.cdf" As #1

    Get #1, 2, GamePars.ResX
    Get #1, 3, GamePars.ResY

    Close #1
End Sub

Sub SaveSettings
    Open "Assets\SaveData\Settings.cdf" As #1
    Put #1, 1, GamePars.VerNum
    Put #1, 2, GamePars.ResX
    Put #1, 3, GamePars.ResY

    Close #1

End Sub

Sub FirstRun
    'generate default values
    GamePars.ResX = DesktopWidth
    GamePars.ResY = DesktopHeight
    FullScreen SquarePixels


    'save default values to settings.cdf
    If DirExists("Assets\SaveData") = 0 Then MkDir "Assets\SaveData"
    Open "Assets\SaveData\Settings.cdf" As #1
    Put #1, 2, GamePars.ResX
    Put #1, 3, GamePars.ResY


    'prompt user for user specific information
    Input "Please enter a username (you can change this later)", Client.Username
    Put #1, 4, Client.Username

    'prompt ask if certain values are okay (eg. screen resolution)
    Close #1
End Sub


Sub ErrorHandler

End Sub



Rem Temporary Usage Only, Replace With New
'$include:'Assets\Sources\Footers\ErrorHandlerOld.ftcdf'

'$include:'Assets\Sources\OSprobe.bm'

