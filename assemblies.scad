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
    tip_thread_f()
    attach("effective_core_top", "core_anchor")
    tip_thread_m()
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
                attach("blade_epp_top", "epp_blade_side")
                    blade_f(){
                        attach("blade_spline_interface", "blade_spline_interface")
                            blade_m();
                        attach("collet_interface", "collet_interface")
                            collet();
                    }
            }
    }
}

long();