photo_width = 5*25.4;
photo_height = 7*25.4;

edge = 1;
overlap = 15;

tolerance = 0.5;
slot_thickness = 0.7;

frame_width = photo_width + 2 * edge + 2 * tolerance;
frame_height = photo_height + 2 * edge + 2 * tolerance;
frame_thickness = 2*edge + slot_thickness;

slot_width = photo_width + 2 * tolerance;
slot_height = photo_height + 2 * tolerance;

photo_angle = 80;
base_thickness = 3;

module frame_box() {
  // Frame
  cube([frame_width, frame_height, frame_thickness], center = true);
}

module corners() {
  translate([frame_width/2, frame_height/2, 0])
    rotate([0,0,45])
      cube(2*overlap, center = true);
  translate([frame_width/2, -frame_height/2, 0])
    rotate([0,0,45])
      cube(2*overlap, center = true);
  translate([-frame_width/2, -frame_height/2, 0])
    rotate([0,0,45])
      cube(2*overlap, center = true);
  translate([-frame_width/2, frame_height/2, 0])
    rotate([0,0,45])
      cube(2*overlap, center = true);
}

module frame_corners() {
  intersection() {
    corners();
    frame_box();
  }
}

difference() {
  union() {
    difference() {
      frame_box();
      translate([0, 0, frame_thickness / 2])
        cube([slot_width, slot_height, frame_thickness], center=true);
    }
    frame_corners();
  }
  #cube([slot_width, slot_height, slot_thickness], center=true);
}


/*
-------
|/   \|
|     |
|\   /|
-------
*/
