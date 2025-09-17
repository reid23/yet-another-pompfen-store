include <BOSL2/std.scad>
include <params.scad>
include <flexibles.scad>
include <core.scad>
include <threaded.scad>
include <splined.scad>
include <epp.scad>
include <foam.scad>

$fn = 100;
$include_dfm = false;

module long_blade(){
    tip_thread_m()
    attach("epp_anchor", "tip_epp_bottom")
    tip_epp(){
        attach("tip_epp_top", "tip_noodle_bottom")
            tip_noodle();
        attach("tip_epp_bottom", "core_tip")
            long_blade_noodle()
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
module short_blade(){
    tip_thread_m()
    attach("epp_anchor", "tip_epp_bottom")
    tip_epp(){
        attach("tip_epp_top", "tip_noodle_bottom")
            tip_noodle();
        attach("tip_epp_bottom", "core_tip")
            short_blade_noodle()
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

module qtip_blade(){
    tip_thread_m()
    attach("epp_anchor", "tip_epp_bottom")
    tip_epp(){
        attach("tip_epp_top", "tip_noodle_bottom")
            tip_noodle();
        attach("tip_epp_bottom", "core_tip")
            short_blade_noodle()
                attach("hand_side", "blade_epp_top")
                    blade_epp()
                        attach("blade_epp_top", "epp_blade_side")
                            blade_f(){
                                attach("blade_spline_interface", "blade_spline_interface")
                                    blade_m();
                                attach("collet_interface", "collet_interface")
                                    collet();
                            }
    }
}

module staff_guard(od=GUARD_OD, length=GUARD_LEN){
    staff_grip(){
        attach("grip_top", "spacer_top")
            staff_spacer()
                attach("screw_side_anchor", "guard_top_thread_reference")
                    guard_thread_m();// attach("guard_top_thread_reference", "guard_thread_ref_surface")
        attach("grip_top", "grip_collar_top")
            guard_grip_collar();
        attach("grip_bottom", "guard_f_top")
            guard_thread_f(){
                attach("guard_epp_attachment", "epp_bottom")
                    guard_epp(od);
                attach("guard_epp_attachment", "guard_foam_top", inside=true)
                    guard_foam(od, length){
                        attach("guard_foam_bottom", "epp_top", inside=true)
                            guard_epp(od);
                        attach("guard_foam_bottom", "guard_epp_attachment")
                            guard_thread_f()
                                attach("guard_thread_ref_surface", "guard_lower_thread_flange_top", inside=true)
                                    lower_guard_thread_m();
                    }
            }
         
    }
}

module long_tla(){
    pommel() attach("core_end", "core_bottom")
        long_core() attach("core_top", "carbon_core_tip")
            tip_thread_f() attach("effective_core_top", "core_anchor")
                long_blade();
}

module short_tla(){
    pommel() attach("core_end", "core_bottom")
        short_core() attach("core_top", "carbon_core_tip")
            tip_thread_f() attach("effective_core_top", "core_anchor")
                short_blade();
}

module staff_tla(){
    pommel()
    attach("core_end", "core_bottom")
    staff_core(){
        attach("core_top", "carbon_core_tip")
            tip_thread_f()
                attach("effective_core_top", "core_anchor")
                    long_blade();
        attach("reach_limit", "grip_top")
            staff_guard();
    }
}

module short_staff_tla(){
    pommel()
    attach("core_end", "core_bottom")
    short_staff_core(){
        attach("core_top", "carbon_core_tip")
            tip_thread_f()
                attach("effective_core_top", "core_anchor")
                    long_blade();
        attach("reach_limit", "grip_top")
            staff_guard(GUARD_OD, SHORT_GUARD_LEN);
    }
}

module qtip_tla(){
    qtip_core(){
        attach("core_bottom", "carbon_core_tip", inside=true)
            tip_thread_f()
                attach("effective_core_top", "core_anchor")
                    qtip_blade();
        attach("core_top", "carbon_core_tip")
            tip_thread_f()
                attach("effective_core_top", "core_anchor")
                    qtip_blade();
    }

}

// long_tla();
// short_tla();
// staff_tla();
// short_staff_tla();
// qtip_tla();
// up(-53+2000) #zcyl(r=100, h=1, anchor=BOTTOM);
// intersection(){
// staff_grip(){
//     attach("grip_top", "spacer_top")
//         staff_spacer()
//             attach("screw_side_anchor", "guard_top_thread_reference")
//                 guard_thread_m();// attach("guard_top_thread_reference", "guard_thread_ref_surface")
//     attach("grip_bottom", "guard_f_top")
//         guard_thread_f();
//     attach("grip_top", "grip_collar_top")
//         guard_grip_collar();

// }
// cube(1000, anchor=BACK);
// }