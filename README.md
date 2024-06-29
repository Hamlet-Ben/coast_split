# coast_split
GIS work to create to split the British coast into regions of equal length.

This work was conducted to support research on shore crabs by Laura Coles. The task in to create a GIS polyline shapefile of the British coast that has splits the coast into equal length sections, with the length of these sections being roughly equivilant to the length of the Cornish coast. In addition, one of these sections must represent the actual Cornish coast as closely as possible.

Input data:
 - 'British Coast.shp' & associated files - a shapefile that I created myself in QGIS from a shapefile of the whole of Europe. I extracted the main island of Great Britain from this shapefile then reconfigured the resulting polyline shapefile to make the 'origin' vertex at the top of the Tamar river with vertices then accumulating west of this point - this was necessary to ensure the R function used laterextracted a section of line covering the Cornish coast.

