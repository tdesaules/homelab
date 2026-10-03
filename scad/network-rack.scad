// Tiroir reseau superieur pour sbc-rack.scad, mm. PLA, assemblage colle.
// X=largeur du corps, Y=profondeur depuis la face avant, Z=bas du tiroir.
// Imprimer floor, side_panel, front avec side=0/1, puis floor_key et front_key : huit pieces.
// En autonomie : profil commun rack-config.scad. Pour les reglages locaux du
// boitier, exporter depuis sbc-rack.scad avec part="module_export", module_name="network".
// Assembler les deux fonds autour de leur cle longue, puis les deux facades pareillement.
// Jamais completed/exploded/installed. key_coupon teste les deux jonctions a pleine longueur.
// Coller les demi-fonds autour de leur cle, inserer les flancs par le haut,
// puis enfiler la facade assemblee sur les trois languettes du fond et celles des flancs.
// Les flancs s'impriment a plat, rainures vers le haut ; rebord arriere integre au fond.
// Coller le tiroir hors du boitier, sans colle dans ses rainures de guidage.
// Tester coupon avant de visser les entretoises M2.5 directement dans le PLA.
// Controler dans le slicer les ponts des logements de cles et les petites
// languettes avant ; supports localises possibles sous ces dernieres.
// Materiel : 8 entretoises M2.5 (corps 20 + male 6), 8 vis M2.5 pour les cartes
// superieures (longueur a adapter aux entretoises), 2 vis M3 de facade.
// Le bord avant des PCB affleure la face interieure de la facade.
// Les ports depassent de 2 mm du PCB : retrait exterieur nominal de 2 mm.
// Les acces USB-C de 11 x 7, rayon 1,
// sont prevus pour les fiches mesurees de 10 x 6 mm.
// Cotes utiles cote interieur ; entrees evasees depuis Y=0 sur 3 mm.
// Les cartes, entretoises et vis affichees sont des references exclues des STL.
// Orange Pi : pile a gauche. Switchs : pile a droite. Les vues sont depuis l'avant.
// Connecteurs appuyes sur le dessus des PCB ; pour les switchs, 2+14=16 mm
// est retenu prudemment plutot que les 15 mm d'enveloppe initialement annonces.
// Fond et flancs ajoures : conserver les appuis, joints colles et guides pleins.
// Bibliotheque sans rendu automatique : pas de dependance vers le fichier
// d'affichage sbc-rack.scad, qui peut donc afficher ce module a son tour.
use <sbc-rack-core.scad>

/* [Selection] */
part = "completed"; // [completed,exploded,installed,floor,side_panel,front,floor_key,front_key,coupon,key_coupon]
// Vu de face : 0=gauche, 1=droite pour floor/side_panel/front. Cles et coupons entiers.
side = 0; // [0:Gauche,1:Droite]
/* [Affichage] */
show_boards = true;
show_envelopes = false;
show_hardware = true;

/* [Tiroir] */
slot_index = 4; // emplacement superieur, numerotation depuis zero
body_depth = 175; // derriere la facade : profondeur totale 179 mm
floor_thickness = 3;
rear_lip_height = 8;
front_edge_clearance = 0.2;
join_fit = 0.15; // jeu total des coupes, par face des logements ; a calibrer en PLA
join_x = 72.5; // jonction du fond dans l'espace entre les piles
front_join_x = 66.5; // jonction de facade decalee pour degager les LED des switchs
board_edge_clearance = 2;

/* [Cles longues a coller] */
floor_key_length = 130; // suivant Y, de Y=20 a Y=150 au nominal
floor_key_width = 6; // evite les pieds des bossages voisins
floor_key_start = 20;
front_key_height = 40; // centree en hauteur sur la facade
front_key_width = 8;
key_thickness = 1.2;
key_corner_radius = 0.5;

/* [Ventilation] */
vent_hex_flat = 5; // ouverture entre faces paralleles
vent_web = 2; // nervures entre les hexagones
vent_border = 6; // cadre plein autour des zones ajourees
vent_support_margin = 2; // matiere autour des pieds, cles et rainures
vent_power_border = 4; // anneau plein autour du passage de cables Ø50

/* [Fixations des cartes] */
post_height = 4;
post_diameter = 6.4;
post_foot_diameter = 8;
post_foot_height = 0.6;
post_pilot = 2.2; // eprouvette 2.1 / 2.2 / 2.3, pas un filetage imprime
post_lead = 0.4;
standoff_height = 20; // corps hors filetage male
standoff_thread = 6;
thread_tip_clearance = 0.3;
standoff_flats = 5; // reference d'encombrement, a comparer aux entretoises reelles
mount_keepout = 8; // zone supposee sans composants autour des trous de fixation

