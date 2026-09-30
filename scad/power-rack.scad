// Tiroir alimentation + 6x Orange Pi Zero 3 pour sbc-rack.scad, mm. PLA, colle.
// X=largeur du corps, Y=profondeur depuis la face avant, Z=bas du tiroir.
// Imprimer body side=0/1, front side=0/1, une floor_key et une front_key : six pieces.
// Jamais assembly/installed. Assembler les fonds autour de leur cle, puis les facades.
// Coller la facade sur les languettes du fond et les chants des parois, hors du boitier.
// Tester coupon avant de visser les entretoises M2.5 directement dans le PLA.
// Le coupon teste aussi les lamages de facade ; verifier dans le slicer les
// ponts des logements internes et les meplats des pieds avant.
// Cotes Zero 3 extraites du 3MF avec les transformations v_local * R + t.
// Repere des donnees : coin avant-gauche, X le long du chant de 55 mm,
// Y vers l'arriere, Z=0 SOUS le PCB. Toutes les enveloppes incluent le PCB.
// Ordre en facade : HDMI (objet 19), USB-C (3), USB-A (26), RJ45 (2).
// L'objet 2 n'est pas une antenne. Aucun objet du 3MF n'est supprime ni tronque.
// Seuls USB-C et Ethernet sont ouverts en facade.
// Cotes utiles cote interieur ; entrees evasees depuis Y=0 sur 3 mm.
// Les cartes, entretoises et vis affichees sont des references exclues des STL.
// 3 colonnes x 2 niveaux de Zero 3 a l'avant, 2 cartes 88x88 empilees centrees derriere.
// Profil nominal commun : rack-config.scad. Pour les reglages locaux du boitier,
// exporter depuis sbc-rack.scad avec part="module_export", module_name="power".
use <sbc-rack-core.scad>

/* [Affichage] */
part = "assembly"; // [assembly,installed,exploded,body,front,floor_key,front_key,coupon,key_coupon]
side = 0; // [0,1]
show_boards = true;
show_envelopes = false;
show_hardware = true;
show_3mf = true; // remplace les gabarits Zero 3 quand show_boards est actif

/* [Tiroir] */
slot_index = 3; // sous le tiroir reseau (slot 4), numerotation depuis zero
floor_thickness = 3;
rear_lip_height = 8;
front_edge_clearance = 0.2;
join_fit = 0.15; // jeu total de collage, a calibrer en PLA
join_x = 142.8; // jonction de facade entre RJ45 central et logement HDMI droit
board_edge_clearance = 1;
col_gap_side = 1; // entre colonnes 0-1
col_gap_mid = 1; // entre colonnes 1-2 ; cle du fond sous la colonne centrale

/* [Zero 3] */
zero_model_clearance = 0.2; // marge ajoutee aux enveloppes dessus/dessous du 3MF
connector_inset = 1; // extremite USB-C dans l'epaisseur de facade ; RJ45 presque identique

/* [Cartes d'alimentation 88x88] */
power_size = 88;
power_pcb = 1.6; // HYPOTHESE : mesurer sur les cartes d'alimentation
power_solder = 2; // HYPOTHESE : depassement SOUS le PCB
power_components_height = 12; // HYPOTHESE : hauteur AU-DESSUS du PCB
power_hole_diameter = 3; // suppose, comme les Zero 3
power_hole_margin = 3;
power_gap = 5; // entre l'arriere des Zero 3 et l'avant des cartes alim
power_rear_clearance = 20; // du bord arriere des PCB jusqu'a la paroi arriere

/* [Fixations des cartes] */
post_height = 4;
post_diameter = 6.4;
post_foot_diameter = 8;
post_foot_height = 0.6;
post_pilot = 2.2; // eprouvette 2.1 / 2.2 / 2.3, pas un filetage imprime
post_lead = 0.4;
standoff_height = 20; // corps hors filetage male, les deux stacks
standoff_thread = 6;
thread_tip_clearance = 0.3;
standoff_flats = 5; // reference d'encombrement, a comparer aux entretoises reelles
mount_keepout = 8; // zone supposee sans composants autour des trous de fixation

/* [Acces et cables] */
port_clearance = 0.5;
usb_c_plug_width = 7; // fiche 10x6 tournee a 90 degres par la prise verticale
usb_c_plug_height = 11;
usb_c_corner_radius = 1;
rj45_plug_width = 17.5; // fiche + boot, a valider sur les cordons reels
rj45_plug_height = 15;
front_cable_diameter = 25;
front_cable_clearance = 1; // minimum paroi / PCB / entretoise autour du passage
port_chamfer_depth = 3; // profondeur depuis la face exterieure, reste 1 mm droit
port_chamfer_width = 1; // evasement par bord, limite pres des parois et cles

