include <BOSL2/std.scad>
include <params.scad>


module core(l){
    difference(){
        zcyl(h=l, d=COREDIMS[1], anchor=BOTTOM);
        zcyl(h=l, d=COREDIMS[0], anchor=BOTTOM);
    }
}

module qtip_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_bottom", pos=CENTER, orient=UP),
        named_anchor(name="core_top", pos=(2000-2*TIP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=2000-2*TIP_THICKNESS);
        children();
    }
}

module short_core(anchor=CENTER, spin=0, orient=UP){
    // test 2
    anchors = [
        named_anchor(name="core_bottom", pos=CENTER, orient=UP),
        named_anchor(name="core_top", pos=(850-POMMEL_THICKNESS-TIP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=850-POMMEL_THICKNESS-TIP_THICKNESS);
        children();
    }
}
module staff_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_top", pos=CENTER, orient=UP),
        named_anchor(name="core_bottom", pos=(1800-POMMEL_THICKNESS-TIP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=1800-POMMEL_THICKNESS-TIP_THICKNESS);
        children();
    }
}

module long_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_bottom", pos=CENTER, orient=UP),
        named_anchor(name="core_top", pos=(1400-POMMEL_THICKNESS-TIP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=1400-POMMEL_THICKNESS-TIP_THICKNESS);
        children();
    }
}

module short_staff_core(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="core_top", pos=CENTER, orient=UP),
        named_anchor(name="core_bottom", pos=(1600-POMMEL_THICKNESS-TIP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        core(l=1600-POMMEL_THICKNESS-TIP_THICKNESS);
        children();
    }
}
