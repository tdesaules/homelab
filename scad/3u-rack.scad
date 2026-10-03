// Chassis des slots 0,1,2 ; cinq cassettes egales, jeu 1 mm entre elles et aux flancs.
// Les facades (dont oreilles hautes) sont a Y=0, comme celles du boitier principal.
// Fixations externes : six M3 ; internes : cinq inserts M3 Ø5.5 x 6 a Y=4.
// floor/ceiling/side_panel : side=0/1 ET segment=0/1 (avant/arriere).
// front/mount_bar : side=0/1 ; floor_key et ceiling_key : une chacune.
// joint_key : huit exemplaires. Total chassis : 26 pieces hors coupon/cassettes.
// Coller d'abord les sections avant/arriere avec joint_key, puis les demi-plateaux
// autour des cles longues ; ajouter flancs et cadre avant. Traverse
// porte-inserts engagee dans le plafond. Tester coupon et guidages avant serie.
// completed : chassis nu ; sub-installed : chassis equipe ; installed : boitier complet.
use <sbc-rack-core.scad>
use <compute-rack-core.scad>
use <arduino-ventuno-q-rack.scad>
use <orange-pi-3b-rack.scad>
use <network-rack.scad>
use <power-rack.scad>
/* [Selection] */
part="completed"; // [completed,exploded,sub-installed,installed,floor,ceiling,side_panel,front,mount_bar,floor_key,ceiling_key,joint_key,coupon]
// floor/ceiling/side_panel : side et segment ; front/mount_bar : side seulement.
side=0; // [0:Gauche,1:Droite]
segment=0; // [0:Avant,1:Arriere]
/* [Affichage] */
show_cassettes=true; // sub-installed/installed ; completed et exploded restent le chassis nu
show_boards=true;
show_panels=true; // boitier principal, vue installed
show_fan=true;
show_hardware=true;
/* [Implantation] */
rack_depth=230;
/* [Hidden] */
$fn=$preview?24:48;
$compute_depth=rack_depth;
function three_u_slots() = [0,1,2];
module three_u_assembly(explode=0,cassettes=true,boards=true) {
    cr_validate() {
        cr_structure(explode);
        if(cassettes) for(i=[0:4]) translate([0,-3*explode,0]) cr_cassette_position(i)
            if(i<4) ventuno_cassette(0,boards); else orange_cassette(0,boards);
    }
}
module three_u_installed(boards=true) { cr_install() three_u_assembly(0,true,boards); }
// Pas de use <sbc-rack.scad> : celui-ci importe deja ce module.
module three_u_full_assembly() {
    slots=concat(three_u_slots(),[network_slot_index(),power_slot_index()]);
    for(i=[0:len(slots)-2],j=[i+1:len(slots)-1])
        assert(slots[i]!=slots[j],"Emplacement partage entre 3U, reseau et alimentation");
    assembly(panels=show_panels,fan=show_fan,slots=false,occupied=slots);
    network_installed(boards=show_boards,hardware=show_hardware,envelopes=false);
    power_installed(boards=show_boards,hardware=show_hardware,envelopes=false);
    cr_install() three_u_assembly(0,show_cassettes,show_boards);
}
module three_u_export(selection,s=0,piece=0) { cr_validate() cr_export(selection,s,piece); }
assert(side==0 || side==1);
assert(segment==0 || segment==1);
assert(len([for(p=["completed","exploded","sub-installed","installed","floor","ceiling","side_panel","front","mount_bar","floor_key","ceiling_key","joint_key","coupon"]) if(p==part) p])==1);
cr_validate() {
    if(part=="completed") three_u_assembly(cassettes=false);
    else if(part=="exploded") three_u_assembly(18,cassettes=false);
    else if(part=="sub-installed") three_u_assembly(0,show_cassettes,show_boards);
    else if(part=="installed") three_u_full_assembly();
    else three_u_export(part,side,segment);
    echo("3U : corps XYZ",[cr_w(),cr_d(),cr_h()]);
    echo("Cassettes : largeur, jeu, hauteur corps",[cr_cw(),cr_gap(),cr_ch()]);
    echo("Distance au ventilateur",rack_value("fan_front")-cr_d());
}
