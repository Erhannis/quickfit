/*
Platform for the Snappy 3, providing a platform for
RichRap's Quick-Fit mount.

The Snappy 3 is at https://github.com/revarbat/snappy-reprap/ .
I worked from commit 1e9785113d9411961d42889f3a6d794b454ab787
which I think may technically be v3.1; you might need to use
that commit specifically depending on whether filenames
changed or something.  (Oh, uh, I think I modified my config to
match the dimensions of my hotend, before generating the STLs.
You might need to generate your own STLs if the pregenerated
ones don't fit your hotend.)  (Also, the Snappy has slop values;
you may want to print a slop calibrator, adjust the slop, and
regenerate the STLs regardless.  These were generated at 0.25 slop.)
You'll also need to print the other parts from the Snappy to
attach all the extruder bits, such as:
  extruder_idler_parts.stl
  extruder_motor_clip_parts.stl
  compression_screw_parts.stl
  e3dv6_lock_parts.stl
  
You also need a 686 bearing for the idler, and an extruder drive gear, I'm afraid.  Check the Snappy wiki for details.


I've basically modified the platform code to remove the extruder
bits and added code to put the quickfit in the middle.
Go down to the bottom to select the things you want to print;
comment out the ones you don't want.

*/

include <../deps.link/snappy-reprap/config.scad>
use <../deps.link/snappy-reprap/GDMUtils.scad>
use <../deps.link/snappy-reprap/NEMA.scad>
use <../deps.link/snappy-reprap/joiners.scad>
use <../deps.link/snappy-reprap/extruder_mount.scad>

use <../deps.link/quickfitPlate/blank_plate.scad>

$fa = 2;
$fs = 1;


module e3dv6_single_platform()
{
	motor_width = nema_motor_width(17);

	color("cornflowerblue")
	difference() {
		union() {
			extruder_platform(
				l=extruder_length,
				w=motor_width + extruder_drive_diam + 4*joiner_width + 5,
				h=rail_height,
				thick=e3dv6_groove_thick
			);

			// Extruder mount
//			zrot(-90)
//			extruder_additive(
//				groove_thick=e3dv6_groove_thick,
//				groove_diam=e3dv6_groove_diam,
//				shelf=e3dv6_shelf_thick,
//				cap=e3dv6_cap_height,
//				barrel=e3dv6_barrel_diam,
//				filament=filament_diam,
//				drive_gear=extruder_drive_diam,
//				shaft=extruder_shaft_len,
//				idler=extruder_idler_diam,
//				slop=printer_slop
//			);
		}

		// Subtractive extruder parts
//		zrot(-90)
//		extruder_subtractive(
//			groove_thick=e3dv6_groove_thick,
//			groove_diam=e3dv6_groove_diam,
//			shelf=e3dv6_shelf_thick,
//			cap=e3dv6_cap_height,
//			barrel=e3dv6_barrel_diam,
//			filament=filament_diam,
//			drive_gear=extruder_drive_diam,
//			shaft=extruder_shaft_len,
//			idler=extruder_idler_diam,
//			slop=printer_slop
//		);
	}
}



module e3dv6_single_platform_parts() { // make me
	e3dv6_single_platform();
}










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


{ // Platform
  difference() {
    translate([-PLATE_SIZE_X/2,-PLATE_SIZE_Y/2,0]) {
      quickfit();
    }
    cube([55,50,PLATE_SIZE_Z*3], center=true);
  }
  difference() {
    e3dv6_single_platform_parts();
    translate([-PLATE_SIZE_X/2,-PLATE_SIZE_Y/2,-1])
      cube([PLATE_SIZE_X, PLATE_SIZE_Y, PLATE_SIZE_Z+1]);
  };
}

/*
{ // Latch
  translate([0,0,0])
    latchType3();
  translate([15,0,0])
    latchType3();
}
*/
/*
//translate([15,0,15])
{ // Extruder
  SLAB_SIZE_X = 28;
  SLAB_SIZE_Y = 100;
  SLAB_SIZE_Z = 5;

  difference() {
    union() {
      translate([(SLAB_SIZE_Y/2)-20,SLAB_SIZE_X/-2,0])
        zrot(90)
          plate(SLAB_SIZE_X, SLAB_SIZE_Y, SLAB_SIZE_Z);
      zrot(-90)
      extruder_additive(
        groove_thick=e3dv6_groove_thick,
        groove_diam=e3dv6_groove_diam,
        shelf=e3dv6_shelf_thick,
        cap=e3dv6_cap_height,
        barrel=e3dv6_barrel_diam,
        filament=filament_diam,
        drive_gear=extruder_drive_diam,
        shaft=extruder_shaft_len,
        idler=extruder_idler_diam,
        slop=printer_slop
      );
    }
    
		zrot(-90)
		extruder_subtractive(
			groove_thick=e3dv6_groove_thick,
			groove_diam=e3dv6_groove_diam,
			shelf=e3dv6_shelf_thick,
			cap=e3dv6_cap_height,
			barrel=e3dv6_barrel_diam,
			filament=filament_diam,
			drive_gear=extruder_drive_diam,
			shaft=extruder_shaft_len,
			idler=extruder_idler_diam,
			slop=printer_slop
		);
  }
}
*/

// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
