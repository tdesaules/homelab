// Rack SBC 5 emplacements identiques de 47.4 mm - prototype d'assemblage, mm.
// X=largeur, Y=profondeur, Z=hauteur, avant Y=0.
// Les chassis internes ne sont PAS inclus. Ventilateur et volumes 1U = references.
// Ossature : tenons pleins emboites et colles, sans insert ni vis.
// Bandes 1U separees : logement traversant diametre 5 x 6, espace libre arriere 4.
// NF-A20 PWM : 200x200x32 avec patins, entraxe choisi 170x170.

/* [Affichage] */
part = "assembly"; // [assembly,exploded,beam,node,panel,rack_strip,cross,key,coupon,joint_coupon]
show_fan = true;
show_slots = false;
// Barre : axis 0=X, 1=Y, 2=Z ; edge 0..3 ; half 0..1.
// Bande rack_strip : half 0=segment bas, 1=haut ; deux exemplaires de chaque.
axis = 0;
edge = 0;
half = 0;
// Pour un noeud : coordonnees 0, 1, 2 sur chaque axe (coin ou milieu d'arete).
node_x = 0;
node_y = 0;
node_z = 0;
// Panneaux : deux colonnes x deux rangees par face.
face = "left"; // [left,right,top,bottom,rear]
column = 0; // [0,1]
row = 0; // [0,1]

/* [Dimensions] */
width = 272.25;
height = 269;
depth = 272.25;
units = 5;
unit_height = 47.4;
top_unit_extra_height = 0; // aucune surhauteur specifique au dernier emplacement
gap = 2;
structure = 10;
chassis_width = 222.25;
chassis_wall_thickness = 4; // parois des futurs chassis et eprouvette de rainure
ear_width = 15;
chassis_clearance = 2; // par cote, pris sur les bandes de fixation

/* [Panneaux] */
panel_thickness = 5;
hex_flat = 5; // ouverture entre faces paralleles
rear_hex_flat = 10;
web = 2; // distance minimale entre deux ouvertures
panel_border = 8;
groove_fit = 0.1; // jeu par face : languette 5 dans rainure 5.2
tile_gap = 0.3;
groove_depth = 4;

/* [Croix a coller] */
cross_span = 50;
cross_width = 12;
cross_thickness = 2;
cross_fit = 0.15; // jeu lateral pour insertion et colle
cross_pocket_depth = 2.3; // logement interne centre : peaux de 1.35 mm

/* [Guides des chassis] */
rail_height = 10;
rail_engagement = 2;
// Le centre des rails suit automatiquement l'axe des vis de chaque emplacement.
rail_start = 16; // depuis la face avant du boitier
rail_end = 222.25; // conserve 10.5 mm devant le ventilateur
rail_entry = 2; // longueur du chanfrein d'entree
rail_gusset = 6; // renfort triangulaire sous chaque rail
rail_fit = 0.2; // jeu par face dans les rainures des futurs chassis

/* [Assemblage colle] */
fit = 0.2; // jeu par face, a calibrer avec le filament et la colle
tenon_size = 6;
tenon_length = 15;
tenon_chamfer = 0.5;
glue_vent_diameter = 1.5; // evacuation d'air/colle au fond des mortaises

/* [Fixations 1U] */
screw_clearance = 3.3;
rack_front_thickness = 4; // retrait des bandes pour une facade affleurante
rack_insert_diameter = 5;
rack_insert_depth = 6;
rack_screw_relief = 4; // espace libre a reserver derriere la bande
rack_peg_diameter = 3;
rack_peg_height = 2;
rack_peg_offset = 10; // au-dessus et au-dessous de l'axe de l'insert
rack_peg_chamfer = 0.4;

/* [Ventilateur] */
fan_size = 200;
fan_thickness = 32;
fan_pitch = 170;
fan_aperture = 190; // zone de grille, a verifier sur le ventilateur reel
fan_screw_clearance = 5.5; // passage libre des vis de ventilateur dites M5
fan_head_diameter = 10; // hypothese a valider avec les vis fournies
fan_head_depth = 3; // lamage exterieur, reste 2 mm de paroi sous la tete

