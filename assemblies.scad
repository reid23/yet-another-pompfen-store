include <BOSL2/std.scad>
include <params.scad>
include <flexibles.scad>
include <core.scad>
include <threaded.scad>
include <splined.scad>
include <epp.scad>
include <foam.scad>
module long(){
    pommel()
    attach("core_end", "core_bottom")
    long_core()
    attach("core_top", "carbon_core_tip")
    tip_thread_f(depth=8, above_core_height=2, $pitch=1.5, $starts=2, $major_d=COREDIMS[0]-0.4*4)
    attach("effective_core_top", "core_anchor")
    tip_thread_m(flange_od=30, flange_depth=3.1, core_pin_depth=8, core_to_epp_dist=1, epp_pin_depth=9)
    attach("epp_anchor", "tip_epp_bottom")
    tip_epp(){
        attach("tip_epp_top", "tip_noodle_bottom")
            tip_noodle();
        attach("tip_epp_bottom", "core_tip")
            blade_noodle()
            attach("hand_side", "blade_epp_top")
            blade_epp(){
                attach("blade_epp_bottom", "buffer_top")
                    buffer_noodle();
                attach("blade_epp_top", "blade_epp_bond")
                    blade_assy();
            }
    }
}

long();