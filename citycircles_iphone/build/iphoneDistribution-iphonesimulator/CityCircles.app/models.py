#from django.contrib.gis.db import models
from django.db import models
import os

class Tile(models.Model):
    level = models.IntegerField()
    
    #THE X,Y VALUES RELATIVE TO THE ORIGIN OF THE MAP AT THE DEFAULT ZOOM LEVEL AND DEFAULT CENTER LAT/LONG
    ll_x = models.IntegerField()
    ll_y = models.IntegerField()
    size_x = models.IntegerField()
    size_y = models.IntegerField()
    fl_name = models.CharField(max_length=50)
    
