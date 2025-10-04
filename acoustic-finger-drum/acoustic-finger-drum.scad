$fn=100;

bodyHeight=4.4;
bodyWidth=22;

module pieSlice(a, r, h, offset){
  // a:angle, r:radius, h:height
   rotate_extrude(angle=a) {
       translate([offset,0,0]) square([r,h]);
   }
}

module body(w, h) {
  translate([0, 0, 0.001]) rotate(-90) rotate_extrude(angle=180) {
    square([w/2,h]);
    //roundedRectangle(r, h, 3);
  } 
}

module lowerBody(w, h) {
  difference() {
    intersection() {
      translate([-20, -w / 2, 0]) cube([w, w, w]);
      translate([w, 0, 0]) cylinder(h, w * 1.5, w * 1.5); 
    }
    translate([0, -30.001, -0.01]) cube([62, 62, 32]);
  }
}

module body2(w, h) {
  union() {
    intersection() {
      translate([0, -bodyWidth/2, -1]) cube([w, w,  h +2]);
      translate([-1, 0, 0.001]) cylinder(h, w / 1.65, bodyWidth / 1.65);
    }
    translate([-w/2 + 3, -w/2, 0.001]) cube([(w/2), w, h]);
  }
}


module cutouts(h) {
  union() {
    rotate(-25) pieSlice(50, bodyWidth / 4, h, 3.5);

    rotate(30) pieSlice(20, bodyWidth / 8, h - 2, 9);
    rotate(-50) pieSlice(20, bodyWidth / 8, h - 2, 9);

    rotate(55) pieSlice(40, bodyWidth / 4, h , 3.5);
    rotate(-95) pieSlice(40, bodyWidth / 4, h, 3.5);
  }
}

module pilotHolePair(x, y) {
    translate([x, y, -0.001])  cylinder(1.5, 0.1, 0.1, $fn=8);
    translate([x, -y, -0.001])  cylinder(1.5, 0.1, 0.1, $fn=8);
}

module pilotHoles() {
    pilotHolePair(10,4);
    pilotHolePair(10.7,2);
    pilotHolePair(11,0);
    pilotHolePair(5, 4);
    pilotHolePair(6.5, 10);
    pilotHolePair(4.5, 10);
    pilotHolePair(2.5, 10);
    pilotHolePair(0.5, 10);
    pilotHolePair(-1.5, 10);
    pilotHolePair(-1.5, 5);
    pilotHolePair(-7, 10);
    pilotHolePair(-7, 8);
    pilotHolePair(-7, 6);
    pilotHolePair(-7, 4);
    pilotHolePair(-7, 2);
    pilotHolePair(-7, 0);
}
   

module main () {
    difference() {
      union() {
        body2(bodyWidth, bodyHeight);
      }
      
      cutouts(bodyHeight - 0.3);
      
      // contact mic cutout
      translate([0,0,-1]) cylinder(bodyHeight + 0.5, 2.25, 2.25);
      translate([-4,-0.5,bodyHeight -2.5]) cube([3,1,1]);
      
      // jack cutout
      translate([-6,-10,-1.5]) cube([3.5,bodyWidth/2.1,bodyHeight]);
      rotate([90, 0 ,0]) translate([-4.2, 1.25, 7]) cylinder(10, 0.63, 0.63);
      

      // battery cutout
      translate([-6, 4.501, -0.001]) cube([3.7, 6.5, 3.2]);
      translate([-3.5,-0.5,bodyHeight -2.5]) rotate([0,0,90])  cube([6,1,1]);
      
      pilotHoles();
    }
}

// base plate
translate([28, 0, 0]) {
    difference() {
      body2(bodyWidth,0.5);
      pilotHoles();
    }
  
}



main();










  










// difference() {   
//  cylinder(r=30, h=8, $fn=200);
//  union() {
//    translate([0,0,-0.01]) cylinder(r=5, h=9, $fn=200);
//    translate([0,0,-0.01]) pieSlice(20,30,10);
//  }
//}

