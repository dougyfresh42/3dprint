// Inputs
padding = 5;
w = 2.5*25.4-2*padding; //width - padding
h = 11.125*25.4 -2*padding; // height - padding

d = 3.125;
gs = 3;
as = 3;
vs = 1;
qs = 5;


// Output
s = (h - w/2 - 1.5*d) / (7.5*gs+28+4*vs+0.5*as+qs);
g = s * gs;
a = s * as;
v = s * vs;
q = s * qs;

X = 2*v+a+v - g/2;

G = 4*s+g;
A = 2*v+a;

module row(t=[0,0,0]) {
  translate(t) {
    for(x = [0:2])
      translate([x*v, 0, 0])
        circle(d=d);
  }
}

module group(t=[0,0,0]) {
  translate(t) {
    for(y = [0:4])
      row(t=[0,y*s,0]);
  }
}

module peg_start(t=[0,0,0]) {
  translate(t) {
    for(y = [0:2])
      row(t=[0, y*s, 0]);
  }
}

module lanes(t=[0,0,0]) {
  translate(t) {
    for(x = [0:2])
      for(y = [0:6])
        group([x*A, y*G, 0]);
  }
}

module half_circle(t=[0,0,0]) {
  translate(t) {
    for(o = [0:4])
      rotate([0,0,-22.5*o])
        row([-X, 0, 0]);
  }
}

module upper_circle(t=[0,0,0]) {
  translate(t) {
    //right half
    translate([-(g)/2, 0, 0])
      half_circle();
    //left half
    translate([(g)/2, 0, 0])
      rotate([0, 180, 0])
        half_circle();
  }
}

lower_x = (4*v+a) / 2;
module lower_circle(t=[0,0,0]) {
  translate(t) {
    for(o = [0:4])
      rotate([0,0,45*o])
        row([-lower_x, 0, 0]);
  }
}

width = 2*X+g;
num_scores = 8;
module score_track(t=[0,0,0]) {
  translate(t) {
    rotate([0,0,-90])
      for(y = [0:num_scores-1])
        row([0, y*width/(num_scores-1), 0]);
  }
}

module all_holes(t=[0,0,0]) {
  translate(t) {
    lanes();
    peg_start(t=[0, -2*s-g, 0]);
    upper_circle(t=[X+g/2,G*7,0]); // TODO
    lower_circle(t=[lower_x+2*v+a,-g,0]);
    score_track([0, -g-q-lower_x,0]);
  }
}

offset = q + g + lower_x + 2*s;

all_holes(t=[d/2,offset+d/2,0]);
#cube([w, h, 0.1]);
