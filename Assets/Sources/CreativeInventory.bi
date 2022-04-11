Dim i, inc

For iiii = 0 To creativepages
    For ii = 0 To 2
        For iii = 0 To 5
            For i = 0 To invparameters
                Print ii, iii, i, iiii, itemindex(inc, i)
                creativeinventory(ii, iii, i, iiii) = itemindex(inc, i)
               ' Sleep
            Next
            inc = inc + 1
        Next
    Next
Next

