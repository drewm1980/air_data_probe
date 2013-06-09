#!/usr/bin/env python
import numpy
from numpy import array
from pylab import norm
from pygraph.classes.graph import graph

from pitot_constants import r,h,r_ducts,w_walls,w_shell

def floor(x):
    return int(numpy.floor(x))
def ceil(x):
    return int(numpy.ceil(x))

# Coordinate system is [forward, starboard, down]
# i.e. match the plane coordinate system.

# Compute a 1D mesh in y direction, centered at centerpoint,
# with minimum "radius" r_grid, and spacing of gridspacing.
# Pure.
def y_mesh(centerpoint, gridspacing, r_grid):
    neighborvector=array([0.,gridspacing,0.])
    n = ceil(r_grid/gridspacing)
    nodes = [centerpoint+i*neighborvector for i in range(-n,n+1)]
    edges = zip(nodes[:-1],nodes[1:]) 
    return nodes,edges

# Compute a 2D mesh in the y-z plane, centered at centerpoint,
# with minimum "radius" r_grid in z, and spacing of gridspacing.
# Pure.
def yz_mesh_rectangular(centerpoint, gridspacing, r_grid):
    neighborvector=array([0.,0.,gridspacing])
    n = ceil(r_grid/gridspacing)
    nodes, edges = y_mesh(centerpoint + -n*neighborvector, gridspacing, r_grid)
    oldnodes=nodes
    oldedges=edges
    for i in range(-n+1,n+1):
        newnodes, newedges = y_mesh(centerpoint + i*neighborvector, gridspacing, r_grid)
        nodes.extend(newnodes)
        edges.extend(newedges)
        edges.extend(zip(oldnodes,newnodes))
        oldnodes=newnodes
        oldedges=newedges
    return nodes,edges

# Compute a 3D mesh centered at centerpoint, with minum extend in the
# x direction of [x_start,x_end], "radius" of r_grid in the y-z plane,
# and spacing of gridspacing in all directions.
#  Pure.
def xyz_mesh_rectangular(centerpoint, x_start, x_end, r_grid, gridspacing):
    neighborvector=array([gridspacing,0.,0.])
    n_start = floor(x_start/gridspacing)
    n_end = ceil(x_end/gridspacing)
    nodes, edges = yz_mesh_rectangular(centerpoint + n_start*neighborvector, gridspacing, r_grid)
    oldnodes=nodes
    oldedges=edges
    for i in range(n_start+1,n_end+1):
        newnodes, newedges = yz_mesh_rectangular(centerpoint + i*neighborvector, gridspacing, r_grid)
        nodes.extend(newnodes)
        edges.extend(newedges)
        edges.extend(zip(oldnodes,newnodes))
        oldnodes=newnodes
        oldedges=newedges
    return nodes,edges

# Grid the part of the pitot tube that is available for routing
# Not Pure!
hemisphere_center = array([0,0,0])
def is_point_internal(p):
    x,y,z = p[0],p[1],p[2]
    if x>hemisphere_center[0]:
        # point is in the hemisphere
        return norm(p-hemisphere_center) < r-w_shell
    if x>(-(h-r)):
        # point is in the shaft
        return y*y+z*z < (r-w_shell)*(r-w_shell)
    return False
def is_point_external(p):
    return not is_point_internal(p)

gridspacing = 2*r_ducts + w_walls
#nodes,edges = y_mesh(hemisphere_center, gridspacing, r)
#nodes,edges = yz_mesh_rectangular(hemisphere_center, gridspacing, r)
nodes,edges = xyz_mesh_rectangular(hemisphere_center, -(h-r), r, r, gridspacing)

# Codegen openscad code snippet that renders a pygraph grid
def codegen_graph(g,filename='graph.scad', r_nodes=1.5, r_edges=1):
    nodes = g.nodes()
    edges = g.edges()
    f = open(filename, 'w')
    f.write('use <helpers.scad>\n')
    for n in nodes:
        f.write('sphere_from_point(' + str(list(n)) + ',r=' + str(r_nodes) + ');\n')
    #for e in edges:
        #f.write('cylinder_from_two_points(' +
               #str(list(e[0])) + ',' + str(list(e[1])) + 
                #',r=' + str(r_edges) + ');\n')
    f.close()

# Convert our graph to a pygraph data structure.
# This will give us more efficient node removal (?)
# and shortest path algorithms like Dijksra's and A*
#
# Implementation note: the identity of nodes in pygraph
# can be anything that is hashable.  References to numpy
# arrays are not hashable, so we convert to 3-tuples.
nodes = map(tuple,nodes)
edges = [tuple(map(tuple,e)) for e in edges]
g = graph()
g.add_nodes(nodes)
for e in edges:
    g.add_edge(e)

codegen_graph(g,'mesh_before_trimming.scad')

# Filter out the nodes from our mesh that are external
# to the volume we have available for routing.
external_nodes = filter(is_point_external,nodes)
for n in external_nodes:
    g.del_node(n)

codegen_graph(g,'mesh_after_trimming.scad')

