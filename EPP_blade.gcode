; r = 35 + 1.25 = 36.25
; r2 = 6-1.25 = 4.75
; center is (37.25, 37.25)
; small circle plunge is (33.5, 37.25)
; small circle left is (32.5, 37.25)
; big circle plunge is (0, 37.25)
; big circle left is (1, 37.25)

G0 Z25
G0 X0 Y37.25
G1 X1 Y37.25 F2000
G2 I36.25 J0 F2000

G0 X37.25 Y37.25 F2000
G1 Z0 F500
G1 X30 Y37.25 F100
G2 I7.25 J0 F100
G1 X37.25 Y37.25 F1000
G0 Z20 F1000

G0 X0 Y37.25 F2000
G1 Z0 F500
G1 X1 Y37.25 F100
G2 I36.25 J0 F100
G1 X0 Y37.25 F100
G0 Z20 F1000

G0 X0 Y100 F2000
