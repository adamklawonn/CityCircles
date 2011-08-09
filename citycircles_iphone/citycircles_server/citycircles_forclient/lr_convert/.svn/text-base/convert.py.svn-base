import re
import csv
import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
import sys
sys.path.append("/home/micah/projects/current/citycircles_server/citycircles_forclient/")
import settings

from django.core.management import setup_environ
from django.db import models, connection

import gis2raphael.models

#os.chdir("/home/micah/projects/current/citycircles_server/citycircles_forclient/lr_convert")
setup_environ(settings)

ip_file = file("lr_convert/interest_points", "r")

reader = csv.reader(ip_file)

TOT_STATIONS = 28

dct_nwb = {}
dct_seb = {}

dct_nwb_pnts = {}
dct_seb_pnts = {}

seb_pnts = []
nwb_pnts = []

reader.next() #skip first

for row in reader:
    sebi,nwbi,id, map_id, map_layer_id, map_icon_id, label, body, description, twitter_hashtag, lat, lng, author_id, created_at, updated_at = row
    lat = float(lat)
    lng = float(lng)
    sebi = int(sebi)
    nwbi = int(nwbi)
    if "NWB" in label:
        dct_nwb[nwbi] = [lat, lng, label]
    elif "SEB" in label:
        dct_seb[sebi] = [lat, lng, label]
    else:    
        dct_nwb[nwbi] = [lat, lng, label]
        dct_seb[sebi] = [lat, lng, label]        
    
for sfi in range(1, 6):
    def_fl = file("lr_convert/SE%s.osm" % sfi, "r")
    def_txt = def_fl.read()
    pnts = re.findall(r'<node id="[^"]+" lat="([^"]+)" lon="([^"]+)">', def_txt)
    seb_pnts += [[float(x[0]), float(x[1])] for x in pnts]
    
for sfi in range(1, 6):
    def_fl = file("lr_convert/NW%s.osm" % sfi, "r")
    def_txt = def_fl.read()
    pnts = re.findall(r'<node id="[^"]+" lat="([^"]+)" lon="([^"]+)">', def_txt)
    pnts.reverse()
    nwb_pnts += [[float(x[0]), float(x[1])] for x in pnts]
    
#MAKE THE SE SEGMENTS
cur_idx = 1
while cur_idx < TOT_STATIONS:
    cur_lat, cur_lng, cur_nm = dct_seb[cur_idx]
    nxt_lat, nxt_lng, nxt_nm = dct_seb[cur_idx + 1]
    for lat, lng in seb_pnts:
        if abs(cur_lat - nxt_lat) < 0.005:
            cur_lat += 0.01
            nxt_lat -= 0.01
        if abs(cur_lng - nxt_lng) < 0.005:
            cur_lng -= 0.01
            nxt_lng += 0.01
        if (lat <= cur_lat and lat >= nxt_lat) and (lng >= cur_lng and lng <= nxt_lng):
            pnts = dct_seb_pnts.get(cur_idx, [])
            pnts.append([lat, lng])
            dct_seb_pnts[cur_idx] = pnts
    cur_idx += 1
            
#MAKE THE NW SEGMENTS
cur_idx = 1
while cur_idx < TOT_STATIONS:
    cur_lat, cur_lng, cur_nm = dct_nwb[cur_idx]
    nxt_lat, nxt_lng, nxt_nm = dct_nwb[cur_idx + 1]
    for lat, lng in nwb_pnts:
        if abs(cur_lat - nxt_lat) < 0.005:
            cur_lat -= 0.01
            nxt_lat += 0.01
        if abs(cur_lng - nxt_lng) < 0.005:
            cur_lng += 0.01
            nxt_lng -= 0.01
        if (lat > cur_lat and lat < nxt_lat) and (lng < cur_lng and lng > nxt_lng):
            pnts = dct_nwb_pnts.get(cur_idx, [])
            pnts.append([lat, lng])
            dct_nwb_pnts[cur_idx] = pnts    
    cur_idx += 1
    

#NOW UPDATE THE DATABASE
#NW SEGMENTS
for station_idx in dct_nwb.keys():
    lat, lng, name = dct_nwb[station_idx]
    new_station = gis2raphael.models.Station()
    new_station.direction="N"
    new_station.name = name
    new_station.index = station_idx
    new_station.lat = lat
    new_station.lng = lng
    new_station.save()
    
    new_pnt = gis2raphael.models.SegmentPoint()
    new_pnt.start_station = new_station
    new_pnt.idx = 1
    new_pnt.lat = lat
    new_pnt.lng = lng
    new_pnt.save()
    
    pidx = 2
    for pnt in dct_nwb_pnts.get(station_idx, []):
        new_pnt = gis2raphael.models.SegmentPoint()
        new_pnt.start_station = new_station
        new_pnt.idx = pidx
        new_pnt.lat = pnt[0]
        new_pnt.lng = pnt[1]
        new_pnt.save()
        pidx += 1
        
    if dct_nwb.has_key(station_idx + 1):
        nlat, nlng, nname = dct_nwb[station_idx + 1]
        new_pnt = gis2raphael.models.SegmentPoint()
        new_pnt.start_station = new_station
        new_pnt.idx = pidx
        new_pnt.lat = nlat
        new_pnt.lng = nlng
        new_pnt.save()

#SE SEGMENTS
for station_idx in dct_nwb.keys():
    lat, lng, name = dct_seb[station_idx]
    new_station = gis2raphael.models.Station()
    new_station.direction="S"
    new_station.name = name
    new_station.index = station_idx
    new_station.lat = lat
    new_station.lng = lng
    new_station.save()
    
    new_pnt = gis2raphael.models.SegmentPoint()
    new_pnt.start_station = new_station
    new_pnt.idx = 1
    new_pnt.lat = lat
    new_pnt.lng = lng
    new_pnt.save()
    
    pidx = 2
    for pnt in dct_seb_pnts.get(station_idx, []):
        new_pnt = gis2raphael.models.SegmentPoint()
        new_pnt.start_station = new_station
        new_pnt.idx = pidx
        new_pnt.lat = pnt[0]
        new_pnt.lng = pnt[1]
        new_pnt.save()
        pidx += 1
        
    if dct_seb.has_key(station_idx + 1):
        nlat, nlng, nname = dct_seb[station_idx + 1]
        new_pnt = gis2raphael.models.SegmentPoint()
        new_pnt.start_station = new_station
        new_pnt.idx = pidx
        new_pnt.lat = nlat
        new_pnt.lng = nlng
        new_pnt.save()