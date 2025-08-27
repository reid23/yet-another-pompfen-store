include <BOSL2/std.scad>
include <params.scad>

function hermite(t, p0, p1, v0, v1) = (
    [[t*t*t, t*t, t, 1]]
  * [[2, -2, 1, 1], 
     [-3, 3, -2, -1], 
     [0, 0, 1, 0], 
     [1, 0, 0, 0]]
  * [p0,p1,v0,v1]
)[0];

// @build staff_grip.stl
module staff_grip(
    min_wall_thickness=4,
    od=GUARD_OD*0.75,
    id=INCH,
    total_length=45,
    start_height=3,
    th1=30,
    th2=10,
    w1=100,
    w2=50,

    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="grip_top", pos=total_length*UP, orient=DOWN),
        named_anchor(name="grip_bottom", pos=CENTER, orient=UP)
    ];
    p0 = [od/2, start_height];
    p1 = [id/2+min_wall_thickness, total_length];
    v0 = [cos(90+th1), sin(90+th1)]*w1;
    v1 = [cos(90+th2), sin(90+th2)]*w2;
    attachable(anchor, spin, orient, anchors=anchors){
        rotate_extrude() polygon(concat(
            [[id/2, total_length], [id/2, 0], [od/2, 0]],
            [for(i=[0:0.01:1]) hermite(i, p0, p1, v0, v1)])
        );
        children();
    }
}

// staff_grip() show_anchors(std=false);

function rad2deg(x) = x*180/3.14159265358979;
function cos_sin(theta) = [cos(theta), sin(theta)];

module _chamfered_slotted_ring(ir, or, slot_angular_size, chamfer_size){
    startsideangles = [
        -rad2deg(chamfer_size/ir), 
        0.0, 
        0.0, 
        -rad2deg(chamfer_size/or)
    ];
    endsideangles   = [
        slot_angular_size+rad2deg(chamfer_size/or),
        slot_angular_size, 
        slot_angular_size, 
        slot_angular_size+rad2deg(chamfer_size/ir)
    ];
    difference(){
        circle(r=or);
        circle(r=ir);
        polygon([[0, 0], 2*or*[1, 0], 2*or*[cos(slot_angular_size), sin(slot_angular_size)]]);
        polygon([
            cos_sin(startsideangles[0])     * ir,
            cos_sin(startsideangles[1])     * (ir+chamfer_size),
            cos_sin(startsideangles[2])     * (or-chamfer_size),
            cos_sin(startsideangles[3])     * or,
            cos_sin(slot_angular_size/2)    * or*5,
            cos_sin(endsideangles[0])       * or,
            cos_sin(endsideangles[1])       * (or-chamfer_size),
            cos_sin(endsideangles[2])       * (ir+chamfer_size),
            cos_sin(endsideangles[3])       * ir,
        ]);
    }
}

// @build staff_spacer.stl
module staff_spacer(
    od=INCH,
    slot_angular_size=4,
    height=45,
    shoulder_od=22,
    shoulder_height=2,
    
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="screw_side_anchor", pos=shoulder_height*DOWN, orient=DOWN),
        named_anchor(name="spacer_top", pos=height*UP, orient=UP)
    ];
    id = COREDIMS[1];
    r_c = 1; // rad of chamfer
    attachable(anchor, spin, orient, anchors=anchors){
        union(){
            linear_extrude(height) 
                _chamfered_slotted_ring(ir = COREDIMS[1]/2, or = od/2, slot_angular_size = slot_angular_size, chamfer_size = r_c);
            down(shoulder_height) linear_extrude(shoulder_height)
                _chamfered_slotted_ring(ir = COREDIMS[1]/2, or = shoulder_od/2, slot_angular_size = slot_angular_size, chamfer_size = r_c);
        }
        children();
    }
}
// staff_spacer() show_anchors(std=false);

module pommel_body(height=32, r_fillet=10, r_main=47, x_main=60){
    function r(x) = sqrt((x-10)^2 - 100^2) + y_main;
    id = COREDIMS[1]-0.5;
    od = POMMEL_OD;
    base_thickness = POMMEL_THICKNESS;
    echo(id);
    difference(){
        union(){
            y_fillet = r_fillet*sin(45);
            fillet_c = [od/2 - r_fillet, y_fillet];
            rotate_extrude(){
                difference(){
                    translate([fillet_c.x, fillet_c.y])
                        circle(r=r_fillet);
                    translate([0, -20])
                        square([od, 20]);
                }
            }
            y_main = sqrt(-(x_main - fillet_c.x)^2 + (r_fillet + r_main)^2) + fillet_c.y;
            tangent_pt = [cos(atan2((y_main-fillet_c.y), (x_main-fillet_c.x)))*r_fillet + fillet_c.x, sin(atan2((y_main-fillet_c.y), (x_main-fillet_c.x)))*r_fillet + fillet_c.y];
            rotate_extrude(){
                difference(){
                    translate([id/2, tangent_pt.y])
                        square([(od-id)/2, height-tangent_pt.y]); 
                    translate([x_main, y_main])
                        circle(r=r_main);
                }
            }
            rotate_extrude(){
                translate([id/2, 0])
                    square([fillet_c.x - id/2, tangent_pt.y]);
                square([fillet_c.x, base_thickness]);
            }
            top_edge = [- sqrt((r_main)^2 - (height-y_main)^2) + x_main, height];
            slope = -(top_edge.x - x_main)/(top_edge.y - y_main);
            y_offset = slope*(-top_edge.x) + top_edge.y;
            pts = [for(x=[(id/2 + 1):0.1:(top_edge.x+0.1)]) [x, slope*x + y_offset]];
            pts_final = concat([[id/2, slope*(id/2+1) + y_offset]], pts, [[id/2, top_edge.y]]);
            rotate_extrude(){
                polygon(pts_final);
            }
        }
        rotate_extrude(){
            r_pocket = 0.5;
            translate([id/2, base_thickness+r_pocket]){
                circle(r_pocket);
                polygon([[0, 0], [r_pocket*cos(30), r_pocket*sin(30)], [0, r_pocket/sin(30)]]);
            }
            translate([id/2-r_pocket, base_thickness]){
                square([r_pocket, r_pocket]);
            }
        }
    }
}

// anchors: `core_end` and `bottom`
// @build pommel.stl
module pommel(height=32, r_fillet=10, r_main=47, x_main=60,
    anchor=CENTER,
    spin=0,
    orient=UP){
    anchors = [
        named_anchor(name="core_end", pos=POMMEL_THICKNESS*UP, orient=DOWN),
        named_anchor(name="bottom", pos=CENTER, orient=UP)
    ];
    attachable(anchor, spin, orient, anchors=anchors){
        pommel_body(height=height, r_fillet=r_fillet, r_main=r_main, x_main=x_main);
        children();
    }
}

// @build pommel_modifier.stl
module pommel_modifier(d_solid=30, chamfang=45){
    up(5) zcyl(h=100, d=100, chamfer1=(100-d_solid)/2, chamfang=chamfang, anchor=BOTTOM);
}

