include <BOSL2/std.scad>
include <params.scad>

include <pommel.scad>
include <staff_grip.scad>
include <tip_interface.scad>
include <guard_interface.scad>
include <blade_interface.scad>

include <core.scad>
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
        attach("grip_top", "grip_collar_top")
            guard_grip_collar();
        attach("grip_top", "spacer_top")
            staff_spacer()
                attach("screw_side_anchor", "guard_thread_top")
                    guard_thread_m()// attach("guard_top_thread_reference", "guard_thread_ref_surface")
                        attach("guard_thread_flange_top", "guard_thread_ref_surface")
                            guard_thread_f(){
                                attach("guard_epp_attachment", "epp_bottom")
                                    guard_epp(od);
                                attach("guard_epp_attachment", "guard_foam_top", inside=true)
                                    guard_foam(od, length){
                                        attach("guard_foam_center", "guard_spacer_center", inside=false)
                                            staff_guard_spacer();
                                        attach("guard_foam_center", "guard_spacer_center", inside=true)
                                            staff_guard_spacer();                                        
                                        attach("guard_foam_bottom", "epp_top", inside=true)
                                            guard_epp(od){
                                                attach("epp_bottom", "guard_spacer_bottom")
                                                    staff_guard_spacer();
                                                attach("epp_bottom", "guard_spacer_top", inside=true)
                                                    staff_guard_spacer();
                                            }
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
    qtip_core(anchor="bottom_tip"){
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

right(0) long_tla();
right(100) short_tla();
right(200) staff_tla();
right(300) short_staff_tla();
right(400) qtip_tla();