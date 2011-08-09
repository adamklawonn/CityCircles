# Create your views here.
from django.shortcuts import render_to_response
from pyproj import Proj
from models import *
import django
from django.utils import simplejson
from math import pi, sin, log
import globalmaptiles
import pntsandrects

WIDTH = 320
HEIGHT = 250

MAP_LL_LONG = -112.217
MAP_LL_LAT = 33.339

MAP_UL_LONG = MAP_LL_LONG
MAP_UL_LAT = MAP_LL_LAT

DEFAULT_ZOOM = 10


TILE_SIZE = 256


mercator = globalmaptiles.GlobalMercator(TILE_SIZE)

ul_m_x, ul_m_y = mercator.LatLonToMeters(MAP_UL_LAT, MAP_UL_LONG)

ul_x, ul_y = mercator.MetersToPixels(ul_m_x, ul_m_y, DEFAULT_ZOOM)

ul_x = round(ul_x)
ul_y = round(ul_y)

start_tile_x, start_tile_y = mercator.PixelsToTile(ul_x, ul_y)

start_tile_origin_x = start_tile_x * TILE_SIZE
start_tile_origin_y = start_tile_y * TILE_SIZE



#MAP_LL_LAT = 33.3617
#
#proj4_init_str = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +no_defs"
#p = Proj(proj4_init_str) # use kwargs
#
#x_start, y_end = p(MAP_UL_LONG, MAP_UL_LAT)
#
#x_tmp, y_start = p(MAP_UL_LONG, MAP_LL_LAT)
#
#pnt_to_mtr = (float(y_end) - float(y_start)) / float(HEIGHT)
#
#x_end = x_start + round(WIDTH * pnt_to_mtr)



def meter_to_pnt(x, y):
    new_x = ((x - x_start) / (x_end - x_start)) * WIDTH
    new_y = ((y - y_start) / (y_end - y_start)) * HEIGHT
    
    return new_x, new_y

def index(request):
    dct_return = {
        "points": "", #json encoded list of points to draw
        "tiles": "" #json encoded list of tiles
    }
    
    #import rpdb2; rpdb2.start_embedded_debugger("password")
    
    #first get the tiles
    li_tiles = []
    
    curr_x = start_tile_origin_x
    while (curr_x <= (ul_x + WIDTH)):
        curr_y = start_tile_origin_y
        while (curr_y <= (ul_y + HEIGHT)):
            gtx, gty = mercator.GoogleTile(curr_x / TILE_SIZE, curr_y / TILE_SIZE, DEFAULT_ZOOM)
            #li_tiles.append(["http://mt.google.com/mt?x=%d&y=%d&zoom=%d" % (gtx, gty, 17-DEFAULT_ZOOM), curr_x - ul_x, curr_y - ul_y])
            li_tiles.append(["http://mt1.google.com/vt/lyrs=m@139&hl=en&src=api&x=%d&y=%d&z=%d&s=Galileo" % (gtx, gty, DEFAULT_ZOOM), curr_x - ul_x, (HEIGHT - (curr_y - ul_y)) - TILE_SIZE])
            
            curr_y += TILE_SIZE
            
        curr_x += TILE_SIZE
    
    
    li_shapes = []
    
    model_lines = LightRail.objects.all()
    
    for model_line in model_lines:
        for all_points in model_line.geom.coords:
            ltln_pnts = zip(*all_points)
            ltln_pnts.reverse() #latitute first
            proj_points = map(mercator.LatLonToMeters, *ltln_pnts)
            
            proj_points = zip(*proj_points)
            proj_points.append([DEFAULT_ZOOM, ] * len(proj_points[0]))
            pnt_proj_points = map(mercator.MetersToPixels, *proj_points )
            
            pnt_proj_points = map(lambda x,y: [x - ul_x, HEIGHT - (y - ul_y)], *zip(*pnt_proj_points))
            
            li_shapes.append(pnt_proj_points)

    
    #for model_line in model_lines:
    #    for all_points in model_line.geom.coords:
    #    
    #        proj_points = map(p, *zip(*all_points))
    #        
    #        pnt_proj_points = map(meter_to_pnt, *zip(*proj_points))
    #        li_shapes.append(pnt_proj_points)

    dct_return["tiles"] = simplejson.dumps(li_tiles)
    dct_return["points"] = simplejson.dumps(li_shapes)
    return render_to_response('index.html', dct_return)
    
    
