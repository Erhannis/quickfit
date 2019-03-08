// Originally by Hexdoll https://www.thingiverse.com/thing:40110

module plate(PLATE_SIZE_X = 28, PLATE_SIZE_Y = 100, PLATE_SIZE_Z = 5)
{
  BUMP_RADIUS = 5.5;
  BUMP_OFFSET_X = 2;
  
  difference() {
    union()
    {
      cube([PLATE_SIZE_X,PLATE_SIZE_Y,PLATE_SIZE_Z]);
    
      intersection()
      {
        translate([0,BUMP_OFFSET_X,0])
        rotate([0,90,0])
        cylinder(r=BUMP_RADIUS, h=PLATE_SIZE_X, $fn=64);
    
        cube([PLATE_SIZE_X,PLATE_SIZE_Y,PLATE_SIZE_Z+(2*BUMP_RADIUS)]);
      }
    
      intersection()
      {
        translate([0,PLATE_SIZE_Y-BUMP_OFFSET_X,0])
        rotate([0,90,0])
        cylinder(r=BUMP_RADIUS, h=PLATE_SIZE_X, $fn=64);
    
        cube([PLATE_SIZE_X,PLATE_SIZE_Y,PLATE_SIZE_Z+(2*BUMP_RADIUS)]);
      }
    }
    
    for (i = [0,1]) {
      translate([0, i*PLATE_SIZE_Y, 0])
      mirror([0,i,0])
      scale([PLATE_SIZE_X, BUMP_RADIUS/2, BUMP_RADIUS/2])
      translate([0,1,0])
      mirror([0,1,0])
      difference() {
        cube(1);
        rotate([45,0,0])
          cube(2);
      }
    }
  }
}
plate();