/* [Hidden] */
$fn = $preview ? 24 : 48;
eps = 0.02;
B = structure;
dims = [width, depth, height];
coords = [[0,width/2-B/2,width-B],
          [0,depth/2-B/2,depth-B],
          [0,height/2-B/2,height-B]];
panel_offset = (B-panel_thickness)/2;
fan_rear = depth-panel_offset-panel_thickness;
fan_front = fan_rear-fan_thickness;
rack_strip_thickness = rack_insert_depth;
rack_tongue_offset = rack_front_thickness+(rack_strip_thickness-panel_thickness)/2;
front_tenon_width = 4;
front_tenon_offset = 1;
beam_end_solid = tenon_length+4;
// Marge longitudinale pour engager les panneaux avec les raccords encore
// entrouverts de 4.5 mm, puis refermer progressivement le cadre.
panel_tab_inset = beam_end_solid+B/2+groove_depth+1;
rail_standoff = (width-chassis_width)/2-panel_offset-panel_thickness;
rail_reach = rail_standoff+rail_engagement;
rail_groove_depth = rail_engagement+rail_fit;

assert(top_unit_extra_height>=0);
assert(abs(height-(2*B+units*unit_height+top_unit_extra_height+(units+1)*gap))<0.01,
       "Hauteur incompatible avec les emplacements, la rehausse et les jeux");
assert(abs(width-(2*B+2*ear_width+chassis_width))<0.01);
assert(panel_thickness+2*groove_fit < B);
assert(groove_depth > groove_fit && groove_depth < B-panel_offset-groove_fit);
assert(fit>0 && tenon_size+2*fit<B);
assert(tenon_chamfer>eps && tenon_chamfer<tenon_length
       && 2*tenon_chamfer<min(tenon_size,front_tenon_width));
assert(glue_vent_diameter>0 && glue_vent_diameter<front_tenon_width);
assert(rack_insert_depth > 0 && rack_insert_depth < B);
assert(rack_screw_relief >= 4);
assert(rack_front_thickness+rack_strip_thickness <= B);
assert(rack_strip_thickness >= panel_thickness);
assert(front_tenon_offset+front_tenon_width+fit < B-groove_depth,
       "La mortaise collee doit rester separee de la rainure avant");
assert(rack_insert_diameter > screw_clearance);
assert(rack_insert_diameter/2 < ear_width/2-chassis_clearance);
assert(rack_peg_chamfer > 0 && rack_peg_chamfer < rack_peg_height
       && 2*rack_peg_chamfer < rack_peg_diameter);
assert(rack_peg_diameter/2 < ear_width/2-chassis_clearance);
assert(rack_peg_offset > (rack_insert_diameter+rack_peg_diameter)/2
       && rack_peg_offset+rack_peg_diameter/2 < unit_height/2);
assert(fan_screw_clearance>0 && fan_head_diameter>fan_screw_clearance);
assert(fan_head_depth>0 && fan_head_depth<panel_thickness);
assert(cross_thickness>0 && cross_pocket_depth>=cross_thickness
       && cross_pocket_depth<panel_thickness);
assert(cross_width+2*cross_fit<2*panel_border && cross_span>cross_width);
assert(rail_standoff>rail_fit && rail_engagement>1);
assert(rail_fit>=0 && rail_groove_depth<chassis_wall_thickness,
       "La rainure de guidage doit conserver un fond dans la paroi du chassis");
assert(2*chassis_wall_thickness<chassis_width);
assert(rail_start>=rack_front_thickness+rack_insert_depth+rack_screw_relief);
assert(rail_end>rail_start+rail_entry && rail_end<fan_front);
for(i=[0:units-1])
    assert(rail_height>0 && (slot_height(i)-rail_height)/2>rail_gusset,
           "Le rail centre et son renfort doivent tenir dans l'emplacement");
assert(part=="assembly" || part=="exploded" || part=="beam" || part=="node"
       || part=="panel" || part=="rack_strip" || part=="cross"
       || part=="key" || part=="coupon" || part=="joint_coupon",
       "Selection inconnue");

