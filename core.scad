include <BOSL2/std.scad>
include <params.scad>


module core(l){
    difference(){
        zcyl(h=l, d=COREDIMS[1], anchor=BOTTOM);
        zcyl(h=l, d=COREDIMS[0], anchor=BOTTOM);
    }
}

module short_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_top", pos=ORIGIN, orient=DOWN),
        named_anchor(name="core_bottom", pos=(TIP_THICKNESS-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=850-pommel_thickness-TIP_THICKNESS, anchor=BOTTOM);
        children();
    }
}

module staff_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_top", pos=ORIGIN, orient=DOWN),
        named_anchor(name="core_bottom", pos=(TIP_THICKNESS-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=1800-pommel_thickness-TIP_THICKNESS, anchor=BOTTOM);
        children();
    }
}

module long_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_top", pos=ORIGIN, orient=DOWN),
        named_anchor(name="core_bottom", pos=(TIP_THICKNESS-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=1600-pommel_thickness-TIP_THICKNESS, anchor=BOTTOM);
        children();
    }
}

module short_staff_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_top", pos=ORIGIN, orient=DOWN),
        named_anchor(name="core_bottom", pos=(TIP_THICKNESS-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=1600-pommel_thickness-TIP_THICKNESS, anchor=BOTTOM);
        children();
    }
}