/* [Ventilation] */
vent_hex_flat = 5;
vent_web = 2;
vent_border = 6;
vent_support_margin = 2;
vent_joint_margin = 2; // bande pleine autour de la jonction commune

/* [Vis de facade] */
head_diameter = 8; // lamage cylindrique nominal : calibrer le jeu sur la tete reelle
head_depth = 2.5; // fond plat, reste 1.5 mm de facade
peg_fit = 0.3; // jeu diametral des logements d'ergots

/* [Hidden] */
$fn = $preview ? 24 : 48;
ne = 0.02;
zero_width = 55;
zero_depth = 50;
zero_pcb = 1.3;
zero_hole_diameter = 3;
zero_solder = -zero3_bounds()[0][2]+zero_model_clearance;
zero_envelope = zero3_bounds()[1][2]+zero_model_clearance; // depuis SOUS le PCB
power_envelope = power_pcb+power_components_height; // meme convention que Zero 3
body_width = rack_value("chassis_width");
wall = rack_value("chassis_wall_thickness");
front_thickness = rack_value("front_thickness");
drawer_height = slot_height(slot_index);
mount_z = slot_mount_z(slot_index)-slot_z(slot_index);
groove_height = rack_value("rail_height")+2*rack_value("rail_fit");
guide_groove_depth = rack_value("rail_groove_depth");
groove_bottom = mount_z-groove_height/2;
interior_width = body_width-2*wall;
col_pitch = zero_width+col_gap_side;
col_x0 = wall+(interior_width-(3*zero_width+col_gap_side+col_gap_mid))/2;
function zero_col_x(i) = col_x0+i*col_pitch+(i==2 ? col_gap_mid-col_gap_side : 0);
// L'extremite USB-C se trouve a front_thickness-connector_inset.
pcb_front_y = front_thickness-connector_inset-zero_port_box("usb_c")[0][1];
power_x = (body_width-power_size)/2;
// Intervalle reel entre les bords des PCB, suivant la position des Zero 3.
power_front_y = pcb_front_y+zero_depth+power_gap;
rear_y = power_front_y+power_size+power_rear_clearance+wall;
body_depth = rear_y-front_thickness;
body_front = front_thickness+join_fit;
ear = rack_value("ear_width")-front_edge_clearance;
rear_lip_y = rear_y-wall;
key_thickness = 1.2;
floor_key_start = 20;
floor_key_length = rear_lip_y-floor_key_start-14; // garder 14 mm avant le rebord arriere
floor_key_width = 6;
floor_join_x = body_width/2; // distinct de la jonction de facade
front_key_height = 40;
front_key_width = 8; // conserve >1 mm avant le logement borgne HDMI droit
front_key_z = (drawer_height-front_key_height)/2;
key_corner_radius = 0.5;
joint_support_width = max(floor_key_width,front_key_width)+2*join_fit+2*vent_joint_margin;
front_tab_width = 6;
front_tab_thickness = 1.4;
front_tab_depth = 2;
front_tab_x = [body_width*0.15,body_width/2,body_width*0.85];

// 3D/3dmodel.model SHA256 :
// 5fa0dea909087e3d762f16ecc3f5d749bff249ab5bbe4653faefcb981f4ba0bb
// Cercles ajustes sur les bords des quatre perçages : Ø3, erreur <0.00007 mm.
function zero_holes() = [[2.548428,2.510722],[52.488648,2.510722],
                         [2.548428,47.573354],[52.488648,47.573354]];
function zero3_bounds() = [[0,-0.95,-2],[55,50,15.11158]];
// Chaque entree : nom, boite complete, boite des sommets depassant le bord avant.
function zero3_connectors() = [
    ["hdmi",[[4.62365,-0.92,0.63],[13.52,6.58,4.38]],
            [[5.82,-0.92,1.40815],[12.32,-0.002914,4.38]]],
    ["usb_c",[[17.51954,-0.8704,-0.25],[22.03954,13.4296,11.18]],
             [[18.19954,-0.8704,1.94],[21.35954,-0.39199,10.88]]],
    ["usb_a",[[26.15,-0.95,1.35],[31.85,12.91,15.1]],
             [[26.15,-0.95,1.9],[31.85,-0.95,15.1]]],
    ["rj45",[[32.9537,-0.8837,-1.98842],[49.3937,20.2163,15.11158]],
            [[33.1737,-0.8837,1.81158],[49.1737,-0.2837,15.11158]]]
];
function zero_port_box(name,front=false) =
    let(rows=[for(p=zero3_connectors()) if(p[0]==name) p])
    assert(len(rows)==1,"Connecteur Zero 3 inconnu") rows[0][front?2:1];
