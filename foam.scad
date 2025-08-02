include <BOSL2/std.scad>

COREDIMS=[12, 14];
NOODLE_OD=2.7*INCH;
EPP_THICKNESS=0.5*INCH;
SHEEP_DIAMETER=(7/16)*INCH;

module tip_noodle(tip_thickness=50,
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="epp_top", pos=ORIGIN, orient=DOWN),
        named_anchor(name="tip_tip", pos=(tip_thickness-EPP_THICKNESS)*UP, orient=UP)
    ];
    attachable(anchor, spin, orient, tip_thickness=tip_thickness, anchors=anchors){
        zcyl(h=tip_thickness-EPP_THICKNESS, d=NOODLE_OD, anchor=BOTTOM);
        children();
    }
}
module blade_noodle(tip_thickness, buffer_thickness,
    anchor=CENTER,
    spin=0,
    orient=UP){
    echo(tip_thickness);
    anchors = [
        named_anchor(name="core_tip", pos=(900-tip_thickness-(EPP_THICKNESS+buffer_thickness))*UP, orient=UP),
        named_anchor(name="hand_side", pos=CENTER, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tube(h=900-tip_thickness-(EPP_THICKNESS+buffer_thickness), od=NOODLE_OD, id=SHEEP_DIAMETER, anchor=BOTTOM);
        children();
    }
}
// module buffer_noodle(buffer_thickness=50,
//     anchor=CENTER,
//     spin=0,
//     orient=UP){
//     anchors = [
//         named_anchor(name="core_tip", pos=900-tip_thickness, orient=UP),
//         named_anchor(name="hand_side", pos=ORIGIN, orient=UP)
//     ];
//     attachable(anchor, spin, orient, tip_thickness=tip_thickness, buffer_thickness=buffer_thickness, anchors=anchors){
//         up(EPP_THICKNESS+buffer_thickness) tube(h=900-tip_thickness-(EPP_THICKNESS+buffer_thickness), od=NOODLE_OD, id=SHEEP_DIAMETER, anchor=BOTTOM);
//         children();
//     }
// }