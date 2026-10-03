// Interfaces du chassis 3U et de ses cinq cassettes. Toutes les cotes sont en mm.
// Les pieces de structure se collent ; les cassettes et cartes se vissent.
use <sbc-rack-core.scad>
function cr_w() = rack_value("chassis_width");
function cr_wall() = rack_value("chassis_wall_thickness");
function cr_d() = is_undef($compute_depth)?230:$compute_depth;
function cr_h() = slot_z(2)+slot_height(2)-slot_z(0);
function cr_fit() = 0.15;
function cr_front() = rack_value("front_thickness");
function cr_ear() = rack_value("ear_width")-0.2;
function cr_gap() = 1;
function cr_cw() = (cr_w()-2*cr_wall()-6*cr_gap())/5;
function cr_cx(i) = cr_wall()+cr_gap()+i*(cr_cw()+cr_gap());
function cr_ch() = cr_h()-6-10-1; // corps 129.2 ; oreillette haute 10 en plus
function cr_cd() = cr_d()-8; // butee avant la traverse arriere
function cr_rail_x(i) = cr_cx(i)+cr_cw()/2;
function cr_mount_z(j) = slot_mount_z(j)-slot_z(0);
// Jonctions decalees : les flancs pontent la jonction des fonds/plafonds.
function cr_floor_join_y() = 100;
function cr_side_join_y() = 120;
function cr_segment_start(segment,at) = segment==0?2:at+cr_fit()/2;
function cr_spec() = [
    ["width",cr_cw()],["body_height",cr_ch()],["front_height",cr_ch()+10],
    ["depth",cr_cd()],["front_thickness",cr_front()],["floor_thickness",3],
    ["gap",cr_gap()],["guide_width",6],["guide_height",1.5],
    ["groove_width",6.4],["groove_depth",1.7],["mount_z",cr_ch()+5],
    ["head_diameter",8],["head_depth",2.5],["screw_clearance",3.3]];
function cassette_value(name) = let(v=[for(p=cr_spec()) if(p[0]==name) p[1]])
    assert(len(v)==1,"Cote cassette inconnue") v[0];

