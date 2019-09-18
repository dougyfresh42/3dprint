/*
\\   //
 \\-//
 |   |
 //-\\
//   \\
*/

slat_width = 25.4;
slat_thick = 6;

wall_thickness = 4;
leg_length = 25.4;

clip_width = 10;

angle = 90;

//calculated
leg_thickness = slat_width + 2 * wall_thickness;
leg_height = slat_thick + wall_thickness;

center_width = clip_width + 2 * leg_thickness * cos(angle / 2);

//Center box
cube([center_width, center_width, leg_thickness], true);
