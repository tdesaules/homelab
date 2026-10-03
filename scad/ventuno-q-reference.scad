// Modele fourni : arduino-ventuno-q.3mf, carte complete avec refroidissement.
// Repere recoupe avec le STEP equipe dans sbc/, ecart d'enveloppe <0.001 mm.
// Conteneur FreeCAD normalise : declarations PNG dedupliquees, 32 triangles
// d'aire nulle retires ; transformations appliquees dans un maillage d'affichage
// unique pour eviter la fusion booleenne implicite des sous-objets ouverts.
// Source : Arduino VENTUNO Q ABX00181, CC BY-SA 4.0.
// https://creativecommons.org/licenses/by-sa/4.0/
// PCB : X=0..100, Y=0..160, Z=-1.9971..0. Coordonnees conservees dans le 3MF.
// Le jeu sous les composants est mesure depuis Z=-6.5971, pas depuis le PCB.
function ventuno_bounds() = [[-0.656773,-0.350983,-6.5971],[102.348053,160,27.550005]];
function ventuno_holes() = [[14.117,6.6],[92,4],[3.5,156],[90,156]];
function ventuno_pcb_thickness() = 1.9971;
module ventuno_reference() { import("arduino-ventuno-q.3mf",convexity=10); }
