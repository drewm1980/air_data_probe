
include <pitot_constants.scad>
use <helpers.scad>

module outer_shell() {
	hull() {
	difference() {
		sphere(r=r,center=true);
		cylinder_from_two_points([0,0,0],[-2*r,0,0],2*r);
	}
	cylinder_from_two_points([0,0,0],[-(h-r),0,0],r=r);
	}
}

%outer_shell();
//include <mesh_before_trimming.scad>
include <mesh_after_trimming.scad>
