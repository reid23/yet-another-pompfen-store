function hermite(t, p0, p1, v0, v1) = (
    [[t*t*t, t*t, t, 1]]
  * [[2, -2, 1, 1], 
     [-3, 3, -2, -1], 
     [0, 0, 1, 0], 
     [1, 0, 0, 0]]
  * [p0,p1,v0,v1]
)[0];

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
        polygon(concat(
            [[0, 0]], 
            [for(i=[0:1:slot_angular_size]) 2*or*cos_sin(i)],
            [2*or*cos_sin(slot_angular_size)]
        ));

        // polygon([[0, 0], 2*or*[1, 0], 2*or*[cos(slot_angular_size), sin(slot_angular_size)]]);
        polygon([
            cos_sin(startsideangles[0])     * ir,
            cos_sin(startsideangles[1])     * (ir+chamfer_size),
            cos_sin(startsideangles[2])     * (or-chamfer_size),
            cos_sin(startsideangles[3])     * or,
            cos_sin(startsideangles[3])     * or*2,
            cos_sin(startsideangles[2])     * or*2,
            cos_sin(startsideangles[1])     * (ir-chamfer_size)
        ]);
        polygon([
            cos_sin(endsideangles[2])       * (ir-chamfer_size),
            cos_sin(endsideangles[1])       * 2*or,
            cos_sin(endsideangles[0])       * 2*or,
            cos_sin(endsideangles[0])       * or,
            cos_sin(endsideangles[1])       * (or-chamfer_size),
            cos_sin(endsideangles[2])       * (ir+chamfer_size),
            cos_sin(endsideangles[3])       * ir,
        ]);
    }
}