/* [Switchs] */
switch_width = 150;
switch_depth = 93;
switch_pcb = 2;
switch_solder = 2;
switch_envelope = 15; // depuis le dessous du PCB, avant correction des ports
switch_ports_x = 10;
switch_ports_width = 128;
switch_ports_height = 14;
switch_led_x = 0; // HYPOTHESE : zone LED alignee sur le bord gauche du PCB
switch_led_z = 0; // HYPOTHESE : depuis le dessus du PCB
switch_led_width = 6;
switch_led_height = 13;
switch_reset_edge = 1; // du bord droit du PCB au bord droit du boitier 6x6
switch_reset_z = 1; // du dessus du PCB au bas du boitier
switch_reset_size = 6;
switch_reset_diameter = 3; // bouton au centre du boitier

/* [Orange Pi R1 Plus LTS] */
orange_width = 57;
orange_depth = 56;
orange_pcb = 1;
orange_solder = 3;
orange_envelope = 15; // PCB inclus, sans soudures inferieures
orange_ports_x = 16;
orange_ports_width = 34;
orange_ports_height = 14;
orange_usb_x = 4;
orange_usb_width = 9;
orange_usb_height = 3;
orange_side_usb = 3; // depassement a gauche, aucun acces lateral demande

/* [Acces et cables] */
port_overhang = 2; // commun aux deux cartes, vers l'avant du PCB
pcb_front_clearance = 0; // recul du PCB depuis la face interieure ; 0=affleurement maximal
port_clearance = 0.5;
usb_c_plug_width = 11; // ouverture pour le corps de fiche mesure a 10 x 6
usb_c_plug_height = 7;
usb_c_corner_radius = 1;
power_hole_diameter = 50;
ethernet_depth_reference = 22; // illustration seulement : profondeur non mesuree
usb_depth_reference = 8;
port_chamfer_depth = 3; // profondeur depuis la face exterieure, reste 1 mm droit
port_chamfer_width = 1; // par bord, limite localement pour garder les cloisons

/* [Vis de facade] */
head_diameter = 8; // lamage cylindrique nominal : calibrer le jeu sur la tete reelle
head_depth = 2.5; // fond plat, reste 1.5 mm de facade
peg_fit = 0.3; // jeu diametral des logements d'ergots

/* [Hidden] */
$fn = $preview ? 24 : 48;
ne = 0.02;
body_width = rack_value("chassis_width");
wall = rack_value("chassis_wall_thickness");
front_thickness = rack_value("front_thickness");
drawer_height = slot_height(slot_index);
mount_z = slot_mount_z(slot_index)-slot_z(slot_index);
groove_height = rack_value("rail_height")+2*rack_value("rail_fit");
guide_groove_depth = rack_value("rail_groove_depth");
groove_bottom = mount_z-groove_height/2;
rear_y = front_thickness+body_depth;
body_front = front_thickness+join_fit;
ear = rack_value("ear_width")-front_edge_clearance;
board_front = front_thickness+pcb_front_clearance;
orange_x = wall+orange_side_usb+board_edge_clearance;
switch_x = body_width-wall-board_edge_clearance-switch_width;
power_x = switch_x+switch_width/2;
power_y = (board_front+switch_depth+rear_y)/2;
front_key_z = (drawer_height-front_key_height)/2;
// Conserver la bande pleine existante autour de la jonction commune.
joint_support_width = max(floor_key_width,12)+2*join_fit+2*vent_support_margin;
front_tab_width = 6;
front_tab_thickness = 1.4;
front_tab_depth = 2;
front_tab_x = [body_width*0.15,body_width/2,body_width*0.85];

function pcb_width(kind) = kind=="orange" ? orange_width : switch_width;
function pcb_depth(kind) = kind=="orange" ? orange_depth : switch_depth;
function pcb_thickness(kind) = kind=="orange" ? orange_pcb : switch_pcb;
function solder_height(kind) = kind=="orange" ? orange_solder : switch_solder;
function pcb_x(kind) = kind=="orange" ? orange_x : switch_x;
function pcb_bottom(kind,level) = floor_thickness+post_height
    +level*(pcb_thickness(kind)+standoff_height);
function pcb_top(kind,level) = pcb_bottom(kind,level)+pcb_thickness(kind);
function board_envelope(kind) = kind=="orange"
    ? max(orange_envelope,orange_pcb+orange_ports_height)
    : max(switch_envelope,switch_pcb+switch_ports_height);
