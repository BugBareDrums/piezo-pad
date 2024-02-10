// $fa = 1;
// $fs = 0.4;

include <modules/roundedcube.scad>

padWidth = 40;
padHeight = 15;
wallThickness = 5;
cushionHeight = 10;
cushionCutout = padWidth - (2 * wallThickness);
cushionWidth = cushionCutout - 0.5;
cushionCenter = cushionWidth / 2;
piezoDiameter = 20;
numberOfPads = 16;
numberOfPadsPerRow = sqrt(numberOfPads);
gap = 5;
bodyHeight = 20;
bodyWidth = (padWidth + (gap * 2)) * numberOfPadsPerRow;

module pad(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      roundedcube([ padWidth, padWidth, padHeight ], false, 4, "all");

      translate([ wallThickness, wallThickness, padHeight / 2 ]) {
        cube([ cushionCutout, cushionCutout, padHeight ]);
      }
    }
  }
}

module cushion(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      cube([ cushionWidth, cushionWidth, cushionHeight ]);
      translate([ cushionCenter, cushionCenter, cushionHeight ]) {
        resize([ piezoDiameter, piezoDiameter, 3 ]) sphere(r = 5);
      }

      translate([ cushionCenter, cushionCenter + (piezoDiameter / 2) ])
          cylinder(h = cushionWidth + 10, r = 1);
    }
  }
}

module controllerBody(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      roundedcube([ bodyWidth, bodyWidth, bodyHeight ], false, 4, "all");
      translate([ gap * 2, gap * 2, 10 ]) {
        for (i = [0:numberOfPads - 1]) {
          translate([
            (i % numberOfPadsPerRow) * (bodyWidth / numberOfPadsPerRow),
            floor(i / numberOfPadsPerRow) * (bodyWidth / numberOfPadsPerRow)
          ]) {
            cube([ cushionWidth, cushionWidth, 1000 ]);
          }
        }
      }
    }
  }
}

pad();
cushion([ 50, 0 ]);
controllerBody([ 100, 0 ]);