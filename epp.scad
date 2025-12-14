include <BOSL2/std.scad>
include <params.scad>

module epp(id, od){
    difference(){
        zcyl(h=EPP_THICKNESS, d=od, anchor=BOTTOM);
        zcyl(h=EPP_THICKNESS*3, d=id, anchor=CENTER);
    }
}

module tip_epp_axial(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="tip_epp_axial_top", pos=CENTER, orient=DOWN),
        named_anchor(name="tip_epp_axial_bottom", pos=EPP_THICKNESS*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=TIP_EPP_AXIAL_ID, od=NOODLE_OD);
        children();
    }
}
module tip_epp_radial(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="tip_epp_radial_top", pos=CENTER, orient=DOWN),
        named_anchor(name="tip_epp_radial_bottom", pos=EPP_THICKNESS*UP, orient=UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=TIP_EPP_RADIAL_ID, od=NOODLE_OD);
        children();
    }
}
module blade_epp_handside(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="blade_epp_handside_top", pos=EPP_THICKNESS*UP, orient=UP),
        named_anchor(name="blade_epp_handside_bottom", pos=CENTER, orient=DOWN)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=BLADE_EPP_ID, od=NOODLE_OD);
        children();
    }
}
module blade_epp_foamside(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="blade_epp_foamside_top", pos=EPP_THICKNESS*UP, orient=UP),
        named_anchor(name="blade_epp_foamside_bottom", pos=CENTER, orient=DOWN)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        epp(id=COREDIMS[1], od=NOODLE_OD);
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