def test(request, from_zl=DEFAULT_ZOOM, to_zl=DEFAULT_ZOOM, center_x=WIDTH/2, center_y=HEIGHT/2):
    dct_return = {
        "points": "", #json encoded list of points to draw
        "tiles": "" #json encoded list of tiles
    }
    
    #CONVERT CENTER_X, CENTER_Y TO METERS AT FROM ZOOM LEVEL
    from_zl = int(from_zl)
    ll_m_x, ll_m_y = mercator.LatLonToMeters(MAP_LL_LAT, MAP_LL_LONG)
    #this is the x,y values for the world map origin at the from zoom level
    ll_x, ll_y = mercator.MetersToPixels(ll_m_x, ll_m_y, from_zl)
    #center_x, center_y at the world map zoom level
    c_w_x = ll_x + center_x
    c_w_y = ll_y + center_y
    #now make this lat/long
    c_w_m_x, c_w_m_y = mercator.PixelsToMeters(c_w_x, c_w_y, from_zl)
    
    #NOW MAKE THIS CENTER_X, CENTER_Y AT THE NEW ZOOM LEVEL
    n_c_w_x, n_c_w_y = mercator.MetersToPixels(c_w_m_x, c_w_m_y, to_zl)
    
    #CALCULATE THE NEW ZOOM LVLS ORIGIN IN THE WORLD
    n_ll_w_x = n_c_w_x - (WIDTH / 2) #new lower left world x
    n_ll_w_y = n_c_w_y - (HEIGHT / 2) # " y
    
    n_ur_w_x = n_ll_w_x + WIDTH
    n_ur_w_y = n_ll_w_y + HEIGHT
    
    li_tiles = []
    
    pnt_ll_w = pntsandrects.Point(n_ll_w_x, n_ll_w_y)
    pnt_ur_w = pntsandrects.Point(n_ur_w_x, n_ur_w_y)
    viewable_rect = pntsandrects.Rect(pnt_ll_w, pnt_ur_w)
    
    #MAKE A LIST OF TILES AT THIS ZOOM LEVEL THAT TOUCH THE VIEWABLE AREA
    for model_tile in models.Tile.objects.all():
        tile_pnt_ll_w = pntsandrects.Point(model_tile.ll_x, model_tile.ll_y)
        tile_pnt_ur_w = pntsandrects.Point(model_tile.ll_x + model_tile.size_x, model_tile.ll_y + model_tile.size_y)
        tile_rect = pntsandrects.Rect(tile_pnt_ll_w, tile_pnt_ur_w)
        if viewable_rect.overlaps(tile_rect):
            li_tiles.append([model_tile.fl_name, model_tile.ll_x, model_tile.ll_y])
            
    #NOW THE LIGHTRAIL LINES
    li_shapes = []
    
    model_lines = LightRail.objects.all()
    
    for model_line in model_lines:
        for all_points in model_line.geom.coords:
            ltln_pnts = zip(*all_points)
            ltln_pnts.reverse() #latitute first
            proj_points = map(mercator.LatLonToMeters, *ltln_pnts)
            
            proj_points = zip(*proj_points)
            proj_points.append([DEFAULT_ZOOM, ] * len(proj_points[0]))
            pnt_proj_points = map(mercator.MetersToPixels, *proj_points )
            
            pnt_proj_points = map(lambda x,y: [x - ul_x, HEIGHT - (y - ul_y)], *zip(*pnt_proj_points))
            
            li_shapes.append(pnt_proj_points)
            
    dct_return["tiles"] = simplejson.dumps(li_tiles)
    dct_return["points"] = simplejson.dumps(li_shapes)
    return render_to_response('test.html', dct_return)
    
