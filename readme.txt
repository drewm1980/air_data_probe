Code to procedurally generate a CAD model for a multi-hole air data probe, using python to compute all off the routing, and openscad as a CSG file and rendering target.

This is a work-in-progress! Don't be surprised if openscad chokes on the generated files.

The idea is to 3D print the whole part as one piece, glue pressure sensors into one side, solder on a PCB, you're done.  

Of course this whole idea depends a lot on print quality.  

The point of having many holes is for the probe to still work if some holes get clogged (traditionally a weakness of pitot probes)
