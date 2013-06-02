module hole(v1, v2, r) {
	l_hole = norm(v2-v1);
	rotate(a = rot, v = [1, 0, 0]) {
		translate([0, distance, 0]) {
			cylinder(r=r, h=l_hole, center=false);
		}
	}
}

R=15; // Radius of the sphere
R_ducts = 5; // Radius of the internal ductwork
R_holes = 2; // Radius of the holes to be drilled
H=100-R; // Overall height of the pitot tube

// Units in mm
union(){
	sphere(r=R,center=true);
	rotate(a=[0,180,0]) {cylinder(r=R,h=H);}
}
