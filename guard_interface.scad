include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <params.scad>
use <utils.scad>

$guard_pitch = 2.5;
$guard_major_d = 20;
$guard_thread_stop_d = 24;

// uses: $guard_major_d
// @build staff_grip_collar.stl
module guard_grip_collar(anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name = "grip_collar_top", pos = CENTER, orient = UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tube(h=10, id=COREDIMS[1]+CLEARANCE, od=COREDIMS[1]+3, anchor=TOP);
        children();
    }

}

// uses: $guard_pitch, $guard_major_d, $guard_thread_stop_d
// @build guard_thread_m.stl
module guard_thread_m(
    length=12.7+1.5+2,
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="guard_thread_flange_top", pos=CENTER, orient=UP),
        named_anchor(name="guard_thread_top", pos=length*UP, orient=UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        difference(){
            union(){
                intersection(){
                    down($guard_pitch) threaded_rod(d=$guard_major_d, l=length+$guard_pitch, pitch=$guard_pitch, anchor=BOTTOM);
                    down(0.5) zcyl(h=length+1, d=$guard_major_d+1, anchor=BOTTOM);
                }
                zcyl(h=2, d=$guard_thread_stop_d-CLEARANCE, chamfer2=1, anchor=TOP);
            }
            zcyl(h=3*length, d=COREDIMS[1]+CLEARANCE);
        }
        children();
    }
}

// @build guard_thread_f.stl
module guard_thread_f(
    length=10, 
    flange_thickness=1.5, 
    flange_od=50, 
    small_flange_od=35,
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors=[
        named_anchor(name="guard_epp_attachment", pos=DOWN*(EPP_THICKNESS), orient=UP),
        named_anchor(name="guard_thread_ref_surface", pos=DOWN*(EPP_THICKNESS+flange_thickness), orient=DOWN),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        union(){
            intersection(){
                threaded_nut(nutwidth=GUARD_EPP_ID*2, id=$guard_major_d, h=length, pitch=$guard_pitch, ibevel=false, blunt_start1=false, $slop=0.15, anchor=TOP);
                zcyl(h=length, d=GUARD_EPP_ID, anchor=TOP);
            }
            difference(){
                tube(h=EPP_THICKNESS+flange_thickness, id=$guard_major_d, od=GUARD_EPP_ID, anchor=TOP);
                // #zcyl(h=EPP_THICKNESS, d=$guard_thread_stop_d+CLEARANCE, chamfer1=0.7, anchor=BOTTOM);
            }
            // bottom flange
            down(EPP_THICKNESS) tube(h=flange_thickness, id=$guard_major_d, od=flange_od, anchor=TOP);
            // top flange
            // up(2) tube(h=flange_thickness, id=$guard_thread_stop_d+CLEARANCE, od=small_flange_od, anchor=TOP);
            // %up(2-flange_thickness) zcyl(h=EPP_THICKNESS, d=30, anchor=TOP);
        }
        children();
    }
}

// @build staff_guard_spacer.stl
module staff_guard_spacer(h=50, slot_size=120, anchor=CENTER, spin=0, orient=UP){
    anchors=[
        named_anchor(name="guard_spacer_center", pos=UP*h/2, orient=UP),
        named_anchor(name="guard_spacer_bottom", pos=CENTER, orient=UP),
        named_anchor(name="guard_spacer_top", pos=UP*h, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        union(){
            linear_extrude(h/2){
                zrot(-slot_size/2) _chamfered_slotted_ring(ir = COREDIMS[1]/2, or = INCH/2, slot_angular_size = slot_size, chamfer_size = 1);
            }
            little_slot_size = 360-slot_size-2;
            linear_extrude(h){
                zrot(-little_slot_size/2) _chamfered_slotted_ring(ir = COREDIMS[1]/2, or = INCH/2, slot_angular_size = 360-slot_size, chamfer_size = 1);
            }
        }
        children();
    }
}
