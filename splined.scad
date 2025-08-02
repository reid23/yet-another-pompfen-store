include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <params.scad>

module spline_cyl(n_splines, spline_id, od, chamfer_angle){
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
module blade_m(n_splines, spline_id, od, chamfer_angle){
    difference(){
        union(){
            up(CLEARANCE) spline_cyl(n_splines, spline_id, od, chamfer_angle);
            up(CLEARANCE) zcyl(h=INCH, d=spline_id, anchor=BOTTOM);
            up(7) zcyl(h=4, d=od, chamfer=1.5, anchor=BOTTOM);
        }
        zcyl(h=INCH, d=COREDIMS[1]+PRESSFIT, chamfer=-0.25,anchor=BOTTOM);
    }
}


module blade_f(n_splines=6, spline_id=15, od=17, chamfer_angle=45, n_splines_per_segment=2, flange_od=40, flange_thickness=1.5, collet_id=19, collet_od=21, epp_id = 22, slot_angular_size=4){
    difference(){
        union(){
            down(flange_thickness) zcyl(h=INCH/2+flange_thickness, d=epp_id, anchor=BOTTOM);
            zcyl(h=flange_thickness, d=flange_od, anchor=TOP);
        }
        difference(){
            zcyl(h=INCH/2, d=collet_od, anchor=BOTTOM);
            zcyl(h=INCH/2, d=collet_id, chamfer2=0.25, anchor=BOTTOM);
        }
        s = (od+CLEARANCE)/od;
        scale([s, s, 1]) blade_m(n_splines, spline_id, od, chamfer_angle);
        zcyl(h=INCH/2, d=spline_id, anchor=BOTTOM);
        for(i=[0:(360/(n_splines/n_splines_per_segment)):359]){
            echo(i);
            up(2) linear_extrude(INCH/2) polygon([
                [0, 0],
                0.25*(collet_id+collet_od)*[cos(i-slot_angular_size/2), sin(i-slot_angular_size/2)],
                0.25*(collet_id+collet_od)*[cos(i+slot_angular_size/2), sin(i+slot_angular_size/2)],
            ]);
        }
        zcyl(h=INCH/2, d=spline_id, chamfer2=-1, anchor=BOTTOM);
        zcyl(h=100, d=COREDIMS[1]+CLEARANCE*2);
    }
    // #blade_m(n_splines, spline_id, od, chamfer_angle);
}

module collet(id, od, flange_thickness){
    difference(){
        union(){
            up(INCH/2) zcyl(h=INCH/4, d=od-PRESSFIT/2, chamfer1=0.2, anchor=TOP);
            up(INCH/2) zcyl(h=2, d=od+6, anchor=BOTTOM);
        }
        zcyl(h=INCH/2+2, d=id+PRESSFIT/2, chamfer1=-0.2, anchor=BOTTOM);
        // pie_slice(h = INCH/2+flange_thickness, d = od*2, ang=6, anchor = BOTTOM);
    }
}
module blade_assy(
    n_splines = 6,
    spline_id = 15.5,
    spline_od = 17,
    spline_chamfer = 30,
    n_splines_per_segment = 2,
    flange_od = 30,
    collet_id = 19.25,
    collet_od = 21,
    epp_id = 24,
    flange_thickness = 1.5,
    slot_angular_size = 4){
    blade_m(n_splines, spline_id, spline_od, spline_chamfer);
    blade_f(n_splines, spline_id, spline_od, spline_chamfer, n_splines_per_segment, flange_od, flange_thickness, collet_id, collet_od, epp_id, slot_angular_size);
    up(CLEARANCE) collet(collet_id, collet_od, flange_thickness);
}


// difference(){
//     blade_assy();
//     cube(100, anchor=RIGHT);
// }

// blade_m(chamfer_angle=30);
// blade_m(chamfer_angle=30);