include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <params.scad>
include <utils.scad>

// uses: $include_dfm, $major_d, $pitch, $starts, $thread_len
module tip_thread_m_body(flange_od,
                    flange_depth,
                    cone_od,
                    cone_depth,
                    core_to_epp_dist,
                    epp_pin_depth,
                    extra_tube_height,
                    mini_chamfer_size){

    // zcyl(h=core_pin_depth, d=COREDIMS[0]-CLEARANCE, chamfer1=1, anchor=TOP);
    intersection() {
        threaded_rod(h=2*$thread_len, d=COREDIMS[0]-1, pitch=$pitch, blunt_start2=false, starts=$starts, anchor=TOP);
        union(){
            // #zcyl(h=core_pin_depth, d=$major_d-CLEARANCE, anchor=TOP);
            zcyl(h=$thread_len, d=$major_d-1.5, anchor=TOP);
            down($thread_len) zcyl(h=$thread_len, d=$major_d-CLEARANCE, anchor=TOP);
        }
    }
    no_cone_od=COREDIMS[1]+2;
    // core to epp flat part (can be thinner than flange)
    zcyl(h=core_to_epp_dist, d=no_cone_od, anchor=BOTTOM);
    // additional reinforcing material: flange, cone, extra tube, etc.
    up(core_to_epp_dist){
        // flange
        difference(){
            tube(id=COREDIMS[1]+CLEARANCE, od=flange_od, h=flange_depth, anchor=TOP);
            radially_distributed_filleted_slots(ir=flange_od/3);
        }

        // cone + extra tube
        down(flange_depth){
            // cone
            rotate_extrude() polygon([
                [no_cone_od/2-0.1, 0],
                [cone_od/2+mini_chamfer_size, 0],
                [cone_od/2, -mini_chamfer_size],
                [no_cone_od/2, -cone_depth],
                [no_cone_od/2-0.1, -cone_depth],
            ]);

            // extra tube
            tube(id=COREDIMS[1]+CLEARANCE, od=no_cone_od, h=cone_depth+extra_tube_height, ichamfer1=0.5, anchor=TOP);
        }
    }
    
    if(TIP_EPP_AXIAL_ID > 0){
        up(core_to_epp_dist) zcyl(h=epp_pin_depth, d=TIP_EPP_ID, chamfer2=0.5, anchor=BOTTOM);
        if(first_defined([$include_dfm, false])){
            up(core_to_epp_dist) {
                zcyl(h=12+1.5, d=2, anchor=BOTTOM);
                up(12+1.5) zcyl(h=0.7, d=30, anchor=TOP);
            }
        }
    }
}


// uses: $include_dfm, $major_d, $pitch, $starts, $thread_len
// @build components/tip_thread_m.stl $include_dfm=false
module tip_thread_m(
    flange_od=35, 
    flange_depth=1,
    cone_od=20,
    cone_depth=15, 
    core_to_epp_dist=CORE_TO_EPP_DIST,
    epp_pin_depth=9,
    extra_tube_height=0,
    mini_chamfer_size=0.5,
    anchor = CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name = "core_anchor", pos = CENTER, orient = DOWN),
        named_anchor(name = "epp_anchor", pos = core_to_epp_dist*UP, orient = UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tip_thread_m_body(flange_od, flange_depth, cone_od, cone_depth, core_to_epp_dist, epp_pin_depth, extra_tube_height, mini_chamfer_size);
        children();
    }

}

// uses: $major_d, $pitch, $starts, $thread_len
module tip_thread_f_body(depth, above_core_height){
    intersection(){
        difference(){
            union(){
                zcyl(h=depth-above_core_height, d=COREDIMS[0], anchor=TOP);
                zcyl(h=above_core_height, d=COREDIMS[1]-CLEARANCE, anchor=BOTTOM);
            }
            down($thread_len-above_core_height) zcyl(h=depth-$thread_len+1, d=$major_d, anchor=TOP);
        }
        
        up(ceil(above_core_height/$pitch + 1)*$pitch - 0.25) union() {
            threaded_nut(nutwidth=50, id=COREDIMS[0]-1, h=depth*2, pitch=$pitch, starts=$starts, $slop=0.025, ibevel=false, blunt_start=true, lead_in=1, anchor=TOP);
            difference(){
                zcyl(h=depth*2, d=50, anchor=TOP);
                zcyl(h=depth*2, d=$major_d, anchor=TOP);
            }
        }
    }
    // chamfered base
    if(2*$thread_len+1 < depth){
        chamfersize=2;
        up(above_core_height) difference(){
            zcyl(h=depth, d=COREDIMS[0], anchor=TOP);
            zcyl(h=2*$thread_len+1+chamfersize, d=$major_d, chamfer1=chamfersize, anchor=TOP);
        }
    }
}

// uses: $major_d, $pitch, $starts, $thread_len
// @build components/tip_thread_f.stl
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


tip_thread_m();
