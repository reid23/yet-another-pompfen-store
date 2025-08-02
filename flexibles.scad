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

module staff_grip(
    min_wall_thickness=4,
    od=GUARD_OD*0.75,
    total_length=50,
    start_height=3,
    th1=30,
    th2=10,
    w1=100,
    w2=50){
    p0 = [od/2, start_height];
    p1 = [COREDIMS[1]+min_wall_thickness, total_length];
    v0 = [cos(90+th1), sin(90+th1)]*w1;
    v1 = [cos(90+th2), sin(90+th2)]*w2;
    rotate_extrude() polygon(concat(
        [[COREDIMS[1], total_length], [COREDIMS[1], 0], [od/2, 0]],
        [for(i=[0:0.01:1]) hermite(i, p0, p1, v0, v1)])
    );
}

//* dummy module for now!!! fill in later
module pommel_body(){
    difference(){
        up(30) zcyl(h=50, d=50, anchor=BOTTOM);
        zcyl(h=50, d=COREDIMS[1], anchor=BOTTOM);
    }
}
// staff_grip();