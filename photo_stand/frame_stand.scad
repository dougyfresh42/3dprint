photo_width = 5*25.4;

edge = 1;
slot_thickness = 1;

old_tolerance = 1;

frame_width = photo_width + 2*edge + 2*old_tolerance;
frame_thickness = 2*edge + slot_thickness;

overlap = 15;
angle = 10;

wall_thickness = 1.5;
base_thickness = 3;
tolerance = 0.5;

stand_width = frame_width + 2*wall_thickness + 2*tolerance;
stand_thickness = frame_thickness + 2*wall_thickness + 2*tolerance;
stand_height = overlap * sqrt(2);

module stand_box() {
  cube([stand_width, stand_thickness, stand_height], center=true);
}

module corners() {
  translate([stand_width / 2, stand_height / 2, -overlap/sqrt(2)])
  rotate([0, 45, 0])
  cube(2 * overlap, center = true);

  translate([-stand_width / 2, stand_height / 2, -overlap/sqrt(2)])
  rotate([0, 45, 0])
  cube(2 * overlap, center = true);
}

module frame_box() {
  translate([0, 0, wall_thickness])
  cube([frame_width + 2*tolerance, frame_thickness + 2*tolerance, stand_height], center=true);
}

module top_section() {
  rotate([-angle, 0, 0])
  translate([0, stand_thickness/2, stand_height/2])
  difference() {
    intersection() {
      stand_box();
      corners();
    }
    frame_box();
  }
}

module trapezoid(twidth, tlength, tthick) {
  difference() {
    cube([twidth, tlength, tthick], center=true);

    translate([twidth / 2, -tlength / 2, -tthick/2 - 0.1])
    rotate([0, 0, 30])
      cube([twidth, tlength*2, tthick + 0.2]);

    translate([-twidth / 2, -tlength / 2, tthick/2 + 0.1])
    rotate([0, 180, -30])
      cube([twidth, tlength*2, tthick + 0.2]);
  }
}

cube_thick = stand_thickness/cos(angle);
module base() {
  union() {
    difference() {
      trapezoid(stand_width, stand_width/2, base_thickness);
      trapezoid(stand_width - 20, stand_width / 2 - 10, base_thickness + 0.1);
    }
    translate([0, -(stand_width/4+cube_thick/2), 0])
    cube([stand_width, cube_thick, base_thickness], center=true);
  }
}

union() {
  translate([0, stand_width/4+cube_thick, -base_thickness/2])
  base();
  top_section();
}
