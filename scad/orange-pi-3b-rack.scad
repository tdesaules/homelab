// Reservation MECANIQUE, specifications Orange Pi 3B non confirmees.
// Les quatre volumes orange 90 x 60 x 25 sont des budgets, pas des modeles de cartes.
// Aucun percage PCB ni decoupe de connecteur ne sont inventes.
// floor/side_panel : deux segments avant/arriere ; facade + trois joint_key : huit pieces.
use <sbc-rack-core.scad>
use <compute-rack-core.scad>
use <compute-cassette-core.scad>
/* [Selection] */
part="completed"; // [completed,exploded,installed,floor,side_panel,front,joint_key,coupon]
// floor/side_panel : section avant/arriere ; front/joint_key/coupon : piece entiere.
segment=0; // [0:Avant,1:Arriere]
/* [Affichage] */
show_reservations=true;
cassette_index=4; // [0:4]
/* [Implantation] */
rack_depth=230;
/* [Hidden] */
$fn=$preview?24:48;
$compute_depth=rack_depth;
module orange_cassette(explode=0,reservations=true) {
    cc_parts(explode) cc_carrier();
    if(reservations) for(row=[0,1],col=[0,1])
        %color([1,.55,.1,.4]) translate([7,8+98*col,4+64*row]) cube([25,90,60]);
}
module orange_cassette_export(selection,piece=0) {
    assert(piece==0 || piece==1);
    if(selection=="floor") cc_floor_flat(piece);
    if(selection=="side_panel") cc_carrier_flat(piece) cc_carrier();
    if(selection=="front") cc_front_flat() cc_front();
    if(selection=="joint_key") cr_joint_key();
    if(selection=="coupon") drawer_screw_coupon(4);
}
assert(segment==0 || segment==1);
assert(len([for(p=["completed","exploded","installed","floor","side_panel","front","joint_key","coupon"]) if(p==part) p])==1);
cr_validate() {
    if(part=="completed") orange_cassette(0,show_reservations);
    else if(part=="exploded") orange_cassette(18,reservations=false);
    else if(part=="installed") {
        %assembly();
        cr_install() { %cr_structure(); cr_cassette_position(cassette_index) orange_cassette(0,show_reservations); }
    }
    else orange_cassette_export(part,segment);
    echo("RESERVATION Orange Pi 3B : perçages et connecteurs a confirmer");
}