function beam_length(a) = (dims[a]-3*B)/2;
function slot_z(i) = B+gap+i*(unit_height+gap);
function slot_height(i) = unit_height+(i==units-1 ? top_unit_extra_height : 0);
// Vis centree sur la hauteur utile de chaque emplacement, ergots a +/-10.
function slot_mount_z(i) = slot_z(i)+slot_height(i)/2;
function interior(v) = v==0 ? 1 : -1;
function is_front_vertical(a,e) = a==2 && floor(e/2)==0;
// Jonction entre les U 2 et 3, jamais dans un insert ou un ergot.
function strip_split() = slot_z(floor(units/2))-gap/2;
function strip_start(h) = h==0 ? B+groove_fit : strip_split()+tile_gap/2;
function strip_end(h) = h==0 ? strip_split()-tile_gap/2 : height-B-groove_fit;
function rail_z(i) = slot_mount_z(i)-rail_height/2;

module cross_outline(clearance=0) {
    offset(delta=clearance) union() {
        square([cross_span,cross_width],center=true);
        square([cross_width,cross_span],center=true);
    }
}

module cross_key() { linear_extrude(cross_thickness) cross_outline(); }

// Logement interne, ouvert uniquement sur les chants des quartiers.
module cross_pocket() {
    translate([0,0,(panel_thickness-cross_pocket_depth)/2])
        linear_extrude(cross_pocket_depth)
        cross_outline(cross_fit);
}

module fan_mount_hole() {
    translate([0,0,-eps]) cylinder(d=fan_screw_clearance,h=panel_thickness+2*eps);
    translate([0,0,-eps]) cylinder(d=fan_head_diameter,h=fan_head_depth+eps);
}

// Section d'un guide : X=profondeur du boitier, Y=vertical, Z=saillie du panneau.
// Le renfort s'arrete 0.2 mm avant le flanc du chassis ; seul le rail y entre.
module rail_prism(length,reach=rail_reach) {
    multmatrix([[0,0,1,0],[0,1,0,0],[1,0,0,0],[0,0,0,1]])
        linear_extrude(length)
            polygon([[-eps,-rail_gusset],[rail_standoff-rail_fit,0],
                     [reach,0],[reach,rail_height],[-eps,rail_height]]);
}

module guide_rail(length=rail_end-rail_start) {
    // Limiter le hull au profil concave : sinon il comble le dessous de
    // l'entree et empiete sur le flanc du chassis sous sa rainure.
    intersection() {
        rail_prism(length);
        union() {
            hull() {
                rail_prism(eps,rail_reach-1);
                translate([rail_entry,0,0]) rail_prism(eps);
            }
            translate([rail_entry,0,0]) rail_prism(length-rail_entry);
        }
    }
}

// Coupe aux limites de chaque tuile ; le rail central chevauche aussi les
// deux rangees. Les segments reprennent apres les jeux de jonction de 0.3 mm.
module panel_rails(w,h,ox,oy) {
    intersection() {
        cube([w,h,panel_thickness+rail_reach]);
        for(i=[0:units-1])
            translate([rail_start-ox,rail_z(i)-oy,panel_thickness])
                guide_rail();
    }
}

// Languette vers -X, longueur selon Y, epaisseur selon Z.
// Onglet : X global >= profondeur globale + jeu ; le panneau voisin prend
// l'autre demi-plan. Les deux languettes peuvent ainsi entrer de 3.9 mm.
module edge_tab(length,offset=panel_offset) {
    d=groove_depth-groove_fit;
    cut=max(0,d+offset+panel_thickness+groove_fit-B);
    assert(cut<panel_thickness && cut<d,"Onglet incompatible avec la rainure");
    multmatrix([[1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,0,1]])
        linear_extrude(length)
            polygon([[eps,0],[-d,0],[-d,panel_thickness-cut],
                     [-d+cut,panel_thickness],[eps,panel_thickness]]);
}

