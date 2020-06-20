chest_length = 80;
chest_depth = 40;

total_height = 40;
lid_height = 10;
chest_height = total_height - lid_height;
decoration_extrude = 0.3;
decoration_height = 3;

/*
// Chest body
cube([chest_length, chest_depth, chest_height]);

// Chest lid
translate([0,chest_depth,chest_height]) {
    rotate(a=[-40,0,0]) {
        translate([0, -chest_depth,0]) {
            cube([chest_length, chest_depth, lid_height]);
        }
    }
}
*/

module makechest() {
    union() {
    color("saddlebrown", 1.0)
    cube([chest_length, chest_depth, total_height]);

    color("black", 1.0)
    translate([-decoration_extrude, -decoration_extrude,
              chest_height - decoration_height / 2]) 
        cube([chest_length + 2 * decoration_extrude,
             chest_depth + 2 * decoration_extrude,
             decoration_height]);

    color("lightgray", 1.0)
    translate([chest_length / 2, 0, chest_height-decoration_height*2])
        rotate([90,0,0])
            cube([decoration_height * 1.5,
                  decoration_height * 3,
                  decoration_extrude*1.1]);

    // Larger box
    difference() {
    color("black", 1.0)
    translate([chest_length / 2,
               chest_depth / 2,
               total_height / 2])
    cube([chest_length + decoration_extrude * 2,
          chest_depth + decoration_extrude * 2,
          total_height + decoration_extrude * 2], true);


    // Minus X
    translate([chest_length / 2,
               chest_depth / 2,
               total_height / 2])
    cube([chest_length + decoration_extrude*5,
          chest_depth - decoration_height,
          total_height - decoration_height], true);

    // Minus Y
    translate([chest_length / 2,
               chest_depth / 2,
               total_height / 2])
    cube([chest_length - decoration_height,
          chest_depth + decoration_extrude*5,
          total_height - decoration_height], true);

    // Minus Z
    translate([chest_length / 2,
               chest_depth / 2,
               total_height / 2])
    cube([chest_length - decoration_height,
          chest_depth - decoration_height,
          total_height + decoration_extrude * 5], true);
    }
    }
}

makechest();
