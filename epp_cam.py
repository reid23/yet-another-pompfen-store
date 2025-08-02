travel = 2000
feed = 100
plunge = 500

# get values from params.scad
INCH = 25.4
with open("params.scad", "r") as f:
    for line in f.readlines():
        print(line)
        if line[0] in '$/': continue
        exec(line)

OD = float(input("OD (3in = 76.2, 2.75in = 69.85): "))
ID = float(input("ID (12mm tip, 24mm blade, 26mm guard): "))
kerf = input("kerf radius (2.25mm default): ")
kerf = 2.25 if len(kerf)==0 else float(kerf)
center = OD/2 + kerf + 1
out = f"""
G0 Z25 F{travel}
G0 X0 Y{center}
G1 X1 Y{center} F{travel}
G2 I{OD/2+kerf} J0 F{travel}

G0 X{center} Y{center} F{travel}
G1 Z0 F{plunge}
G1 X{center-(ID/2-kerf)} Y{center} F100
G2 I{ID/2 - kerf} J0 F{feed}
G1 X{center} Y{center} F{travel}
G0 Z20 F{feed}

G0 X0 Y{center} F{travel}
G1 Z0 F{plunge}
G1 X1 Y{center} F{feed}
G2 I{OD/2 + kerf} J0 F{feed}
G1 X0 Y{center} F{travel}
G0 Z20 F{travel}

G0 X0 Y100 F{travel}
"""

print(out)