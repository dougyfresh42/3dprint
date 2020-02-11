stamp_size = 20;

module stamp_body() {
  height = 2 * stamp_size;
  radius = stamp_size;
  cutout_radius = 1 * height;

  cutout_x=radius+sqrt(pow(cutout_radius,2)-pow(height/2,2));
  cutout_y=height / 2;
  cutout_z=0;

  rotate_extrude() {
    difference() {
    // Rectangle
      square([radius, height], center=false);
    // Minus Circle
      translate([cutout_x, cutout_y, cutout_z])
        circle(cutout_radius, $fn=50);
    }
  }
}

module initials(height=1) {
  size = stamp_size / 2;
  linear_extrude(height)
    mirror([1,0,0])
      text("DDM",
        halign="center",
        valign="center",
        size=size);
}

union() {
  difference() {
    stamp_body();
    translate([0,0,-0.1]);
    initials();
  }
  translate([0,0,stamp_size*2])
    initials();
}
