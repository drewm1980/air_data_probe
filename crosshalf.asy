unitsize(1mm);
real paperwidth=100mm;
real paperheight=100mm;
size(paperwidth,paperheight,IgnoreAspect);

real bearing_id;
real bearing_od;
real bearing_h;
real material_t;
include "constants.scad";
real eps = .000001;

path c = circle(10,20);
path s = shift((-10,0)) * (0,0)--(50,0)--(50,25)--cycle;
pen cutpen = black+linewidth(1mm);
pen fillpen = evenodd + 0.8*white;
path foo = buildcycle(c,s);
filldraw(c,fillpen,cutpen);
filldraw(s,fillpen,cutpen);
filldraw(foo,fillpen,cutpen);

////--------------------------Subroutines-------------------------//
//import graph;
//path slot(pair c1, pair c2, real r)
//{
	//real l = abs(c2-c1);
	//path p = arc((0,0),r,90,270,CCW)--arc((l,0),r,270,90,CCW)--cycle;
	//p = rotate(degrees(c2-c1))*p;
	//p = shift(c1)*p;
	//return p;
//};

//pair rotate_up_to_new_height(real h, pair p){
	//assert(p.y<h, "Height Cannot Be Achieved; Keyboard is probably silly tall; Try Lower Key Travel");
	//real r = abs(p);
	//// r*sin(theta)=h
	//real theta = asin(h/r);
	//return (r*cos(theta),h);
//}

//struct Touchpoint{
	//pair bottomfront;
	//pair topfront;
	//pair topback;
	//pair bottomback;
	//path p;
	
	//static Touchpoint Touchpoint(pair prevUpperLeftCorner, bool isFirst=false)
	//{
		//Touchpoint tp = new Touchpoint;
		////pair prevUpperLeftCorner = previousTouchpoint.topback;
		//real rFront = abs(prevUpperLeftCorner)-radialKeyGap;

		//// Compute the top, front corner of the touchpoint
		//pair topfront = prevUpperLeftCorner - unit(prevUpperLeftCorner)*radialKeyGap;
		//topfront = rotate_up_to_new_height(prevUpperLeftCorner.y+depressedLedge, topfront);
		//topfront = rotate(keyTravelAngle)*topfront;

		//// The top, back corner of the touchpoint
		//pair topback = topfront - (touchpointLength, 0);
		//real rBack = abs(topback);

		//// The bottom, back corner of the touchpoint
		//pair bottomback = rotate(-keyTravelAngle)*topback;
		//bottomback = rotate(-degrees(sidewaysVisibilityTolerance/rBack))*bottomback;

		//// The bottom, front of the touchpoint. 
		//// Needs to be low enough to not be visible when the row in front is depressed.
		//pair bottomfront = prevUpperLeftCorner - unit(prevUpperLeftCorner)*radialKeyGap;
		//if(isFirst==false)	bottomfront = rotate(-keyTravelAngle)*bottomfront;
		//bottomfront = rotate(-degrees(frontbackVisibilityTolerance/rFront))*bottomfront;

		//tp.bottomfront = bottomfront;
		//tp.topfront = topfront;
		//tp.topback = topback;
		//tp.bottomback = bottomback;
		//tp.p = arc((0,0),bottomfront,topfront,CCW)--arc((0,0),topback,bottomback,CW)--cycle;	
		//return tp;
	//}

	//static Touchpoint Touchpoint(Touchpoint previousTouchpoint)
	//{
		//Touchpoint tp = Touchpoint(previousTouchpoint.topback);	
		//return tp;
	//}
//}
//from Touchpoint unravel Touchpoint;

//path arc_with_radius(pair a, pair b, real r){
	//assert(r>abs(b-a)/2, "Requested r is too small to be achievable");
	//pair mp = (a+b)/2;
	//real h = sqrt(r^2 - abs(mp-a)^2);
	//pair center = rotate(90)*unit(b-a)*h + mp;
	//return arc(center, a, b, CCW);
//}

//// Use Thales' theorem to find the two tangents from a point to a circle.
//pair[] tangents_to_circle(pair c, real r, pair p){
	//assert(abs(p-c)>r, "point p must be outside the circle!");
	//path temp = circle((p-c)/2, abs((p-c)/2));
	//pair[] intersections = intersectionpoints(circle(c,r), temp);
	//return intersections;
//}

