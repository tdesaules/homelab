// Profil nominal commun : modifier ces valeurs pour changer durablement le
// boitier ET les tiroirs ouverts/exportes separement. Aucun rendu automatique.
// Les reglages locaux du Customizer de sbc-rack.scad sont des surcharges :
// exporter alors les tiroirs depuis ce fichier avec part="module_export".
function rack_defaults() = [
    ["width",280.25], ["height",269], ["depth",280.25], ["units",5],
    ["unit_height",47.4], ["top_unit_extra_height",0], ["gap",2], ["structure",10],
    ["chassis_width",230.25], ["chassis_wall_thickness",4], ["ear_width",15],
    ["chassis_clearance",2], ["panel_thickness",5], ["hex_flat",5],
    ["rear_hex_flat",10], ["web",2], ["panel_border",8], ["groove_fit",0.1],
    ["tile_gap",0.3], ["groove_depth",4], ["cross_span",130], ["cross_width",12],
    ["cross_thickness",2], ["cross_tip_radius",1], ["cross_fit",0.15],
    ["cross_pocket_depth",2.3], ["rail_height",10], ["rail_engagement",2],
    ["rail_start",16], ["rail_end",undef], // undef : calculer depth-50
    ["rail_entry",2], ["rail_gusset",6], ["rail_fit",0.2], ["fit",0.2],
    ["tenon_size",6], ["tenon_length",15], ["tenon_chamfer",0.5],
    ["glue_vent_diameter",1.5], ["screw_clearance",3.3], ["rack_front_thickness",4],
    ["rack_insert_diameter",5.5], ["rack_insert_depth",6], ["rack_screw_relief",4],
    ["rack_peg_diameter",3], ["rack_peg_height",2], ["rack_peg_offset",10],
    ["rack_peg_chamfer",0.4], ["fan_size",200], ["fan_thickness",32],
    ["fan_pitch",170], ["fan_aperture",190], ["fan_screw_clearance",5.5],
    ["fan_head_diameter",10], ["fan_head_depth",3]
];