// Transformation des barres : x local suit l'arete, y/z pointent vers l'interieur.
module edge_transform(a,e) {
    s=e%2; t=floor(e/2);
    if(a==0)
        multmatrix([[1,0,0,0],[0,interior(s),0,s*depth],
                    [0,0,interior(t),t*height],[0,0,0,1]]) children();
    if(a==1)
        multmatrix([[0,interior(s),0,s*width],[1,0,0,0],
                    [0,0,interior(t),t*height],[0,0,0,1]]) children();
    if(a==2)
        multmatrix([[0,interior(s),0,s*width],[0,0,interior(t),t*depth],
                    [1,0,0,0],[0,0,0,1]]) children();
}

module bore_down(d,h) { translate([0,0,-h]) cylinder(d=d,h=h+eps); }

// Face avant locale Z=0 : insert vers +Z, ergot saillant vers -Z.
module rack_mount_hole() {
    translate([0,0,-eps])
        cylinder(d=rack_insert_diameter,h=rack_insert_depth+eps);
    translate([0,0,rack_insert_depth-eps])
        cylinder(d=screw_clearance,h=rack_screw_relief+2*eps);
}

module rack_peg() {
    translate([0,0,-rack_peg_height])
        cylinder(d1=rack_peg_diameter-2*rack_peg_chamfer,
                 d2=rack_peg_diameter,h=rack_peg_chamfer);
    translate([0,0,-rack_peg_height+rack_peg_chamfer])
        cylinder(d=rack_peg_diameter,h=rack_peg_height-rack_peg_chamfer+eps);
}

// Profil longitudinal rainure sur les deux faces interieures.
// Extremites pleines reservees aux mortaises collees. La rainure des bandes
// avant reste continue, separee de la colle par une paroi de 0.8 mm au nominal.
module beam(a,e,h,joint_fit=fit) {
    L=beam_length(a);
    front=is_front_vertical(a,e);
    tw=front ? front_tenon_width : tenon_size;
    ty=front ? front_tenon_offset : (B-tenon_size)/2;
    assert(L>2*beam_end_solid);
    assert(!front || ty+tw+joint_fit<B-groove_depth);
    difference() {
        cube([L,B,B]);
        for(end=[0,1]) {
            translate([end==0 ? -eps : L-tenon_length-joint_fit,
                       ty-joint_fit,(B-tenon_size)/2-joint_fit])
                cube([tenon_length+joint_fit+eps,tw+2*joint_fit,tenon_size+2*joint_fit]);
            // Petit event vers l'interieur, pres du fond, sans vis ni insert.
            translate([end==0 ? tenon_length+joint_fit/2 : L-tenon_length-joint_fit/2,
                       ty+tw/2,B+eps])
                bore_down(glue_vent_diameter,(B-tenon_size)/2+2*eps);
        }
        translate([front ? -eps : beam_end_solid,B-groove_depth,
                   (front ? rack_tongue_offset : panel_offset)-groove_fit])
            cube([front ? L+2*eps : L-2*beam_end_solid,groove_depth+eps,
                  panel_thickness+2*groove_fit]);
        translate([beam_end_solid,panel_offset-groove_fit,B-groove_depth])
            cube([L-2*beam_end_solid,panel_thickness+2*groove_fit,groove_depth+eps]);
    }
}

// Tenon plein +X, avec chanfrein d'entree sur les quatre aretes de son bout.
module tongue_x(front=false) {
    tw=front ? front_tenon_width : tenon_size;
    ty=front ? front_tenon_offset : (B-tenon_size)/2;
    hull() {
        translate([B,ty,(B-tenon_size)/2])
            cube([tenon_length-tenon_chamfer,tw,tenon_size]);
        translate([B+tenon_length-eps,ty+tenon_chamfer,(B-tenon_size)/2+tenon_chamfer])
            cube([eps,tw-2*tenon_chamfer,tenon_size-2*tenon_chamfer]);
    }
}