module cr_validate() {
    assert(cr_d()>180 && cr_d()<=230,"Profondeur compatible avec les sections et cles imprimees sur 220 mm");
    assert(cr_d()<rack_value("fan_front"));
    assert(cr_front()==4 && cr_wall()==4,"Cette interface emploie facades et flancs de 4 mm");
    assert(cr_cw()>35 && cr_ch()>100);
    rack_validate() children();
}
module cr_install(start=0) {
    translate([(rack_value("width")-cr_w())/2,0,slot_z(start)]) children();
}
module cr_cassette_position(i) {
    assert(i>=0 && i<5 && floor(i)==i);
    translate([cr_cx(i),0,3]) children();
}
module cr_hex(w,h) {
    for(i=[0:ceil(w/6)],j=[0:ceil(h/7)])
        translate([6*i,7*j+3.5*(i%2)]) circle(d=5.8,$fn=6);
}
module cr_half(which,split=undef) {
    x=is_undef(split)?cr_w()/2:split;
    intersection() {
        children();
        translate([which==0?-30:x+cr_fit()/2,-30,-30])
            cube([which==0?x+30-cr_fit()/2:cr_w()+30,cr_d()+60,cr_h()+60]);
    }
}
// Sections avant/arriere : fente de collage de 0.15 mm, cles engagees par les chants.
module cr_depth_piece(segment,at) {
    assert(segment==0 || segment==1);
    intersection() {
        children();
        translate([-50,segment==0?-30:at+cr_fit()/2,-30])
            cube([cr_w()+100,segment==0?at+30-cr_fit()/2:cr_d()+30,cr_h()+60]);
    }
}
module cr_joint_key(clearance=0) {
    translate([-clearance,-clearance,-clearance]) cube([6+2*clearance,30+2*clearance,1.2+2*clearance]);
}
module cr_slab_joint_keys(clearance=0) {
    for(x=[cr_w()*.25,cr_w()*.75])
        translate([x-3,cr_floor_join_y()-15,.9]) cr_joint_key(clearance);
}
module cr_side_joint_keys(s,clearance=0) {
    for(z=[cr_h()/3,2*cr_h()/3])
        multmatrix([[0,0,s==0?1:-1,s==0?cr_wall()/2-.6:cr_w()-cr_wall()/2+.6],
                    [0,1,0,cr_side_join_y()-15],[1,0,0,z-3],[0,0,0,1]]) cr_joint_key(clearance);
}
module cr_wall_tabs(which) {
    drawer_wall_floor_tabs(which,cr_w(),cr_wall(),cr_front()+cr_fit(),
                          cr_d()-cr_wall()-cr_fit(),3,cr_fit());
}
module cr_wall_sockets(which) {
    drawer_wall_floor_tabs(which,cr_w(),cr_wall(),cr_front()+cr_fit(),
                          cr_d()-cr_wall()-cr_fit(),3,cr_fit(),cr_fit());
}
module cr_front_tabs() {
    for(x=[cr_w()*.15,cr_w()*.5,cr_w()*.85])
        translate([x-3,cr_front()-2,.8]) cube([6,2+cr_fit()+.02,1.4]);
}
module cr_key() { cube([6,cr_d()-40,1.2]); }
module cr_key_at() { translate([cr_w()/2-3,20,.9]) cr_key(); }
module cr_slab_base(guides=true) {
    difference() {
        union() {
            translate([0,cr_front()+cr_fit(),0]) cube([cr_w(),cr_d()-cr_front()-cr_fit(),3]);
            translate([0,cr_d()-4,0]) cube([cr_w(),4,8]);
            cr_front_tabs();
            if(guides) for(i=[0:4]) translate([cr_rail_x(i)-3,16,3])
                hull() {
                    translate([.5,0,0]) cube([5,.02,1]);
                    translate([0,2,0]) cube([6,cr_d()-30,1.5]);
                }
        }
        for(s=[0,1]) cr_wall_sockets(s);
        translate([cr_w()/2-3.15,19.85,.75]) cube([6.3,cr_d()-39.7,1.5]);
        cr_slab_joint_keys(cr_fit());
        translate([0,0,-.02]) linear_extrude(3.04) difference() {
            intersection() {
                translate([10,22]) square([cr_w()-20,cr_d()-36]);
                cr_hex(cr_w(),cr_d());
            }
            translate([cr_w()/2-8,0]) square([16,cr_d()]);
            translate([0,cr_floor_join_y()-18]) square([cr_w(),36]);
            if(guides) for(i=[0:4]) translate([cr_rail_x(i)-5,0]) square([10,cr_d()]);
        }
    }
}
module cr_header_tabs(clearance=0) {
    for(x=[20,60,150,195])
        translate([x-6-clearance,8-clearance,cr_h()-3.15-clearance])
            cube([12+2*clearance,2+2*clearance,1.65+2*clearance]);
}
module cr_ceiling() {
    difference() {
        translate([0,0,cr_h()]) mirror([0,0,1]) cr_slab_base(guides=false);
        cr_header_tabs(cr_fit());
    }
}
module cr_side(s) {
    if(s==1) translate([cr_w(),0,0]) mirror([1,0,0]) cr_side(0);
    else {
    h=cr_h(); g=rack_value("rail_height")+2*rack_value("rail_fit");
    difference() {
        union() {
            translate([s==0?0:cr_w()-cr_wall(),cr_front()+cr_fit(),3.15])
                cube([cr_wall(),cr_d()-cr_wall()-cr_front()-2*cr_fit(),h-6.3]);
            cr_wall_tabs(s);
            translate([0,0,h]) mirror([0,0,1]) cr_wall_tabs(s);
            drawer_wall_front_tabs(s,cr_w(),cr_wall(),cr_front(),3,cr_fit(),
                                  cr_mount_z(0)-g/2,g,h);
        }
        for(j=[0:2]) translate([s==0?-.02:cr_w()-rack_value("rail_groove_depth"),
                                 cr_front(),cr_mount_z(j)-g/2])
            cube([rack_value("rail_groove_depth")+.02,cr_d(),g]);
        cr_side_joint_keys(s,cr_fit());
        multmatrix([[0,0,1,-.02],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
            linear_extrude(cr_w()+.04) difference() {
                intersection() { translate([14,10]) square([cr_d()-28,h-20]); cr_hex(cr_d(),h); }
                for(j=[0:2]) translate([0,cr_mount_z(j)-g/2-2]) square([cr_d(),g+4]);
                translate([cr_side_join_y()-18,0]) square([36,h]);
            }
    }
}
}
module cr_front_frame() {
    h=cr_h(); g=rack_value("rail_height")+2*rack_value("rail_fit");
    difference() {
        translate([-cr_ear(),0,0]) cube([cr_w()+2*cr_ear(),cr_front(),h]);
        translate([cr_wall(),-.02,3])
            cube([cr_w()-2*cr_wall(),cr_front()+.04,h-6]);
        for(x=[-rack_value("ear_width")/2,cr_w()+rack_value("ear_width")/2],j=[0:2]) {
            translate([x,0,cr_mount_z(j)]) rotate([-90,0,0]) drawer_mount_bore(cr_front());
            for(sign=[-1,1]) translate([x,1.8,cr_mount_z(j)+sign*rack_value("peg_offset")])
                rotate([-90,0,0]) cylinder(d=3.3,h=2.22);
        }
        for(s=[0,1]) drawer_wall_front_tabs(s,cr_w(),cr_wall(),cr_front(),3,cr_fit(),
                                            cr_mount_z(0)-g/2,g,h,cr_fit());
        for(top=[0,1]) translate([0,0,top*h]) scale([1,1,top==0?1:-1])
            for(x=[cr_w()*.15,cr_w()*.5,cr_w()*.85]) translate([x-3.15,1.85,.65]) cube([6.3,2.3,1.7]);
    }
}
module cr_mount_bar() {
    difference() {
        union() {
            // Jeu de colle contre les deux flancs, comme pour les autres jonctions.
            translate([cr_wall()+cr_fit(),4,cr_h()-13])
                cube([cr_w()-2*cr_wall()-2*cr_fit(),6,9.85]);
            cr_header_tabs();
        }
        for(i=[0:4]) translate([cr_rail_x(i),3.98,3+cr_ch()+5]) rotate([-90,0,0])
            cylinder(d=rack_setting("rack_insert_diameter"),h=6.04);
    }
}
module cr_structure(explode=0) {
    for(s=[0,1]) {
        for(segment=[0,1]) {
            color("#84aaa1") translate([(2*s-1)*explode,(2*segment-1)*explode,0])
                cr_depth_piece(segment,cr_floor_join_y()) cr_half(s) cr_slab_base();
            color("#7199ac") translate([(2*s-1)*2*explode,(2*segment-1)*explode,explode])
                cr_depth_piece(segment,cr_side_join_y()) cr_side(s);
            color("#84aaa1") translate([(2*s-1)*explode,(2*segment-1)*explode,2*explode])
                cr_depth_piece(segment,cr_floor_join_y()) cr_half(s) cr_ceiling();
        }
        color("#416886") translate([(2*s-1)*explode,-2*explode,0]) cr_half(s,93) cr_front_frame();
        color("#d0aa65") translate([(2*s-1)*explode,-2*explode,explode]) cr_half(s,93) cr_mount_bar();
        color("#d0aa65") translate([(2*s-1)*explode,0,explode]) cr_side_joint_keys(s);
    }
    color("#d0aa65") cr_key_at();
    color("#d0aa65") cr_slab_joint_keys();
    translate([0,0,cr_h()+2*explode]) mirror([0,0,1]) cr_key_at();
    color("#d0aa65") translate([0,0,cr_h()+2*explode]) mirror([0,0,1]) cr_slab_joint_keys();
}
module cr_export(part,s=0,segment=0) {
    assert(s==0 || s==1);
    assert(segment==0 || segment==1);
    assert(part=="floor" || part=="side_panel" || part=="front" || part=="floor_key" || part=="coupon"
           || part=="ceiling" || part=="ceiling_key" || part=="mount_bar" || part=="joint_key","Composant compute inconnu");
    if(part=="floor") translate([s==0?0:-cr_w()/2-.075,-cr_segment_start(segment,cr_floor_join_y()),0])
        cr_depth_piece(segment,cr_floor_join_y()) cr_half(s) cr_slab_base();
    if(part=="ceiling") translate([s==0?0:-cr_w()/2-.075,-cr_segment_start(segment,cr_floor_join_y()),cr_h()])
        mirror([0,0,1]) cr_depth_piece(segment,cr_floor_join_y()) cr_half(s) cr_ceiling();
    if(part=="side_panel") translate([-cr_segment_start(segment,cr_side_join_y())+2,0,0])
        drawer_wall_flat(s,cr_w(),cr_wall(),cr_front(),3) cr_depth_piece(segment,cr_side_join_y()) cr_side(s);
    if(part=="front") multmatrix([[1,0,0,s==0?cr_ear():-93.075],[0,0,1,0],[0,-1,0,4],[0,0,0,1]]) cr_half(s,93) cr_front_frame();
    if(part=="mount_bar") multmatrix([[1,0,0,s==0?-cr_wall():-93.075],[0,0,1,-cr_h()+13],[0,-1,0,10],[0,0,0,1]]) cr_half(s,93) cr_mount_bar();
    if(part=="floor_key" || part=="ceiling_key") cr_key();
    if(part=="joint_key") cr_joint_key(); // huit exemplaires : 4 dans les plateaux, 4 dans les flancs
    if(part=="coupon") drawer_screw_coupon(4);
}
