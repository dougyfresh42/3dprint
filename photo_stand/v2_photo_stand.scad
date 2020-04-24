photo_width = 5*25.4;
photo_height = 7*25.4;

edge = 1;
overlap = 15;

tolerance = 1;
slot_thickness = 1;

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

module frame_x() {
  overlap_side = sqrt(2) * overlap;
  echo("Overlap_side = ", overlap_side);
  theta_x = photo_width - overlap_side;
  theta_y = photo_height - overlap_side;
  echo("X: ",theta_x, "Y: ",theta_y);
  theta = atan2(theta_y, theta_x);
  echo("Theta: ",theta);

  x_width = cos(theta - 45)*overlap*2+1;
  echo("cos: ",cos(theta-45)," X_width: ", x_width);
  x_length = sqrt(pow(photo_width, 2) + pow(photo_height, 2));

  intersection() {
    frame_box();
    union() {
      rotate([0, 0, theta])
        cube([x_length, x_width, frame_thickness], center=true);
      rotate([0, 0, -theta])
        cube([x_length, x_width, frame_thickness], center=true);
    }
  }
}

module frame_outline() {
  difference() {
    frame_box();
    cube([slot_width - edge*2, slot_height - edge*2, frame_thickness + 1], center=true);
  }
}

module frame_corners() {
  intersection() {
    corners();
    frame_box();
  }
}

module combine_frame() {
  union() {
    frame_outline();
    frame_x();
  }
}

difference() {
  union() {
    difference() {
      combine_frame();
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
