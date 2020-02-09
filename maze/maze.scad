ball_width = 5;
maze_width = 42;
maze_height = 8;

wall_thickness = 1;

// Walls of Maze
outer_width = maze_width + wall_thickness * 2;
outer_height = maze_height + wall_thickness * 2;

module maze() {
  // Maze Internals
  translate([0,0,-0.1])
    linear_extrude(maze_height+0.2)
      import(file="interior.svg");
}

module walls() {
  difference() {
    
    translate([-wall_thickness, -wall_thickness, -wall_thickness])
      cube([outer_width, outer_width, outer_height]);
    cube([maze_width, maze_width, maze_height]);
    //translate([0,0,maze_height-0.1])
    //  cube([maze_width, maze_width, wall_thickness+0.2]);
  }
}

rh = 3;
rl = 5;
rw = 5.2;
module ramp(x=[0,0,0]) {
  translate(x) {
  translate([0, 0, rh/2-0.1])
    difference() {
      cube([rl, rw, rh+0.1], center=true);
      rotate([0, atan2(rh, rl), 0])
        translate([0, 0, 1*rh])
          cube([rl * 2, rw * 2, rh * 2], center=true);
    }
  }
}

module hole(x=0,y=0) {
  translate([x, y, maze_height+wall_thickness/2])
    cylinder(wall_thickness + 0.2, r=1.2, center=true, $fs=0.7);
}

coords = [[3,21],
          [9,9],
          [15,39],
          [21,3],
          [21,33],
          [27,27],
          [33,15],
          [39,21]];
module holes() {
  for(coord = coords) {
    hole(coord[0], coord[1]);
  }
}

module letters() {
  translate([6,21,maze_height+wall_thickness-0.3])
    linear_extrude(0.5)
      text("s", size=4, halign="center", valign="center");
  translate([36,21,maze_height+wall_thickness-0.3])
    linear_extrude(0.5)
      text("e", size=4, halign="center", valign="center");
}

union() {

maze();

ramp([27,21,0]);
translate([33, 21, maze_height])
  rotate([180, 0, 180])
    ramp([0,0,0]);

difference() {
walls();
holes();
letters();
}
}
