module duct_segment(p1, p2, r) {
	hull() {
		translate(p1)sphere(r=r,center=true);
		translate(p2)sphere(r=r,center=true);
	}
}

// Units in mm
r=15; // Radius of the sphere
r_ducts = 4; // Radius of the internal ductwork
r_holes = 2; // Radius of the holes to be drilled
h=50-r; // Overall height of the pitot tube

module outer_shell() {
	hull() {
	sphere(r=r,center=true);
	rotate(a=[0,180,0]) {cylinder(r=r,h=h);}
	}
}

r_join=r * .66; // The Radius where the drilled holes join with the ducts


module holes() {
	union() {
		duct_segment([0,0,r_join],[0,0,r+10],r_holes);
		for(i=[0:90:360])	
		{
			rotate(i,[0,0,1]) 
			{
				duct_segment([r_join,0,0],[r+10,0,0],r_holes);
			}
		}
	}
}

module ducts() {
	union() {
		duct_segment([0,0,r_join],[0,0,-h-10],r_ducts);
		for(i=[0:90:360])	
		{
			rotate(i,[0,0,1]) 
			{
				duct_segment([r_join,0,0],[r_join,0,-h-10],r_ducts);
			}
		}
	}
}

/*holes();*/
difference() {
	% outer_shell();
	union() {
	ducts();
    # holes();
	}
}