// Cube de jonction : coins (3 tenons) ou milieux d'aretes (2 tenons).
module node(ix,iy,iz) {
    indices=[ix,iy,iz];
    middle=(ix==1?1:0)+(iy==1?1:0)+(iz==1?1:0);
    assert(middle<=1,"Noeud invalide : choisir un coin ou milieu d'arete");
    front_mid=iy==0 && iz==1;
    front_vertical=iy==0 && ix!=1;
    difference() {
        union() {
            cube([B,B,B]);
            for(a=[0:2]) if(middle==0 || indices[a]==1)
                for(sign=indices[a]==1 ? [-1,1] : [indices[a]==0 ? 1 : -1]) {
                    // Orienter les tenons, notamment ceux des montants avant.
                    if(a==0)
                        multmatrix([[sign,0,0,sign==1?0:B],
                            [0,1,0,0],[0,0,interior(iz==2?1:0),iz==2?B:0],
                            [0,0,0,1]]) tongue_x();
                    if(a==1)
                        multmatrix([[0,1,0,0],[sign,0,0,sign==1?0:B],
                            [0,0,interior(iz==2?1:0),iz==2?B:0],[0,0,0,1]]) tongue_x();
                    if(a==2)
                        multmatrix([[0,front_vertical && ix==2 ? -1 : 1,0,
                                     front_vertical && ix==2 ? B : 0],
                            [0,0,interior(iy==2?1:0),iy==2?B:0],
                            [sign,0,0,sign==1?0:B],[0,0,0,1]]) tongue_x(front_vertical);
                }
        }
        if(front_mid)
            translate([ix==0 ? B-groove_depth : -eps,
                       rack_tongue_offset-groove_fit,-eps])
                cube([groove_depth+eps,panel_thickness+2*groove_fit,B+2*eps]);
    }
}

// Bande separee : X=largeur, Y=hauteur, Z=profondeur depuis son appui avant.
module rack_strip(h) {
    start=strip_start(h);
    length=strip_end(h)-start;
    difference() {
        union() {
            cube([ear_width-chassis_clearance,length,rack_strip_thickness]);
            translate([0,0,(rack_strip_thickness-panel_thickness)/2])
                edge_tab(length,rack_tongue_offset);
            for(i=[0:units-1],sign=[-1,1]) {
                y=slot_mount_z(i)+sign*rack_peg_offset-start;
                if(y>0 && y<length) {
                    assert(y>rack_peg_diameter/2 && y<length-rack_peg_diameter/2);
                    translate([ear_width/2,y,0]) rack_peg();
                }
            }
        }
        for(i=[0:units-1]) {
            y=slot_mount_z(i)-start;
            if(y>0 && y<length) {
                assert(y>rack_insert_diameter/2 && y<length-rack_insert_diameter/2);
                translate([ear_width/2,y,0]) rack_mount_hole();
            }
        }
    }
}

module rack_strips(explode=0) {
    for(side=[0,1],h=[0,1])
        multmatrix([[side==0?1:-1,0,0,side==0?B:width-B],
                    [0,0,1,rack_front_thickness-explode],
                    [0,1,0,strip_start(h)],[0,0,0,1]]) rack_strip(h);
}

// Ouvertures hexagonales : reseau triangulaire, espace minimal = web.
module honeycomb(w,h,flat=hex_flat) {
    R=(flat+web)/sqrt(3);
    for(i=[-1:ceil(w/(1.5*R))+1])
        for(j=[-1:ceil(h/(flat+web))+1])
            translate([i*1.5*R,(j+(i%2)/2)*(flat+web)])
                circle(r=flat/sqrt(3),$fn=6);
}

function panel_dims(f) = (f=="left" || f=="right") ? [depth,height] :
                         f=="rear" ? [width,height] : [width,depth];

