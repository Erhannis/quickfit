/*
OpenSCAD reverse engineering of RichRap's Quick-Fit attachment plate.
( https://www.thingiverse.com/thing:19590 )

It's intended to be used in the construction of other x-carriages etc.,
not used on its own - it currently doesn't have any kind of anchor-point.
I plan on making a RepRap Snappy extruder plaform for the quick-fit
attachment.

Note: the hinge doesn't print well, when the model is printed flat.
When I printed it hinge-end-down, standing up, it actually printed decently.
A little rough near the latch, but functional.  I did thicken the plate
from 4.28mm to 6mm, to improve stability while printing.

I've taken most measurements from the STL files, presumably derived from
the SketchUp files, so the numbers are pretty arbitrary-looking.  The
only deviations-from-source I know of are:
1. I stripped off the x-carriage bits
2. Also skipped the zip-tie holes and grooves
3. The shape of the big tool-hole in the middle was somewhat inscrutable, so now it's an ellipse
4. Technically the resolution of the circles may be different
I think everything else should be accurate to within a hundredth of a mm.
*/

$fn = 50;

LATCH_TYPE = 3; // 1=original, 2=bar, 3=multibar

PLATE_SIZE_Z = 6; //4.28
PLATE_SIZE_X = 122.1398;
PLATE_SIZE_Y = 72.09;

HINGE_FLOOR_X = 20.5;

// Side ramps are assumed to end at the edge of the plate
SIDE_RAMP_GAP_Y = 28.6;
SIDE_RAMP_SIZE_Y = 4.275;
SIDE_RAMP_SIZE_Z = 5.1;
SIDE_RAMP_1_SIZE_X = 5.5267; // Short one near center
SIDE_RAMP_2_SIZE_X = 10.7464; // Flat segment
SIDE_RAMP_3_SIZE_X = 16.7225; // Long one near edge


// Latch type 1
LATCH_SEAT_SMALL_HOLE_DIAM = 4.4;
LATCH_SEAT_BIG_HOLE_DIAM = 13.5983;
LATCH_SEAT_HOLE_X_OFFSET = 6.2733;
LATCH_SEAT_SIZE_X = 15.4733;
LATCH_SEAT_SIZE_Y = LATCH_SEAT_BIG_HOLE_DIAM*1.5;//TODO
LATCH_SEAT_SIZE_Z = 5.6;

// Latch type 2
BRACKET_SKEW_X = 1*SIDE_RAMP_1_SIZE_X;
BRACKET_1_SIZE_X = 2*SIDE_RAMP_1_SIZE_X;// + BRACKET_SKEW_X;
BRACKET_3_SIZE_X = SIDE_RAMP_3_SIZE_X - BRACKET_SKEW_X;
BRACKET_SIZE_Z = 2*SIDE_RAMP_SIZE_Z;
BRACKET_TOP_SIZE_Z = (BRACKET_SIZE_Z - SIDE_RAMP_SIZE_Z) / 2;
BRACKET_LATCH_SIZE_X = SIDE_RAMP_2_SIZE_X - 1;
BRACKET_LATCH_SIZE_Y = SIDE_RAMP_GAP_Y + (4*SIDE_RAMP_SIZE_Y) + 6;
BRACKET_LATCH_SIZE_Z = BRACKET_SIZE_Z - SIDE_RAMP_SIZE_Z - BRACKET_TOP_SIZE_Z - 0.3;
BRACKET_LATCH_HANDLE_SIZE_Z = BRACKET_LATCH_SIZE_Z + (2*BRACKET_TOP_SIZE_Z);

// Latch type 3
BRACKET_LATCH_3_SIZE_Y = BRACKET_LATCH_SIZE_Y/3;


TOOL_HOLE_SIZE_Y = 39.65;
TOOL_HOLE_HINGE_X = 22.077;
TOOL_HOLE_LATCH_X = 24.9733;
TOOL_HOLE_SIZE_X = PLATE_SIZE_X - TOOL_HOLE_HINGE_X - TOOL_HOLE_LATCH_X;

HINGE_OUTER_SIZE_X = 12.42;
HINGE_OUTER_SIZE_Y = 43.15;
HINGE_OUTER_SIZE_Z = 9.5 + PLATE_SIZE_Z;