function zero_port_center(name) = let(b=zero_port_box(name,true)) (b[0]+b[1])/2;
function zero_port_size(name) = let(b=zero_port_box(name,true)) b[1]-b[0];
function power_holes() = [
    [power_hole_margin,power_hole_margin],
    [power_size-power_hole_margin,power_hole_margin],
    [power_hole_margin,power_size-power_hole_margin],
    [power_size-power_hole_margin,power_size-power_hole_margin]];
function zero_bottom(level) = floor_thickness+post_height+level*(zero_pcb+standoff_height);
function zero_top(level) = zero_bottom(level)+zero_pcb;
function power_bottom(level) = floor_thickness+post_height+level*(power_pcb+standoff_height);
function power_top(level) = power_bottom(level)+power_pcb;
function post_depth(pcb) = standoff_thread-pcb+thread_tip_clearance;
function mounting_xs() = [-rack_value("ear_width")/2,
                          body_width+rack_value("ear_width")/2];
function front_cable_xs() = let(x=wall+front_cable_clearance+front_cable_diameter/2)
    [x,body_width-x];
function power_key_dims(kind) = kind=="floor" ? [floor_key_width,floor_key_length]
    : assert(kind=="front","Cle inconnue") [front_key_width,front_key_height];

assert(side==0 || side==1);
assert(part=="assembly" || part=="installed" || part=="exploded" || part=="body"
       || part=="front" || part=="floor_key" || part=="front_key"
       || part=="coupon" || part=="key_coupon","Selection inconnue");

module power_validate() {
    assert(port_chamfer_depth>=0 && port_chamfer_depth<front_thickness);
    assert(port_chamfer_width>=0);
    assert(zero_model_clearance>=0 && power_pcb>0 && power_solder>=0 && power_components_height>=0);
    assert(slot_index>=0 && slot_index<rack_value("units") && floor(slot_index)==slot_index);
    assert(body_width-2*wall>0 && guide_groove_depth<wall);
    assert(join_fit>0 && join_fit<key_thickness);
    assert(key_thickness+2*join_fit<min(floor_thickness,front_thickness));
    assert(rear_lip_height<groove_bottom && rear_y<rack_value("fan_front"));
    assert(col_x0>=wall+board_edge_clearance
           && zero_col_x(2)+zero_width<=body_width-wall-board_edge_clearance);
    assert(power_x>wall && power_x+power_size<body_width-wall);
    assert(power_front_y>pcb_front_y+zero_depth);
    assert(abs(power_front_y-(pcb_front_y+zero_depth)-power_gap)<ne);
    for(col=[0:2],p=zero_holes())
        assert(abs(zero_col_x(col)+p[0]-floor_join_x)
               >floor_key_width/2+join_fit+post_foot_diameter/2,
               "La cle du fond doit eviter tous les pieds Zero 3");
    assert(floor_join_x-floor_key_width/2-join_fit
           >power_x+power_hole_margin+post_foot_diameter/2,
            "La cle du fond doit eviter les pieds des cartes alim");
    assert(floor_join_x+floor_key_width/2+join_fit
           <power_x+power_size-power_hole_margin-post_foot_diameter/2,
            "La cle du fond doit eviter les pieds des cartes alim");
    assert(floor_key_start-join_fit>body_front
           && floor_key_start+floor_key_length+join_fit<rear_lip_y);
    assert(front_key_z-join_fit>0 && front_key_z+front_key_height+join_fit<drawer_height);
    assert(join_x-front_key_width/2-join_fit
           >zero_col_x(1)+zero_port_center("rj45")[0]+rj45_plug_width/2,
           "La cle de facade doit eviter les ouvertures de la colonne 1");
    assert(join_x+front_key_width/2+join_fit
            <zero_col_x(2)+zero_port_center("usb_c")[0]-usb_c_plug_width/2,
            "La cle de facade doit eviter les ouvertures de la colonne 2");
    assert(join_x+front_key_width/2+join_fit+1
           <zero_col_x(2)+zero_port_box("hdmi")[0][0]-zero_model_clearance,
           "Garder 1 mm entre cle de facade et logement HDMI droit");
    assert(col_gap_side>=1 && col_gap_mid>=1);
    assert(front_cable_diameter>0 && front_cable_clearance>=1);
    assert(drawer_height/2-front_cable_diameter/2>=floor_thickness+post_height+front_cable_clearance);
    for(which=[0,1]) {
        edge=front_cable_xs()[which]+(which==0?1:-1)*front_cable_diameter/2;
        pcb_edge=zero_col_x(which==0?0:2)+(which==0?0:zero_width);
        post_edge=zero_col_x(which==0?0:2)
            +(which==0?min([for(p=zero_holes()) p[0]]):max([for(p=zero_holes()) p[0]]))
            +(which==0?-1:1)*standoff_flats/(2*cos(30));
        assert((which==0?1:-1)*(pcb_edge-edge)>=front_cable_clearance,
               str("Passage de cables trop proche du PCB (",which==0?"gauche":"droite",
                   ") : jeu=",(which==0?1:-1)*(pcb_edge-edge),
                   " mm, minimum=",front_cable_clearance,
                   " mm ; diametre=",front_cable_diameter,
                   ", espaces colonnes=",[col_gap_side,col_gap_mid],
                   ", largeur corps=",body_width,", paroi=",wall,
                   ". Verifier les valeurs actives du Customizer/preset."));
        assert((which==0?1:-1)*(post_edge-edge)>=front_cable_clearance,
               str("Passage de cables trop proche des entretoises (",which==0?"gauche":"droite",
                   ") : jeu=",(which==0?1:-1)*(post_edge-edge),
                   " mm, minimum=",front_cable_clearance,
                   " mm ; entretoise sur plats=",standoff_flats," mm."));
    }
    assert(key_corner_radius>0 && 2*key_corner_radius<
           min(floor_key_width,front_key_width,floor_key_length,front_key_height));
    assert(head_depth<front_thickness && head_diameter>rack_value("screw_clearance"));
    assert(usb_c_plug_width>=zero_port_size("usb_c")[0]+2*port_clearance
           && usb_c_plug_height>=zero_port_size("usb_c")[2]+2*port_clearance);
    assert(rj45_plug_width>=zero_port_size("rj45")[0]+2*port_clearance
           && rj45_plug_height>=zero_port_size("rj45")[2]+2*port_clearance);
    assert(usb_c_corner_radius>0 && 2*usb_c_corner_radius<=min(usb_c_plug_width,usb_c_plug_height));
    assert(connector_inset>=0 && connector_inset<front_thickness);
    assert(pcb_front_y+min([for(p=zero3_connectors()) p[1][0][1]])
           -zero_model_clearance>=2,"Garder au moins 2 mm devant les logements borgnes");
    assert(power_rear_clearance>=0);
    for(level=[0,1]) {
        assert(zero_bottom(level)-zero_solder>floor_thickness);
        assert(zero_bottom(level)+zero_envelope<drawer_height-1);
        assert(power_bottom(level)-power_solder>floor_thickness);
        assert(power_bottom(level)+power_envelope<drawer_height-1);
    }
    assert(zero_bottom(1)-zero_solder>zero_bottom(0)+zero_envelope);
    assert(power_bottom(1)-power_solder>power_bottom(0)+power_envelope);
    for(p=zero_holes()) assert(pcb_front_y+p[1]-post_pilot/2-body_front>=1,
                               "Garder au moins 1 mm de PLA entre avant-trou et meplat");
    assert(post_depth(zero_pcb)<floor_thickness+post_height);
    assert(post_depth(power_pcb)<floor_thickness+post_height);
    children();
}

