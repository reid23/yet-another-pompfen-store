import argparse

def export_cam():
    ap = argparse.ArgumentParser()
    ap.add_argument('-f', '--feed', default=100, type=float, help="feedrate for cutting, in mm/s")
    ap.add_argument('-t', '--travel', default=2000, type=float, help="feedrate for travel, in mm/s")
    ap.add_argument('-p', '--plunge', default=500, type=float, help="feedrate for plunge, in mm/s")
    ap.add_argument('-z', '--zclear', default=25, type=float, help="z height that clears the stock, in mm. Used for travel moves.")
    ap.add_argument('-y', '--yclear', default=100, type=float, help="y position that clears the stock, in mm. Used for start/end position.")
    ap.add_argument('-k', '--kerf', default=2.25, type=float, help="**radius** of hot knife kerf (ie, effective tool radius), in mm.")
    args = ap.parse_args()

    # get values from params.scad
    INCH = 25.4
    fullstr = ""
    with open("params.scad", "r") as f:
        for line in f.readlines():
            if line[0] in '$/': continue
            if "=" not in line: continue
            fullstr += line.replace(";",",")
    params = eval("dict("+fullstr+")")
            

    def get_gcode_string(OD, ID, args):
        center = OD/2 + args.kerf + 1
        zclear = args.zclear
        yclear = args.yclear
        travel = args.travel
        feed = args.feed
        plunge = args.plunge
        kerf = args.kerf
        if ID >= 2*kerf:
            inner_circle = f"""
G0 X{center} Y{center} F{travel}
G1 Z0 F{plunge}
G1 X{center-(ID/2-kerf)} Y{center} F{feed}
G2 I{ID/2 - kerf} J0 F{feed}
G1 X{center} Y{center} F{travel}
G0 Z{zclear} F{feed}
"""
        else:
            inner_circle = ""
        return f"""
G0 Z{zclear} F{travel}
G0 X0 Y{center}
G1 X1 Y{center} F{travel}
G2 I{OD/2+kerf} J0 F{travel}

{inner_circle}

G0 X0 Y{center} F{travel}
G1 Z0 F{plunge}
G1 X1 Y{center} F{feed}
G2 I{OD/2 + kerf} J0 F{feed}
G1 X0 Y{center} F{travel}
G0 Z{zclear} F{travel}

G0 X0 Y{yclear} F{travel}

"""

    with open('build/guard_epp.gcode', 'w') as f:
        print(get_gcode_string(params["GUARD_OD"], params["GUARD_EPP_ID"], args), file=f)
    with open('build/blade_epp.gcode', 'w') as f:
        print(get_gcode_string(params["NOODLE_OD"], params["BLADE_EPP_ID"], args), file=f)
    with open('build/tip_epp.gcode', 'w') as f:
        print(get_gcode_string(params["NOODLE_OD"], params["TIP_EPP_ID"], args), file=f)

if __name__ == '__main__': export_cam()