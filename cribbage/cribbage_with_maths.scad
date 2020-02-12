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

X = (w-g)/2;

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

module lanes(t=[0,0,0]) {
  translate(t) {
    for(x = [0:2])
      for(y = [0:6])
        group([x*A, y*G, 0]);
  }
}

module half_circle(t=[0,0,0]) {
  translate(t) {
    for(o = [0:5])
      rotate([0,0,-18*o])
        row([-X, 0, 0]);
  }
}

module upper_circle(t=[0,0,0]) {
  translate(t) {
    //right half
    translate([-g/2, 0, 0])
      half_circle();
    //left half
    translate([g/2, 0, 0])
      rotate([0, 180, 0])
        half_circle();
  }
}

module lower_circle(t=[0,0,0]) {
  
}

module all_holes(t=[0,0,0]) {
  lanes();
  //upper_circle(t=[w/2,-x-5,0]);
}

all_holes();
