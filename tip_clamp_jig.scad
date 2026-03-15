include <BOSL2/std.scad>
include <params.scad>

// @build extras/tip_clamp_jig.stl
module tip_clamp_jig(){
  intersection(){
    union(){
      tube(id=NOODLE_OD, od=NOODLE_OD+4, h=2*(TIP_THICKNESS+EPP_THICKNESS), anchor=CENTER);
      for(pos=[TIP_THICKNESS+EPP_THICKNESS+1, -TIP_THICKNESS-EPP_THICKNESS-1]) up(pos) {
	  tube(id=22, od=NOODLE_OD+4, h=2, anchor=CENTER);
	}
    }
    cube([30, 1000, 1000], anchor=CENTER);
  }
}
