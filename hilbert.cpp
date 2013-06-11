#include <string>
#include <iostream>
#include <stdint.h>

#include <cairo.h>
#include <cairo-pdf.h>

using namespace std;

// These C functions for generating a 2D Hilbert are borrowed from wikipedia.
// http://en.wikipedia.org/wiki/Hilbert_curve

//rotate/flip a quadrant appropriately
void rot(int n, int *x, int *y, int rx, int ry) {
    if (ry == 0) {
        if (rx == 1) {
            *x = n-1 - *x;
            *y = n-1 - *y;
        }
 
        //Swap x and y
        int t  = *x;
        *x = *y;
        *y = t;
    }
}

//convert (x,y) to d
int xy2d (int n, int x, int y) {
    int rx, ry, s, d=0;
    for (s=n/2; s>0; s/=2) {
        rx = (x & s) > 0;
        ry = (y & s) > 0;
        d += s * s * ((3 * rx) ^ ry);
        rot(s, &x, &y, rx, ry);
    }
    return d;
}
 
//convert d to (x,y)
void d2xy(int n, int d, int *x, int *y) {
    int rx, ry, s, t=d;
    *x = *y = 0;
    for (s=1; s<n; s*=2) {
        rx = 1 & (t/2);
        ry = 1 & (t ^ rx);
        rot(s, x, y, rx, ry);
        *x += s * rx;
        *y += s * ry;
        t /= 4;
    }
}

void print_points(int n)
{
	cout << "x\ty" << endl;
	for (int d=0; d<n*n; d++)
	{
		int x,y;
		d2xy(n,d,&x,&y);
		cout << x << '\t' << y << endl;
	}
}

void output_to_pdf(int n)
{
	int h = 640;
	int w = 640;
	cairo_surface_t *s = cairo_pdf_surface_create("hilbert_path.pdf", w, h);
	
	cairo_t *c=cairo_create(s);

	cairo_scale(c,w/n,h/n); // order?
	cairo_translate(c,0.5,0.5);
	cairo_move_to(c,0,0);
	for (int d=0; d<n*n; d++)
	{
		int x,y;
		d2xy(n,d,&x,&y);
		cairo_line_to(c,x,y);
	}

	//cairo_close_path(c);
	cairo_set_source_rgb(c, 0.0, 0.0, 0.0);
	cairo_set_line_width(c, 0.1);
	cairo_stroke(c);

	cairo_show_page(c);
	cairo_destroy(c);

	cairo_surface_flush(s);
	cairo_surface_destroy(s);

	//cairo_surface_write_to_pdf(s, "hilbert.pdf");
}

int main(int argc, char **argv) 
{
	//int n=4;
	int n=8;
	print_points(n);
	output_to_pdf(n);
}

