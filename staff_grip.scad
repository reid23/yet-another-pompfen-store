include <BOSL2/std.scad>
include <params.scad>
use <utils.scad>

// uses: $grip_step_size
// @build staff_grip.stl od=STAFF_GRIP_OD
// @build staff_grip_narrow.stl od=NARROW_STAFF_GRIP_OD, w1=40
module staff_grip(
    min_wall_thickness=4,
    od=STAFF_GRIP_OD,
    id=INCH,
    total_length=STAFF_GRIP_HEIGHT,
    start_height=3,
    th1=40,
    th2=10,
    w1=70,
    w2=30,

    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="grip_top", pos=total_length*UP, orient=DOWN),
        named_anchor(name="grip_bottom", pos=CENTER, orient=UP)
    ];
    p0 = [od/2, start_height];
    p1 = [id/2, total_length - min_wall_thickness] + [cos(th2), sin(th2)]*min_wall_thickness;
    v0 = [cos(90+th1), sin(90+th1)]*w1;
    v1 = [cos(90+th2), sin(90+th2)]*w2;
    attachable(anchor, spin, orient, anchors=anchors){
        rotate_extrude() #polygon(concat(
            [[id/2, total_length], 
            [id/2, total_length/3],
            [id/2+$grip_step_size, total_length/3 - $grip_step_size],
            [id/2+$grip_step_size, 0], 
            [od/2, 0]],
            [for(i=[0:0.01:1]) hermite(i, p0, p1, v0, v1)],
            [for(i=[th2:1:90]) [cos(i), sin(i)]*min_wall_thickness + [id/2, total_length-min_wall_thickness]])
        );
        children();
    }
}


// uses: $grip_step_size
// @build staff_spacer.stl
module staff_spacer(
    od=INCH,
    slot_angular_size=4,
    height=STAFF_GRIP_HEIGHT,
    shoulder_od=22,
    shoulder_height=2,
    
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="screw_side_anchor", pos=CENTER, orient=DOWN),
        named_anchor(name="spacer_top", pos=height*UP, orient=UP)
    ];
    id = COREDIMS[1];
    r_c = 1; // rad of chamfer
    attachable(anchor, spin, orient, anchors=anchors){
        difference(){
            union(){
                linear_extrude(height, convexity=20) 
                    _chamfered_slotted_ring(ir = COREDIMS[1]/2, or = od/2, slot_angular_size = slot_angular_size, chamfer_size = r_c);
                linear_extrude(height/3, convexity=20)
                    _chamfered_slotted_ring(ir = COREDIMS[1]/2, or = od/2 + $grip_step_size, slot_angular_size = slot_angular_size, chamfer_size = r_c);
            }
            up(height+0.1){
                cylinder(h=10.1, d=COREDIMS[1] + 3 + PRESSFIT, anchor=TOP);
            }
            up(height/3-$grip_step_size-0.1){
                tube(h=3*$grip_step_size, ir=od/2, or=od/2+2*$grip_step_size+0.1, ichamfer=$grip_step_size+0.1, anchor=BOTTOM);
            }
        }
        children();
    }
}