// Coupe biaisee a 45 degres, dans les 3 mm du fond ou les 4 mm de facade.
module scarf_profile(which,thickness,at=join_x) {
    reach=body_width+2*ear+10;
    lo=at-thickness/2;
    hi=at+thickness/2;
    if(which==0)
        polygon([[-reach,-ne],[hi+ne-join_fit/2,-ne],
                 [lo-join_fit/2,thickness],[lo-join_fit/2,2*drawer_height],
                 [-reach,2*drawer_height]]);
    else
        polygon([[hi+ne+join_fit/2,-ne],[reach,-ne],[reach,2*drawer_height],
                 [lo+join_fit/2,2*drawer_height],[lo+join_fit/2,thickness]]);
}

module power_key_outline(kind,clearance=0) {
    size=power_key_dims(kind);
    offset(delta=clearance) translate([key_corner_radius,key_corner_radius])
        offset(r=key_corner_radius)
            square([size[0]-2*key_corner_radius,size[1]-2*key_corner_radius]);
}

module power_key(kind) {
    linear_extrude(key_thickness) power_key_outline(kind);
}

module floor_key_pocket() {
    translate([floor_join_x-floor_key_width/2,floor_key_start,
               (floor_thickness-key_thickness)/2-join_fit])
        linear_extrude(key_thickness+2*join_fit) power_key_outline("floor",join_fit);
}

module front_key_pocket() {
    translate([join_x-front_key_width/2,(front_thickness+key_thickness)/2+join_fit,front_key_z])
        rotate([90,0,0]) linear_extrude(key_thickness+2*join_fit)
            power_key_outline("front",join_fit);
}

module board_post(depth,pilot=post_pilot) {
    difference() {
        union() {
            cylinder(d=post_diameter,h=post_height);
            cylinder(d1=post_foot_diameter,d2=post_diameter,h=post_foot_height);
        }
        translate([0,0,post_height-depth]) cylinder(d=pilot,h=depth+ne);
    }
}

