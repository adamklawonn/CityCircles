import re
import csv
import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
import sys

sys.path.append("/home/micah/projects/citycircles_server/citycircles_forclient/")
import settings
from BeautifulSoup import BeautifulSoup

from django.core.management import setup_environ
from django.db import models, connection

import gis2raphael.models

import math

#os.chdir("/home/micah/projects/current/citycircles_server/citycircles_forclient/lr_convert")
setup_environ(settings)

TOT_STATIONS = 28

se_in = file("lr_convert/NW.osm", "r").read()

soup = BeautifulSoup(se_in)



def calculate_distance(lat1, lon1, lat2, lon2):
    '''
    * Calculates the distance between two points given their (lat, lon) co-ordinates.
    '''

    if ((lat1 == lat2) and (lon1 == lon2)):
        return 0

    try:
        delta = lon2 - lon1
        a = math.radians(lat1)
        b = math.radians(lat2)
        C = math.radians(delta)
        x = math.sin(a) * math.sin(b) + math.cos(a) * math.cos(b) * math.cos(C)
        distance = math.acos(x) # in radians
        distance  = math.degrees(distance) # in degrees
        distance  = distance * 60 # 60 nautical miles / lat degree
        distance = distance * 1852 # conversion to meters
        distance  = round(distance)
        return distance
    except:
        return 0


li_points = []  #lat/lon/station_id (-1 if point)
dct_stations = {}
station_idx = 1
pnt_idx = 1
station = ""
model_station = None

for node in soup.findAll("node", lat=True, lon=True):
    lat = float(node.attrMap["lat"])
    lon = float(node.attrMap["lon"])
    
    if node.findAll(k="railway", v="station"):
        result = node.find('tag', k="name")
        if result:
            station_name = result.attrMap["v"]
            print "NEW STATION: ", station_name
            
            dct_stations[station_idx] = [lat, lon, station_name]
            li_points.append([lat, lon, station_idx])
            station_idx += 1
            continue
    
    li_points.append([lat, lon, -1])
            
            
station_idx = 1
curr_station = dct_stations[1]

#new_station = gis2raphael.models.Station()
#new_station.direction="S"
#new_station.name = curr_station[2]
#new_station.index = station_idx
#new_station.lat = curr_station[0]
#new_station.lng = curr_station[1]
#new_station.save()
#model_station = new_station
model_station = None

while li_points:
    shortest_distance = 99999999
    closest_idx = None
    for pnt_idx in range(0, len(li_points), 1):
        chk_pnt = li_points[pnt_idx]
        distance = calculate_distance(curr_station[0], curr_station[1], chk_pnt[0], chk_pnt[1])
        if distance < shortest_distance:
            shortest_distance = distance
            closest_idx = pnt_idx
            
    if closest_idx != None:  #this should never happen
        pnt = li_points.pop(closest_idx)
        if pnt[2] >= 1:
            #this is a station
            if model_station:
                new_pnt = gis2raphael.models.SegmentPoint()
                new_pnt.start_station = model_station
                new_pnt.idx = db_pnt_idx
                new_pnt.lat = pnt[0]
                new_pnt.lng = pnt[1]
                new_pnt.save()
                db_pnt_idx += 1
            
            #save the new station
            curr_station = dct_stations[pnt[2]]
            new_station = gis2raphael.models.Station()
            new_station.direction="N"
            new_station.name = curr_station[2]
            new_station.index = station_idx
            new_station.lat = curr_station[0]
            new_station.lng = curr_station[1]
            new_station.save()
            model_station = new_station
            station_idx += 1
            
            #the new stations first point is its own location
            db_pnt_idx = 1
            new_pnt = gis2raphael.models.SegmentPoint()
            new_pnt.start_station = model_station
            new_pnt.idx = db_pnt_idx
            new_pnt.lat = pnt[0]
            new_pnt.lng = pnt[1]
            new_pnt.save()
            db_pnt_idx += 1
            
        else:
            #this is a point
            new_pnt = gis2raphael.models.SegmentPoint()
            new_pnt.start_station = model_station
            new_pnt.idx = db_pnt_idx
            new_pnt.lat = pnt[0]
            new_pnt.lng = pnt[1]
            new_pnt.save()
            db_pnt_idx += 1

#new_pnt = gis2raphael.models.SegmentPoint()
#new_pnt.start_station = model_station
#new_pnt.idx = pnt_idx
#new_pnt.lat = lat
#new_pnt.lng = lon
#new_pnt.save()
#pnt_idx += 1

    
#new_station = gis2raphael.models.Station()
#new_station.direction="S"
#new_station.name = station_name
#new_station.index = station_idx
#new_station.lat = lat
#new_station.lng = lon
#new_station.save()
#station_idx += 1
    



