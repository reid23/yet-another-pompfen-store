include <BOSL2/std.scad>;
include <BOSL2/threading.scad>;

$fn = 100;
coredims = [12, 14];
PRESSFIT = 0.1;
CLEARANCE = 0.2;
module core(length){
    tube(h=length, id=coredims[0], od=coredims[1]);
}

module blade_thread_m(){
    intersection(){
        threaded_rod(h=20, d=18, pitch=1.5, anchor=BOTTOM);
        difference(){
            zcyl(h=INCH/2, d=25, anchor=BOTTOM);
            zcyl(h=INCH/2, d=coredims[1]+PRESSFIT, chamfer=-0.3, anchor=BOTTOM);
        }
        // up(INCH/4) zcyl(h=INCH/2, d=coredims[1]+PRESSFIT, chamfer=-0.3);
    }
    up(12) tube(h=1.5, od=18, id=coredims[1]+PRESSFIT, anchor=BOTTOM);
}

module blade_thread_f(flange_thickness, epp_thickness){
    intersection(){
        threaded_nut(nutwidth=50, id=18, h=20, pitch=1.5, anchor=BOTTOM, $slop=0.025, ibevel=false);
        union(){
            zcyl(h=epp_thickness + flange_thickness, d=20, anchor=BOTTOM);
            up(epp_thickness+flange_thickness) zcyl(h=flange_thickness, id=coredims[1], od=18, anchor=BOTTOM);
        }
    }
    tube(h=1.5, id=coredims[1]+CLEARANCE, od=50, anchor=BOTTOM);
    up(epp_thickness+2*flange_thickness) intersection(){
        tube(h=1.5, id=18+CLEARANCE, od=35, anchor=TOP);
        cube([27, 500, 500], anchor=TOP);
    }
}

module tip_3dp_body(flange_od, 
                    flange_depth, 
                    core_pin_depth, 
                    core_to_epp_dist,
                    epp_pin_depth){

    zcyl(h=core_pin_depth, d=coredims[0]-CLEARANCE, chamfer1=1, anchor=TOP);
    zcyl(h=core_to_epp_dist, d=flange_od, anchor=BOTTOM);
    
    h = flange_depth-core_to_epp_dist;
    difference(){
        zcyl(h=h, d=flange_od, chamfer1=h, chamfang=atan2(h, flange_od/2 - (coredims[1]/2 + 1)), from_end=true, anchor=TOP);
        zcyl(h=h, d=coredims[1]+CLEARANCE, chamfer1=-0.5, anchor=TOP);
    }
    up(core_to_epp_dist) zcyl(h=epp_pin_depth, d=12, chamfer2=0.5, anchor=BOTTOM);
}

module tip_3dp_component(
    flange_od, 
    flange_depth, 
    core_pin_depth, 
    core_to_epp_dist,
    epp_pin_depth,
    anchor = CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name = "core_anchor", pos = core_to_epp_dist*DOWN, orient = DOWN),
        named_anchor(name = "epp_anchor", pos = CENTER, orient = UP),
    ];
    attachable(anchor, spin, orient, 
        flange_od=flange_od, 
        flange_depth=flange_depth, 
        core_pin_depth=core_pin_depth, 
        core_to_epp_dist=core_to_epp_dist,
        epp_pin_depth=epp_pin_depth,
        anchors=anchors
    ){
        tip_3dp_body(flange_od, flange_depth, core_pin_depth, core_to_epp_dist, epp_pin_depth);
        children();
    }

}



// tip_3dp_component(40, 4, 12, 1, 9);
difference(){
union(){
    up(1.5) zrot(180) blade_thread_m();
    blade_thread_f(1.5, 12);
}
cube(100, anchor=LEFT);
}
// core(1900);


