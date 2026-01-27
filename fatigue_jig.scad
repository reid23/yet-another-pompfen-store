include <BOSL2/std.scad>
$fn = 200;

module hole_pattern(){
  for(i=[[10, 0, 0],
	 [25, 0, 0],
	 [40, 0, 0],
	 [25, -20, 0]]){
    translate(i)
      children();
  }
}

module strain_gauge_mount_side(){
  difference(){
    hull(){
      hole_pattern()
        circle(d=20);
      translate([10, 35, 0])
	circle(d=20);
    }
    hole_pattern()
      circle(d=4);
  }
}

module counterbored(depth, bore_d=4.2, head_d=8){
  cylinder(h=depth, d=bore_d);
  translate([0, 0, depth])
    cylinder(h=1000, d=head_d);
}

// @build extras/fatigue_jig_strain_guage_mount.stl width=80.5
module strain_guage_mount(width){
  difference(){
    union(){
      translate([0, 0, -10]) linear_extrude(10) strain_gauge_mount_side();
      translate([0, 0, width]) linear_extrude(10) strain_gauge_mount_side();
      intersection(){
	linear_extrude(width) strain_gauge_mount_side();
	translate([0, 7, 0]) cube([1000, 1000, width]);
      }
    }
    translate([0, 0, width/2]){
      translate([0, 15, 0])
	rotate([0, 90, 0]) counterbored(16, bore_d=5.2, head_d=11);
      translate([0, 15+15, 0])
	rotate([0, 90, 0]) counterbored(16, bore_d=5.2, head_d=11);
    }
  }
}

// @build extras/fatigue_jig_bumper.stl
module bumper(){
  difference(){
    union(){
      difference(){
	translate([0, 0, -10]) rotate([0, 90, 0]) cylinder(h=70, d=70, center=true);
	translate([0, 0, -100]) cube(200, center=true);
      }
      translate([0, 0, 5]) cube([25, 16, 30], center=true);
    }
    translate([7.5, 0, -10]) counterbored(20);
    translate([-7.5, 0, -10]) counterbored(20);

  }
}


module sample_mount_plate_hole_pattern(h){
  for(v=[[0, 0, 0],
	 [50, 0, 0],
	 [0, h, 0]]){
	translate(v) children();
  }
}

// @build extras/fatigue_jig_sample_mount_1.stl height=100
module sample_mount_plate(height){
  difference(){
    union(){
      hull(){
	sample_mount_plate_hole_pattern(height)
	  cylinder(h=10, d=14);
      }
      translate([0, height, 0]) cylinder(h=25, d=11.5);
    }
    sample_mount_plate_hole_pattern(height)
      cylinder(h=100, d=3.5);
  }
}

// @build extras/fatigue_jig_sample_mount_2.stl height=100
module mirrored_sample_mount_plate(height){
  mirror([0, 0, 1]) sample_mount_plate(height);
}

// bumper();
// strain_guage_mount(width = 80.5);
// sample_mount_plate(100);
