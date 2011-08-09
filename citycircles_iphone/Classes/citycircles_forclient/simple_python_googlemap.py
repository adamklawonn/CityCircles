#!/usr/bin/env python

from math import pi, sin, log

# Python sample. How to ask Google for map tiles?

# This script is published under GPL (included below)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#



# Constants used for degree to radian conversion, and vice-versa.
DTOR = pi / 180.
RTOD = 180. / pi
TILE_SIZE = 256

class GoogleZoom(object):
	def locationCoord(self, lat, lon, zoom):
		# Per se earth coordinates are -90? <= lat <= +90? and -180? <= lon <= 180? 
		# Mercator is NOT applicable for abs(lat) > 85.0511287798066 degrees 
		if (abs(lat) > 85.0511287798066):
			raise "Invalid latitude"
		# latitude (deg) -> latitude (rad) 
		sin_phi = sin(float(lat) * DTOR)
		# Use Mercator to calculate x and normalize this to -1 <= x <= +1 by division by 180.
		# The center of the map is lambda_0 = 0, hence x = lat. 
		norm_x = lon / 180.
		# Use Mercator to calculate y and normalize this to -1 <= y <= +1 by division by PI. 
		# According to Mercator y is defined in the range of -PI <= y <= PI only 
		norm_y = (0.5 * log((1 + sin_phi) / (1 - sin_phi))) / pi
		# Apply the normalized point coordinations to any application (here the coordinates of 
		# a 256*256 image holding that point in a thought grid with origin 0,0 top/left)
		col = pow(2, zoom) * ((norm_x + 1) / 2);
		row = pow(2, zoom) * ((1 - norm_y) / 2);
		return (col, row, zoom);
		
		
# Main
gz = GoogleZoom()
col, row, zoom = gz.locationCoord(-36.856257, 174.765058, 17)
print "Google Tile URL: http://mt.google.com/mt?x=%d&y=%d&zoom=%d" % (col, row, 17-zoom)
print "X coordinate within the tile =", (col - long(col)) * TILE_SIZE
print "Y coordinate within the tile =", (row - long(row)) * 256