// Les mesures switch donnent 15 mm au total, mais PCB 2 + ports 14 = 16.
// L'ouverture couvre les deux positions possibles du bas du bloc Ethernet.
function switch_port_low() = min(switch_pcb,max(0,switch_envelope-switch_ports_height));
function mounting_holes(kind) = kind=="orange"
    ? [[3,orange_depth-3-32.5],[orange_width-3,orange_depth-3-50],
       [3,orange_depth-3],[orange_width-3,orange_depth-3]]
    : [[6,switch_depth-5-50],[switch_width-6,switch_depth-5-50],
       [6,switch_depth-5],[switch_width-6,switch_depth-5]];
function post_depth(kind) = standoff_thread-pcb_thickness(kind)+thread_tip_clearance;
function mounting_xs() = [-rack_value("ear_width")/2,
                           body_width+rack_value("ear_width")/2];
function network_key_dims(kind) = kind=="floor" ? [floor_key_width,floor_key_length]
    : assert(kind=="front","Cle inconnue") [front_key_width,front_key_height];
function switch_reset_center(level) = [
    switch_x+switch_width-switch_reset_edge-switch_reset_size/2,
    pcb_top("switch",level)+switch_reset_z+switch_reset_size/2];

assert(side==0 || side==1);
assert(part=="completed" || part=="installed" || part=="exploded" || part=="floor" || part=="side_panel"
       || part=="front" || part=="floor_key" || part=="front_key"
       || part=="coupon" || part=="key_coupon","Selection inconnue");

