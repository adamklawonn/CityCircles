#from django.contrib.gis.db import models
from django.db import models
import os
from geopy import geocoders

class Tile(models.Model):
    level = models.IntegerField()
    
    #THE X,Y VALUES RELATIVE TO THE ORIGIN OF THE MAP AT THE DEFAULT ZOOM LEVEL AND DEFAULT CENTER LAT/LONG
    ll_x = models.IntegerField()
    ll_y = models.IntegerField()
    size_x = models.IntegerField()
    size_y = models.IntegerField()
    fl_name = models.CharField(max_length=50)
    

class Station(models.Model):
    direction = models.CharField(max_length=1) #S/N
    name = models.CharField(max_length=100)
    index = models.IntegerField()
    lat = models.FloatField()
    lng = models.FloatField()
    
    def __unicode__(self):
        return "%s - %s" % (self.direction, self.name)
    
    
class SegmentPoint(models.Model):
    start_station = models.ForeignKey(Station, related_name="line_points")
    idx = models.IntegerField()
    lat = models.FloatField()
    lng = models.FloatField()
    
    
class BusinessCategory(models.Model):
    name = models.CharField(max_length=200)
    
class Business(models.Model):
    name = models.CharField(max_length=200)
    category = models.ForeignKey(BusinessCategory, related_name="businesses")
    
    stations = models.ManyToManyField(Station, related_name="businesses", verbose_name="Stations serving")
    
    lat = models.FloatField(blank=True, null=True)
    lon = models.FloatField(blank=True, null=True)
    
    address_street = models.CharField(max_length=100)
    address_apt = models.CharField(max_length=50, blank=True, null=True)
    city = models.CharField(max_length=50, default="glendale")
    state = models.CharField(max_length=2, default="AZ")
    zip = models.CharField(max_length=20, blank=True, null=True)
    normal_addr = models.CharField(max_length=500, blank=True, null=True)
    
    phone = models.CharField(max_length=50, blank=True, null=True)
    url = models.URLField(blank=True, null=True)
    
    info = models.TextField(blank=True, null=True)
    
    def save(self, *args, **kwargs):
        g = geocoders.Google('ABQIAAAAtkvQZu3SPcy93BP-d0Gh2hRooRwdk4M7Gvlg9qISmjSjaCH4cBSNucC3QJKWjtW4yIA1YbuaZ59bhg')
        
        place, (lat, lng) = g.geocode("%s, %s, %s" % (self.address_street, self.city, self.state))
        
        self.lat = lat
        self.lon = lng
        
        self.normal_addr = place
        
        super(Business, self).save(*args, **kwargs)

    
    