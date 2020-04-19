photo_width = 5*25.4;
photo_height = 5*25.4;

photo_angle = 80;

edge = 1;
slot_thickness = 0.5;
overlap = 2;

tolerance = 0.2;

frame_width = photo_width + 2 * edge + 2 * tolerance;
frame_height = photo_height + edge + tolerance;
frame_thickness = 2*edge + slot_thickness;

slot_width = photo_width + 2 * tolerance;
slot_height = photo_height + tolerance;

view_width = photo_width - 2 * overlap;
view_height = photo_height - overlap;
view_thickness = edge + 0.1;

base_thickness = 3;

union() {
  rotate([photo_angle, 0, 0])
  translate([0, frame_height / 2, -frame_thickness/2])
  difference () {
    cube([frame_width, frame_height, frame_thickness], center = true);
    translate([0, (edge + tolerance) / 2, 0])
      cube([slot_width, slot_height, slot_thickness], center = true);
    translate([0, overlap, (view_thickness + slot_thickness) / 2])
      cube([view_width, view_height, view_thickness], center = true);
  };
  
  // stand
  translate([0, frame_width / 4, -base_thickness / 2])
  difference () {
    cube([frame_width, frame_width/2, base_thickness], center = true);

    translate([frame_width / 2, - frame_width / 4, -base_thickness/2 - 0.1])
    rotate([0, 0, 30])
      cube([2 * frame_width, 2 * frame_width, base_thickness + 0.2]);

    translate([-frame_width / 2, -frame_width / 4, base_thickness/2+0.1])
    rotate([0, 180, -30])
      cube([2 * frame_width, 2 * frame_width, base_thickness + 0.2]);

  };
};
