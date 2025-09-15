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
        named_anchor(name="tip_epp_top", pos=CENTER, orient=DOWN),
        named_anchor(name="tip_epp_bottom", pos=EPP_THICKNESS*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=TIP_EPP_ID, od=NOODLE_OD);
        children();
    }
}
module blade_epp(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="blade_epp_top", pos=CENTER, orient=UP),
        named_anchor(name="blade_epp_bottom", pos=EPP_THICKNESS*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=BLADE_EPP_ID, od=NOODLE_OD);
        children();
    }
}

module guard_epp(od, anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="epp_top", pos=CENTER, orient=DOWN),
        named_anchor(name="epp_bottom", pos=EPP_THICKNESS*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=GUARD_EPP_ID, od=od);
        children();
    }
}
