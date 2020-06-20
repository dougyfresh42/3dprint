$fn=60;

OD = 22;
ID = 14.5;
in_len = 37;

out_len = OD/2 + in_len;

union() {
  sphere(r=OD/2);

  cylinder(r=OD/2, h=OD/2);
  rotate([90, 0, 0])
    cylinder(r=OD/2, h=OD/2);
  rotate([0, 90, 0])
    cylinder(r=OD/2, h=OD/2);

  cylinder(r=ID/2, h=out_len);
  rotate([90, 0, 0])
    cylinder(r=ID/2, h=out_len);
  rotate([0, 90, 0])
    cylinder(r=ID/2, h=out_len);
}
