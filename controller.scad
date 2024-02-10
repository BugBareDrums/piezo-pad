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
bodyHeight = 25;
electronicsCutoutHeight = 10;
bodyWidth = (padWidth + (gap * 2)) * numberOfPadsPerRow;
wireHoleDiameter = 1.5;
sinkDepth = 5;

usbWidth = 8.1;
teensyWidth = 17.84;
teensyLength = 61;
teensyHeight = 4.5;

module pad(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      roundedcube([ padWidth, padWidth, padHeight ], false, 4, "all");

      // cushion cutout
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

      // piezo cutout
      translate([ cushionCenter, cushionCenter, cushionHeight ]) {
        resize([ piezoDiameter, piezoDiameter, 3 ]) sphere(r = 5);
      }

      // wire hole
      translate([ cushionCenter, cushionCenter + (piezoDiameter / 2) ])
          cylinder(h = cushionWidth + 10, r = wireHoleDiameter);
    }
  }
}

module controllerBody(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      // body
      roundedcube([ bodyWidth, bodyWidth, bodyHeight ], false, 4, "all");

      // electronics cutout
      translate([ gap * 2, gap * 2, 0 ]) {
        cube([
          bodyWidth - (gap * 4), bodyWidth - (gap * 4),
          electronicsCutoutHeight
        ]);
      }

      translate([ gap * 1.5, gap * 1.5, 0 ]) {
        cube([ bodyWidth - (gap * 3), bodyWidth - (gap * 3), 2 ]);
      }

      // USB cutout
      translate([ bodyWidth / 2, 0, bodyHeight / 5 ]) {
        cube([ usbWidth, 30, teensyHeight ]);
      }

      translate([ gap * 2, gap * 2, bodyHeight - sinkDepth ]) {
        for (i = [0:numberOfPads - 1]) {
          translate([
            (i % numberOfPadsPerRow) * (bodyWidth / numberOfPadsPerRow),
            floor(i / numberOfPadsPerRow) * (bodyWidth / numberOfPadsPerRow)
          ]) {
            // cushion cutout
            cube([ cushionWidth, cushionWidth, 100 ]);

            // wire hole
            translate([
              cushionCenter, cushionCenter + (piezoDiameter / 2), -bodyHeight
            ]) {
              cylinder(h = bodyHeight + 5, r = wireHoleDiameter);
            }
          }
        }
      }
    }
  }
}

pad();
cushion([ 50, 0 ]);
controllerBody([ 100, 0 ]);