module network_validate() {
    assert(pcb_front_clearance>=0,"Le PCB ne doit pas traverser la facade");
    assert(port_overhang>=0 && port_overhang<=board_front,"Les prises ne doivent pas depasser la face exterieure");
    assert(port_chamfer_depth>=0 && port_chamfer_depth<front_thickness);
    assert(port_chamfer_width>=0);
    assert(orange_x+orange_ports_x-port_clearance
           -(orange_x+orange_usb_x+orange_usb_width/2+usb_c_plug_width/2)
           >=1,"Garder 1 mm entre entrees USB-C et Ethernet");
    assert(slot_index>=0 && slot_index<rack_value("units") && floor(slot_index)==slot_index);
    assert(body_width-2*wall>0 && guide_groove_depth<wall);
    assert(join_fit>0 && join_fit<key_thickness);
    assert(key_thickness+2*join_fit<min(floor_thickness,front_thickness));
    assert(rear_lip_height<groove_bottom && rear_y<rack_value("fan_front"));
    assert(orange_x-orange_side_usb>wall);
    assert(switch_x-orange_x-orange_width>2);
    assert(join_x-floor_key_width/2-join_fit>orange_x+orange_width-3+post_foot_diameter/2,
           "La cle du fond doit eviter les pieds des Orange Pi");
    assert(join_x+floor_key_width/2+join_fit<switch_x+6-post_foot_diameter/2,
           "La cle du fond doit eviter les pieds des switchs");
    assert(floor_key_start-join_fit>body_front
           && floor_key_start+floor_key_length+join_fit<rear_y-wall);
    assert(front_key_z-join_fit>0 && front_key_z+front_key_height+join_fit<drawer_height);
    assert(front_join_x-front_key_width/2-join_fit
           >=orange_x+orange_ports_x+orange_ports_width+port_clearance+port_chamfer_width+1,
           str("Garder 1 mm entre cle de facade et entree Ethernet Orange Pi : jeu=",
               front_join_x-front_key_width/2-join_fit
               -(orange_x+orange_ports_x+orange_ports_width+port_clearance+port_chamfer_width),
               " mm ; front_join_x=",front_join_x,", front_key_width=",front_key_width,
               ", join_fit=",join_fit,", port_chamfer_width=",port_chamfer_width,
               ". Nominal : front_join_x=66.5, front_key_width=8. Verifier le Customizer/preset."));
    assert(front_join_x+front_key_width/2+join_fit+1
           <=switch_x+switch_led_x-port_clearance-port_chamfer_width,
           str("Garder 1 mm entre cle de facade et fenetre LED : jeu=",
               switch_x+switch_led_x-port_clearance-port_chamfer_width
               -(front_join_x+front_key_width/2+join_fit),
               " mm ; front_join_x=",front_join_x,", front_key_width=",front_key_width,
               ", switch_led_x=",switch_led_x,
               ". Nominal : front_join_x=66.5, front_key_width=8. Verifier le Customizer/preset."));
    assert(switch_led_x>=0 && switch_led_z>=0 && switch_led_width>0 && switch_led_height>0);
    assert(switch_led_x+switch_led_width+2*port_clearance+2*port_chamfer_width+1
           <=switch_ports_x,"Garder 1 mm entre fenetre LED et Ethernet du switch");
    assert(switch_reset_edge>=0 && switch_reset_z>=0 && switch_reset_size>switch_reset_diameter
           && switch_reset_diameter>0);
    assert(switch_ports_x+switch_ports_width+port_clearance+port_chamfer_width+1
           <=switch_width-switch_reset_edge-switch_reset_size/2
             -switch_reset_diameter/2-port_clearance-port_chamfer_width,
           "Garder 1 mm entre Ethernet et acces reset");
    for(level=[0,1]) {
        assert(pcb_top("switch",level)+switch_led_z-port_clearance-port_chamfer_width>=1);
        assert(pcb_top("switch",level)+switch_led_z+switch_led_height
               +port_clearance+port_chamfer_width<=drawer_height-1);
        assert(switch_reset_center(level)[1]-switch_reset_diameter/2-port_clearance-port_chamfer_width>=1);
        assert(switch_reset_center(level)[1]+switch_reset_diameter/2+port_clearance+port_chamfer_width<=drawer_height-1);
    }
    assert(key_corner_radius>0 && 2*key_corner_radius<
           min(floor_key_width,front_key_width,floor_key_length,front_key_height));
    assert(power_y-power_hole_diameter/2>board_front+switch_depth);
    assert(power_y+power_hole_diameter/2<rear_y-wall);
    assert(power_x-power_hole_diameter/2-vent_power_border>join_x+joint_support_width/2);
    assert(power_x+power_hole_diameter/2<body_width-wall);
    assert(head_depth<front_thickness && head_diameter>rack_value("screw_clearance"));
    assert(usb_c_plug_width>=orange_usb_width && usb_c_plug_height>=orange_usb_height);
    assert(usb_c_corner_radius>0 && 2*usb_c_corner_radius<=min(usb_c_plug_width,usb_c_plug_height));
    assert(vent_hex_flat>0 && vent_web>0 && vent_border>0 && vent_support_margin>0);
    assert(vent_power_border>0 && body_width>2*(wall+vent_border));
    assert(rear_y-wall-body_front>2*vent_border && drawer_height>2*vent_border);
    for(kind=["orange","switch"]) {
        assert(pcb_bottom(kind,0)-solder_height(kind)>floor_thickness);
        assert(pcb_bottom(kind,1)+board_envelope(kind)<drawer_height-1);
        assert(pcb_bottom(kind,1)-solder_height(kind)>
               pcb_bottom(kind,0)+board_envelope(kind));
        assert(post_depth(kind)<floor_thickness+post_height);
        for(p=mounting_holes(kind))
            assert(board_front+p[1]-(post_pilot+0.4)/2-body_front>=1,
                   "Garder 1 mm entre le meplat avant et l'entree chanfreinee du vissage");
    }
    children();
}

// Coupe biaisee a 45 degres, dans les 3 mm du fond ou les 4 mm de facade.
// Le biais donne une surface de collage et un surplomb imprimable a plat.
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

module network_key_outline(kind,clearance=0) {
    size=network_key_dims(kind);
    offset(delta=clearance) translate([key_corner_radius,key_corner_radius])
        offset(r=key_corner_radius)
            square([size[0]-2*key_corner_radius,size[1]-2*key_corner_radius]);
}

module network_key(kind) {
    linear_extrude(key_thickness) network_key_outline(kind);
}

module floor_key_pocket() {
    translate([join_x-floor_key_width/2,floor_key_start,
               (floor_thickness-key_thickness)/2-join_fit])
        linear_extrude(key_thickness+2*join_fit) network_key_outline("floor",join_fit);
}

module front_key_pocket() {
    translate([front_join_x-front_key_width/2,(front_thickness+key_thickness)/2+join_fit,front_key_z])
        rotate([90,0,0]) linear_extrude(key_thickness+2*join_fit)
            network_key_outline("front",join_fit);
}

module board_post(depth,pilot=post_pilot) {
    difference() {
        union() {
            cylinder(d=post_diameter,h=post_height);
            cylinder(d1=post_foot_diameter,d2=post_diameter,h=post_foot_height);
        }
        // Le trou dans le fond est soustrait dans network_body, pas seulement ici.
        translate([0,0,post_height-depth]) cylinder(d=pilot,h=depth+ne);
    }
}

