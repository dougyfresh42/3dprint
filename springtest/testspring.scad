border = 5; //mm

w = 10;
h = 30;

d = 10;

spring_w = 1.5;
spring_l = h/2;
spring_angle = 10;

width = w + 2 * border;
height = h + 2 * border;
depth = d;

union() {

difference() {
    // Big Rectangle
    cube([width, height, depth], center = true);

    // cutout
    translate([-spring_w/2, 0, 0])
        cube([w+spring_w, h, d + 2], center = true);
}

// spring... bit
// extra
translate([-w/2 - spring_w, -h/2, -d/2])
    cube([spring_w, h - spring_l, d]);

// spring
translate([-w/2 - spring_w, h/2 - spring_l, -d/2])
    rotate([0, 0, -spring_angle])
        cube([spring_w, spring_l-1, d]);
}
