$NoPrefix
Option Explicit
'On Error GoTo ERRORHANDLE
Randomize Timer
Screen NewImage(641, 481, 32) '40x30
PrintMode KeepBackground
DisplayOrder Hardware , Software
Title "CDF-Quest"
Dim Shared As Byte aaa, aba, aab, abb, baa, bba, bab, bbb
Dim i, ii
For i = 0 To 20
    For ii = 0 To 20
        Locate i + 1, ii + 1
        Print Perlin(i, ii, 30)
        Locate i + 1, ii + 11
        Print Right$(Hex$(aaa), 1)
    Next
Next

'$include: 'Assets\Sources\VariableDeclaration.bi'

Function Perlin (X As Double, Y As Double, z As Double)
    Dim i, p, first As Unsigned Byte
    Static As Unsigned Byte PermArray(512)
    Dim u, v, w As Double

    Restore permdata
    If first = 0 Then
        For i = 0 To 512
            Read p
            PermArray(i) = p
            If i = 256 Then Restore permdata
        Next
        first = 1
    End If


    u = PerlinFade(X - Int(X))
    v = PerlinFade(Y - Int(Y))
    w = PerlinFade(z - Int(z))



    aaa = PermArray(PermArray(PermArray(Int(X)) + Int(Y)) + Int(z))
    aba = PermArray(PermArray(PermArray(Int(X)) + Int(Y) + 1) + Int(z))
    aab = PermArray(PermArray(PermArray(Int(X)) + Int(Y)) + Int(z) + 1)
    abb = PermArray(PermArray(PermArray(Int(X)) + Int(Y) + 1) + Int(z) + 1)
    baa = PermArray(PermArray(PermArray(Int(X) + 1) + Int(Y)) + Int(z))
    bba = PermArray(PermArray(PermArray(Int(X) + 1) + Int(Y) + 1) + Int(z))
    bab = PermArray(PermArray(PermArray(Int(X) + 1) + Int(Y)) + Int(z) + 1)
    bbb = PermArray(PermArray(PermArray(Int(X) + 1) + Int(Y) + 1) + Int(z) + 1)





    Dim As Unsigned Byte xi, yi, zi


    permdata:
    Data 151,160,137,91,90,15,
    Data 131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
    Data 190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    Data 88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,134,139,48,27,166,
    Data 77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    Data 102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,18,169,200,196,
    Data 135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,
    Data 5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    Data 223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,155,167,43,172,9,
    Data 129,22,39,253,19,98,108,110,79,113,224,232,178,185,112,104,218,246,97,228,
    Data 251,34,242,193,238,210,144,12,191,179,162,241,81,51,145,235,249,14,239,107,
    Data 49,192,214,31,181,199,106,157,184,84,204,176,115,121,50,45,127,4,150,254,
    Data 138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180

End Function

Function Grad (hash As Byte, x As Double, y As Double, z As Double)

    Select Case Right$(Hex$(hash), 1)
        Case "0"
            Grad = x + y


    End Select

End Function

Function LiIp
End Function

Function PerlinFade (t As Double)
    PerlinFade = (6 * t ^ 5) - (15 * t ^ 4) + (10 * t ^ 3)
End Function



