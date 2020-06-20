$fn=60;

OD = 38;
ID = 29;
in_len = 37;

out_len = OD/2 + in_len;

difference() {
  union() {
    sphere(r=OD/2);

    cylinder(r=OD/2, h=out_len);
    rotate([90, 0, 0])
      cylinder(r=OD/2, h=out_len);
    rotate([0, 90, 0])
      cylinder(r=OD/2, h=out_len);
  }

  translate([0, 0, OD/2])
    cylinder(r=ID/2, h=in_len+1);

  translate([0, -OD/2, 0])
    rotate([90, 0, 0])
      cylinder(r=ID/2, h=in_len+1);

  translate([OD/2, 0, 0])
    rotate([0, 90, 0])
      cylinder(r=ID/2, h=in_len+1);
}
