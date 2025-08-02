include <BOSL2/std.scad>
include <params.scad>

module epp(id, od){
    difference(){
        zcyl(h=EPP_THICKNESS, d=od, anchor=BOTTOM);
        zcyl(h=EPP_THICKNESS, d=id, anchor=BOTTOM);
    }
}

module tip_epp(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="epp_top", pos=ORIGIN, orient=DOWN),
        named_anchor(name="epp_bottom", pos=(TIP_THICKNESS-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=10, NOODLE_OD);
        children();
    }
}
module blade_epp(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="epp_top", pos=ORIGIN, orient=DOWN),
        named_anchor(name="epp_bottom", pos=(TIP_THICKNESS-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=24, NOODLE_OD);
        children();
    }
}


module blade_epp(id=24){
    epp(id, NOODLE_OD);
}

module guard_epp(id=30){
    epp(id, NOODLE_OD);
}
