include <BOSL2/std.scad>
include <params.scad>


module core(l){
    difference(){
        zcyl(h=l, d=COREDIMS[1], anchor=BOTTOM);
        zcyl(h=l, d=COREDIMS[0], anchor=BOTTOM);
    }
}

module qtip_core(anchor=CENTER, spin=0, orient=UP){
    corelen = QTIP-2*(TIP_THICKNESS+ABOVE_CORE_HEIGHT+CORE_TO_EPP_DIST);
    anchors = [
        named_anchor(name="core_bottom", pos=CENTER, orient=UP),
        named_anchor(name="core_top", pos=corelen*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=corelen);
        children();
    }
}

module short_core(anchor=CENTER, spin=0, orient=UP){
    // test 2
    anchors = [
        named_anchor(name="core_bottom", pos=CENTER, orient=UP),
        named_anchor(name="core_top", pos=(SHORT-POMMEL_THICKNESS-TIP_THICKNESS-ABOVE_CORE_HEIGHT-CORE_TO_EPP_DIST)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=SHORT-POMMEL_THICKNESS-TIP_THICKNESS-ABOVE_CORE_HEIGHT-CORE_TO_EPP_DIST);
        children();
    }
}
module staff_core(anchor=CENTER, spin=0, orient=UP){
    corelen = STAFF-POMMEL_THICKNESS-TIP_THICKNESS-ABOVE_CORE_HEIGHT-CORE_TO_EPP_DIST;

    anchors = [
        named_anchor(name="core_bottom", pos=CENTER, orient=UP),
        named_anchor(name="core_top", pos=corelen*UP, orient=UP),
        named_anchor(name="reach_limit", pos=(corelen-STAFF_REACH)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=STAFF-POMMEL_THICKNESS-TIP_THICKNESS);
        children();
    }
}

module long_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_bottom", pos=CENTER, orient=UP),
        named_anchor(name="core_top", pos=(LONG-POMMEL_THICKNESS-TIP_THICKNESS-ABOVE_CORE_HEIGHT-CORE_TO_EPP_DIST)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=LONG-POMMEL_THICKNESS-TIP_THICKNESS-ABOVE_CORE_HEIGHT-CORE_TO_EPP_DIST);
        children();
    }
}

module short_staff_core(anchor=CENTER, spin=0, orient=UP){
    corelen = SHORTSTAFF-POMMEL_THICKNESS-TIP_THICKNESS-ABOVE_CORE_HEIGHT-CORE_TO_EPP_DIST;
    anchors = [
        named_anchor(name="core_top", pos=CENTER, orient=UP),
        named_anchor(name="core_bottom", pos=corelen*UP, orient=UP),
        named_anchor(name="reach_limit", pos=(corelen-ABOVE_CORE_HEIGHT-CORE_TO_EPP_DIST)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=CORELEN);
        children();
    }
}
