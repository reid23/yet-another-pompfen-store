
M73 P0 R111
M201 X9000 Y9000 Z500 E10000 ; sets maximum accelerations, mm/sec^2
M203 X500 Y500 Z12 E120 ; sets maximum feedrates, mm / sec
M204 S2000 T1500 ; sets acceleration (S) and retract acceleration (R), mm/sec^2
M205 X10.00 Y10.00 Z0.20 E4.50 ; sets the jerk limits, mm/sec
; M205 S0 T0 ; sets the minimum extruding and travel feed rate, mm/sec

;TYPE:Custom
; M862.3 P "MK2.5S" ; printer model check
; M862.1 P0.4 ; nozzle diameter check
; M115 U3.14.1 ; tell printer latest fw version
G90 ; use absolute coordinates

; printing object tip0 id:0 copy 0
; CUT ONE X=36.5 Y=36.5 Z=[0, 25]
G0 Z25 F2000
G0 X-1.0 Y36.54
G1 Z0 F500
G1 X0.0 Y36.54 F100
G2 I36.54 J0 F100
G0 X-1.0 Y36.54 F2000
G0 Z25 F2000


; stop printing object tip0 id:0 copy 0

; printing object blade0 id:0 copy 0
; CUT ONE X=36.5 Y=110 Z=[0, 25]
G0 Z25 F2000
G0 X36.54 Y109.62 F2000
G1 Z0 F500
G1 X26.79 Y109.62 F100
G2 I9.75 J0 F100
G0 X36.54 Y109.62 F2000
G0 Z25 F2000

G0 Z25 F2000
G0 X-1.0 Y109.62
G1 Z0 F500
G1 X0.0 Y109.62 F100
G2 I36.54 J0 F100
G0 X-1.0 Y109.62 F2000
G0 Z25 F2000


; stop printing object blade0 id:0 copy 0

; printing object tip1 id:0 copy 0
; CUT ONE X=110 Y=36.5 Z=[0, 25]
G0 Z25 F2000
G0 X72.08000000000001 Y36.54
G1 Z0 F500
G1 X73.08000000000001 Y36.54 F100
G2 I36.54 J0 F100
G0 X72.08000000000001 Y36.54 F2000
G0 Z25 F2000


; stop printing object tip1 id:0 copy 0

; printing object blade1 id:1 copy 0
; CUT ONE X=110 Y=110 Z=[0, 25]
G0 Z25 F2000
G0 X109.62 Y109.62 F2000
G1 Z0 F500
G1 X99.87 Y109.62 F100
G2 I9.75 J0 F100
G0 X109.62 Y109.62 F2000
G0 Z25 F2000

G0 Z25 F2000
G0 X72.08000000000001 Y109.62
G1 Z0 F500
G1 X73.08000000000001 Y109.62 F100
G2 I36.54 J0 F100
G0 X72.08000000000001 Y109.62 F2000
G0 Z25 F2000


; stop printing object blade1 id:1 copy 0

; printing object tip2 id:0 copy 0
; CUT ONE X=183 Y=36.5 Z=[0, 25]
G0 Z25 F2000
G0 X145.16 Y36.54
G1 Z0 F500
G1 X146.16 Y36.54 F100
G2 I36.54 J0 F100
G0 X145.16 Y36.54 F2000
G0 Z25 F2000


; stop printing object tip2 id:0 copy 0

; printing object blade2 id:2 copy 0
; CUT ONE X=183 Y=110 Z=[0, 25]
G0 Z25 F2000
G0 X182.7 Y109.62 F2000
G1 Z0 F500
G1 X172.95 Y109.62 F100
G2 I9.75 J0 F100
G0 X182.7 Y109.62 F2000
G0 Z25 F2000

G0 Z25 F2000
G0 X145.16 Y109.62
G1 Z0 F500
G1 X146.16 Y109.62 F100
G2 I36.54 J0 F100
G0 X145.16 Y109.62 F2000
G0 Z25 F2000


; stop printing object blade2 id:2 copy 0
