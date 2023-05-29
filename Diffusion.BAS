Option _Explicit

Screen _NewImage(800, 800, 32)

Type Vector2D
    x As Double
    y As Double
End Type

Type Vector2I
    x As Integer
    y As Integer
End Type

Type Cell
    Center As Vector2D
    Species As Integer
    ' -1 = Source
    '  0 = Clear
    '  1 = Opaque
    Intensity As Double
    Translucence As Double
End Type

Dim As Double CellWidth
Dim As Double CellHeight
Dim As Integer CellCountX
Dim As Integer CellCountY

If (1 = 1) Then ' Specify cell dimensions, calculate total number.
    CellWidth = 40
    CellHeight = 40
    CellCountX = Int(_Width / CellWidth)
    CellCountY = Int(_Height / CellHeight)
Else '          ' Specify cell number, calculate dimensions.
    CellCountX = 40
    CellCountY = 40
    CellWidth = _Width / CellCountX
    CellHeight = _Height / CellCountY
End If

Dim As Cell World(CellCountX, CellCountY)
Dim As Cell WorldAux(CellCountX, CellCountY)

Dim As Integer i
Dim As Integer j
Dim As Integer jj
Dim As Integer j0
Dim As Integer k
Dim As Integer kk
Dim As Integer k0
Dim As Double x0
Dim As Double y0
Dim As Double Accumulator
Dim As Double Normalizer
Dim As Double Factor

' Create diffusion kernel.
Dim As Double ImgKernel(-1 To 1, -1 To 1)
ImgKernel(1, -1) = 7 '  1 / Sqr(2)
ImgKernel(0, -1) = 10 ' 1
ImgKernel(-1, -1) = 7 ' 1 / Sqr(2)
ImgKernel(1, 0) = 10 '  1
ImgKernel(0, 0) = 0 '   0
ImgKernel(-1, 0) = 10 ' 1
ImgKernel(1, 1) = 7 '   1 / Sqr(2)
ImgKernel(0, 1) = 10 '  1
ImgKernel(-1, 1) = 7 '  1 / Sqr(2)

' Initialize world (just once)
For j = 1 To CellCountX
    For k = 1 To CellCountY
        World(j, k).Center.x = (j - 1 / 2) * CellWidth
        World(j, k).Center.y = (k - 1 / 2) * CellHeight
    Next
Next

Dim Player As Vector2I
Player.x = 12
Player.y = 15

Do

    ' Load world (with every refresh)
    For j = 1 To CellCountX
        For k = 1 To CellCountY
            World(j, k).Species = 0
            World(j, k).Translucence = 1
            World(j, k).Intensity = 0
        Next
    Next

    ' Opaque things
    j0 = 4
    k0 = 4
    For j = j0 To 2 * j0 + 1
        World(j, j0).Species = 1
        World(j, 2 * k0 + 1).Species = 1
        World(j, j0).Translucence = 0
        World(j, 2 * k0 + 1).Translucence = 0
    Next
    For k = k0 + 1 To 2 * k0
        World(j0, k).Species = 1
        World(2 * j0 + 1, k).Species = 1
        World(j0, k).Translucence = 0
        World(2 * j0 + 1, k).Translucence = 0
    Next

    For j = j0 To 2 * j0 + 1
        World(7 + j, 7 + j0).Species = 1
        World(7 + j, 7 + 2 * k0 + 1).Species = 1
        World(7 + j, 7 + j0).Translucence = .25
        World(7 + j, 7 + 2 * k0 + 1).Translucence = .25
    Next
    For k = k0 + 1 To 2 * k0
        World(7 + j0, 7 + k).Species = 1
        World(7 + 2 * j0 + 1, 7 + k).Species = 1
        World(7 + j0, 7 + k).Translucence = .25
        World(7 + 2 * j0 + 1, 7 + k).Translucence = .25
    Next


    ' Light sources
    j = 3
    k = 3
    World(j, k).Species = -1
    World(j, k).Intensity = 1

    While _MouseInput: Wend

    ' Player
    Player.x = Int(_MouseX + CellWidth / 2) / CellWidth
    Player.y = Int(_MouseY + CellHeight / 2) / CellHeight
    j = Int(Player.x)
    k = Int(Player.y)
    World(j, k).Species = -1
    World(j, k).Intensity = 1

    For i = 1 To 20
        For j = 1 To CellCountX
            For k = 1 To CellCountY
                If (World(j, k).Species <> -1) Then
                    Accumulator = 0
                    Normalizer = 0
                    For jj = -1 To 1
                        For kk = -1 To 1
                            j0 = j + jj
                            k0 = k + kk
                            If (j0 < 1) Then j0 = 1
                            If (k0 < 1) Then k0 = 1
                            If (j0 > CellCountX) Then j0 = CellCountX
                            If (k0 > CellCountY) Then k0 = CellCountY
                            Accumulator = Accumulator + (World(j0, k0).Intensity) * World(j, k).Translucence * ImgKernel(jj, kk)
                            Normalizer = Normalizer + ImgKernel(jj, kk)
                        Next
                    Next
                    WorldAux(j, k).Intensity = Accumulator / Normalizer
                End If
            Next
        Next
        For j = 1 To CellCountX
            For k = 1 To CellCountY
                If (World(j, k).Species <> -1) Then
                    World(j, k).Intensity = WorldAux(j, k).Intensity
                End If
            Next
        Next
    Next

    Cls
    For j = 1 To CellCountX
        For k = 1 To CellCountY
            x0 = World(j, k).Center.x
            y0 = World(j, k).Center.y
            Factor = (World(j, k).Intensity) ^ .3
            If (World(j, k).Species = -1) Then
                Line (x0 - CellWidth / 2, y0 - CellHeight / 2)-(x0 + CellWidth / 2, y0 + CellHeight / 2), _RGB32(255 * Factor, 255 * Factor, 0, 255), BF
            ElseIf (World(j, k).Species = 0) Then
                Line (x0 - CellWidth / 2, y0 - CellHeight / 2)-(x0 + CellWidth / 2, y0 + CellHeight / 2), _RGB32(255 * Factor, 0, 0, 255), BF
            ElseIf (World(j, k).Species = 1) Then
                Line (x0 - CellWidth / 2, y0 - CellHeight / 2)-(x0 + CellWidth / 2, y0 + CellHeight / 2), _RGB32(0, 0, 100, 255), BF
            End If
            Line (x0 - CellWidth / 2, y0 - CellHeight / 2)-(x0 + CellWidth / 2, y0 + CellHeight / 2), _RGB32(128, 128, 128, 255), B
        Next
    Next

    _Display
    _Limit 60
Loop
