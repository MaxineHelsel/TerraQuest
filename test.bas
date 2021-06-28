$NoPrefix
Option Explicit
Randomize Timer
Screen NewImage(641, 481, 32) '40x30
PrintMode KeepBackground
DisplayOrder GLRender , Hardware , Software
Title "CDF-Quest"
Dim Shared OGLFPS As Integer
Dim i

Do
    Locate 1, 1: Print "yeet "; OGLFPS
    If i = 60 Then
        DisplayOrder Hardware , Software
        Input "test", i
        DisplayOrder GLRender , Hardware , Software
        endif
    i = i + 1
    Limit 60
    Display
    Cls
Loop

Sub _GL

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

