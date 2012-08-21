include <constants.scad>
/*cube([10,20,30],center=true);*/
union(){
	difference(){
		cube(20,center=true);
		sphere(15,center=true);
	}
	sphere(3,center=true);
}
