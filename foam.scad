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
module blade_noodle(
    anchor=CENTER,
    spin=0,
    orient=UP){
    echo(TIP_THICKNESS);
    anchors = [
        named_anchor(name="core_tip", pos=(900-TIP_THICKNESS-(EPP_THICKNESS+BUFFER_THICKNESS))*UP, orient=UP),
        named_anchor(name="hand_side", pos=CENTER, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tube(h=900-TIP_THICKNESS-(EPP_THICKNESS+BUFFER_THICKNESS), od=NOODLE_OD, id=SHEEP_DIAMETER, anchor=BOTTOM);
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