// Une tuile imprimee a plat, epaisseur 5 mm, bords pleins, languettes externes.
// Mortaises sur les deux bords internes pour les cles independantes.
module panel(f,c,r) {
    ds=panel_dims(f);
    w=(ds[0]-2*B-tile_gap)/2;
    h=(ds[1]-2*B-tile_gap)/2;
    ox=B+c*(w+tile_gap);
    oy=B+r*(h+tile_gap);
    rear=f=="rear";
    side=f=="left" || f=="right";
    assert(min(w,h)>2*panel_tab_inset);
    difference() {
        union() {
            cube([w,h,panel_thickness]);
            // Tabs discontinus : evitent les noeuds et les extremites des barres.
            translate([c==0?0:w,panel_tab_inset,0])
                scale([c==0?1:-1,1,1]) edge_tab(h-2*panel_tab_inset);
            translate([panel_tab_inset,r==0?0:h,0])
                rotate([0,0,r==0?90:-90])
                    scale([1,r==0?-1:1,1]) edge_tab(w-2*panel_tab_inset);
            if(side) panel_rails(w,h,ox,oy);
        }
        translate([0,0,-eps]) linear_extrude(panel_thickness+2*eps)
            difference() {
                intersection() {
                    translate([panel_border,panel_border])
                        square([w-2*panel_border,h-2*panel_border]);
                    honeycomb(w,h,rear ? rear_hex_flat : hex_flat);
                    if(rear) translate([width/2-ox,height/2-oy]) circle(d=fan_aperture);
                }
                if(rear) for(sx=[-1,1],sy=[-1,1])
                    translate([width/2+sx*fan_pitch/2-ox,height/2+sy*fan_pitch/2-oy])
                        circle(d=max(14,fan_head_diameter+4));
                // Le nid d'abeille suit les rails centres et leurs renforts
                // inferieurs : bandes pleines jusqu'aux bordures pour la charge.
                if(side) for(i=[0:units-1])
                    translate([-eps,rail_z(i)-oy-rail_gusset-1])
                        square([w+2*eps,rail_height+rail_gusset+2]);
            }
        translate([ds[0]/2-ox,ds[1]/2-oy,0]) cross_pocket();
        // Cles 12 x 6 x 2 : logement 6.4 de profondeur, 6.4 de large, 2.4 epais.
        translate([c==0?w-6.4:-eps,h/2-3.2,(panel_thickness-2.4)/2])
            cube([6.4+eps,6.4,2.4]);
        translate([w/2-3.2,r==0?h-6.4:-eps,(panel_thickness-2.4)/2])
            cube([6.4,6.4+eps,2.4]);
        if(rear) for(sx=[-1,1],sy=[-1,1]) {
            x=width/2+sx*fan_pitch/2-ox;
            y=height/2+sy*fan_pitch/2-oy;
            if(x>0 && x<w && y>0 && y<h)
                translate([x,y,0]) fan_mount_hole();
        }
    }
}

module face_transform(f,explode=0) {
    if(f=="left")
        multmatrix([[0,0,1,panel_offset-explode],[1,0,0,0],[0,1,0,0],[0,0,0,1]]) children();
    if(f=="right")
        multmatrix([[0,0,-1,width-panel_offset+explode],[1,0,0,0],[0,1,0,0],[0,0,0,1]]) children();
    if(f=="bottom") translate([0,0,panel_offset-explode]) children();
    if(f=="top") translate([0,0,height-panel_offset+explode]) mirror([0,0,1]) children();
    if(f=="rear")
        multmatrix([[1,0,0,0],[0,0,-1,depth-panel_offset+explode],
                    [0,1,0,0],[0,0,0,1]]) children();
}

module panel_face(f,explode=0) {
    ds=panel_dims(f);
    w=(ds[0]-2*B-tile_gap)/2;
    h=(ds[1]-2*B-tile_gap)/2;
    spread=explode>0 ? cross_width/2+2 : 0;
    face_transform(f,explode) {
        // Ecarter les quartiers dans leur plan revele la croix interne.
        for(c=[0,1],r=[0,1])
            translate([B+c*(w+tile_gap)+(c==0?-spread:spread),
                       B+r*(h+tile_gap)+(r==0?-spread:spread),0]) panel(f,c,r);
        // Quatre cles par face, a inserer avant la fermeture du cadre.
        for(r=[0,1]) translate([ds[0]/2-6,
            B+r*(h+tile_gap)+h/2-3+(r==0?-spread:spread),1.5]) key();
        for(c=[0,1]) translate([B+c*(w+tile_gap)+w/2+3+(c==0?-spread:spread),
                                ds[1]/2-6,1.5])
            rotate([0,0,90]) key();
        color("#c79165")
            translate([ds[0]/2,ds[1]/2,
                       (panel_thickness-cross_thickness)/2]) cross_key();
    }
}

