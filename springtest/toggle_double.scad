$fs=0.1;

sqtw = sqrt(2);

switch_w = 10;
switch_top = 25;

switch_tolerance = 0.3;

axis_r = 1.5;

hole_height = 3;
hole_w = switch_w * sqtw;
hole_top = hole_w + 2 * hole_height; // trapezoid

border = 10;

spring_l = 15;
spring_h = 5;
spring_w = 1.5;
spring_angle = 8;

switch_bottom = ((switch_w / 2 + spring_l) - (switch_w / 2 / sqtw)) * sqtw;

switch_l = switch_top + switch_bottom;

// from hole to bottom of spring
spring_z = switch_w / 2 + spring_l - switch_w / sqtw + spring_h / 2;

wire_r = 1;
wire_h = 3;

module switch_box(tolerance=0) {
    translate([0, switch_l / 2 - switch_bottom, 0])
        cube([switch_w-tolerance, switch_l, switch_w-tolerance], center=true);
}

module toggle_switch () {
    difference() {
        switch_box(tolerance=switch_tolerance);

        cylinder(h = switch_w + 2, r = axis_r, center=true);

        for (i = [0:90:270]) {
            rotate([0, i, 0])
                translate([-switch_w / 2, -switch_bottom + wire_h, 0])
                    cylinder(h = switch_w + 2, r = wire_r, center=true);
        }

        translate([0, -switch_bottom + wire_h, 0])
            rotate([0, 90, 0])
                cylinder(h = switch_w + 2, r = wire_r, center=true);
    }
}

module toggle_box() {
    box_length = max(hole_top + 2 * border, 2 * (switch_w / 2 + spring_l + border));
    box_height = hole_height + switch_bottom + switch_w;
    box_height = hole_height + spring_z;

    total_l = switch_w + 2 * spring_l;
    difference() {
        union() {
            difference() {
                translate([0, 0, -box_height / 2 + hole_height])
                    cube([switch_w + 2 * border, box_length, box_height], center = true);

                for (i = [45:45:135]) {
                    rotate([i, 0, 0])
                        switch_box();
                }
                
                translate([0, 0, -box_height / 2])
                    cube([switch_w + 2 * spring_w, total_l, box_height], center = true);

            }

        // spring
        translate([-switch_w/2 - spring_w, -total_l/2, -spring_z])
            cube([spring_w, total_l - spring_l, spring_z]);

        translate([-switch_w/2 - spring_w, switch_w/2, -spring_z])
            rotate([0,0,-spring_angle])
                cube([spring_w, spring_l - 1, spring_h]);

        translate([switch_w/2, -switch_w/2, -spring_z])
            cube([spring_w, total_l - spring_l, spring_z]);

        translate([switch_w/2+spring_w, -switch_w/2, -spring_z])
            rotate([0,0,-180-spring_angle])
                cube([spring_w, spring_l - 1, spring_h]);

        //Stupid little 3d printer angle thing
        angle = atan2(hole_w/2 - switch_w/2, spring_z - spring_h);
        translate([-switch_w/2-spring_w, switch_w / 2, -spring_z + spring_h])
        rotate([-angle,0,0])
        translate([0, -hole_w / 2, 0])
        cube([spring_w, hole_w / 2,spring_z - spring_h + hole_height/2]);

        translate([switch_w/2, -switch_w / 2, -spring_z + spring_h])
        rotate([angle,0,0])
        cube([spring_w, hole_w / 2,spring_z - spring_h + hole_height/2]);

        }
        //axis
        rotate([0,90,0])
            cylinder(h = switch_w + 2 * border + 2, r = axis_r, center = true);
    }
}
