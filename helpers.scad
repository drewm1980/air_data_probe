$fn=20;

module cylinder_from_two_points(p1,p2,r=1)
{
	v=p2-p1;
	h = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
	mirrorplane = [0,0,h]-v;
	translate(p1) mirror(mirrorplane) cylinder(h=h,r=r,center=false);
}

module sphere_from_point(p,r=1)
{
	translate(p) sphere(r=r,center=true);
}

module capped_cylinder(p1, p2, r) {
	hull() {
		translate(p1)sphere(r=r,center=true);
		translate(p2)sphere(r=r,center=true);
	}
}

p0=[0,0,0];
p1=[1,1,1];
p2=[2,2,2];

hull(){
cylinder_from_two_points(p1,p2);
sphere_from_point(p1);
sphere_from_point(p2);
};
