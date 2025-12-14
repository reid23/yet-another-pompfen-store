include <BOSL2/std.scad>
include <params.scad>

module pommel_body(height=32, r_fillet=10, r_main=47, x_main=60){
    function r(x) = sqrt((x-10)^2 - 100^2) + y_main;
    id = COREDIMS[1]-1;
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
