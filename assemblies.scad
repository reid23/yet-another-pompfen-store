include <BOSL2/std.scad>
include <params.scad>

use <pommel.scad>
use <staff_grip.scad>
use <tip_interface.scad>
use <guard_interface.scad>
use <blade_interface.scad>

use <core.scad>
use <epp.scad>
use <foam.scad>

$fn = 100;
$include_dfm = false;

module blade(length, buffer=true){
    noodle_length = length
        - (buffer ? BUFFER_THICKNESS : 0)
        - 3*EPP_THICKNESS // 2 on blade side + radial tip epp (axial tip epp is included in TIP_THICKNESS)
        - TIP_THICKNESS;

    tip_thread_m()
    attach("epp_anchor", "tip_epp_axial_bottom")
    tip_epp_axial(){
        attach("tip_epp_axial_top", "tip_noodle_bottom")
            tip_noodle();
        attach("tip_epp_axial_bottom", "tip_epp_radial_top")
            tip_epp_radial()
                attach("tip_epp_radial_bottom", "core_tip")
                    blade_noodle(noodle_length)
                        attach("hand_side", "blade_epp_foamside_top")
                            blade_epp_foamside()
                                attach("blade_epp_foamside_bottom", "blade_epp_handside_top")
                                    blade_epp_handside(){
                                        if(buffer)
                                            attach("blade_epp_handside_bottom", "buffer_top")
                                                buffer_noodle();
                                        attach("blade_epp_handside_top", "epp_blade_side", inside=true)
                                            blade_f(){
                                                attach("blade_spline_interface", "blade_spline_interface")
                                                    blade_m();
                                                attach("collet_interface", "collet_interface")
                                                    collet();
                                            }
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
                blade(LONG_BLADE);
}

module short_tla(){
    pommel() attach("core_end", "core_bottom")
        short_core() attach("core_top", "carbon_core_tip")
            tip_thread_f() attach("effective_core_top", "core_anchor")
                blade(SHORT_BLADE);
}

module staff_tla(){
    pommel()
    attach("core_end", "core_bottom")
    staff_core(){
        attach("core_top", "carbon_core_tip")
            tip_thread_f()
                attach("effective_core_top", "core_anchor")
                    blade(LONG_BLADE);
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
                    blade(LONG_BLADE);
        attach("reach_limit", "grip_top")
            staff_guard(GUARD_OD, SHORT_GUARD_LEN);
    }
}

module qtip_tla(){
    qtip_core(anchor="bottom_tip"){
        attach("core_bottom", "carbon_core_tip", inside=true)
            tip_thread_f()
                attach("effective_core_top", "core_anchor")
                    blade(QTIP_BLADE, buffer=false);
        attach("core_top", "carbon_core_tip")
            tip_thread_f()
                attach("effective_core_top", "core_anchor")
                    blade(QTIP_BLADE, buffer=false);
    }

}

right(000) long_tla();
right(100) short_tla();
right(200) staff_tla();
right(300) short_staff_tla();
right(400) qtip_tla();