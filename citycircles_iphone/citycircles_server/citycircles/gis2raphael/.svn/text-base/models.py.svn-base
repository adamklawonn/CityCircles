from django.contrib.gis.db import models
import os
from django.contrib.gis.utils import LayerMapping


class LightRail(models.Model):
    service = models.CharField(max_length=16)
    shp_id = models.IntegerField()
    city = models.CharField(max_length=12)
    length = models.FloatField()
    geom = models.MultiLineStringField(srid=4326) #WGS84 (SRID=4326).
    objects = models.GeoManager()
    
class Tile(models.Model):
    level = models.IntegerField()
    ll_x = models.IntegerField()
    ll_y = models.IntegerField()
    size_x = models.IntegerField()
    size_y = models.IntegerField()
    fl_name = models.CharField(max_length=50)
    

# Auto-generated `LayerMapping` dictionary for LightRail model
lightrail_mapping = {
    'service' : 'Service',
    'shp_id' : 'ID',
    'city' : 'City',
    'length' : 'Length',
    'geom' : 'MULTILINESTRING',
}


rail_shp = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../Light_Rail/LIGHT_RAIL_LINE.shp'))

def run(verbose=True):
    lm = LayerMapping(LightRail, rail_shp, lightrail_mapping,
                      transform=True, encoding='iso-8859-1')

    lm.save(strict=True, verbose=verbose)
