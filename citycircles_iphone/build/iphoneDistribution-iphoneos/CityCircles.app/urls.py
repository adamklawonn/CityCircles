from django.conf.urls.defaults import *
import gis2raphael.views
from settings import MEDIA_ROOT, GTILE_ROOT
# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    (r'^$', gis2raphael.views.index),
    (r'^test/$', gis2raphael.views.test),
    (r'^static/(?P<path>.*)$', 'django.views.static.serve', {'document_root': MEDIA_ROOT}),
    (r'^gtiles/(?P<path>.*)$', 'django.views.static.serve', {'document_root': GTILE_ROOT}),
    (r'^test/(?P<from_zl>.*)/(?P<to_zl>.*)/(?P<center_x>.*)/(?P<center_y>.*)/(?P<from_origin_x>.*)/(?P<from_origin_y>.*)/$', gis2raphael.views.test),
    # Example:
    # (r'^citycircles/', include('citycircles.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # (r'^admin/', include(admin.site.urls)),
)
