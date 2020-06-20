// Parameters

input_diameters = [1.27,1.5,2,2.5,3,3.5,4,5,5.5];
spacing = 2;

start_height = 20;
final_height = 30;

// Useful functions
function sumv(v,i,s=0) = (i==s ? v[i] : v[i] + sumv(v,i-1,s));
function enlarge(diam) = (diam >= 5.5 ? diam + 0.8 : diam >= 4 ? diam + 0.6 : diam >= 1.5 ? diam + 0.5 : diam + 0.25 );
function act_circle(diam) = diam / cos(30);

// Calculations
$fn=50;

allen_diameters = [for (d = input_diameters) enlarge(d)];
test_diameters = [for (d = input_diameters) act_circle(d)];

echo( input_diameters);
echo( allen_diameters);
echo( test_diameters);

final_width = max(allen_diameters) + 2 * spacing;
initial_width = min(allen_diameters) + 2 * spacing;

total_spacing = spacing * (len(allen_diameters) + 1);

total_length = total_spacing
    + sumv(allen_diameters, len(allen_diameters)-1);

// Modules

module body() {
// create body
linear_extrude(height = final_height)
union() {
  y_diff = final_width - initial_width;
  x_diff = total_length - (final_width + initial_width) / 2;
  theta = atan2(y_diff, x_diff);

  unit_tan_x = cos(theta + 90);
  unit_tan_y = sin(theta + 90);

  init_circ_x = initial_width / 2;
  init_circ_y = initial_width / 2;

  final_circ_x = total_length - final_width / 2;
  final_circ_y = final_width / 2;

  tan_x_1 = unit_tan_x * initial_width / 2 + init_circ_x;
  tan_y_1 = unit_tan_y * initial_width / 2 + init_circ_y;

  tan_x_2 = unit_tan_x * final_width / 2 + final_circ_x;
  tan_y_2 = unit_tan_y * final_width / 2 + final_circ_y;

  // Cubic Part
  polygon([[init_circ_x, 0], // bottom left
          [final_circ_x, 0], //bottom right
          [tan_x_2, tan_y_2], // top right
          [tan_x_1, tan_y_1]]);

  // First Rounded
  translate([init_circ_x, init_circ_y, 0])
  circle(d=initial_width);

  // Larger Rounded
  translate([final_circ_x, final_circ_y, 0])
  circle(d=final_width);
}
}

module holes() {
for (i = [0:len(allen_diameters)]) {
    // translate hole to proper location
    hole_x = sumv(allen_diameters,i) + spacing*(i+1) - allen_diameters[i]/2;
    hole_y = spacing + allen_diameters[i]/2;
    translate([hole_x, hole_y, -0.5])
    // create hole
    cylinder(final_height + 1, d=allen_diameters[i]);
}
}

module top_slant() {
    translate([0,0,start_height])
    rotate([0, -atan2(final_height - start_height, total_length),0])
    translate([-0.5,-0.5,0])
    cube([total_length * 2, final_width + 1, final_height]);
}

// Final

difference() {
body();
holes();
top_slant();
}
