// Ugh this is taking too long

padding = 6;
real_width = 2.5 * 25.4;
real_height = 11.125 * 25.4;

pin_diam = 3.5;

width = real_width - 2*padding - pin_diam;
height = real_height - 2*padding - pin_diam;

// Just start with the circle
// All spacing is pin center-center
group_space = 8.5;
col_space = 4.5;

module peg(x, y) {
  translate([x, y, 0])
    circle(d=pin_diam);
}


big_rad = (width - group_space)/2;
med_rad = big_rad - col_space;
small_rad = med_rad - col_space;
module top_arc() {
  for (a = [0:22.5:90] ) {
    big_x = big_rad * cos(a) + group_space / 2;
    med_x = med_rad * cos(a) + group_space / 2;
    small_x = small_rad * cos(a) + group_space / 2;

    big_y = big_rad * sin(a);
    med_y = med_rad * sin(a);
    small_y = small_rad * sin(a);

    peg(big_x, big_y);
    peg(med_x, med_y);
    peg(small_x, small_y);

    peg(-big_x, big_y);
    peg(-med_x, med_y);
    peg(-small_x, small_y);
  }
}

// Arc length between pegs in med_rad
peg_space = med_rad * (PI/180) * 22.5;

module group() {
  for(i = [0:4]) {
    for(j = [0:2]) {
      peg(col_space * j, peg_space * i);
    }
  }
}

group_height = 4 * peg_space;
group_width = 2 * col_space;

side_space = (width - 3 * group_width) / 2;

module groups() {
  for(i = [0:6]) {
    for(j = [0:2]) {
      translate([j*(group_width+side_space), i*(group_height+group_space), 0])
        group();
    }
  }
}

sbig_rad = group_width + side_space/2;
smed_rad = sbig_rad - col_space;
ssmall_rad = smed_rad - col_space;
module small_circle() {
  for(a = [0:45:180]) {
    bigx = cos(a) * sbig_rad;
    medx = cos(a) * smed_rad;
    smallx = cos(a) * ssmall_rad;
    bigy = sin(a) * sbig_rad;
    medy = sin(a) * smed_rad;
    smally = sin(a) * ssmall_rad;

    peg(bigx, -bigy);
    peg(medx, -medy);
    peg(smallx, -smally);
  }
}

module start_holes() {
  for(i = [0:2]) {
    peg(i * col_space, 0);
    peg(i * col_space, sbig_rad/2);
    peg(i * col_space, sbig_rad);
  }
}

translate([0, sbig_rad+group_space, 0]) {
  translate([width/2, 7*(group_height + group_space), 0])
    top_arc();

  translate([2*group_width+3*side_space/2, -group_space, 0])
    small_circle();

  groups();

  translate([0, -sbig_rad-group_space, 0])
    start_holes();
}

offset = padding + pin_diam / 2;
translate([-offset, -offset, -10])
#  cube([real_width, real_height, 5]);

total_height = big_rad + 
               7 * group_height + 
               8 * group_space + 
               sbig_rad;

echo("Height:");
echo(total_height);
echo("(in inches is)");
echo(total_height / 25.4);

total_width = 3 * group_width +
              2 * side_space;

echo("Width:");
echo(total_width);
echo("(in inches is}");
echo(total_width / 25.4);
