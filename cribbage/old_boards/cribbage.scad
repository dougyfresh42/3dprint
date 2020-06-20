// Inputs
peg_diameter = 5;
total_length = 11.125 * 25.4;
total_width = 2.5;

// Calcs
//row_spacing = peg_diameter;
//peg_spacing = row_spacing * 1.5;
//group_width = 3*peg_diameter + 2*peg_spacing + horiz_spacing;
//overall_width = group_width * 3 - horiz_spacing;



// Inputs
peg_diameter = 5;
//A
row_spacing = 5;
//B
peg_spacing = row_spacing * 1.5;
//C
group_spacing = 10;
//D
horiz_spacing = 10;

/*
oBo oD o o o
A
o o o  o o o

o o o  o o o

o o o  o o o

o o o  o o o
C

o o o  o o o
...
*/

// width calcs
group_length = 5*peg_diameter+4*row_spacing + group_spacing;
//group_width = 3*(peg_diameter + peg_spacing) + horiz_spacing;
group_width = 3*peg_diameter + 2*peg_spacing + horiz_spacing;

// big arc calcs
center_radius = 3 * peg_diameter+2*peg_spacing+horiz_spacing-group_spacing/2 - peg_diameter/2;
outer_radius = center_radius + peg_diameter + peg_spacing;
inner_radius = center_radius - peg_diameter - peg_spacing;

// little arc calcs

overall_width = group_width * 3 - horiz_spacing;
//Length:
overall_length = 
//7 * group length
7 * group_length +
//arc height
3*peg_diameter+2*peg_spacing+horiz_spacing+peg_diameter+peg_spacing +
//bottom arc extension
// IRRELEVANT
//bottom pegs
2*(group_spacing+peg_diameter)+(group_width/2+peg_spacing+peg_diameter)
// NEEDS SOMETHING ADDED THIS IS TOP ROW OF BOTTOM PEGS
+2*(peg_spacing +peg_diameter)
-peg_diameter/2;


module row() {
  translate([-peg_diameter-peg_spacing,0,0])
    #circle(d=peg_diameter);
  translate([peg_diameter+peg_spacing,0,0])
    #circle(d=peg_diameter);
  #circle(d=peg_diameter);
}

module group() {
  for(i = [0:4]) {
    translate([0,(row_spacing+peg_diameter)*i, 0])
      row();
  }
}

module start_group() {
  for(i = [-2:0]) {
    translate([0,(row_spacing+peg_diameter)*i, 0])
      row();
  }
}

// 7 - 2 - 7 - 1 - 7

for(i = [0:2]) {
  for(j = [0:6]) {
    translate([i*group_width,j*group_length,0])
      group();
  }
}

//BIG ARC

translate([group_width, 7*group_length, 0])
for(angle = [0:22.5:90]) {
  x1 = cos(angle)*inner_radius + group_spacing/2 + peg_diameter/2;
  x2 = cos(angle)*center_radius + group_spacing/2 + peg_diameter/2;
  x3 = cos(angle)*outer_radius + group_spacing/2 + peg_diameter/2;
  y1 = sin(angle)*inner_radius;
  y2 = sin(angle)*center_radius;
  y3 = sin(angle)*outer_radius;
  translate([x1,y1,0])
    #circle(d=peg_diameter);
  translate([x2,y2,0])
    #circle(d=peg_diameter);
  translate([x3,y3,0])
    #circle(d=peg_diameter);

  translate([-x1,y1,0])
    #circle(d=peg_diameter);
  translate([-x2,y2,0])
    #circle(d=peg_diameter);
  translate([-x3,y3,0])
    #circle(d=peg_diameter);
}

//LITTLE ARC
translate([3*group_width/2, -group_spacing-peg_diameter, 0])
for(angle = [0:-45:-180]) {
  x1 = cos(angle)*(group_width/2+peg_spacing+peg_diameter);
  x2 = cos(angle)*group_width/2;
  x3 = cos(angle)*(group_width/2-peg_spacing-peg_diameter);
  y1 = sin(angle)*(group_width/2+peg_spacing+peg_diameter);
  y2 = sin(angle)*group_width/2;
  y3 = sin(angle)*(group_width/2-peg_spacing-peg_diameter);

  translate([x1,y1,0])
    circle(d=peg_diameter);
  translate([x2,y2,0])
    circle(d=peg_diameter);
  translate([x3,y3,0])
    circle(d=peg_diameter);
}

translate([0, -group_spacing-peg_diameter, 0])
start_group();

// FINISH HOLE
translate([group_width, 7 * group_length, 0])
  circle(d=peg_diameter);

// GAMES HOLES
// First hole
left_hole = -peg_diameter - peg_spacing;
right_hole = 2*group_width + peg_diameter + peg_spacing;

spacing = (right_hole - left_hole) / 6;

translate([0, -2*(group_spacing+peg_diameter)-(group_width/2+peg_spacing+peg_diameter), 0])
for(y = [-2:0]) {
  for(x = [left_hole:spacing:right_hole+spacing/2]) {
    translate([x, y*(peg_spacing+peg_diameter), 0])
      #circle(d=peg_diameter);
    echo(x);
  }
}

//BOARD
translate([-peg_spacing-peg_diameter*3/2,
-2*(group_spacing+peg_diameter)-(group_width/2+peg_spacing+peg_diameter)-2*(peg_spacing+peg_diameter)-0.5*peg_diameter,
-0.5])
square([overall_width, overall_length], center = false);
