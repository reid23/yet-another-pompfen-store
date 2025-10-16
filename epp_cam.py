#!/usr/bin/python
import argparse
import numpy as np

PREFIX = """
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
"""

def label(gcode, name, id, copy):
    return f"""
; printing object {name} id:{id} copy {copy}
{gcode}
; stop printing object {name} id:{id} copy {copy}
"""

def cut_one(x, y, hclear, hcut, ID, OD, travel=2000, ztravel=1000, feed=100, plunge=500, kerf=2.25):
    realid = ID/2 - kerf
    realod = OD/2 + kerf
    diag = np.sqrt(2)/2
    print(ID, OD)
    inner = f"""
G1 Z{hclear} F{ztravel}
G1 X{x} Y{y} F{travel}
G1 Z{hcut} F{plunge}
G1 X{x-realid} Y{y} F{feed}
G2 I{realid} J0 F{feed}
G1 X{x} Y{y} F{travel}
G1 Z{hclear} F{ztravel}
"""
    outer = f"""
G1 Z{hclear} F{ztravel}
G1 X{x-realod*diag-1} Y{y-realod*diag-1}
G1 Z{hcut} F{plunge}
G1 X{x-realod*diag} Y{y-realod*diag} F{feed}
G2 I{realod*diag} J{realod*diag} F{feed}
G1 X{x-realod*diag-1} Y{y-realod*diag-1} F{travel}
G1 Z{hclear} F{ztravel}

"""
    header = f"; CUT ONE X={x:.3g} Y={y:.3g} Z=[{hcut:.3g}, {hclear:.3g}]"
    return header + (inner+outer if realid>=0.0 else outer)

def export_cam_grids():
    ap = argparse.ArgumentParser()
    ap.add_argument('-f', '--feed', default=100, type=float, help="feedrate for cutting, in mm/min")
    ap.add_argument('-t', '--travel', default=2000, type=float, help="feedrate for travel, in mm/min")
    ap.add_argument('-p', '--plunge', default=500, type=float, help="feedrate for plunge, in mm/min")
    ap.add_argument('-r', '--ztravel', default=2000, type=float, help="feedrate for travel, in mm/min")
    ap.add_argument('-z', '--zclear', default=55, type=float, help="z height that clears the stock, in mm. Used for travel moves.")
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

    gridsize = params["NOODLE_OD"] + 2*args.kerf
    guardgridsize = params["GUARD_OD"] + 2*args.kerf
    narrowguardgridsize = params["SMALL_GUARD_OD"] + 2*args.kerf
    cut_one_args = (args.travel, args.ztravel, args.feed, args.plunge, args.kerf)
    blades = PREFIX
    wideguards = PREFIX
    narrowguards = PREFIX
    for idx, i in enumerate(np.arange(2)*guardgridsize + guardgridsize/2):
        for jdx, j in enumerate(np.arange(2)*guardgridsize + guardgridsize/2):
            wideguards += label(
                cut_one(i, j, args.zclear, 0, params["GUARD_EPP_ID"], params["GUARD_OD"], *cut_one_args),
                f"wideguard{idx}{jdx}", idx*jdx, 0
            )
    for idx, i in enumerate(np.arange(3)*narrowguardgridsize + narrowguardgridsize/2):
        for jdx, j in enumerate(np.arange(2)*narrowguardgridsize + narrowguardgridsize/2):
            narrowguards += label(
                cut_one(i, j, args.zclear, 0, params["GUARD_EPP_ID"], params["SMALL_GUARD_OD"], *cut_one_args),
                f"narrowguard{idx}{jdx}", idx*jdx, 0
            )

    for idx, i in enumerate(np.arange(3)*gridsize + gridsize/2):
        for jdx, j in enumerate(np.arange(2)*gridsize + gridsize/2):
            if idx%3 == 0:
                ID = params["TIP_EPP_AXIAL_ID"]
            elif idx%3 == 1:
                ID = params["BLADE_EPP_ID"]
            else:
                ID = params["TIP_EPP_RADIAL_ID"] 
            blades += label(
                cut_one(i, j, args.zclear, 0, ID, params["NOODLE_OD"], *cut_one_args),
                ["tip_axial", "tip_radial", "blade"][idx%3] + str(jdx), idx*jdx, 0
            )
    with open('build/blades.gcode', 'w') as f:
        f.write(blades)
    with open('build/wide_guards.gcode', 'w') as f:
        f.write(wideguards)
    with open('build/narrow_guards.gcode', 'w') as f:
        f.write(narrowguards)


if __name__ == '__main__': export_cam_grids()