// Meplat cote facade : tout le pied repose sur le fond, sans deplacer son trou.
module zero_board_post(p,pilot=post_pilot) {
    intersection() {
        board_post(post_depth(zero_pcb),pilot);
        translate([-post_foot_diameter,body_front-(pcb_front_y+p[1]),-ne])
            cube([2*post_foot_diameter,rear_y,post_height+2*ne]);
    }
}

module post_bore(depth,pilot=post_pilot) {
    translate([0,0,post_height-depth]) cylinder(d=pilot,h=depth+ne);
    translate([0,0,post_height-post_lead])
        cylinder(d1=pilot,d2=pilot+0.4,h=post_lead+ne);
}

// Motif independant du boitier : reglable pour ce tiroir.
module power_honeycomb(w,h) {
    pitch=vent_hex_flat+vent_web;
    radius=pitch/sqrt(3);
    for(i=[-1:ceil(w/(1.5*radius))+1],j=[-1:ceil(h/pitch)+1])
        translate([i*1.5*radius,(j+(i%2)/2)*pitch])
            circle(r=vent_hex_flat/sqrt(3),$fn=6);
}

module floor_vent_pattern() {
    difference() {
        intersection() {
            translate([wall+vent_border,body_front+vent_border])
                square([body_width-2*(wall+vent_border),
                        rear_lip_y-body_front-2*vent_border]);
            power_honeycomb(body_width,rear_y);
        }
        translate([floor_join_x-joint_support_width/2,0]) square([joint_support_width,rear_y]);
        for(i=[0:2],p=zero_holes())
            translate([zero_col_x(i)+p[0],pcb_front_y+p[1]])
                circle(d=post_foot_diameter+2*vent_support_margin);
        for(p=power_holes())
            translate([power_x+p[0],power_front_y+p[1]])
                circle(d=post_foot_diameter+2*vent_support_margin);
    }
}

module side_vent_pattern() {
    difference() {
        intersection() {
            translate([body_front+vent_border,vent_border])
                square([rear_y-body_front-2*vent_border,drawer_height-2*vent_border]);
            power_honeycomb(rear_y,drawer_height);
        }
        translate([0,groove_bottom-vent_support_margin])
            square([rear_y,groove_height+2*vent_support_margin]);
    }
}

