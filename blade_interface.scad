include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <params.scad>

$collet_id=20;
$collet_od=22;
$flange_thickness=1.5;
$n_splines = 6;
$spline_id = 15.5;
$spline_od = 17;
$spline_chamfer_angle = 30;

// uses: $n_splines, $spline_id, $spline_od, $spline_chamfer_angle
module _spline_cyl(){
    n_splines = $n_splines;
    spline_id = $spline_id;
    od = $spline_od;
    chamfer_angle = $spline_chamfer_angle;
    difference(){
        zcyl(h=INCH/2+(od-spline_id)/2, d=od, chamfer1=0.5, anchor=BOTTOM);
        linear_extrude(height=INCH/2+(od-spline_id)/2) difference(){
            circle(d=od+1);
            circle(d=spline_id);
            angular_width = (360/n_splines)/2;
            ir = spline_id/2;
            or = od/2+1;
            inner_point_start = [ir, 0];
            outer_point_start = circle_line_intersection(r=or, cp=[0, 0], line=[inner_point_start, inner_point_start + [cos(chamfer_angle), sin(chamfer_angle)]], bounded=[true, false])[0];
            chamfer_angular_width = atan2(outer_point_start[1], outer_point_start[0]);
            outside_point = (or/cos((angular_width-chamfer_angular_width)/2))*[cos((angular_width+chamfer_angular_width)/2), sin((chamfer_angular_width+angular_width)/2)];
            inner_point_end = ir*[cos(angular_width+chamfer_angular_width), sin(angular_width+chamfer_angular_width)];
            outer_point_end = circle_line_intersection(r=or, cp=[0, 0], line=[inner_point_end, inner_point_end+[cos(angular_width+chamfer_angular_width-chamfer_angle), sin(angular_width+chamfer_angular_width-chamfer_angle)]], bounded=[true, false])[0];
            for(theta=[0:(360/n_splines):359]){
                zrot(theta-(angular_width+chamfer_angular_width)/2) polygon([
                    [0, 0], 
                    inner_point_start,
                    outer_point_start,
                    outside_point,
                    outer_point_end,
                    inner_point_end,
                ]);
            }
        }
        up(INCH/2) difference(){
            zcyl(h=od-spline_id, d=od, anchor=BOTTOM);   
            zcyl(h=od-spline_id, d=spline_id, chamfer=-(od-spline_id)/2, anchor=BOTTOM);
        }
    }
}

// uses $n_splines, $spline_id, $spline_od, $spline_chamfer_angle
module blade_m_body(){
    difference(){
        union(){
            _spline_cyl();
            zcyl(h=INCH, d=$spline_id, anchor=BOTTOM);
            up(7) zcyl(h=4, d=$spline_od, chamfer=1.5, anchor=BOTTOM);
        }
        zcyl(h=INCH, d=COREDIMS[1]+PRESSFIT, chamfer=-0.25, anchor=BOTTOM);
    }
}

// uses $n_splines, $spline_id, $spline_od, $spline_chamfer_angle
// @build blade_m.stl
module blade_m(
    anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="blade_spline_interface", pos=CENTER, orient=UP),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        blade_m_body();
        children();
    }
}

// uses $flange_thickness, $collet_id, $collet_od, $n_splines, $spline_id, $spline_od, $spline_chamfer_angle
module blade_f_body(
    n_splines_per_segment,
    bladeside_flange_od,
    handside_flange_od,
    slot_angular_size,
    real_epp_height){
    
    n_splines = $n_splines;
    spline_id = $spline_id;

    difference(){
        union(){
            down($flange_thickness) zcyl(h=INCH/2+$flange_thickness, d=BLADE_EPP_ID, anchor=BOTTOM);
            zcyl(h=$flange_thickness, d=bladeside_flange_od, anchor=TOP);
        }
        difference(){
            zcyl(h=INCH/2, d=$collet_od, anchor=BOTTOM);
            zcyl(h=INCH/2, d=$collet_id, chamfer2=0.25, anchor=BOTTOM);
        }
        s = ($spline_od+CLEARANCE)/$spline_od;
        scale([s, s, 1]) blade_m();
        zcyl(h=INCH/2, d=s*spline_id, anchor=BOTTOM);
        for(i=[0:(360/(n_splines/n_splines_per_segment)):359]){
            up(2) linear_extrude(INCH/2) polygon([
                [0, 0],
                0.25*($collet_id+$collet_od)*[cos(i-slot_angular_size/2), sin(i-slot_angular_size/2)],
                0.25*($collet_id+$collet_od)*[cos(i+slot_angular_size/2), sin(i+slot_angular_size/2)],
            ]);
        }
        zcyl(h=INCH/2, d=spline_id, chamfer2=-1, anchor=BOTTOM);
        zcyl(h=100, d=COREDIMS[1]+CLEARANCE*2);
    }
    up(real_epp_height) difference(){
        zcyl(h=$flange_thickness, d=handside_flange_od, anchor=BOTTOM);
        zcyl(h=$flange_thickness, d=$collet_od, anchor=BOTTOM);
    }
}

// uses $flange_thickness, $collet_id, $collet_od, $n_splines, $spline_id, $spline_od, $spline_chamfer_angle
// @build blade_f.stl
module blade_f(
    n_splines_per_segment=2,
    bladeside_flange_od=40,
    handside_flange_od=0,
    slot_angular_size=4,
    real_epp_height=EPP_THICKNESS, //INCH/2-$flange_thickness,
    anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="blade_spline_interface", pos=CENTER, orient=DOWN),
        named_anchor(name="epp_hand_side", pos=UP*EPP_THICKNESS, orient=DOWN),
        named_anchor(name="epp_blade_side", pos=CENTER, orient=DOWN),
        named_anchor(name="collet_interface", pos=UP*real_epp_height)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        blade_f_body(n_splines_per_segment, bladeside_flange_od, handside_flange_od, slot_angular_size, real_epp_height);
        children();
    }
}

// uses $flange_thickness, $collet_id, $collet_od
// @build collet.stl
module collet(h=INCH/4, anchor=CENTER, spin=0, orient=UP){
    anchors = [
        named_anchor(name="collet_interface", pos=CENTER, orient=DOWN),
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        difference(){
            union(){
                zcyl(h=h, d=$collet_od-PRESSFIT/2, chamfer1=0.2, chamfang=70, anchor=TOP);
                zcyl(h=2, d=$collet_od+6, chamfer1=1.5, anchor=BOTTOM);
            }
            zcyl(h=2*h+2, d=$collet_id+PRESSFIT/2, chamfer1=-0.2, anchor=CENTER);
            // pie_slice(h = INCH/2+flange_thickness, d = od*2, ang=6, anchor = BOTTOM);
        }
        children();
    }

}

intersection(){
    up(12.7) collet();
    cube(1000, anchor=LEFT);
}

difference(){
    blade_m();
    cube(1000, anchor=RIGHT);
}
difference(){
    blade_f();
    cube(1000, anchor=RIGHT);
}        