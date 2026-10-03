// Cassette VENTUNO verticale. Ports vers le haut ; refroidissement conserve.
// Passage de cables rectangulaire arrondi en haut de facade, sous l'oreillette M3.
// Facade ajouree ; exploded ne montre que les huit pieces imprimees.
// floor et side_panel : segment 0=avant, 1=arriere ; front monobloc.
// Trois joint_key (une semelle, deux support) : huit pieces collees ; supports PCB M3.
// Deux SSD USB 100 x 24 x 5, USB vers +Z : deux fixations au milieu des 24 mm chacun,
// a 24.5 et 54.5 mm du bas. Entretoises M2.5, corps 10 et male 6 dans le PLA.
// Degagement minimal 2 mm hors appuis de fixation. En bas, reference au chant
// du PCB : controle sur la carte reelle, le refroidissement ne depasse pas ce chant.
// Les positions et bossages suivent la meme transformation.
use <sbc-rack-core.scad>
use <compute-rack-core.scad>
use <compute-cassette-core.scad>
use <ventuno-q-reference.scad>
/* [Selection] */
part="completed"; // [completed,exploded,installed,floor,side_panel,front,joint_key,coupon]
// floor/side_panel : section avant/arriere ; front/joint_key/coupon : piece entiere.
segment=0; // [0:Avant,1:Arriere]
/* [Affichage] */
cassette_index=0; // [0:4]
show_boards=true;
show_ssd=true; // reference SSD/entretoises ; les bossages restent dans la piece imprimee
/* [Implantation] */
rack_depth=230;
board_clearance=2; // minimum commun : facade, semelle, support, SSD et extremite arriere
/* [Passage de cables en facade] */
front_cable_width=30; // dimensions utiles cote interieur
front_cable_height=16.5; // agrandissement vers le bas ; bord superieur fixe
front_cable_radius=3;
front_cable_top_clearance=2; // entre ouverture utile et debut de l'oreillette
/* [Ventilation de facade] */
front_ventilation=true;
front_vent_hex_flat=5; // ouverture entre faces paralleles
front_vent_web=2; // nervures et anneau plein autour de l'entree evasee
front_vent_border=6; // cadre plein, protege aussi les languettes de collage
/* [SSD USB] */
ssd_count=2; // [1,2]
ssd_height=100;
ssd_depth=24;
ssd_thickness=5;
ssd_standoff_height=10; // corps hors filetage
ssd_standoff_thread=6;
ssd_hole_low=24.5; // centres depuis le bas du SSD, sur l'axe median des 24 mm
ssd_hole_high=54.5;
ssd_mount_diameter=7;
ssd_pilot=2.2; // avant-trou M2.5 dans le PLA, a calibrer
ssd_standoff_flats=5; // encombrement de reference, a comparer aux entretoises reelles
ssd_hole_diameter=2.7; // passage M2.5 du gabarit SSD ; diametre reel a confirmer
/* [Hidden] */
$fn=$preview?24:48;
$compute_depth=rack_depth;
// Dans la cassette, Z du modele devient X, Y reste Y et X devient Z.
// En X/Y on utilise l'enveloppe equipee. En Z, le chant PCB (X=0 dans le 3MF)
// fait foi d'apres la mesure reelle ; le debord graphique de 0.657 mm est conserve
// dans la reference 3MF, mais n'ajoute plus de recul au-dessus de la semelle.
function vc_board_origin() = [3+board_clearance-ventuno_bounds()[0][2],
    cr_front()+board_clearance-ventuno_bounds()[0][1],
    3+board_clearance];
function vc_board_y() = vc_board_origin()[1];
function vc_board_holes() = [for(p=ventuno_holes())
    [vc_board_y()+p[1],vc_board_origin()[2]+p[0]]];
function vc_board_seat_x() = vc_board_origin()[0]-ventuno_pcb_thickness();
function vc_required_depth() = vc_board_y()+ventuno_bounds()[1][1]
    +ssd_count*ssd_depth+(ssd_count+1)*board_clearance+8;
function vc_cable_origin() = [(cr_cw()-front_cable_width)/2,
    cr_ch()-front_cable_top_clearance-front_cable_height];
