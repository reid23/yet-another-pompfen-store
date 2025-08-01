module tip_foam(tip_thickness=50, tip_foam_thickness=33, tip_diameter=70){
    up(tip_thickness) zcyl(h=tip_foam_thickness, d=tip_diameter anchor=TOP);
}