module key() { cube([12,6,2]); }

module frame() {
    for(ix=[0:2],iy=[0:2],iz=[0:2])
        if((ix==1?1:0)+(iy==1?1:0)+(iz==1?1:0)<=1)
            color("#e8b65d") translate([coords[0][ix],coords[1][iy],coords[2][iz]])
                node(ix,iy,iz);
    for(a=[0:2],e=[0:3],h=[0:1])
        color("#405d70") edge_transform(a,e)
            translate([B+h*(beam_length(a)+B),0,0]) beam(a,e,h);
}

module fan_reference() {
    // Encombrement uniquement, pas une reproduction du cadre arrondi Noctua.
    color([0.55,0.35,0.22,0.65])
        translate([width/2,fan_front+fan_thickness/2,height/2]) rotate([90,0,0])
            difference() {
                cube([fan_size,fan_size,fan_thickness],center=true);
                cylinder(d=fan_aperture,h=fan_thickness+2,center=true);
                for(x=[-1,1],y=[-1,1]) translate([x*fan_pitch/2,y*fan_pitch/2,0])
                    cylinder(d=fan_screw_clearance,h=fan_thickness+2,center=true);
            }
}

// Encombrement uniquement : rainures ouvertes sur toute la profondeur afin
// de verifier aussi l'insertion par l'avant. Ne constitue pas un chassis fini.
module chassis_reference(i) {
    x=(width-chassis_width)/2;
    difference() {
        translate([x,10,slot_z(i)]) cube([chassis_width,fan_front-15,slot_height(i)]);
        for(side=[0,1])
            translate([side==0 ? x-eps : x+chassis_width-rail_groove_depth,
                       10-eps,rail_z(i)-rail_fit])
                cube([rail_groove_depth+eps,fan_front-15+2*eps,
                      rail_height+2*rail_fit]);
    }
}

module assembly(explode=0) {
    frame();
    color("#82aa75") rack_strips(explode);
    for(f=["left","right","top","bottom","rear"])
        color([0.7,0.78,0.82,1]) panel_face(f,explode);
    if(show_fan) %fan_reference();
    if(show_slots) for(i=[0:units-1]) %chassis_reference(i);
    echo("EXTERIEUR XYZ",[width,depth,height]);
    echo("Largeur libre avant",chassis_width+2*chassis_clearance);
    echo("Face avant du ventilateur depuis Y=0",fan_front);
    echo("Ossature collee : engagement et jeu par face",[tenon_length,fit]);
    echo("Logement insert 1U : diametre, profondeur, espace libre derriere",
         [rack_insert_diameter,rack_insert_depth,rack_screw_relief]);
    echo("Retrait des bandes / epaisseur facade",rack_front_thickness);
    echo("Hauteurs utiles des emplacements",[for(i=[0:units-1]) slot_height(i)]);
    echo("Axes des vis 1U depuis le bas",[for(i=[0:units-1]) slot_mount_z(i)]);
    echo("Guides : hauteur, engagement, deport, debut et fin",
         [rail_height,rail_engagement,rail_standoff,rail_start,rail_end]);
    echo("Rainure chassis : hauteur, profondeur, fond restant",
         [rail_height+2*rail_fit,rail_groove_depth,chassis_wall_thickness-rail_groove_depth]);
    echo("Largeur interieure des futurs chassis",chassis_width-2*chassis_wall_thickness);
    echo("Passage et lamage des vis ventilateur (a valider)",
         [fan_screw_clearance,fan_head_diameter,fan_head_depth]);
}

