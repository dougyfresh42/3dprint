// SOURCE
// http://saccade.com/blog/2019/06/how-to-make-apples-mac-pro-holes/

thickness = 10;

length = 50;
width = 30;

multiple_of_circle = false;

circle_thick_ratio = 0.7;

circle_distance = 3;

// Calculate

circle_rad = thickness * circle_thick_ratio;

startxy = circle_distance + circle_rad;
stepx = 2 * circle_rad + circle_distance;
stepy = stepx * cos(30);
insetx = stepx / 2;

// Generate
difference() {
  cube([length, width, thickness]);

  for (y = [startxy:stepy*2:width]) {
    for (x = [startxy:stepx:length]) {
      translate([x, y, -1])
      cylinder(h = thickness + 2, r = circle_rad);
    }
  }

  for (y = [startxy+stepy:stepy*2:width]) {
    for (x = [startxy+insetx:stepx:length]) {
      translate([x, y, -1])
      cylinder(h = thickness + 2, r = circle_rad);
    }
  }
}
