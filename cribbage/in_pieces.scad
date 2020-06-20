include <2pv8cribbage.scad>;

tenon_width = side_space / 2;
gtolerance = 1;
tenon_length = 5;

cut_point = length_offset + sbig_rad + 4.5 * group_space + 4 * group_height;

first_x = padding + pin_diam/2 + group_width + side_space / 2;
second_x = first_x + group_width + side_space;

module tenon1(tolerance=0, cutout=0) {
  translate([first_x,cut_point,thickness/2]) {
    cube([tenon_width-tolerance, 2*tenon_length-tolerance, thickness+cutout], center=true);
  }
}

module tenon2(tolerance=0, cutout=0) {
  translate([second_x,cut_point,thickness/2]) {
    cube([tenon_width-tolerance, 2*tenon_length-tolerance, thickness+cutout], center=true);
  }
}

// First Half
module part_one() {
  union() {
    difference() {
      translate([side_offset, length_offset, 0])
        board();

      translate([-1, cut_point, -1])
        cube([real_width + 2, real_height, thickness + 2]);

      tenon2(cutout=1);
    }

    tenon1(tolerance=gtolerance);
  }
}

// Second Half
module part_two() {
  union() {
    difference() {
      translate([side_offset, length_offset, 0])
        board();

      translate([-1, -1, -1])
        cube([real_width + 2, cut_point + 1 + gtolerance/2, thickness + 2]);

      tenon1(cutout=1);
    }
    tenon2(tolerance=gtolerance);
  }
}

//part_one();
part_two();
