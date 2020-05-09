wall_thickness = 1;
wlls = 2 * wall_thickness;

pi_width = 85;
pi_height = 56.2;

//TODO
screen_width = 70;
screen_height = 50;

display_width = 75;
display_height = 55;
display_thickness = 7;

display_x_off = 0;
display_y_off = 0;

total_depth = 20;
display_depth = 5;

barrier_depth = 2; //TODO

total_width = 150;

//Faceplate
module faceplate(thck) {
  translate([0, 0, thck/2])
  difference() {
    cube([total_width, pi_height, thck], center=true);
    translate([display_x_off, display_y_off, 0])
    cube([screen_width, screen_height, thck + 0.2], center=true);
  }
}

module display_surround(thck) {
  translate([0, 0, thck/2])
  difference() {
    cube([display_width + wlls, display_height + wlls, thck],
      center=true);
    cube([display_width, display_height, thck+0.2], center=true);
  }
}

module corners(width, height, thickness, overlap, nesw=[1,1,1,1]) {
  translate([0, 0, thickness/2])
  intersection() {
    cube([width, height, thickness], center=true);
    union() {
      if (nesw[0] == 1)
        translate([width/2, height/2, 0])
          rotate([0,0,45])
            cube(2*overlap, center = true);
      if (nesw[1] == 1)
        translate([width/2, -height/2, 0])
          rotate([0,0,45])
            cube(2*overlap, center = true);
      if (nesw[2] == 1)
        translate([-width/2, -height/2, 0])
          rotate([0,0,45])
            cube(2*overlap, center = true);
      if (nesw[3] == 1)
        translate([-width/2, height/2, 0])
          rotate([0,0,45])
            cube(2*overlap, center = true);
    }
  }
}

post_width = 5;
module posts(height) {
  difference() {
    union() {
      translate([pi_width / 2, 0, height/2])
        cube([post_width, post_width, height], center=true);
      translate([-pi_width / 2, 0, height/2])
        cube([post_width, post_width, height], center=true);
    }
    translate([0, 0, height - 3])
    rotate([0, 90, 0])
    cylinder(r=1.5, h=4*pi_width, center=true);
  }
}

module walls(height) {
  translate([0, 0, height/2])
    difference() {
      cube([total_width+wlls, pi_height+wlls, height], center=true);
      cube([total_width, pi_height, height+0.2], center=true);
    }
}

module front_part() {
  faceplate(wall_thickness);
  translate([0, 0, wall_thickness])
    display_surround(display_depth+wall_thickness);
  translate([0, 0, wall_thickness + display_depth])
    corners(display_width+wlls, display_height+wlls, wall_thickness, 10, [0,1,1,0]);
  translate([0, 0, wall_thickness])
  posts(display_depth * 2);//TODO
  walls(display_depth * 2);
}

module back_plate(thck) {
  difference() {
    translate([0, 0, thck/2])
      cube([total_width, pi_height, thck], center=true);
    translate([0, 0, -0.1])
      posts(thck + 0.2);
  }
}

module back_part() {
  back_plate(wall_thickness);
}

//front_part();
back_part();
