include <BOSL2/std.scad>;

module core(id=12, od=14, l=2000){
    difference(){
        zcyl(h=l, d=od, anchor=BOTTOM);
        zcyl(h=l, d=id, anchor=BOTTOM);
    }
}

module short_core(pommel_thickness=25, tip_thickness=50){
    up(pommel_thickness) core(l=85-pommel_thickness-tip_thickness, anchor=BOTTOM);
}

module staff_core(pommel_thickness=25, tip_thickness=50){
    up(pommel_thickness) core(l=180-pommel_thickness-tip_thickness, anchor=BOTTOM);
}

module long_core(pommel_thickness=25, tip_thickness=50){
    up(pommel_thickness) core(l=180-pommel_thickness-tip_thickness, anchor=BOTTOM);
}

module qtip_core(tip_thickness=50){
    up(pommel_thickness) core(l=200-2*tip_thickness, anchor=BOTTOM);
}

module short_staff_core(pommel_thickness=25, tip_thickness=50){
    up(pommel_thickness) core(l=170-pommel_thickness-tip_thickness, anchor=BOTTOM);
}
