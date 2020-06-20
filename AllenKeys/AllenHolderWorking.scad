allen_diameters = [1,2,2.5,3,3.5,4,5];
spacing = 2;

total_width = max(allen_diameters) + 2 * spacing;

initial_spacing = (total_width - min(allen_diameters)) / 2;

total_spacing = initial_spacing + spacing * len(allen_diameters);

function sumv(v,i,s=0) = (i==s ? v[i] : v[i] + sumv(v,i-1,s));

total_length = total_spacing
    + sumv(allen_diameters, len(allen_diameters)-1);

start_height = 10;
final_height = 20;

module body() {
// create body
union() {
translate([total_width / 2,0,0])
cube([total_length - total_width, total_width, final_height]);

translate([total_width/2, total_width/2,0])
cylinder(final_height, d=total_width);

translate([total_length - total_width/2, total_width/2,0])
cylinder(final_height, d=total_width);
}
}

module holes() {
for (i = [0:len(allen_diameters)]) {
    // translate hole to proper location
    hole_x = initial_spacing + sumv(allen_diameters, i) + spacing * i - allen_diameters[i] / 2;
    hole_y = total_width / 2;
    translate([hole_x, hole_y, -0.5])
    // create hole
    cylinder(final_height + 1, d=allen_diameters[i]);
}
}

module top_slant() {
    
    translate([0,0,start_height])
    rotate([0, -atan2(final_height - start_height, total_length),0])
    translate([-0.5,-0.5,0])
    cube([total_length * 2, total_width + 1, final_height]);

}

difference() {
body();
holes();
top_slant();
}
