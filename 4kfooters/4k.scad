total_size = 500;

mountains = ["Washington","N. Kinsman","S. Kinsman","Cannon","Lafayette"];
//index = [0:len(mountains):1];
index = [for (i = [0:1:len(mountains)-1]) i];
echo(index);

font_height = 10;
mtn_spacing = 2;

bottom_spacing = 10;
right_spacing = 10;

//calculate
num_mountains = len(mountains);
len_mountains = [for(i=mountains) len(i)];
longest_mountain = max(len_mountains);

echo(num_mountains);
echo(len_mountains);



//linear_extrude(height = 5, center = true, convexity = 10)

//difference() {
//  import(file = "NH_Route_16_100x100.dxf");
//}

for (i = index) {
  x = total_size - right_spacing;
  y = mtn_spacing * i + font_height * i + bottom_spacing;
  echo(y);
  translate([x, y, 0]) {
  #text(mountains[i], halign="right");
  }
}

/*
Washington
Adams
Jefferson
Monroe
Madison
Lafayette
Lincoln
South Twin
Carter Dome
Moosilauke
Eisenhower
North Twin
Carrigain
Bond
Middle Carter
West Bond
Garfield
Liberty
South Carter
Wildcat, A Peak
Hancock
South Kinsman
Field
Osceola
Flume
South Hancock
Pierce
North Kinsman
Willey
Bondcliff
Zealand
North Tripyramid
Cabot
East Osceola
Middle Tripyramid
Cannon
Hale
Jackson
Tom
Wildcat, D Peak
Moriah
Passaconaway
Owl's Head
Galehead
Whiteface
Waumbek
Isolation
Tecumseh
*/
