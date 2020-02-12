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

G = 4*s+g;
A = 2*v+a;

module group(t=[0,0,0]) {
  translate(t) {
    for(x = [0:2])
      for(y = [0:4])
        translate([x*v, y*s, 0])
          circle(d=d);
  }
}

module lanes(t=[0,0,0]) {
  translate(t) {
    for(x = [0:2])
      for(y = [0:6])
        group([x*A, y*G, 0]);
  }
}

lanes();