module vc_cable_outline() {
    translate(vc_cable_origin()+[front_cable_radius,front_cable_radius])
        offset(r=front_cable_radius)
            square([front_cable_width-2*front_cable_radius,
                    front_cable_height-2*front_cable_radius]);
}
module vc_cable_opening() {
    // Chanfrein exterieur de 1 mm sur 3 mm ; passage droit sur le dernier mm.
    drawer_front_opening(4,3,1) vc_cable_outline();
}
module vc_front_vent_pattern() {
    pitch=front_vent_hex_flat+front_vent_web;
    radius=pitch/sqrt(3);
    difference() {
        intersection() {
            translate([front_vent_border,front_vent_border])
                square([cr_cw()-2*front_vent_border,cr_ch()-2*front_vent_border]);
            union() for(i=[0:ceil(cr_cw()/(1.5*radius))],j=[0:ceil(cr_ch()/pitch)])
                translate([i*1.5*radius,(j+(i%2)/2)*pitch])
                    circle(r=front_vent_hex_flat/sqrt(3),$fn=6);
        }
        // Compter le mm de chanfrein dans la reserve de matiere autour du passage.
        offset(delta=1+front_vent_web+.02) vc_cable_outline();
    }
}
module vc_front_cutouts() {
    vc_cable_opening();
    // Hexagones droits : un chanfrein de 1 mm de chaque cote supprimerait les nervures.
    if(front_ventilation) multmatrix([[1,0,0,0],[0,0,1,-.02],[0,1,0,0],[0,0,0,1]])
        linear_extrude(4.04) vc_front_vent_pattern();
}
module vc_front() { cc_front() vc_front_cutouts(); }
// 0.3 mm de garde au bout du filetage et 1.2 mm de peau sous l'avant-trou.
function vc_ssd_seat_x() = ssd_standoff_thread+.3+1.2;
function vc_ssd_origin(index=0) = [vc_ssd_seat_x()+ssd_standoff_height,
    cr_cd()-board_clearance-ssd_depth-(ssd_count-1-index)*(ssd_depth+board_clearance),3+board_clearance];
// Coordonnees Y/Z de la cassette ; axes des vis suivant X.
function vc_ssd_holes(index=undef) = [for(i=is_undef(index)?[0:ssd_count-1]:[index],z=[ssd_hole_low,ssd_hole_high])
    [vc_ssd_origin(i)[1]+ssd_depth/2,vc_ssd_origin(i)[2]+z]];