module coupon() {
    // Rainures croisees 5.2 x 4, languettes a onglet imprimees separement.
    translate([0,25,0]) difference() {
        cube([10,35,10]);
        translate([B-groove_depth,-eps,rack_tongue_offset-groove_fit])
            cube([groove_depth+eps,35+2*eps,panel_thickness+2*groove_fit]);
        translate([panel_offset-groove_fit,4,B-groove_depth])
            cube([panel_thickness+2*groove_fit,27,groove_depth+eps]);
    }
    translate([25,25,0]) {
        cube([10,25,panel_thickness]);
        edge_tab(25);
    }
    translate([45,25,0]) key();
    // Fixation 1U representative, face avant vers le haut pour l'essai.
    translate([85,0,rack_strip_thickness]) mirror([0,0,1]) {
        difference() {
            union() {
                cube([ear_width-chassis_clearance,unit_height,rack_strip_thickness]);
                translate([0,0,(rack_strip_thickness-panel_thickness)/2])
                    edge_tab(unit_height,rack_tongue_offset);
            }
            translate([ear_width/2,unit_height/2,0]) rack_mount_hole();
        }
        for(sign=[-1,1])
            translate([ear_width/2,unit_height/2+sign*rack_peg_offset,0]) rack_peg();
    }
    // Paroi arriere de 5 mm : passage de vis et logement de tete, visibles dessus.
    translate([110,0,panel_thickness]) mirror([0,0,1]) difference() {
        cube([24,24,panel_thickness]);
        translate([12,12,0]) fan_mount_hole();
    }
    // Guide avec son deport reel, rainure 10.4 x 2.2 dans une paroi de 4.
    translate([110,30,0]) {
        cube([30,20,panel_thickness]);
        translate([0,rail_gusset+1,panel_thickness]) guide_rail(30);
    }
    translate([150,30,0]) difference() {
        cube([30,14,chassis_wall_thickness]);
        translate([-eps,(14-rail_height-2*rail_fit)/2,chassis_wall_thickness-rail_groove_depth])
            cube([30+2*eps,rail_height+2*rail_fit,rail_groove_depth+eps]);
    }
    // Quatre quartiers et croix interne separee : insertion par les chants.
    translate([0,70,panel_thickness]) mirror([0,0,1])
        for(c=[0,1],r=[0,1]) difference() {
            translate([c*(30+tile_gap/2),r*(30+tile_gap/2),0])
                cube([30-tile_gap/2,30-tile_gap/2,panel_thickness]);
            translate([30,30,0]) cross_pocket();
        }
    translate([115,105,0]) cross_key();
}

// Six paires reelles barre/raccord : trois jeux pour les tenons ordinaires,
// puis trois pour les tenons avant. Les jeux sont graves sur les barres.
module joint_coupon() {
    for(j=[0:5]) {
        front=j>=3;
        joint_fit=0.15+(j%3)*0.05;
        translate([0,j*15,0]) difference() {
            beam(front?2:0,0,0,joint_fit);
            translate([2,0.5,B-0.3]) linear_extrude(0.3+eps)
                text(str(joint_fit),size=1.5);
        }
        translate([146,j*15,0])
            if(front)
                multmatrix([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]]) node(0,0,1);
            else node(1,0,0);
    }
}

if(part=="assembly") assembly();
if(part=="exploded") assembly(35);
if(part=="beam") beam(axis,edge,half);
if(part=="rack_strip")
    translate([groove_depth,0,rack_strip_thickness]) mirror([0,0,1]) rack_strip(half);
if(part=="node") {
    // Mettre les tenons inferieurs sur Z=0 et garder X/Y positifs.
    // Les noeuds des aretes horizontales hautes n'ont pas de tenon vers le bas.
    translate([tenon_length,tenon_length,
               node_z>0 && node_x!=1 && node_y!=1 ? tenon_length : 0])
        node(node_x,node_y,node_z);
}
if(part=="panel") translate([groove_depth,groove_depth,0]) panel(face,column,row);
if(part=="key") key();
if(part=="cross") translate([cross_span/2,cross_span/2,0]) cross_key();
if(part=="coupon") coupon();
if(part=="joint_coupon") joint_coupon();
