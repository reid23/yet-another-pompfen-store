include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <params.scad>


$pitch=1.5;
$starts=2;
$major_d=COREDIMS[0]-0.4*4;


module blade_thread_m(){
    intersection(){
        threaded_rod(h=20, d=18, pitch=1.5, anchor=BOTTOM);
        difference(){
            zcyl(h=INCH/2, d=25, anchor=BOTTOM);
            zcyl(h=INCH/2, d=COREDIMS[1]+PRESSFIT, chamfer=-0.3, anchor=BOTTOM);
        }
        // up(INCH/4) zcyl(h=INCH/2, d=COREDIMS[1]+PRESSFIT, chamfer=-0.3);
    }
    up(12) tube(h=1.5, od=18, id=COREDIMS[1]+PRESSFIT, anchor=BOTTOM);
}

module blade_thread_f(flange_thickness, epp_thickness){
    intersection(){
        threaded_nut(nutwidth=50, id=18, h=20, pitch=1.5, anchor=BOTTOM, $slop=0.025, ibevel=false);
        union(){
            zcyl(h=epp_thickness + flange_thickness, d=20, anchor=BOTTOM);
            up(epp_thickness+flange_thickness) zcyl(h=flange_thickness, id=COREDIMS[1], od=18, anchor=BOTTOM);
        }
    }
    tube(h=1.5, id=COREDIMS[1]+CLEARANCE, od=50, anchor=BOTTOM);
    up(epp_thickness+2*flange_thickness) intersection(){
        tube(h=1.5, id=18+CLEARANCE, od=35, anchor=TOP);
        cube([27, 500, 500], anchor=TOP);
    }
}

module tip_thread_m_body(flange_od, 
                    flange_depth, 
                    core_pin_depth, 
                    core_to_epp_dist,
                    epp_pin_depth,
                    extra_tube_height=5,
                    include_dfm=true){

    // zcyl(h=core_pin_depth, d=COREDIMS[0]-CLEARANCE, chamfer1=1, anchor=TOP);
    up($pitch) intersection() {
        threaded_rod(h=core_pin_depth+1.5, d=COREDIMS[0]-1, pitch=$pitch, starts=$starts, anchor=TOP);
        zcyl(h=core_pin_depth+1.5, d=$major_d-CLEARANCE, anchor=TOP);
    }
    zcyl(h=core_to_epp_dist, d=flange_od, anchor=BOTTOM);
    
    h = flange_depth-core_to_epp_dist;
    difference(){
        zcyl(h=h, d=flange_od, chamfer1=h, chamfang=atan2(h, flange_od/2 - (COREDIMS[1]/2 + 1)), from_end=true, anchor=TOP);
        zcyl(h=h, d=COREDIMS[1]+CLEARANCE, chamfer1=-0.25, anchor=TOP);
    }
    up(core_to_epp_dist) zcyl(h=epp_pin_depth, d=TIP_EPP_ID, chamfer2=0.5, anchor=BOTTOM);
    difference(){
        zcyl(h=extra_tube_height, d=16, anchor=TOP);
        zcyl(h=extra_tube_height, d=COREDIMS[1]+CLEARANCE, chamfer1=-0.25, anchor=TOP);
    }
    if(include_dfm){
        up(core_to_epp_dist) {
            zcyl(h=12+1.5, d=2, anchor=BOTTOM);
            up(12+1.5) zcyl(h=0.7, d=30, anchor=TOP);
        }
    }
}

// @build tip_thread_m_nodfm.stl include_dfm=false
// @build tip_thread_m.stl include_dfm=true
module tip_thread_m(
    flange_od=30, 
    flange_depth=3.1, 
    core_pin_depth=8, 
    core_to_epp_dist=1,
    epp_pin_depth=9,
    extra_tube_height=5,
    include_dfm=true,
    anchor = CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name = "core_anchor", pos = CENTER, orient = DOWN),
        named_anchor(name = "epp_anchor", pos = core_to_epp_dist*UP, orient = UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tip_thread_m_body(flange_od, flange_depth, core_pin_depth, core_to_epp_dist, epp_pin_depth, extra_tube_height, include_dfm);
        children();
    }

}


module tip_thread_f_body(depth, above_core_height){
    intersection(){
        union(){
            zcyl(h=depth-above_core_height, d=COREDIMS[0], anchor=TOP);
            zcyl(h=above_core_height, d=COREDIMS[1]-CLEARANCE, anchor=BOTTOM);
        }
        
        up(ceil(above_core_height/$pitch + 1)*$pitch - 0.25) union() {
            threaded_nut(nutwidth=50, id=COREDIMS[0]-1, h=depth*2, pitch=$pitch, starts=$starts, $slop=0.025, ibevel=false, blunt_start=true, lead_in=1, anchor=TOP);
            difference(){
                zcyl(h=depth*2, d=50, anchor=TOP);
                zcyl(h=depth*2, d=$major_d, anchor=TOP);
            }
        }
    }
}

// @build tip_thread_f.stl
module tip_thread_f(
    depth=13, above_core_height=2,
    anchor = CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name = "carbon_core_tip", pos = CENTER, orient = DOWN),
        named_anchor(name = "effective_core_top", pos = above_core_height*UP, orient = UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tip_thread_f_body(depth, above_core_height);
        children();
    }

}


$guard_pitch = 2.5;
$guard_major_d = 20;

// @build guard_thread_m.stl
module guard_thread_m(
    length=10,
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="guard_top_thread_reference", pos=CENTER, orient=DOWN),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        intersection(){
            down($guard_pitch) threaded_rod(d=$guard_major_d, l=length+$guard_pitch, pitch=$guard_pitch, $slop=0.025, anchor=BOTTOM);
            tube(h=length+1, id=COREDIMS[1]+CLEARANCE, od=$guard_major_d+1, anchor=BOTTOM);
        }
        children();
    }
}

// @build lower_guard_thread_m.stl
module lower_guard_thread_m(
    length=10,
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="guard_lower_thread_flange_top", pos=CENTER, orient=UP),
        named_anchor(name="guard_lower_thread_bottom", pos=2*DOWN, orient=UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        difference(){
            union(){
                intersection(){
                    down($guard_pitch) threaded_rod(d=$guard_major_d, l=length+$guard_pitch, pitch=$guard_pitch, $slop=0.025, anchor=BOTTOM);
                    down(0.5) zcyl(h=length+1, d=$guard_major_d+1, anchor=BOTTOM);
                }
                zcyl(h=2, d=24, chamfer2=1, anchor=TOP);
            }
            zcyl(h=3*length, d=COREDIMS[1]+CLEARANCE);
        }
        children();
    }
}
// lower_guard_thread_m() show_anchors(std=false);
// intersection() {
//     tip_thread_f(depth = 13, above_core_height = 2, $pitch=1.5, $starts=2, $major_d=COREDIMS[0]-0.4*4)
//         attach("effective_core_top", "core_anchor")
//            tip_thread_m(flange_od=30, flange_depth=3.1, core_pin_depth=8, core_to_epp_dist=1, epp_pin_depth=9)
//     ;
//     cube(100, anchor=LEFT);
// }