module vc_ssd_reference() {
    for(i=[0:ssd_count-1]) difference() {
        translate(vc_ssd_origin(i)) cube([ssd_thickness,ssd_depth,ssd_height]);
        for(p=vc_ssd_holes(i)) translate([vc_ssd_origin(i)[0]-.02,p[0],p[1]])
            rotate([0,90,0]) cylinder(d=ssd_hole_diameter,h=ssd_thickness+.04);
    }
}
module vc_ssd_standoffs(threads=true) {
    for(p=vc_ssd_holes()) translate([vc_ssd_seat_x(),p[0],p[1]]) rotate([0,90,0]) {
        difference() {
            cylinder(d=ssd_standoff_flats/cos(30),h=ssd_standoff_height,$fn=6);
            translate([0,0,ssd_standoff_height-min(5,ssd_standoff_height)])
                cylinder(d=2.1,h=min(5,ssd_standoff_height)+.02);
        }
        if(threads) translate([0,0,-ssd_standoff_thread]) cylinder(d=2.5,h=ssd_standoff_thread);
    }
}
module vc_ssd_bosses() {
    for(p=vc_ssd_holes()) translate([2.98,p[0],p[1]]) rotate([0,90,0])
        cylinder(d=ssd_mount_diameter,h=vc_ssd_seat_x()-2.98);
}
module vc_ssd_bores() {
    for(p=vc_ssd_holes()) {
        translate([1.2,p[0],p[1]]) rotate([0,90,0])
            cylinder(d=ssd_pilot,h=ssd_standoff_thread+.32);
        translate([vc_ssd_seat_x()-.4,p[0],p[1]]) rotate([0,90,0])
            cylinder(d1=ssd_pilot,d2=ssd_pilot+.4,h=.42);
    }
}
module vc_validate() {
    o=vc_board_origin(); b=ventuno_bounds(); tolerance=.0001;
    assert(board_clearance>=2,"Conserver au moins 2 mm autour des cartes");
    assert(o[0]+b[0][2]>=3+board_clearance-tolerance,"Jeu insuffisant contre le support");
    assert(o[0]+b[1][2]<=cr_cw()-board_clearance+tolerance,"Carte equipee trop epaisse");
    assert(o[1]+b[0][1]>=cr_front()+board_clearance-tolerance,"Jeu insuffisant contre la facade");
    assert(o[1]+b[1][1]<=cr_cd()-board_clearance+tolerance,"Carte equipee trop profonde");
    assert(o[2]>=3+board_clearance-tolerance,"Jeu PCB insuffisant au-dessus de la semelle");
    assert(o[2]+b[0][0]>3,"La reference 3MF ne doit pas couper la semelle");
    assert(o[2]+b[1][0]<=cr_ch()-board_clearance+tolerance,"Carte equipee trop haute");
    assert(vc_board_seat_x()-4.3>1.2,"Le vissage VENTUNO doit rester borgne");
    assert(front_cable_width>0 && front_cable_height>0 && front_cable_radius>0
           && 2*front_cable_radius<min(front_cable_width,front_cable_height));
    assert(front_cable_top_clearance>=2,"Garder 2 mm entre entree evasee et lamage M3");
    assert(vc_cable_origin()[0]-1>=3.15+2,
           "Garder 2 mm entre entree evasee et logements des languettes du support");
    assert(vc_cable_origin()[1]-1>=5,"Passage trop bas pour les languettes de semelle");
    assert(vc_cable_origin()[1]-1>=o[2]+b[1][0]+board_clearance-tolerance,
           "L'entree evasee doit garder 2 mm au-dessus de la carte equipee");
    if(front_ventilation) {
        assert(front_vent_hex_flat>0 && front_vent_web>=2);
        assert(front_vent_border>=3.15+2,"Proteger les logements de languettes par 2 mm de matiere");
        assert(2*front_vent_border<min(cr_cw(),cr_ch()));
    }
    // Verifier meme quand la reference SSD est masquee : ses supports sont imprimes.
    {
        p=vc_ssd_origin();
        assert(ssd_count==1 || ssd_count==2);
        assert(ssd_height>0 && ssd_depth>0 && ssd_thickness>0);
        assert(ssd_standoff_height>0 && ssd_standoff_thread>0);
        assert(p[0]>=3+board_clearance && p[0]+ssd_thickness<=cr_cw()-board_clearance);
        assert(p[1]>=vc_board_y()+ventuno_bounds()[1][1]+board_clearance-tolerance,
               str("Marge VENTUNO/SSD insuffisante : profondeur minimale=",vc_required_depth(),
                   " mm, rack_depth actif=",cr_d()," mm. Nominal : 230 mm."));
        assert(p[2]+ssd_height<=cr_ch()-board_clearance,"SSD trop haut");
        assert(cr_cd()-vc_ssd_origin(ssd_count-1)[1]-ssd_depth>=board_clearance-tolerance);
        for(i=ssd_count>1?[0:ssd_count-2]:[])
            assert(vc_ssd_origin(i+1)[1]-vc_ssd_origin(i)[1]-ssd_depth>=board_clearance-tolerance);
        assert(vc_ssd_seat_x()>3 && ssd_pilot>0 && ssd_pilot+.4+2<=ssd_mount_diameter);
        assert(ssd_standoff_flats>=2.5 && ssd_standoff_flats/cos(30)<=ssd_mount_diameter);
        assert(ssd_hole_diameter>2.5);
        assert(ssd_hole_low>ssd_mount_diameter/2 && ssd_hole_high>ssd_hole_low+ssd_mount_diameter);
        assert(ssd_hole_high+ssd_mount_diameter/2<ssd_height);
        for(h=vc_ssd_holes()) {
            assert(h[0]+ssd_mount_diameter/2+2<cr_cd()-.15,"Garder de la matiere derriere les bossages SSD");
            assert(h[0]-ssd_mount_diameter/2>vc_board_y()+ventuno_bounds()[1][1],
                   "Les bossages SSD doivent rester derriere la VENTUNO");
        }
        for(h=concat(vc_board_holes(),vc_ssd_holes()))
            assert(abs(h[0]-cr_side_join_y())>18,"La jonction du support doit eviter les fixations");
    }
    children();
}
module vc_board_position() {
    o=vc_board_origin();
    multmatrix([[0,0,1,o[0]],[0,1,0,o[1]],[1,0,0,o[2]],[0,0,0,1]]) children();
}
module vc_carrier() {
    difference() {
        union() {
            cc_carrier() {
                for(p=vc_board_holes()) translate(p) circle(d=12);
                for(p=vc_ssd_holes()) translate(p) circle(d=ssd_mount_diameter+4.04);
            }
            for(p=vc_board_holes()) translate([3,p[0],p[1]]) rotate([0,90,0])
                cylinder(d=6.4,h=vc_board_seat_x()-3);
            vc_ssd_bosses();
        }
        for(p=vc_board_holes()) translate([vc_board_seat_x()-4.3,p[0],p[1]])
            rotate([0,90,0]) cylinder(d=2.5,h=4.32);
        vc_ssd_bores();
    }
}
module ventuno_cassette(explode=0,boards=true) {
    vc_validate() {
    cc_parts(explode) { vc_carrier(); vc_front_cutouts(); }
    if(boards) %vc_board_position() ventuno_reference();
    if(boards && show_ssd) {
        %color([.35,.45,.55,.6]) vc_ssd_reference();
        %color("#c9aa68") vc_ssd_standoffs();
    }
    }
}
module ventuno_cassette_export(selection,piece=0) {
    vc_validate() {
    assert(piece==0 || piece==1);
    if(selection=="floor") cc_floor_flat(piece);
    if(selection=="side_panel") cc_carrier_flat(piece) vc_carrier();
    if(selection=="front") cc_front_flat() vc_front();
    if(selection=="joint_key") cr_joint_key();
    if(selection=="coupon") drawer_screw_coupon(4);
    }
}
assert(segment==0 || segment==1);
assert(len([for(p=["completed","exploded","installed","floor","side_panel","front","joint_key","coupon"]) if(p==part) p])==1);
cr_validate() {
    if(part=="completed") ventuno_cassette(0,show_boards);
    else if(part=="exploded") ventuno_cassette(18,boards=false);
    else if(part=="installed") {
        %assembly();
        cr_install() { %cr_structure(); cr_cassette_position(cassette_index) ventuno_cassette(0,show_boards); }
    }
    else ventuno_cassette_export(part,segment);
    echo("Cassette : largeur, hauteur corps, hauteur facade, profondeur",[cr_cw(),cr_ch(),cr_ch()+10,cr_cd()]);
    echo("Jeu refroidissement / limite laterale",cr_cw()-vc_board_origin()[0]-ventuno_bounds()[1][2]);
    echo("Degagement minimal commun",board_clearance);
    echo("Jeu PCB / semelle, jeu modele equipe / semelle",
         [vc_board_origin()[2]-3,vc_board_origin()[2]+ventuno_bounds()[0][0]-3]);
    echo("Profondeur minimale pour VENTUNO et SSD",vc_required_depth());
    echo("Passage de cables : dimensions utiles, rayon, origine X/Z",
         [[front_cable_width,front_cable_height],front_cable_radius,vc_cable_origin()]);
    echo("Marge verticale entre entree evasee et carte equipee",
         vc_cable_origin()[1]-1-vc_board_origin()[2]-ventuno_bounds()[1][0]);
    if(show_ssd) {
        echo("SSD USB : origines XYZ, dimensions XYZ",
             [[for(i=[0:ssd_count-1]) vc_ssd_origin(i)],[ssd_thickness,ssd_depth,ssd_height]]);
        echo("Fixations SSD : centres Y/Z, entraxe",[vc_ssd_holes(),ssd_hole_high-ssd_hole_low]);
        echo("Bossages SSD : saillie / profondeur avant-trou / peau",[vc_ssd_seat_x()-3,ssd_standoff_thread+.3,1.2]);
        echo("Jeu VENTUNO / SSD, reserve au-dessus du SSD",
             [vc_ssd_origin()[1]-vc_board_y()-ventuno_bounds()[1][1],
              cr_ch()-vc_ssd_origin()[2]-ssd_height]);
    }
}