module post_bore(depth,pilot=post_pilot) {
    translate([0,0,post_height-depth]) cylinder(d=pilot,h=depth+ne);
    translate([0,0,post_height-post_lead])
        cylinder(d1=pilot,d2=pilot+0.4,h=post_lead+ne);
}

// Meplat cote facade : base et corps restent entierement sur le fond.
// Au nominal, pied avant droit R1 : 1.15 mm sur base Ø8, 0.35 mm sur corps Ø6.4.
module mounted_board_post(kind,p,pilot=post_pilot) {
    intersection() {
        board_post(post_depth(kind),pilot);
        translate([-post_foot_diameter,body_front-(board_front+p[1]),-ne])
            cube([2*post_foot_diameter,rear_y,post_height+2*ne]);
    }
}

// Motif independant du boitier : les dimensions sont reglables pour ce tiroir.
module network_honeycomb(w,h) {
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
                        rear_y-wall-body_front-2*vent_border]);
            network_honeycomb(body_width,rear_y);
        }
        // Bande centrale pleine sur toute la profondeur : joint biaise et cle longue.
        translate([join_x-joint_support_width/2,0]) square([joint_support_width,rear_y]);
        for(kind=["orange","switch"],p=mounting_holes(kind))
            translate([pcb_x(kind)+p[0],board_front+p[1]])
                // Eviter une tangence exacte avec un sommet du nid d'abeille.
                circle(d=post_foot_diameter+2*vent_support_margin+2*ne);
        translate([power_x,power_y]) circle(d=power_hole_diameter+2*vent_power_border);
    }
}