// Some of these params may not lead to reasonable results if other params are changed - it's kindof a complicated shape, and I haven't worked out the most robustly sensical representation.  Particularly the circular cutout in the hinge.
HINGE_INNER_SIZE_Y = 29.22;
HINGE_INNER_BLOCK_SIZE_X = 7;
HINGE_OVERHANG_SIZE_Z = 4;
HINGE_INNER_BLOCK_SIZE_Z = HINGE_OUTER_SIZE_Z - PLATE_SIZE_Z - HINGE_OVERHANG_SIZE_Z;
HINGE_CIRCLE_CUTOUT_DIAMETER = 10.4;
HINGE_CIRCLE_CUTOUT_REGION_X = 4;
HINGE_CIRCLE_CUTOUT_OFFSET_Z = 0.7;
HINGE_RAMP_SIZE_Z = 1.5;

module quickfit() {
  difference() {
    union() {
      { // Plate
        cube([PLATE_SIZE_X, PLATE_SIZE_Y, PLATE_SIZE_Z]);
      }
      { // Latch seat
        if (LATCH_TYPE == 1) {
          translate([PLATE_SIZE_X-LATCH_SEAT_SIZE_X, (PLATE_SIZE_Y-LATCH_SEAT_SIZE_Y)/2, PLATE_SIZE_Z]) {
            difference() {
              cube([LATCH_SEAT_SIZE_X, LATCH_SEAT_SIZE_Y, LATCH_SEAT_SIZE_Z]);
              translate([LATCH_SEAT_HOLE_X_OFFSET, LATCH_SEAT_SIZE_Y/2, 0]) {
                cylinder(d=LATCH_SEAT_BIG_HOLE_DIAM, h=LATCH_SEAT_SIZE_Z);
              };
            };
          };
        } else if (LATCH_TYPE == 2 || LATCH_TYPE == 3) {
          // (Derived from side ramps)
          for (i = [-1,1]) {
            translate([0, i * (((SIDE_RAMP_GAP_Y+SIDE_RAMP_SIZE_Y)/2)+SIDE_RAMP_SIZE_Y), 0]) {
              translate([PLATE_SIZE_X - BRACKET_1_SIZE_X - SIDE_RAMP_2_SIZE_X - BRACKET_3_SIZE_X, (PLATE_SIZE_Y - SIDE_RAMP_SIZE_Y)/2, PLATE_SIZE_Z]) {
                translate([0,0,0]) {
                  scale([BRACKET_1_SIZE_X, SIDE_RAMP_SIZE_Y, BRACKET_SIZE_Z]) {
                    difference() {
                      cube(1);
                      rotate([0,-45,0])
                        cube(2);
                    }
                  }
                }
                translate([BRACKET_1_SIZE_X,0,0]) {
                  cube([SIDE_RAMP_2_SIZE_X,SIDE_RAMP_SIZE_Y,SIDE_RAMP_SIZE_Z]);
                }
                translate([BRACKET_1_SIZE_X,0,BRACKET_SIZE_Z-BRACKET_TOP_SIZE_Z]) {
                  cube([SIDE_RAMP_2_SIZE_X,SIDE_RAMP_SIZE_Y,BRACKET_TOP_SIZE_Z]);
                }
                translate([BRACKET_1_SIZE_X+SIDE_RAMP_2_SIZE_X,0,0]) {
                  scale([BRACKET_3_SIZE_X, SIDE_RAMP_SIZE_Y, BRACKET_SIZE_Z]) {
                    translate([0,0,1])
                    rotate([0,90,0])
                    difference() {
                      cube(1);
                      rotate([0,-45,0])
                        cube(2);
                    }
                  }
                }
              }
            }
          }
        }
      }
      { // Side ramps
        for (i = [-1,1]) {
          translate([0, i * ((SIDE_RAMP_GAP_Y+SIDE_RAMP_SIZE_Y)/2), 0]) {
            translate([PLATE_SIZE_X - SIDE_RAMP_1_SIZE_X - SIDE_RAMP_2_SIZE_X - SIDE_RAMP_3_SIZE_X, (PLATE_SIZE_Y - SIDE_RAMP_SIZE_Y)/2, PLATE_SIZE_Z]) {
              translate([0,0,0]) {
                scale([SIDE_RAMP_1_SIZE_X, SIDE_RAMP_SIZE_Y, SIDE_RAMP_SIZE_Z]) {
                  difference() {
                    cube(1);
                    rotate([0,-45,0])
                      cube(2);
                  }
                }
              }
              translate([SIDE_RAMP_1_SIZE_X,0,0]) {
                cube([SIDE_RAMP_2_SIZE_X,SIDE_RAMP_SIZE_Y,SIDE_RAMP_SIZE_Z]);
              }
              translate([SIDE_RAMP_1_SIZE_X+SIDE_RAMP_2_SIZE_X,0,0]) {
                scale([SIDE_RAMP_3_SIZE_X, SIDE_RAMP_SIZE_Y, SIDE_RAMP_SIZE_Z]) {
                  translate([0,0,1])
                  rotate([0,90,0])
                  difference() {
                    cube(1);
                    rotate([0,-45,0])
                      cube(2);
                  }
                }
              }
            }
          }
        }
      }
      { // Hinge additive
        translate([0, (PLATE_SIZE_Y-HINGE_OUTER_SIZE_Y)/2, 0])
          cube([HINGE_OUTER_SIZE_X, HINGE_OUTER_SIZE_Y, HINGE_OUTER_SIZE_Z]);
      }
    };
    if (LATCH_TYPE == 1) { // Latch hole
      translate([PLATE_SIZE_X-LATCH_SEAT_SIZE_X, (PLATE_SIZE_Y-LATCH_SEAT_SIZE_Y)/2, 0]) {
        translate([LATCH_SEAT_HOLE_X_OFFSET, LATCH_SEAT_SIZE_Y/2, 0]) {
          cylinder(d=LATCH_SEAT_SMALL_HOLE_DIAM, h=PLATE_SIZE_Z);
        };
      };
    }
    { // Tool hole
      // This isn't exactly the (arcane) shape of the original, but maybe it's close enough.
      translate([TOOL_HOLE_HINGE_X, (PLATE_SIZE_Y-TOOL_HOLE_SIZE_Y)/2, 0]) {
        translate([TOOL_HOLE_SIZE_X/2, TOOL_HOLE_SIZE_Y/2, 0]) {
          scale([TOOL_HOLE_SIZE_X, TOOL_HOLE_SIZE_Y, PLATE_SIZE_Z]){
            cylinder(d=1,h=1);
          }
        }
      }
    }
    { // Hinge subtractive
      translate([HINGE_OUTER_SIZE_X-HINGE_INNER_BLOCK_SIZE_X, (PLATE_SIZE_Y-HINGE_INNER_SIZE_Y)/2, PLATE_SIZE_Z]) {
        union() {
          cube([HINGE_INNER_BLOCK_SIZE_X, HINGE_INNER_SIZE_Y, HINGE_INNER_BLOCK_SIZE_Z]);
          translate([0,0,HINGE_CIRCLE_CUTOUT_OFFSET_Z])
            intersection() {
              translate([HINGE_CIRCLE_CUTOUT_REGION_X/2, 0, 0])
                rotate([-90,0,0])
                  cylinder(d=HINGE_CIRCLE_CUTOUT_DIAMETER, h=HINGE_INNER_SIZE_Y);
              cube([HINGE_CIRCLE_CUTOUT_REGION_X, HINGE_INNER_SIZE_Y, HINGE_CIRCLE_CUTOUT_DIAMETER]);
            };
          scale([HINGE_INNER_BLOCK_SIZE_X, 1, HINGE_RAMP_SIZE_Z])
            translate([0,0,-1])
              difference() {
                cube([1, HINGE_INNER_SIZE_Y, 1]);
                rotate([0, 45, 0])
                  cube([2, HINGE_INNER_SIZE_Y, 2]);
              };
        }
      }
    }
    /*
    { // Debug cross-section
      cube([PLATE_SIZE_X, 30, 50]);
      translate([0, 31, 0])
        cube([PLATE_SIZE_X, 300, 50]);
    }
    */
  };
};

module latchType2() {
  cube([BRACKET_LATCH_SIZE_X, BRACKET_LATCH_SIZE_Y, BRACKET_LATCH_SIZE_Z]);
  translate([0, -SIDE_RAMP_SIZE_Y])
    cube([BRACKET_LATCH_SIZE_X, SIDE_RAMP_SIZE_Y, BRACKET_LATCH_HANDLE_SIZE_Z]);
};

module latchType3() {
  cube([BRACKET_LATCH_SIZE_X, BRACKET_LATCH_3_SIZE_Y, BRACKET_LATCH_SIZE_Z]);
  translate([0, -SIDE_RAMP_SIZE_Y])
    cube([BRACKET_LATCH_SIZE_X, SIDE_RAMP_SIZE_Y, BRACKET_LATCH_HANDLE_SIZE_Z]);
};

quickfit();
//latchType2();
//latchType3();
