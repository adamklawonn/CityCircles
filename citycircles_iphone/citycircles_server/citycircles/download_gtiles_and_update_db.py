import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

from django.core.management import setup_environ
from django.db import models, connection

from math import pi, sin, log
import globalmaptiles

import gis2raphael.models
import settings
import urllib

setup_environ(settings)

WIDTH = 320
HEIGHT = 250

#THIS IS REALLY LL, NOT UL
MAP_UL_LONG = -112.217
MAP_UL_LAT = 33.339

ZOOMS = [10, 12, 15]

TILE_SIZE = 256


mercator = globalmaptiles.GlobalMercator()

ul_m_x, ul_m_y = mercator.LatLonToMeters(MAP_UL_LAT, MAP_UL_LONG)

ul_x, ul_y = mercator.MetersToPixels(ul_m_x, ul_m_y, 10)
ul_x = round(ul_x)
ul_y = round(ul_y)

#TODO: IS THIS A MISTAKE, SHOULDN'T THIS BE THE MAP WIDTH AND HEIGHT
ur_m_x, ur_m_y = mercator.PixelsToMeters(ul_x + TILE_SIZE, ul_y + TILE_SIZE, 10)

#LAT/LONG OF MAP BOUNDS, UPPER RIGHT
MAP_UR_LAT, MAP_UR_LONG = mercator.MetersToLatLon(ur_m_x, ur_m_y)


for DEFAULT_ZOOM in ZOOMS:
    ul_x, ul_y = mercator.MetersToPixels(ul_m_x, ul_m_y, DEFAULT_ZOOM)
    ur_x, ur_y = mercator.MetersToPixels(ur_m_x, ur_m_y, DEFAULT_ZOOM)
    
    ul_x = round(ul_x)
    ul_y = round(ul_y)
    ur_x = round(ur_x)
    ur_y = round(ur_y)
    
    #THIS IS THE TILE NUMBER TO THE LEFT AND BOTTOM
    start_tile_x, start_tile_y = mercator.PixelsToTile(ul_x, ul_y)
    
    start_tile_origin_x = start_tile_x * TILE_SIZE
    start_tile_origin_y = start_tile_y * TILE_SIZE
        
    curr_x = start_tile_origin_x
    while (curr_x <= ur_x):
        curr_y = start_tile_origin_y
        while (curr_y <= ur_y):
            gtx, gty = mercator.GoogleTile(curr_x / TILE_SIZE, curr_y / TILE_SIZE, DEFAULT_ZOOM)
            #li_tiles.append(["http://mt.google.com/mt?x=%d&y=%d&zoom=%d" % (gtx, gty, 17-DEFAULT_ZOOM), curr_x - ul_x, curr_y - ul_y])
            
            url = "http://mt1.google.com/vt/lyrs=m@139&hl=en&src=api&x=%d&y=%d&z=%d&s=Galileo" % (gtx, gty, DEFAULT_ZOOM)
            
            fl_name = "%s_%s_%s_%s.png" % (DEFAULT_ZOOM, gtx, gty, TILE_SIZE)
            
            new_tile = gis2raphael.models.Tile()
            new_tile.level = DEFAULT_ZOOM
            #USE X,Y WITH MAP ORIGIN
            new_tile.ll_x = curr_x - ul_x
            new_tile.ll_y = curr_y - ul_y
            
            new_tile.fl_name = fl_name
            new_tile.size_x = TILE_SIZE
            new_tile.size_y  = TILE_SIZE
            
            new_tile.save()
            
            f = urllib.urlopen(url)
            
            out_file = file("gtiles/%s" % fl_name, "w")
            out_file.write(f.read())
            out_file.flush()
            out_file.close()
            
            curr_y += TILE_SIZE
            
        curr_x += TILE_SIZE
        
        
        