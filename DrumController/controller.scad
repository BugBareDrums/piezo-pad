// $fa = 1;
// $fs = 0.4;

include <modules/roundedcube.scad>

padWidth = 32;
padHeight = 10;
padWallThickness = 5;

cushionHeight = 12;
cushionCutout = padWidth - (2 * padWallThickness);
cushionWidth = cushionCutout - 0.5;
cushionCenter = cushionWidth / 2;

piezoDiameter = 22;
numberOfPads = 4;
numberOfPadsPerRow = sqrt(numberOfPads);
gapBetweenPads = 5;
bodyHeight = 25;
electronicsCutoutHeight = 15;
bodyWidth = (padWidth + (gapBetweenPads * 2)) * numberOfPadsPerRow;
wireHoleRadius = 3 / 2;
wireOffset = cushionWidth - 2;
sinkDepth = 5;

bodyWallThickness = 5;
baseCutout = 4;
baseHeight = 2;

usbWidth = 9;
usbHeight = 4.55;
usbScrewHoleToHole = 18;
usbScrewRadius = 3.5 / 2;

usbCutoutHeight = 6;

usbCounterCutoutHeight = 10.5;
usbCounterCutoutWidth = 26;

teensyWidth = 17.84;
teensyLength = 61;
teensyHeight = 4.5;

module pad(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      roundedcube([ padWidth, padWidth, padHeight ], false, 4, "all");

      // cushion cutout
      translate([ padWallThickness, padWallThickness, padHeight / 2 ]) {
        cube([ cushionWidth, cushionWidth, padHeight ]);
      }
    }
  }
}

module cushion(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      cube([ cushionWidth, cushionWidth, cushionHeight ]);

      // piezo cutout
      translate([ cushionCenter, cushionCenter, cushionHeight - 3 ]) {
        cylinder(h=5, r=(piezoDiameter/2));
        //resize([ piezoDiameter, piezoDiameter, 4 ]) sphere(r = 5);
      }

      // wire hole
      translate([ cushionCenter, wireOffset, -0.01 ]) {
        cylinder(h = cushionWidth + 10, r = wireHoleRadius);
      }
    }
  }
}

module controllerBody(pos = [ 0, 0 ]) {
  translate(pos) {
    difference() {
      // body
      roundedcube([ bodyWidth, bodyWidth, bodyHeight ], false, 4, "all");

      // electronics cutout
      translate([ bodyWallThickness, bodyWallThickness, 0 ]) {
        cube([
          bodyWidth - (bodyWallThickness * 2),
          bodyWidth - (bodyWallThickness * 2),
          electronicsCutoutHeight
        ]);
      }

      // base cutout
      translate([ baseCutout, baseCutout, 0 ]) {
        cube([
          bodyWidth - (baseCutout * 2), bodyWidth - (baseCutout * 2),
          baseHeight
        ]);
      }

      // USB cutout
      translate([ (bodyWidth / 2), 0, usbCutoutHeight ]) {
        // center usb holes
        translate([ -(usbWidth / 2), 0, 0 ]) {
          cube([ usbWidth, bodyWallThickness + 0.01, usbHeight ]);

          // screw holes
          translate(
              [ (usbWidth / 2), bodyWallThickness + 0.01, usbHeight / 2 ]) {
            translate([ (usbScrewHoleToHole / 2), 0, 0 ]) {
              rotate(a = 90, v = [ 1, 0, 0 ]) {
                cylinder(h = bodyWallThickness + 0.01, r = usbScrewRadius);
              }
            }
            translate([ -(usbScrewHoleToHole / 2), 0, 0 ]) {
              rotate(a = 90, v = [ 1, 0, 0 ]) {
                cylinder(h = bodyWallThickness + 0.01, r = usbScrewRadius);
              }
            }
          }
        }

        translate(-[ usbCounterCutoutWidth / 2, -3, (usbCutoutHeight / 2) ]) {
          cube([ usbCounterCutoutWidth, 30, usbCounterCutoutHeight ]);
        }
      }

      // cushion cutouts
      translate(
          [ gapBetweenPads * 2, gapBetweenPads * 2, bodyHeight - sinkDepth ]) {
        for (i = [0:numberOfPads - 1]) {
          translate([
            (i % numberOfPadsPerRow) * (bodyWidth / numberOfPadsPerRow),
            floor(i / numberOfPadsPerRow) * (bodyWidth / numberOfPadsPerRow)
          ]) {
            // cushion cutout
            cube([ cushionWidth, cushionWidth, 100 ]);

            // wire hole
            translate([ cushionCenter, wireOffset, -bodyHeight ]) {
              cylinder(h = bodyHeight + 5, r = wireHoleRadius);
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