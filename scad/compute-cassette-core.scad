// Cassette commune : semelle 3, support vertical 3, facade 4 et oreillette haute 10.
// Le support se colle dans la semelle et la facade via des languettes.
// Les percages des cartes sont ajoutes par chaque variante, pas sur ce gabarit.
// Semelle et support vertical en deux sections : segment 0=avant, 1=arriere.
// Trois cles identiques 6 x 30 x 1.2 : une semelle, deux support vertical.
use <sbc-rack-core.scad>
use <compute-rack-core.scad>
module cc_floor_tabs(clearance=0) {
    drawer_wall_floor_tabs(0,cr_cw(),3,4.15,cr_cd()-.15,3,.15,clearance);
}
module cc_front_tabs(clearance=0) {
    for(z=[15,cr_ch()-15]) translate([1-clearance,2-clearance,z-3-clearance])
        cube([2+2*clearance,2.17+2*clearance,6+2*clearance]);
}
module cc_floor_joint_key(clearance=0) {
    translate([cr_cw()*.78-3,cr_floor_join_y()-15,.9]) cr_joint_key(clearance);
}
module cc_carrier_joint_keys(clearance=0) {
    for(z=[cr_ch()/3,2*cr_ch()/3])
        multmatrix([[0,0,1,.9],[0,1,0,cr_side_join_y()-15],[1,0,0,z-3],[0,0,0,1]])
            cr_joint_key(clearance);
}
module cc_floor() {
    difference() {
        union() {
            translate([0,4.15,0]) cube([cr_cw(),cr_cd()-4.15,3]);
            for(x=[cr_cw()*.3,cr_cw()*.75]) translate([x-3,2,.8]) cube([6,2.17,1.4]);
        }
        cc_floor_tabs(.15);
        cc_floor_joint_key(cr_fit());
        translate([cr_cw()/2-3.2,4,-.02]) cube([6.4,cr_cd(),1.72]);
        translate([0,0,-.02]) linear_extrude(3.04) difference() {
            intersection() { translate([7,14]) square([cr_cw()-14,cr_cd()-22]); cr_hex(cr_cw(),cr_cd()); }
            translate([cr_cw()/2-5,0]) square([10,cr_cd()]);
            translate([0,cr_floor_join_y()-18]) square([cr_cw(),36]);
        }
    }
}
module cc_carrier() {
    union() {
        difference() {
            translate([0,4.15,3.15]) cube([3,cr_cd()-4.3,cr_ch()-3.15]);
            cc_carrier_joint_keys(cr_fit());
            multmatrix([[0,0,1,-.02],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
                linear_extrude(3.04) difference() {
                    intersection() { translate([14,12]) square([cr_cd()-28,cr_ch()-24]); cr_hex(cr_cd(),cr_ch()); }
                    children(); // zones pleines des fixations
                    translate([cr_side_join_y()-18,0]) square([36,cr_ch()]);
                }
        }
        cc_floor_tabs(); cc_front_tabs();
    }
}
module cc_front() {
    difference() {
        cube([cr_cw(),4,cr_ch()+10]);
        translate([cr_cw()/2,0,cr_ch()+5]) rotate([-90,0,0]) drawer_mount_bore(4);
        cc_front_tabs(.15);
        for(x=[cr_cw()*.3,cr_cw()*.75]) translate([x-3.15,1.85,.65]) cube([6.3,2.3,1.7]);
        children(); // decoupes propres a la variante de cassette
    }
}
module cc_floor_piece(segment) { cr_depth_piece(segment,cr_floor_join_y()) cc_floor(); }
module cc_carrier_piece(segment) { cr_depth_piece(segment,cr_side_join_y()) children(); }
module cc_floor_flat(segment) {
    translate([0,-cr_segment_start(segment,cr_floor_join_y()),0]) cc_floor_piece(segment);
}
module cc_carrier_flat(segment=0) {
    multmatrix([[0,1,0,-cr_segment_start(segment,cr_side_join_y())],[0,0,1,-1.5],[1,0,0,0],[0,0,0,1]])
        cc_carrier_piece(segment) children();
}
module cc_front_flat() {
    multmatrix([[1,0,0,0],[0,0,1,0],[0,-1,0,4],[0,0,0,1]]) children();
}
module cc_parts(explode=0) {
    has_front_cutout=$children>1;
    for(segment=[0,1]) {
        color("#84aaa1") translate([0,(2*segment-1)*explode,0]) cc_floor_piece(segment);
        color("#7199ac") translate([-explode,(2*segment-1)*explode,explode]) cc_carrier_piece(segment) children(0);
    }
    color("#d0aa65") cc_floor_joint_key();
    color("#d0aa65") translate([-explode,0,explode]) cc_carrier_joint_keys();
    color("#416886") translate([0,-2*explode,0]) cc_front()
        if(has_front_cutout) children(1);
}
