/*

|=============o========|
|                      |
|                      |
|========o=============|


*/

slat_width = 25.4;
slat_thickness = 6;

wall_thickness = 4;
length = 25.4*3;

tooth_length = 1;
tooth_height = 2;

// Calculated

total_height = wall_thickness + slat_thickness;
total_width = 2 * wall_thickness + slat_width;

clip_height = total_height + tooth_height;

clip1x = 0;
clip2x = total_width - wall_thickness;

clip1y = (length / 2) - (total_width / 2) - wall_thickness;
clip2y = (length / 2) + (total_width / 2) - wall_thickness;


// CAD

// Clips
module clip(angle) {
  translate([wall_thickness / 2, wall_thickness / 2, 0])
  rotate([0, 0, angle])
  difference() {
    translate([-wall_thickness / 2, -wall_thickness / 2, -1])
    cube([wall_thickness, wall_thickness+tooth_length, clip_height + tooth_height + 1]);

    translate([-wall_thickness, wall_thickness / 2, -2])
    cube([wall_thickness * 2, wall_thickness * 2, total_height+2]);

    translate([0, wall_thickness/2 + tooth_length + wall_thickness*cos(45), total_height + wall_thickness*cos(45)+1])
    rotate([45, 0, 0])
    cube([wall_thickness * 2, wall_thickness * 2, wall_thickness * 40], true);

  }
}

difference() {
  union() {
  // Holder
  cube([total_width, length, total_height]);

  translate([clip1x, clip1y, total_height])
  clip(0);

  translate([clip2x, clip2y, total_height])
  clip(180);
  }
  
  translate([wall_thickness, -1, wall_thickness])
  cube([slat_width, length + 2, slat_thickness + 1]);
}