// Coordonnees 2D : profondeur Y et hauteur Z. La rainure garde son fond plein
// de 1.8 mm, plus une marge verticale de part et d'autre du guide.
module side_vent_pattern() {
    difference() {
        intersection() {
            translate([body_front+vent_border,vent_border])
                square([rear_y-body_front-2*vent_border,drawer_height-2*vent_border]);
            network_honeycomb(rear_y,drawer_height);
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

module wall_floor_tabs(which,clearance=0) {
    drawer_wall_floor_tabs(which,body_width,wall,body_front,rear_y-wall-join_fit,
                           floor_thickness,join_fit,clearance);
}

module wall_front_tabs(which,clearance=0) {
    drawer_wall_front_tabs(which,body_width,wall,front_thickness,floor_thickness,
                           join_fit,groove_bottom,groove_height,drawer_height,clearance);
}

module network_floor() {
    difference() {
        union() {
            translate([0,body_front,0]) cube([body_width,rear_y-body_front,floor_thickness]);
            translate([0,rear_y-wall,0]) cube([body_width,wall,rear_lip_height]);
            for(kind=["orange","switch"],p=mounting_holes(kind))
                translate([pcb_x(kind)+p[0],board_front+p[1],floor_thickness])
                    mounted_board_post(kind,p);
            for(x=front_tab_x)
                translate([x-front_tab_width/2,front_thickness-front_tab_depth,
                           (floor_thickness-front_tab_thickness)/2])
                    cube([front_tab_width,front_tab_depth+join_fit+ne,front_tab_thickness]);
        }
        for(which=[0,1]) wall_floor_tabs(which,join_fit);
        for(kind=["orange","switch"],p=mounting_holes(kind))
            translate([pcb_x(kind)+p[0],board_front+p[1],floor_thickness])
                post_bore(post_depth(kind));
        translate([power_x,power_y,-ne]) cylinder(d=power_hole_diameter,h=floor_thickness+2*ne);
        floor_key_pocket();
        ventilation_cutouts();
    }
}

module side_panel_piece(which) {
    difference() {
        union() {
            translate([which==0?0:body_width-wall,body_front,floor_thickness+join_fit])
                cube([wall,rear_y-wall-join_fit-body_front,drawer_height-floor_thickness-join_fit]);
            wall_floor_tabs(which);
            wall_front_tabs(which);
        }
        translate([which==0?-ne:body_width-guide_groove_depth,body_front-ne,groove_bottom])
            cube([guide_groove_depth+ne,rear_y-body_front+2*ne,groove_height]);
        ventilation_cutouts();
    }
}

// Corps assemble, utilise aussi pour les controles d'interferences.
module network_body() {
    network_floor();
    for(which=[0,1]) side_panel_piece(which);
}

module body_piece(which) {
    intersection() {
        network_floor();
        multmatrix([[1,0,0,0],[0,0,1,-ne],[0,1,0,0],[0,0,0,1]])
            linear_extrude(rear_y+2*ne) scarf_profile(which,floor_thickness);
    }
}

module network_front_opening() {
    // La cloison nominale de 1.5 mm ne permet pas deux evasements de 1 mm.
    // Conserver une bande de 1 mm au milieu, et autour des cles et des bords.
    divider=(orange_x+orange_ports_x-port_clearance
             +orange_x+orange_usb_x+orange_usb_width/2+usb_c_plug_width/2)/2;
    drawer_front_opening(front_thickness,port_chamfer_depth,port_chamfer_width) {
        children();
        difference() {
            translate([wall+1,1]) square([body_width-2*(wall+1),drawer_height-2]);
            translate([divider-0.5,0]) square([1,drawer_height]);
            translate([front_join_x-front_key_width/2-join_fit-1,0])
                square([front_key_width+2*join_fit+2,drawer_height]);
        }
    }
}

module rectangular_port(x,z,w,h) {
    network_front_opening() translate([x,z]) square([w,h]);
}

module rounded_port(x,z,w,h,r) {
    network_front_opening()
        translate([x+r,z+r]) offset(r=r) square([w-2*r,h-2*r]);
}

module orange_port_opening(level) {
    pcb_z=pcb_top("orange",level);
    ex=orange_x+orange_ports_x-port_clearance;
    ez=pcb_z-port_clearance;
    ux=orange_x+orange_usb_x+orange_usb_width/2-usb_c_plug_width/2;
    uz=pcb_z+orange_usb_height/2-usb_c_plug_height/2;
    rectangular_port(ex,ez,orange_ports_width+2*port_clearance,orange_ports_height+2*port_clearance);
    // Deux ouvertures distinctes, avec une cloison de 1.5 mm au reglage nominal.
    rounded_port(ux,uz,usb_c_plug_width,usb_c_plug_height,usb_c_corner_radius);
}

module switch_control_openings(level) {
    rectangular_port(switch_x+switch_led_x-port_clearance,
                     pcb_top("switch",level)+switch_led_z-port_clearance,
                     switch_led_width+2*port_clearance,switch_led_height+2*port_clearance);
    network_front_opening() translate(switch_reset_center(level))
        circle(d=switch_reset_diameter+2*port_clearance);
}

module front_fastener_hole(x) {
    translate([x,0,mount_z]) rotate([-90,0,0])
        drawer_mount_bore(front_thickness,head_diameter,head_depth);
    for(sign=[-1,1])
        translate([x,front_thickness-rack_value("peg_height")-0.2,
                   mount_z+sign*rack_value("peg_offset")]) rotate([-90,0,0])
            cylinder(d=rack_value("peg_diameter")+peg_fit,h=rack_value("peg_height")+0.2+ne);
}

module network_front() {
    difference() {
        translate([-ear,0,0]) cube([body_width+2*ear,front_thickness,drawer_height]);
        for(level=[0,1]) {
            orange_port_opening(level);
            switch_control_openings(level);
            rectangular_port(switch_x+switch_ports_x-port_clearance,
                pcb_bottom("switch",level)+switch_port_low()-port_clearance,
                switch_ports_width+2*port_clearance,
                switch_ports_height+switch_pcb-switch_port_low()+2*port_clearance);
        }
        for(x=mounting_xs()) front_fastener_hole(x);
        front_key_pocket();
        for(which=[0,1]) wall_front_tabs(which,join_fit);
        for(x=front_tab_x)
            translate([x-front_tab_width/2-join_fit,front_thickness-front_tab_depth-join_fit,
                       (floor_thickness-front_tab_thickness)/2-join_fit])
                cube([front_tab_width+2*join_fit,front_tab_depth+join_fit+ne,
                      front_tab_thickness+2*join_fit]);
    }
}

module front_piece(which) {
    intersection() {
        network_front();
        translate([0,0,-ne]) linear_extrude(drawer_height+2*ne)
            scarf_profile(which,front_thickness,front_join_x);
    }
}

module network_keys(explode=0) {
    translate([join_x-floor_key_width/2,floor_key_start,(floor_thickness-key_thickness)/2])
        network_key("floor");
    translate([front_join_x-front_key_width/2,(front_thickness+key_thickness)/2-explode,front_key_z])
        rotate([90,0,0]) network_key("front");
}

module network_tray(explode=0) {
    for(which=[0,1]) translate([which==0?-explode:explode,0,0]) {
        color(which==0?"#84aaa1":"#9db4cb") body_piece(which);
        color("#416886") translate([0,-explode,0]) front_piece(which);
    }
    for(which=[0,1]) translate([which==0?-2*explode:2*explode,0,explode])
        color("#7199ac") side_panel_piece(which);
    color("#d0aa65") network_keys(explode);
}

// Placement exact dans le boitier, sans duplication des dimensions d'interface.
module network_install() {
    translate([(rack_value("width")-body_width)/2,0,slot_z(slot_index)]) children();
}

function network_slot_index() = slot_index;

// Point d'entree pour la vue equipee de sbc-rack.scad. Le contexte du boitier
// est transmis par $rack_config et les options d'affichage sont explicites.
module network_installed(boards=show_boards,hardware=show_hardware,envelopes=show_envelopes) {
    network_validate() network_install() {
        network_tray();
        network_references(boards=boards,hardware=hardware,envelopes=envelopes);
    }
}

module network_pcbs() {
    for(kind=["orange","switch"],level=[0,1])
        translate([pcb_x(kind),board_front,pcb_bottom(kind,level)]) difference() {
            cube([pcb_width(kind),pcb_depth(kind),pcb_thickness(kind)]);
            for(p=mounting_holes(kind)) translate([p[0],p[1],-ne])
                cylinder(d=3,h=pcb_thickness(kind)+2*ne);
        }
}

module network_ports() {
    for(kind=["orange","switch"],level=[0,1]) {
        x=pcb_x(kind)+(kind=="orange"?orange_ports_x:switch_ports_x);
        translate([x,board_front-port_overhang,pcb_top(kind,level)])
            cube([kind=="orange"?orange_ports_width:switch_ports_width,
                  ethernet_depth_reference,kind=="orange"?orange_ports_height:switch_ports_height]);
        if(kind=="orange")
            translate([orange_x+orange_usb_x,board_front-port_overhang,pcb_top(kind,level)])
                cube([orange_usb_width,usb_depth_reference,orange_usb_height]);
    }
}

// Enveloppes conservatrices des composants et soudures, avec zones supposees
// libres autour des trous. Elles ne remplacent pas le dessin detaille des PCB.
module network_envelopes() {
    for(kind=["orange","switch"],level=[0,1])
        translate([pcb_x(kind),board_front,pcb_bottom(kind,level)]) difference() {
            union() {
                translate([0,0,-solder_height(kind)])
                    cube([pcb_width(kind),pcb_depth(kind),board_envelope(kind)+solder_height(kind)]);
                if(kind=="orange") translate([-orange_side_usb,0,orange_pcb])
                    cube([orange_side_usb,orange_depth,orange_envelope-orange_pcb]);
            }
            for(p=mounting_holes(kind)) translate([p[0],p[1],-solder_height(kind)-ne])
                cylinder(d=mount_keepout,h=board_envelope(kind)+solder_height(kind)+2*ne);
        }
    network_ports();
}

module network_standoffs(threads=true) {
    for(kind=["orange","switch"],p=mounting_holes(kind))
        translate([pcb_x(kind)+p[0],board_front+p[1],pcb_top(kind,0)]) {
            cylinder(d=standoff_flats/cos(30),h=standoff_height,$fn=6);
            if(threads) translate([0,0,-standoff_thread]) cylinder(d=2.5,h=standoff_thread);
        }
}

module network_front_screws() {
    for(x=mounting_xs()) translate([x,0,mount_z]) rotate([-90,0,0])
        drawer_screw_reference(head_depth);
}

module network_references(boards=show_boards,hardware=show_hardware,envelopes=show_envelopes) {
    if(boards) {
        %color("#50764b") network_pcbs();
        %color("#aeb4ba") network_ports();
        // Symboles de face (epaisseur illustrative 0.2), pas des boitiers 3D mesures.
        for(level=[0,1]) {
            %color("#73d66b") translate([switch_x+switch_led_x,board_front,
                                        pcb_top("switch",level)+switch_led_z])
                cube([switch_led_width,.2,switch_led_height]);
            c=switch_reset_center(level);
            %color("#555555") translate([c[0]-switch_reset_size/2,board_front,c[1]-switch_reset_size/2])
                cube([switch_reset_size,.2,switch_reset_size]);
            %color("#e0aa55") translate([c[0],board_front-.02,c[1]]) rotate([-90,0,0])
                cylinder(d=switch_reset_diameter,h=.2);
        }
    }
    if(envelopes) %color([0.6,0.8,0.6,0.3]) network_envelopes();
    if(hardware) %color("#c9aa68") network_standoffs();
}

module mounting_coupon() {
    difference() {
        union() {
            cube([54,16,floor_thickness]);
            for(i=[0:2]) translate([9+18*i,8,floor_thickness])
                mounted_board_post("orange",mounting_holes("orange")[1],2.1+0.1*i);
        }
        for(i=[0:2]) {
            translate([9+18*i,8,floor_thickness]) post_bore(post_depth("orange"),2.1+0.1*i);
            translate([5+18*i,1,floor_thickness-0.3]) linear_extrude(0.3+ne)
                text(str(2.1+0.1*i),size=2);
        }
    }
    // Rondelles de 1 et 2 mm pour simuler le PCB lors de l'essai des entretoises.
    for(i=[0,1]) translate([8+15*i,24,0]) difference() {
        cylinder(d=10,h=i+1);
        translate([0,0,-ne]) cylinder(d=3,h=i+1+2*ne);
    }
    translate([70,0,0]) drawer_screw_coupon(front_thickness,head_diameter,head_depth);
}

// Deux paires de logements avec biais reel et cles a pleine longueur.
// Fond a gauche (3 mm), facade a droite (4 mm) ; pieces espacees sur le plateau.
module key_coupon_half(kind,which) {
    size=network_key_dims(kind);
    thick=kind=="floor" ? floor_thickness : front_thickness;
    intersection() {
        difference() {
            cube([30,size[1]+12,thick]);
            translate([15-size[0]/2,6,(thick-key_thickness)/2-join_fit])
                linear_extrude(key_thickness+2*join_fit) network_key_outline(kind,join_fit);
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
    translate([42,6,0]) network_key("floor");
    translate([100,0,0]) network_key("front");
}

module network_dimensions() {
    echo("Tiroir : largeur corps, profondeur totale, hauteur",[body_width,rear_y,drawer_height]);
    echo("Largeur interieure",body_width-2*wall);
    echo("PCBs : X Orange Pi / switch, Y avant",[orange_x,switch_x,board_front]);
    echo("Jeu PCB / face interieure",pcb_front_clearance);
    echo("Encastrement des extremites USB-C/Ethernet",front_thickness-(board_front-port_overhang));
    echo("Fenetres LED : largeur/hauteur utiles",[switch_led_width+2*port_clearance,switch_led_height+2*port_clearance]);
    echo("Acces reset : diametre, centres X/Z",[switch_reset_diameter+2*port_clearance,
         [for(level=[0,1]) switch_reset_center(level)]]);
    echo("Hauteur maximale Orange Pi / switch",[
        pcb_bottom("orange",1)+board_envelope("orange"),
        pcb_bottom("switch",1)+board_envelope("switch")]);
    echo("Passage alimentation : X,Y,diametre",[power_x,power_y,power_hole_diameter]);
    echo("Distance arriere tiroir / ventilateur",rack_value("fan_front")-rear_y);
    echo("Cles longues : fond et facade (largeur, longueur, epaisseur)",
         [concat(network_key_dims("floor"),[key_thickness]),
          concat(network_key_dims("front"),[key_thickness])]);
}

// Export sous la configuration active de l'appelant, comme la vue installed.
module network_export(selection,which=0) {
    assert(which==0 || which==1);
    assert(selection=="floor" || selection=="side_panel" || selection=="front" || selection=="floor_key"
           || selection=="front_key" || selection=="coupon" || selection=="key_coupon",
           "Piece reseau inconnue");
    network_validate() {
        if(selection=="floor")
            translate([which==0?0:-(join_x-floor_thickness/2+join_fit/2),
                        -front_thickness+front_tab_depth,0]) body_piece(which);
        if(selection=="side_panel")
            drawer_wall_flat(which,body_width,wall,front_thickness,floor_thickness)
                side_panel_piece(which);
        if(selection=="front")
            multmatrix([[1,0,0,which==0?ear:-(front_join_x-front_thickness/2+join_fit/2)],
                        [0,0,1,0],[0,-1,0,front_thickness],[0,0,0,1]]) front_piece(which);
        if(selection=="floor_key") network_key("floor");
        if(selection=="front_key") network_key("front");
        if(selection=="coupon") mounting_coupon();
        if(selection=="key_coupon") key_coupon();
    }
}

// Les validations s'appliquent aussi aux exports individuels du Customizer.
rack_validate() network_validate() {
    if(part=="completed") { network_tray(); network_references(); network_dimensions(); }
    if(part=="installed") {
        %assembly();
        network_install() { network_tray(); network_references(); }
        network_dimensions();
    }
    if(part=="exploded") network_tray(18);
    if(part!="completed" && part!="installed" && part!="exploded") network_export(part,side);
}
