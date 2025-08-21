include <BOSL2/std.scad>
include <params.scad>

module tip_noodle(
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="tip_noodle_bottom", pos=CENTER, orient=DOWN),
        named_anchor(name="tip_noodle_top", pos=(TIP_THICKNESS-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        zcyl(h=TIP_THICKNESS-EPP_THICKNESS, d=NOODLE_OD, anchor=BOTTOM);
        children();
    }
}
module long_blade_noodle(
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="core_tip", pos=(LONG_BLADE-TIP_THICKNESS-(EPP_THICKNESS+BUFFER_THICKNESS))*UP, orient=UP),
        named_anchor(name="hand_side", pos=CENTER, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tube(h=LONG_BLADE-TIP_THICKNESS-(EPP_THICKNESS+BUFFER_THICKNESS), od=NOODLE_OD, id=SHEEP_DIAMETER, anchor=BOTTOM);
        children();
    }
}
module short_blade_noodle(
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="core_tip", pos=(SHORT_BLADE-TIP_THICKNESS-(EPP_THICKNESS+BUFFER_THICKNESS))*UP, orient=UP),
        named_anchor(name="hand_side", pos=CENTER, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tube(h=SHORT_BLADE-TIP_THICKNESS-(EPP_THICKNESS+BUFFER_THICKNESS), od=NOODLE_OD, id=SHEEP_DIAMETER, anchor=BOTTOM);
        children();
    }
}
module buffer_noodle(
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="buffer_top", pos=BUFFER_THICKNESS*UP, orient=UP),
        named_anchor(name="buffer_bottom", pos=CENTER, orient=UP)
    ];

    attachable(anchor, spin, orient, anchors=anchors){
        tube(h=BUFFER_THICKNESS, od=NOODLE_OD, id=SHEEP_DIAMETER, anchor=BOTTOM);
        children();
    }
}
module guard_foam(
    anchor=CENTER,
    spin=0,
    orient=UP){
    length = GUARD_LEN - 2*EPP_THICKNESS - STAFF_GRIP_HEIGHT;
    anchors = [
        named_anchor(name="guard_foam_top", pos=UP*length),
        named_anchor(name="guard_foam_bottom", pos=CENTER)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tube(h=length, od=GUARD_OD, id=INCH, anchor=BOTTOM);
        children();
    }
}

