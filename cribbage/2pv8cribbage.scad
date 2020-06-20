// Ugh this is taking too long
$fn=20;

//TODO
// Currently padding is edge to edge, not edge to pin_center
//  All of the other spaces are center to center which makes math easier
//  : fix padding

////////////////////////////
// Change These Variables //
////////////////////////////

real_width = 2.5 * 25.4;
real_height = 11.125 * 25.4;

thickness = 10;

// 3.2 diam pin (1/8) (standard)
pin_diam = 3.2;

padding = 8.5;

group_space = 11;
col_space = 5.3;

// 2 diam pin (5/64)
// pin_diam = 2;
// 
// padding = 8.5;
// 
// group_space = 9;
// col_space = 5.8;

////////////////////////
// Don't Change These //
////////////////////////

width = real_width - 2*padding - pin_diam;
height = real_height - 2*padding - pin_diam;


module peg(x, y) {
  //translate([x, y, 0])
  //  circle(d=pin_diam);
  translate([x, y, -1])
    cylinder(d=pin_diam, h=thickness+2);
}


big_rad = (width - group_space)/2;
med_rad = big_rad - col_space;
module top_arc() {
  for (a = [0:22.5:90] ) {
    big_x = big_rad * cos(a) + group_space / 2;
    med_x = med_rad * cos(a) + group_space / 2;

    big_y = big_rad * sin(a);
    med_y = med_rad * sin(a);

    peg(big_x, big_y);
    peg(med_x, med_y);

    peg(-big_x, big_y);
    peg(-med_x, med_y);
  }
}

// Arc length between pegs in med_rad
peg_space = (big_rad+med_rad)/2 * (PI/180) * 22.5;

module group() {
  for(i = [0:4]) {
    for(j = [0:1]) {
      peg(col_space * j, peg_space * i);
    }
  }
}

group_height = 4 * peg_space;
group_width = 1 * col_space;

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
module small_circle() {
  for(a = [0:45:180]) {
    bigx = cos(a) * sbig_rad;
    medx = cos(a) * smed_rad;

    bigy = sin(a) * sbig_rad;
    medy = sin(a) * smed_rad;

    peg(bigx, -bigy);
    peg(medx, -medy);
  }
}

module start_holes() {
  for(i = [0:1]) {
    peg(i * col_space, 0);
    peg(i * col_space, peg_space);
    //peg(i * col_space, sbig_rad/2);
    //peg(i * col_space, sbig_rad);
  }
}

module win_hole() {
  x = big_rad + group_space / 2;
  y = sbig_rad + 8 * group_space + 7 * group_height;
  peg(x, y);
}

module all_holes() {
  translate([0, sbig_rad+group_space, 0]) {
    translate([width/2, 7*(group_height + group_space), 0])
      top_arc();

    translate([2*group_width+3*side_space/2, -group_space, 0])
      small_circle();

    groups();

    translate([0, -sbig_rad-group_space, 0])
      start_holes();
  }

  win_hole();
}

side_offset = padding + pin_diam / 2;

total_height = big_rad + 
               7 * group_height + 
               8 * group_space + 
               sbig_rad;

length_offset = (real_height - total_height) / 2;

/////////////////
// Board build //
/////////////////

module board() {
  difference() {
    translate([-side_offset, -length_offset, 0])
      cube([real_width, real_height, thickness]);

    all_holes();
  }
}

echo("Min pin");
echo(med_rad * (PI/180) * 22.5 - pin_diam);
echo("pin");
echo(peg_space);
echo("col");
echo(col_space);

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