module ventilation_cutouts() {
    translate([0,0,-ne]) linear_extrude(floor_thickness+2*ne) floor_vent_pattern();
    for(x=[-ne,body_width-wall-ne])
        multmatrix([[0,0,1,x],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
            linear_extrude(wall+2*ne) side_vent_pattern();
}

module power_body() {
    difference() {
        union() {
            translate([0,body_front,0]) cube([body_width,rear_lip_y-body_front,floor_thickness]);
            for(x=[0,body_width-wall]) translate([x,body_front,0])
                cube([wall,rear_lip_y-body_front,drawer_height]);
            translate([0,rear_lip_y,0]) cube([body_width,wall,rear_lip_height]);
            // A 1 mm entre PCB, les supports voisins fusionnent ; trous de vissage distincts.
            for(i=[0:2],p=zero_holes())
                translate([zero_col_x(i)+p[0],pcb_front_y+p[1],floor_thickness])
                    zero_board_post(p);
            for(p=power_holes())
                translate([power_x+p[0],power_front_y+p[1],floor_thickness])
                    board_post(post_depth(power_pcb));
            for(x=front_tab_x)
                translate([x-front_tab_width/2,front_thickness-front_tab_depth,
                           (floor_thickness-front_tab_thickness)/2])
                    cube([front_tab_width,front_tab_depth+join_fit+ne,front_tab_thickness]);
        }
        for(x=[-ne,body_width-guide_groove_depth])
            translate([x,body_front-ne,groove_bottom])
                cube([guide_groove_depth+ne,rear_lip_y-body_front+2*ne,groove_height]);
        for(i=[0:2],p=zero_holes())
            translate([zero_col_x(i)+p[0],pcb_front_y+p[1],floor_thickness])
                post_bore(post_depth(zero_pcb));
        for(p=power_holes())
            translate([power_x+p[0],power_front_y+p[1],floor_thickness])
                post_bore(post_depth(power_pcb));
        floor_key_pocket();
        ventilation_cutouts();
    }
}

module body_piece(which) {
    intersection() {
        power_body();
        multmatrix([[1,0,0,0],[0,0,1,-ne],[0,1,0,0],[0,0,0,1]])
            linear_extrude(rear_y+2*ne) scarf_profile(which,floor_thickness,floor_join_x);
    }
}

module power_front_opening() {
    drawer_front_opening(front_thickness,port_chamfer_depth,port_chamfer_width) {
        children();
        difference() {
            translate([wall+front_cable_clearance,1])
                square([body_width-2*(wall+front_cable_clearance),drawer_height-2]);
            translate([join_x-front_key_width/2-join_fit-1,0])
                square([front_key_width+2*join_fit+2,drawer_height]);
        }
    }
}

module rectangular_port(x,z,w,h) {
    power_front_opening() translate([x,z]) square([w,h]);
}

module rounded_port(x,z,w,h,r) {
    power_front_opening() translate([x+r,z+r]) offset(r=r) square([w-2*r,h-2*r]);
}

module zero_port_openings(col,level) {
    uc=zero_port_center("usb_c");
    ec=zero_port_center("rj45");
    ux=zero_col_x(col)+uc[0]-usb_c_plug_width/2;
    uz=zero_bottom(level)+uc[2]-usb_c_plug_height/2;
    rounded_port(ux,uz,usb_c_plug_width,usb_c_plug_height,usb_c_corner_radius);
    ex=zero_col_x(col)+ec[0]-rj45_plug_width/2;
    ez=zero_bottom(level)+ec[2]-rj45_plug_height/2;
    rectangular_port(ex,ez,rj45_plug_width,rj45_plug_height);
}

module front_fastener_hole(x) {
    translate([x,0,mount_z]) rotate([-90,0,0])
        drawer_mount_bore(front_thickness,head_diameter,head_depth);
    for(sign=[-1,1])
        translate([x,front_thickness-rack_value("peg_height")-0.2,
                   mount_z+sign*rack_value("peg_offset")]) rotate([-90,0,0])
            cylinder(d=rack_value("peg_diameter")+peg_fit,h=rack_value("peg_height")+0.2+ne);
}

// Logements borgnes depuis l'interieur : PCB, boitiers des quatre connecteurs
// et entretoises. Seuls USB-C et RJ45 traversent la facade.
module zero_front_recesses() {
    intersection() {
        translate([0,0,0]) cube([body_width,front_thickness+ne,drawer_height]);
        union() {
            for(col=[0:2],level=[0,1])
                translate([zero_col_x(col),pcb_front_y,zero_bottom(level)]) {
                    translate([-zero_model_clearance,-zero_model_clearance,-zero_solder])
                        cube([zero_width+2*zero_model_clearance,
                              zero_depth+2*zero_model_clearance,zero_envelope+zero_solder]);
                    for(p=zero3_connectors())
                        translate(p[1][0]-[zero_model_clearance,zero_model_clearance,zero_model_clearance])
                            cube(p[1][1]-p[1][0]+[2*zero_model_clearance,2*zero_model_clearance,2*zero_model_clearance]);
                }
            for(col=[0:2],p=zero_holes())
                translate([zero_col_x(col)+p[0],pcb_front_y+p[1],zero_top(0)-zero_model_clearance])
                    cylinder(d=standoff_flats/cos(30)+2*zero_model_clearance,
                             h=standoff_height+2*zero_model_clearance);
        }
    }
}

module power_front() {
    difference() {
        translate([-ear,0,0]) cube([body_width+2*ear,front_thickness,drawer_height]);
        for(col=[0:2],level=[0,1]) zero_port_openings(col,level);
        for(x=front_cable_xs())
            power_front_opening() translate([x,drawer_height/2])
                circle(d=front_cable_diameter,$fn=96);
        zero_front_recesses();
        for(x=mounting_xs()) front_fastener_hole(x);
        front_key_pocket();
        for(x=front_tab_x)
            translate([x-front_tab_width/2-join_fit,front_thickness-front_tab_depth-join_fit,
                       (floor_thickness-front_tab_thickness)/2-join_fit])
                cube([front_tab_width+2*join_fit,front_tab_depth+join_fit+ne,
                      front_tab_thickness+2*join_fit]);
    }
}

module front_piece(which) {
    intersection() {
        power_front();
        translate([0,0,-ne]) linear_extrude(drawer_height+2*ne)
            scarf_profile(which,front_thickness);
    }
}

module power_keys(explode=0) {
    translate([floor_join_x-floor_key_width/2,floor_key_start,(floor_thickness-key_thickness)/2])
        power_key("floor");
    translate([join_x-front_key_width/2,(front_thickness+key_thickness)/2-explode,front_key_z])
        rotate([90,0,0]) power_key("front");
}

module power_tray(explode=0) {
    for(which=[0,1]) translate([which==0?-explode:explode,0,0]) {
        color(which==0?"#84aaa1":"#9db4cb") body_piece(which);
        color("#416886") translate([0,-explode,0]) front_piece(which);
    }
    color("#d0aa65") power_keys(explode);
}

// Placement exact dans le boitier, sans duplication des dimensions d'interface.
module power_install() {
    translate([(rack_value("width")-body_width)/2,0,slot_z(slot_index)]) children();
}

function power_slot_index() = slot_index;

// Point d'entree pour la vue equipee de sbc-rack.scad.
module power_installed(boards=show_boards,hardware=show_hardware,envelopes=show_envelopes) {
    power_validate() power_install() {
        power_tray();
        power_references(boards=boards,hardware=hardware,envelopes=envelopes);
    }
}

module zero_pcbs() {
    for(i=[0:2],level=[0,1])
        translate([zero_col_x(i),pcb_front_y,zero_bottom(level)]) difference() {
            cube([zero_width,zero_depth,zero_pcb]);
            for(p=zero_holes()) translate([p[0],p[1],-ne])
                cylinder(d=zero_hole_diameter,h=zero_pcb+2*ne);
        }
}

module supply_pcbs() {
    for(level=[0,1])
        translate([power_x,power_front_y,power_bottom(level)]) difference() {
            cube([power_size,power_size,power_pcb]);
            for(p=power_holes()) translate([p[0],p[1],-ne])
                cylinder(d=power_hole_diameter,h=power_pcb+2*ne);
        }
}

module power_pcbs() { zero_pcbs(); supply_pcbs(); }

// Boites des composants du 3MF, evidees autour des fixations comme les autres
// gabarits. Le controle mecanique final emploie aussi le maillage complet.
module zero_ports(col,level) {
    translate([zero_col_x(col),pcb_front_y,zero_bottom(level)]) difference() {
        union() for(p=zero3_connectors()) translate(p[1][0]) cube(p[1][1]-p[1][0]);
        for(p=zero_holes()) translate([p[0],p[1],-zero_solder-ne])
            cylinder(d=mount_keepout,h=zero_envelope+zero_solder+2*ne);
    }
}

module power_ports() {
    for(i=[0:2],level=[0,1]) zero_ports(i,level);
}

// Enveloppes depuis le dessous du PCB, PCB inclus ; soudures retranchees en Z.
module power_envelopes() {
    for(i=[0:2],level=[0,1])
        translate([zero_col_x(i),pcb_front_y,zero_bottom(level)]) difference() {
            translate([0,0,-zero_solder])
                cube([zero_width,zero_depth,zero_envelope+zero_solder]);
            for(p=zero_holes()) translate([p[0],p[1],-zero_solder-ne])
                cylinder(d=mount_keepout,h=zero_envelope+zero_solder+2*ne);
        }
    for(level=[0,1])
        translate([power_x,power_front_y,power_bottom(level)]) difference() {
            translate([0,0,-power_solder])
                cube([power_size,power_size,power_envelope+power_solder]);
            for(p=power_holes()) translate([p[0],p[1],-power_solder-ne])
                cylinder(d=mount_keepout,h=power_envelope+power_solder+2*ne);
        }
    power_ports();
}

module power_standoffs(threads=true) {
    for(i=[0:2],p=zero_holes())
        translate([zero_col_x(i)+p[0],pcb_front_y+p[1],zero_top(0)]) {
            cylinder(d=standoff_flats/cos(30),h=standoff_height,$fn=6);
            if(threads) translate([0,0,-standoff_thread]) cylinder(d=2.5,h=standoff_thread);
        }
    for(p=power_holes())
        translate([power_x+p[0],power_front_y+p[1],power_top(0)]) {
            cylinder(d=standoff_flats/cos(30),h=standoff_height,$fn=6);
            if(threads) translate([0,0,-standoff_thread]) cylinder(d=2.5,h=standoff_thread);
        }
}

// Import integral : l'objet 2 est le RJ45, pas une antenne a retirer.
// Centre carte/dessus Z=0 du fichier vers coin avant-gauche/dessous PCB du tiroir.
module zero_3mf(col,level) {
    translate([zero_col_x(col)+27.5,pcb_front_y+25,zero_bottom(level)+zero_pcb])
        multmatrix([[0,1,0,0],[-1,0,0,0],[0,0,1,0],[0,0,0,1]])
            import("orange-pi-zero3.3mf");
}

module power_references(boards=show_boards,hardware=show_hardware,envelopes=show_envelopes) {
    if(boards) {
        %color("#50764b") supply_pcbs();
        if(show_3mf)
            for(i=[0:2],level=[0,1]) %color("#b78c4e") zero_3mf(i,level);
        else {
            %color("#50764b") zero_pcbs();
            %color("#aeb4ba") power_ports();
        }
    }
    if(envelopes) %color([0.6,0.8,0.6,0.3]) power_envelopes();
    if(hardware) %color("#c9aa68") power_standoffs();
}

module power_front_screws() {
    for(x=mounting_xs()) translate([x,0,mount_z]) rotate([-90,0,0])
        drawer_screw_reference(head_depth);
}

module mounting_coupon() {
    difference() {
        union() {
            cube([54,16,floor_thickness]);
            for(i=[0:2]) translate([9+18*i,8,floor_thickness])
                zero_board_post(zero_holes()[0],2.1+0.1*i);
        }
        for(i=[0:2]) {
            translate([9+18*i,8,floor_thickness]) post_bore(post_depth(zero_pcb),2.1+0.1*i);
            translate([5+18*i,1,floor_thickness-0.3]) linear_extrude(0.3+ne)
                text(str(2.1+0.1*i),size=2);
        }
    }
    for(i=[0,1]) translate([8+15*i,24,0]) difference() {
        cylinder(d=10,h=i==0?zero_pcb:power_pcb);
        translate([0,0,-ne]) cylinder(d=3,h=(i==0?zero_pcb:power_pcb)+2*ne);
    }
    translate([70,0,0]) drawer_screw_coupon(front_thickness,head_diameter,head_depth);
}

// Deux paires de logements avec biais reel et cles a pleine longueur.
module key_coupon_half(kind,which) {
    size=power_key_dims(kind);
    thick=kind=="floor" ? floor_thickness : front_thickness;
    intersection() {
        difference() {
            cube([30,size[1]+12,thick]);
            translate([15-size[0]/2,6,(thick-key_thickness)/2-join_fit])
                linear_extrude(key_thickness+2*join_fit) power_key_outline(kind,join_fit);
        }
        multmatrix([[1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,0,1]])
            linear_extrude(size[1]+12) scarf_profile(which,thick,15);
    }
}

module key_coupon() {
    for(which=[0,1]) {
        translate([which*8,0,0]) key_coupon_half("floor",which);
        translate([55+which*8,0,0]) key_coupon_half("front",which);
    }
    translate([42,6,0]) power_key("floor");
    translate([100,0,0]) power_key("front");
}

module power_dimensions() {
    echo("Tiroir : largeur corps, profondeur totale, hauteur",[body_width,rear_y,drawer_height]);
    echo("Largeur interieure",body_width-2*wall);
    echo("Colonnes Zero 3 : X, Y avant PCB",[[for(i=[0:2]) zero_col_x(i)],pcb_front_y]);
    echo("Passages de cables : diametre, centres X, centre Z",
         [front_cable_diameter,front_cable_xs(),drawer_height/2]);
    echo("Jonctions fond / facade : X",[floor_join_x,join_x]);
    echo("Encastrement des extremites USB-C / RJ45",[for(n=["usb_c","rj45"])
         front_thickness-(pcb_front_y+zero_port_box(n)[0][1])]);
    echo("Matiere entre avant-trou et meplat avant",
         pcb_front_y+zero_holes()[0][1]-post_pilot/2-body_front);
    echo("Cartes alim : X, Y avant",[power_x,power_front_y]);
    echo("Hauteur enveloppe Zero 3 (marge incluse) / alim (hypotheses)",[
        zero_bottom(1)+zero_envelope,
        power_bottom(1)+power_envelope]);
    echo("Hauteur reelle Zero 3 d'apres le 3MF",zero_bottom(1)+zero3_bounds()[1][2]);
    echo("Jeu derriere les cartes alimentation",power_rear_clearance);
    echo("Distance arriere tiroir / ventilateur",rack_value("fan_front")-rear_y);
}

module power_export(selection,which=0) {
    assert(which==0 || which==1);
    assert(selection=="body" || selection=="front" || selection=="floor_key"
           || selection=="front_key" || selection=="coupon" || selection=="key_coupon",
           "Piece alimentation inconnue");
    power_validate() {
        if(selection=="body")
            translate([which==0?0:-(floor_join_x-floor_thickness/2+join_fit/2),
                       -front_thickness+front_tab_depth,0]) body_piece(which);
        if(selection=="front")
            multmatrix([[1,0,0,which==0?ear:-(join_x-front_thickness/2+join_fit/2)],
                        [0,0,1,0],[0,-1,0,front_thickness],[0,0,0,1]]) front_piece(which);
        if(selection=="floor_key") power_key("floor");
        if(selection=="front_key") power_key("front");
        if(selection=="coupon") mounting_coupon();
        if(selection=="key_coupon") key_coupon();
    }
}

// Les validations s'appliquent aussi aux exports individuels du Customizer.
rack_validate() power_validate() {
    if(part=="assembly") { power_tray(); power_references(); power_dimensions(); }
    if(part=="installed") {
        %assembly();
        power_install() { power_tray(); power_references(); }
        power_dimensions();
    }
    if(part=="exploded") { power_tray(18); power_references(); }
    if(part!="assembly" && part!="installed" && part!="exploded") power_export(part,side);
}
