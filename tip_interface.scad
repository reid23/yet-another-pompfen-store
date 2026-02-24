include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <params.scad>
include <utils.scad>

module tip_flange_body(flange_od,
                    flange_depth,
                    cone_od,
                    cone_depth,
                    core_to_epp_dist,
                    extra_tube_height,
                    mini_chamfer_size){

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
            tube(id=COREDIMS[1]+CLEARANCE+2*HEAT_SHRINK_THICKNESS, od=no_cone_od, h=cone_depth+extra_tube_height, ichamfer1=0.5, anchor=TOP);
        }
    }
}

// @build components/tip_flange.stl
module tip_flange(
    flange_od=35, 
    flange_depth=1,
    cone_od=20,
    cone_depth=15, 
    core_to_epp_dist=CORE_TO_EPP_DIST,
    extra_tube_height=5,
    mini_chamfer_size=0.5,
    anchor = CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name = "core_anchor", pos = CENTER, orient = UP),
        named_anchor(name = "epp_anchor", pos = core_to_epp_dist*UP, orient = DOWN),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tip_flange_body(flange_od, flange_depth, cone_od, cone_depth, core_to_epp_dist, extra_tube_height, mini_chamfer_size);
        children();
    }

}

module tip_cap_body(depth, above_core_height){
  tube(od=COREDIMS[0], id=COREDIMS[0]-2, h=depth, anchor=TOP);
  zcyl(d=COREDIMS[1]-CLEARANCE, h=above_core_height, chamfer2=1, anchor=BOTTOM);
}

// @build components/tip_cap.stl
module tip_cap(depth=3, above_core_height=2, anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name = "carbon_core_tip", pos = CENTER, orient = UP),
        named_anchor(name = "effective_core_top", pos = above_core_height*UP, orient = UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        tip_cap_body(depth, above_core_height);
        children();
    }
}



difference() {
   // tip_flange(flange_od = 35, flange_depth = 1, cone_od = 20, cone_depth = 15, core_to_epp_dist = CORE_TO_EPP_DIST, extra_tube_height = 5, mini_chamfer_size = 0.5, anchor = CENTER, spin = 0, orient = UP);
  // tip_cap();
  // cube(100, anchor=RIGHT);
}