//struct Body
//{
	//// Row indexing is zero-based, starting at lowest row.
	//path oddPath; 
	//path evenPath; 
	//// The path for the key, including cutouts.
	//path[] oddPathFinal;
	//path[] evenPathFinal;
	//void operator init(Touchpoint[] tps)
	//{
		//path oddPath; 
		//path evenPath; 
		//// The start point and end points of the part of the path that defines the key supports and cutout.
		//pair keysPathStart; 
		//pair keysPathEnd;


		//// Handle the bottom touchpoint row.
		//{
			//Touchpoint tp = tps[0];
			//Touchpoint tpAbove = tps[1];
			//keysPathStart= tp.bottomback;
			//keysPathStart = rotate(-keyTravelAngle + degrees(-frontKeySupportSize/abs(keysPathStart)))*keysPathStart;
			//keysPathStart = unit(keysPathStart)*abs(tpAbove.topfront);  
			//evenPath = arc_with_radius(keysPathStart, tp.bottomfront, touchpointLength*2);
			//evenPath = evenPath--arc((0,0),tp.bottomfront,tp.topfront,CCW)--tp.topback;
			//oddPath = arc((0,0),keysPathStart,tpAbove.topfront);
		//}

		//// Handle the middle touchpoint rows.
		//for(int i=1; i<rowCount-1; ++i)
		//{
			//Touchpoint tpBelow = tps[i-1];
			//Touchpoint tp = tps[i];
			//Touchpoint tpAbove = tps[i+1];

			//pair p1, p2, p3, p4;
			//p1 = tpBelow.topback;
			//p4 = tpAbove.topfront;
			
			//// We ether need a cutout out make room for the adjacent touchpoints...
			//p2 = rotate(-keyTravelAngle)*tp.bottomfront;
			//p3 = rotate(-keyTravelAngle)*tp.bottomback;
			//pair offsetDirection = unit(rotate(-90)*(p2-p3));
			//p2 += keyGap*offsetDirection;
			//p3 += keyGap*offsetDirection;
			//p2 += (p2-p3);  // Extend to make intersection with circle easier.
			//p3 += (p3-p2);  // Extend to make intersection with circle easier.
			//real rBelow = abs(tpBelow.topback);
			//real rAbove = abs(tpAbove.topfront);
			//p2 = intersectionpoint(p2--p3, circle((0,0),rBelow));
			//p3 = intersectionpoint(p2--p3, circle((0,0),rAbove));
			//path cutout = arc((0,0),p1,p2,CW)--arc((0,0),p3,p4,CCW);

			////... or we need the top of the current touchpoint.
			//path top = tp.topfront--tp.topback;

			//if(i%2==0) 
			//{
				//evenPath = evenPath & top;
				//oddPath = oddPath & cutout;
			//}else{
				//evenPath = evenPath & cutout;
				//oddPath = oddPath & top;
			//}
		//}

		//// Handle the top touchpoint row.
		//{
			//int i = rowCount-1;
			//Touchpoint tpBelow = tps[i-1];
			//Touchpoint tp = tps[i];

			//pair p1, p2, p3, p4;
			//p1 = tpBelow.topback;
			
			//p2 = rotate(-keyTravelAngle)*tp.bottomfront;
			//p3 = rotate(-keyTravelAngle)*tp.bottomback;
			//pair offsetDirection = unit(rotate(-90)*(p2-p3));
			//p2 += keyGap*offsetDirection;
			//p3 += keyGap*offsetDirection;
			//p2 += (p2-p3);  // Extend to make intersection with circle easier.
			//p3 += (p3-p2);  // Extend to make intersection with circle easier.
			//real rBelow = abs(tpBelow.topback);
			//real r = abs(tp.topback);
			//p2 = intersectionpoint(p2--p3, circle((0,0),rBelow));
			//p3 = intersectionpoint(p2--p3, circle((0,0),r));
			//path cutout = arc((0,0),p1,p2,CW)--p3;
			//keysPathEnd= p3;

			////... or we need the top and back of the current touchpoint.
			//path top = tp.topfront--arc((0,0),tp.topback,keysPathEnd,CW);

			//if(i%2==0) 
			//{
				//evenPath = evenPath--top;
				//oddPath = oddPath--cutout;
			//}else{
				//evenPath = evenPath--cutout;
				//oddPath = oddPath--top;
			//}
		//}
		
		//// The rest of the body of the key, common to both parts.
		//path commonPath;
		//pair tangent1 = tangents_to_circle((0,0), mainShaftDiameter, keysPathEnd)[0];
		//pair tangent2 = tangents_to_circle((0,0), mainShaftDiameter/2 + mainShaftDiameter/2, keysPathStart)[1];
		//commonPath = keysPathEnd--arc((0,0),tangent1,tangent2,CCW)--keysPathStart;
		//oddPath = oddPath & commonPath & cycle;
		//evenPath = evenPath & commonPath & cycle;

		//this.oddPath = oddPath;
		//this.evenPath = evenPath;

		//// The hole for the bearing.
		//path hole = scale(mainShaftDiameter/2)*unitcircle;

		//this.oddPathFinal = oddPath^^hole;
		//this.evenPathFinal = evenPath^^hole;
	//}
//}
//from Body unravel Body;
	
////--------------------------Generate all paths, no duplication-------------------------//
//Touchpoint[] touchpoints;
//touchpoints[0] = Touchpoint(touchpointStart);
//for(int i=1; i<rowCount; ++i)
//{
	//touchpoints[i] = Touchpoint(touchpoints[i-1]);
//}
//Body body = Body(touchpoints);

////--------------------------Drawing, with duplication of replicate parts-------------------------//

//pen cutpen = black+linewidth(.001inches);
//pen fillpen = evenodd + 0.8*white;

//for(Touchpoint t:touchpoints)
//{
	//filldraw(shift((0,2.5))*t.p, fillpen, cutpen);
//}
//filldraw(shift((0,0))*body.evenPathFinal,fillpen,cutpen);
//filldraw(shift((0,-5))*body.oddPathFinal,fillpen,cutpen);

