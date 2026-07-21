include <BOSL2/std.scad>
include <BOSL2/geometry.scad>
include <params.scad>

// @build extras/tip_axial_epp_cutter.stl h=10, id=TIP_AXIAL_EPP_ID, od=NOODLE_OD
// @build extras/tip_radial_epp_cutter.stl h=10, id=TIP_RADIAL_EPP_ID, od=NOODLE_OD
// @build extras/blade_handside_epp_cutter.stl h=10, id=BLADE_EPP_ID, od=NOODLE_OD
// @build extras/blade_foamside_epp_cutter.stl h=10, id=COREDIMS[1], od=NOODLE_OD
// @build extras/guard_epp_cutter.stl h=10, id=GUARD_EPP_ID, od=GUARD_OD
module epp_cutter(h, id, od){
  difference(){
    union(){
      zcyl(d=od, h=10, anchor=BOTTOM);
      zcyl(d=od+2, h=1, anchor=TOP);
    }
    fillet_rad = 2;
    linear_extrude(3*h, center=true) for(i=[0, 120, 240]) minkowski() {
	offset(-5) difference() {
	  zrot(i) projection() pie_slice(h=undef, r=od/2-fillet_rad, ang=120);
	  circle(r=id/2+fillet_rad);
	}
	circle(r=fillet_rad);
      }
    zcyl(h=3*h, d=id, center=true);
  }
}

// @build extras/tip_collet.stl h=10, d=TIP_EPP_RADIAL_ID
// @build extras/blade_handside_collet.stl h=10, d=BLADE_EPP_ID
// @build extras/blade_foamside_collet.stl h=10, d=COREDIMS[1]
// @build extras/guard_collet.stl h=10, d=GUARD_EPP_ID
module inner_clamp(h, d) {
  difference(){
    union(){
      zcyl(h=h, d=d, anchor=BOTTOM);
      zcyl(h=2, d=d+5, anchor=TOP, $fn=6);
    }
    zcyl(h=3*h, d1=4, d2=5, anchor=CENTER);
    step = 90;
    for(i=[0,90,180,270]){
      up(3) zrot(i) left(2) zrot(-5) pie_slice(h=h, r=d, ang=10);
      down(3) zrot(i+step/2) left(2) zrot(-5) pie_slice(h=h, r=d, ang=10);
    }
  }
}

// @build extras/blade_epp_cutter_outer_clamp.stl h=10, d=NOODLE_OD
// @build extras/guard_epp_cutter_outer_clamp.stl h=10, d=GUARD_OD
module outer_clamp(h, d, thickness, slot_size){
  difference(){
    tube(id=d, od=d+2*thickness, h=h, anchor=CENTER);
    right(d/2) cube([2*h, slot_size, 2*h], center=true);
  }
  corner = [d/2+thickness+8, slot_size/2+2];
  echo(wut = d/2 + thickness);
  tanpts = circle_point_tangents(r=d/2 + thickness, cp=[0, 0], pt=corner);
  difference(){
    union() for(i = [0,1]) mirror([0,i,0])
    linear_extrude(h, center=true)
      polygon([
	       [d/2, slot_size/2],
	       [d/2+thickness+8, slot_size/2],
	       corner,
	       tanpts[0]
	       ]);
    zcyl(d=d, h=2*h, anchor=CENTER);

    right(d/2+thickness+4){
      ycyl(d=3.2, h=20, anchor=CENTER);
      back(slot_size/2+2) ycyl(d=6, h=20, anchor=FRONT);
      fwd(slot_size/2+2) ycyl(d=6.4, h=20, anchor=BACK, $fn=6);
    }
  }
}

// outer_clamp(10, NOODLE_OD, 2, 2);
// epp_cutter(10, TIP_EPP_RADIAL_ID, NOODLE_OD);
// inner_clamp(10, TIP_EPP_RADIAL_ID);
