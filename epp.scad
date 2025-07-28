include <BOSL2/std.scad>

module epp(id, od, thickness){
    difference(){
        zcyl(h=thickness, d=od, anchor=BOTTOM);
        zcyl(h=thickness, d=id, anchor=BOTTOM);
    }
}

module tip_epp(id=10, od=70, thickness=INCH/2){
    epp(id, od, thickness);
}

module blade_epp(id=24, od=70, thickness=INCH/2){
    epp(id, od, thickness);
}

module guard_epp(id=30, od=80, thickness=INCH/2){
    epp(id, od, thickness);
}
