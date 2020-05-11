wall_thickness = 1;
wlls = 2 * wall_thickness;

total_width = 121;

pi_width = 85.5; // Only lasts 19 mm down the side, 0 up
pi_height = 65;

screen_width = 73; //75, margin a bit
screen_height = 48; //50, margin a bit
// THESE ARE FROM BOUNDARIES
// Screen 3 mm from bottom, + 1 mm margin = 4 mm
// Screen 10 mm from top + 1 mm = 11
// 4 + 48 + 11 = 63, again missing a few we'll say
// 5 from bottom, 12 from top
// Screen 16 mm from left + 1mm margin = 17 mm
// BUT 28 mm from right + 1 mm margin = 29 mm
// Total = 17 + 73 + 29 = 119 .. missing a few mm add one to each side
// 18 from left, 30 from right :)


//THESE ARE FROM DISPLAY
//3 from top + 1 = 4
//3 from bottom + 1 = 4
//3 from left + 1 = 4
//9 from right + 1 = 9

display_width = 86;
display_height = 56;
display_thickness = 7; 

// 12 top, 5 bot, 18 left 30 right
screen_top_offset = 12;
screen_left_offset = 18;
display_y_off = (pi_height - screen_height)/2 - screen_top_offset;
display_x_off = (total_width - screen_width)/2 - screen_left_offset;
screen_x_off = -2.5;

total_depth = 28; // no margin here
display_depth = 7; // ish ofc

barrier_depth = 2;

cutout_height = 18;
cutout_width = 18;


//Faceplate
module faceplate(thck) {
  translate([0, 0, thck/2])
  difference() {
    cube([total_width+0.2, pi_height+0.2, thck], center=true);
    translate([display_x_off, display_y_off, 0])
      cube([screen_width, screen_height, thck + 0.2], center=true);
  }
}

module display_surround(thck) {
  translate([display_x_off + screen_x_off, display_y_off, thck/2]) // Needs another offset
  difference() {
    cube([display_width + wlls, display_height + wlls, thck],
      center=true);
    cube([display_width, display_height, thck+0.2], center=true);
  }
}

module corners(width, height, thickness, overlap, nesw=[1,1,1,1]) {
  translate([display_x_off + screen_x_off, display_y_off, thickness/2])
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
  radius = 1.5;
  cendheight = height + 2*radius + 1;

  slot_width = 3;
  slot_height = 1.5;
  sendheight = height + 1;
  difference() {
    union() {
      //Top
      translate([total_width/2-post_width/2, pi_height/2-post_width/2, cendheight/2])
        cube([post_width, post_width, cendheight], center=true);
      translate([-total_width/2+post_width/2, pi_height/2-post_width/2, cendheight/2])
        cube([post_width, post_width, cendheight], center=true);

      //Bottom
      //translate([total_width/2-post_width/2, -pi_height/2+post_width/2, sendheight/2])
      //  cube([post_width, post_width, sendheight], center=true);
      //translate([-total_width/2+post_width/2, -pi_height/2+post_width/2, sendheight/2])
      //  cube([post_width, post_width, sendheight], center=true);
    }
    translate([0, pi_height/2-post_width/2, height+radius])
      rotate([0, 90, 0])
        cylinder(r=radius, h=4*total_width, center=true, $fn=20);
    //translate([total_width/2-post_width/2, -pi_height/2+post_width/2, height-0.5])
    //  cube([slot_width, 2*post_width, slot_height], center=true);
    //translate([-total_width/2+post_width/2, -pi_height/2+post_width/2, height-0.5])
    //  cube([slot_width, 2*post_width, slot_height], center=true);
    // Commented out for power conn / Ethernet but maybe decent idea
  }
}

module cooling_holes(air_height) {
  air_width = 3;
  air_margin_h =15;
  air_margin_v =17;

  air_horiz = 7;
  air_vert = 3;

  // With Margin
  hd = ((total_width+2*wlls)/2-air_margin_h-air_width/2)/(air_horiz-0.5);
  // With Margin = hd
  //hd = (total_width+2*wlls+air_width)/(2*air_horiz + 1);
  for (i = [1:air_horiz]) {
    translate([(i-0.5)*hd, 0, 0])
      cube([air_width, pi_height*2, air_height], center=true);
    translate([(0.5-i)*hd, 0, 0])
      cube([air_width, pi_height*2, air_height], center=true);
  }

  // With Margin
  vd = ((pi_height+2*wlls)/2-air_margin_v-air_width/2)/(air_vert-0.5);
  // With Margin = vd
  //vd = (pi_height+2*wlls+air_width)/(2*air_vert + 1);
  for (i = [1:air_vert]) {
    translate([0, (i-0.5)*vd, 0])
      cube([total_width*2, air_width, air_height], center=true);
    translate([0, (0.5-i)*vd, 0])
      cube([total_width*2, air_width, air_height], center=true);
  }
}

module cutout(height) {
  endheight = cutout_height+wall_thickness;
  translate([0, -pi_height/2+cutout_width/2, height/2-endheight/2-wall_thickness]) //TODO X/Z
    cube([total_width*2, cutout_width, endheight], center=true);
}

module walls(height) {
  translate([0, 0, height/2])
    difference() {
      cube([total_width+2*wlls, pi_height+2*wlls, height], center=true);
      cube([total_width, pi_height, height+0.2], center=true);
      translate([0, 0, height/2])
      cube([total_width+wlls, pi_height+wlls,wlls], center=true);

      cooling_holes(height-2*wlls);
      cutout(height);
    }
}

module front_part() {
  union(){
  faceplate(wall_thickness);
  translate([0, 0, wall_thickness-0.01])
    display_surround(display_depth+wall_thickness);
  translate([0, 0, wall_thickness + display_depth-0.01])
    corners(display_width+wlls, display_height+wlls, wall_thickness, 10, [0,1,1,0]);
  posts(total_depth+wlls);
  walls(total_depth+wlls);
  }
}

module back_plate(thck) {
  difference() {
    translate([0, 0, thck/2])
      cube([total_width+wlls, pi_height+wlls, thck], center=true);
    translate([0, 0, -0.1])
      posts(thck + 0.2);
  }
}

module back_part() {
  back_plate(wall_thickness);
}

//front_part();
//translate([0,0,total_depth+wall_thickness])
//back_part();
