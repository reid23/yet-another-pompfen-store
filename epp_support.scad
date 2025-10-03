include <BOSL2/std.scad>
include <params.scad>

$kerf=2.25;

// @build epp_support_blade.stl result_od=NOODLE_OD, result_id=BLADE_EPP_ID
// @build epp_support_wide_guard.stl result_od=GUARD_OD, result_id=GUARD_EPP_ID, ncols=2
// @build epp_support_narrow_guard.stl result_od=SMALL_GUARD_OD, result_id=GUARD_EPP_ID
module epp_support(result_od, result_id, nrows=2, ncols=3){
    od = result_od + 2*$kerf;
    r = od/2;
    translate([r, r, 0])
    for(i=[0:nrows-1]){
        for(j=[0:ncols-1]){
            translate([od*j, od*i, 0]) 
                tube(od=result_od-10, id=result_id+10, h=10, anchor=BOTTOM);
        }
    }
    cube([od*ncols, od*nrows, 3]);
}