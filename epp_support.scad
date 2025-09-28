include <BOSL2/std.scad>
include <params.scad>

$kerf = 2.25;

module row(result_od, result_id){
    od = result_od + 2*$kerf;
    r = od/2;
    back(r){
        right(r){
            tube(od=result_od-10, id=result_id+10, h=10, anchor=BOTTOM);
            right(od){
                tube(od=result_od-10, id=result_id+10, h=10, anchor=BOTTOM);
                right(od){
                    tube(od=result_od-10, id=result_id+10, h=10, anchor=BOTTOM);
                }
            }
        }
    }
}
// @build epp_support_blade.stl result_od=NOODLE_OD, result_id=BLADE_EPP_ID
// @build epp_support_wide_guard.stl result_od=GUARD_OD, result_id=GUARD_EPP_ID
// @build epp_support_narrow_guard.stl result_od=SMALL_GUARD_OD, result_id=GUARD_EPP_ID
module epp_support(result_od, result_id){
    od = result_od + 2*$kerf;
    r = od/2;
    row(result_od, result_id);
    back(od) row(result_od, result_id);
    cube([od*3, od*2, 3]);
}