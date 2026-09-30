// Rack SBC 5 emplacements identiques de 47.4 mm - prototype d'assemblage, mm.
// X=largeur, Y=profondeur, Z=hauteur, avant Y=0.
// installed : vue d'ensemble avec les modules dessines, pas un STL a imprimer.
// Cartes, ventilateur et gabarits sont des references visibles avec F5.
// Les pieces restent exportables separement avec les autres valeurs de part.
// Liaison des panneaux : cinq croix internes 130 x 130 x 2, sans petites cles.
// Engager les quartiers par leurs chants autour des croix avant de fermer le cadre.
// Boitier : 73 pieces imprimees hors eprouvettes et tiroirs.
// cross_coupon : quatre quartiers d'essai, a assembler autour d'une croix exportee a part.
// Cotes nominales communes : rack-config.scad. Pour une variante locale,
// activer use_local_rack_settings ; exporter ses tiroirs ici via module_export.
use <rack-config.scad>
use <sbc-rack-core.scad>
use <network-rack.scad>
use <power-rack.scad>

/* [Affichage] */
part = "assembly"; // [assembly,installed,exploded,beam,node,panel,rack_strip,cross,cross_coupon,coupon,joint_coupon,module_export]
show_fan = true;
show_slots = false; // gabarits des emplacements libres dans la vue installed
show_panels = true;
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

/* [Modules installes] */
show_network = true;
show_power = true;
show_module_boards = true;
show_module_hardware = true;

/* [Export des modules] */
module_name = "network"; // [network,power]
module_part = "body"; // [body,front,floor_key,front_key,coupon,key_coupon]
module_side = 0; // [0,1]

/* [Configuration] */
// false : profil commun rack-config.scad. true : utiliser les reglages ci-dessous.
use_local_rack_settings = false;

/* [Dimensions] */
width = 280.25;
height = 269;
depth = 280.25;
units = 5;
unit_height = 47.4;
top_unit_extra_height = 0; // aucune surhauteur specifique au dernier emplacement
gap = 2;
structure = 10;
chassis_width = 230.25;
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
cross_span = 130;
cross_width = 12;
cross_thickness = 2;
cross_tip_radius = 1; // coins arrondis des extremites des branches
cross_fit = 0.15; // jeu lateral pour insertion et colle
cross_pocket_depth = 2.3; // logement interne centre : peaux de 1.35 mm

/* [Guides des chassis] */
rail_height = 10;
rail_engagement = 2;
// Le centre des rails suit automatiquement l'axe des vis de chaque emplacement.
rail_start = 16; // depuis la face avant du boitier
rail_end = depth-50; // conserve 10.5 mm devant le ventilateur
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
rack_insert_diameter = 5.5; // pour insert thermique Ø6 : calibrer l'avant-trou
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
// Valeurs litterales ci-dessus pour conserver tous les champs du Customizer.
// La configuration active est transmise a la bibliotheque ET aux tiroirs.
function sbc_settings() = [
    ["width",width], ["height",height], ["depth",depth], ["units",units],
    ["unit_height",unit_height], ["top_unit_extra_height",top_unit_extra_height],
    ["gap",gap], ["structure",structure], ["chassis_width",chassis_width],
    ["chassis_wall_thickness",chassis_wall_thickness], ["ear_width",ear_width],
    ["chassis_clearance",chassis_clearance], ["panel_thickness",panel_thickness],
    ["hex_flat",hex_flat], ["rear_hex_flat",rear_hex_flat], ["web",web],
    ["panel_border",panel_border], ["groove_fit",groove_fit], ["tile_gap",tile_gap],
    ["groove_depth",groove_depth], ["cross_span",cross_span], ["cross_width",cross_width],
    ["cross_thickness",cross_thickness], ["cross_tip_radius",cross_tip_radius], ["cross_fit",cross_fit],
    ["cross_pocket_depth",cross_pocket_depth], ["rail_height",rail_height],
    ["rail_engagement",rail_engagement], ["rail_start",rail_start], ["rail_end",rail_end],
    ["rail_entry",rail_entry], ["rail_gusset",rail_gusset], ["rail_fit",rail_fit],
    ["fit",fit], ["tenon_size",tenon_size], ["tenon_length",tenon_length],
    ["tenon_chamfer",tenon_chamfer], ["glue_vent_diameter",glue_vent_diameter],
    ["screw_clearance",screw_clearance], ["rack_front_thickness",rack_front_thickness],
    ["rack_insert_diameter",rack_insert_diameter], ["rack_insert_depth",rack_insert_depth],
    ["rack_screw_relief",rack_screw_relief], ["rack_peg_diameter",rack_peg_diameter],
    ["rack_peg_height",rack_peg_height], ["rack_peg_offset",rack_peg_offset],
    ["rack_peg_chamfer",rack_peg_chamfer], ["fan_size",fan_size],
    ["fan_thickness",fan_thickness], ["fan_pitch",fan_pitch], ["fan_aperture",fan_aperture],
    ["fan_screw_clearance",fan_screw_clearance], ["fan_head_diameter",fan_head_diameter],
    ["fan_head_depth",fan_head_depth]
];
$rack_config = use_local_rack_settings ? sbc_settings() : rack_defaults();
echo("Configuration active",use_local_rack_settings ? "Customizer local" : "rack-config.scad");

// Ajouter ici les futurs modules et leur rendu, sans dupliquer leurs cotes.
function installed_module_registry() =
    concat(show_network ? [["network",network_slot_index()]] : [],
           show_power ? [["power",power_slot_index()]] : []);
function installed_module_slots() = [for(entry=installed_module_registry()) entry[1]];

module installed_slots_validate() {
    entries=installed_module_registry();
    for(entry=entries)
        assert(entry[1]>=0 && entry[1]<rack_value("units") && floor(entry[1])==entry[1],
               str("Emplacement invalide pour ",entry[0]));
    for(i=len(entries)>1 ? [0:len(entries)-2] : [],j=[i+1:len(entries)-1])
        assert(entries[i][1]!=entries[j][1],
               str("Emplacement partage par ",entries[i][0]," et ",entries[j][0]));
    children();
}

module installed_modules() {
    installed_slots_validate() for(entry=installed_module_registry()) {
        if(entry[0]=="network")
            network_installed(boards=show_module_boards,hardware=show_module_hardware,envelopes=false);
        if(entry[0]=="power")
            power_installed(boards=show_module_boards,hardware=show_module_hardware,envelopes=false);
    }
}

module installed_assembly() {
    assembly(panels=show_panels,fan=show_fan,slots=show_slots,occupied=installed_module_slots());
    installed_modules();
}

assert(part=="assembly" || part=="installed" || part=="exploded" || part=="beam"
       || part=="node" || part=="panel" || part=="rack_strip" || part=="cross"
       || part=="cross_coupon" || part=="coupon" || part=="joint_coupon"
       || part=="module_export","Selection inconnue");
rack_validate() {
    if(part=="assembly") assembly(panels=show_panels,fan=show_fan,slots=show_slots);
    if(part=="installed") installed_assembly();
    if(part=="exploded") assembly(35,panels=show_panels,fan=show_fan,slots=show_slots);
    rack_export(part,axis,edge,half,node_x,node_y,node_z,face,column,row);
    if(part=="module_export") installed_slots_validate() {
        assert(module_name=="network" || module_name=="power","Module inconnu");
        if(module_name=="network") network_export(module_part,module_side);
        if(module_name=="power") power_export(module_part,module_side);
    }
}
