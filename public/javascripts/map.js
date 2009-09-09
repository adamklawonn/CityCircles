citycircles.maps.Map = function() {
	
    var iconBlue = new GIcon();
    iconBlue.image = 'http://labs.google.com/ridefinder/images/mm_20_blue.png';
    iconBlue.shadow = 'http://labs.google.com/ridefinder/images/mm_20_shadow.png';
    iconBlue.iconSize = new GSize(12, 20);
    iconBlue.shadowSize = new GSize(22, 20);
    iconBlue.iconAnchor = new GPoint(6, 20);
    iconBlue.infoWindowAnchor = new GPoint(5, 1);

    var iconRed = new GIcon();
    iconRed.image = 'http://labs.google.com/ridefinder/images/mm_20_red.png';
    iconRed.shadow = 'http://labs.google.com/ridefinder/images/mm_20_shadow.png';
    iconRed.iconSize = new GSize(12, 20);
    iconRed.shadowSize = new GSize(22, 20);
    iconRed.iconAnchor = new GPoint(6, 20);
    iconRed.infoWindowAnchor = new GPoint(5, 1);

    var customIcons = [];
    customIcons["restaurant"] = iconBlue;
    customIcons["bar"] = iconRed;
    var markerGroups = {
        "restaurant": [],
        "bar": []
    };

    this.load = function(mapEl, datasourceURI) {
        if (GBrowserIsCompatible()) {
            var map = new GMap2($(mapEl));
            map.setCenter(new GLatLng(47.614495, -122.341861), 13);

            GDownloadUrl(datasourceURI,
            function(data) {
                var xml = GXml.parse(data);
                var markers = xml.documentElement.getElementsByTagName("marker");
                for (var i = 0; i < markers.length; i++) {
                    var name = markers[i].getAttribute("name");
                    var address = markers[i].getAttribute("address");
                    var type = markers[i].getAttribute("type");
                    var point = new GLatLng(parseFloat(markers[i].getAttribute("lat")),
                    parseFloat(markers[i].getAttribute("lng")));
                    var marker = this.createMarker(point, name, address, type);
                    map.addOverlay(marker);
                }
            }.bind(this)); // Using bind to ensure correct scope.
        }
    };

    this.createMarker = function(point, name, address, type) {
		var marker = new GMarker(point, customIcons[type]);
        markerGroups[type].push(marker);
        var html = "<b>" + name + "</b> <br/>" + address;
        GEvent.addListener(marker, 'click',
        function() {
            marker.openInfoWindowHtml(html);
        });
        return marker;
    };

    this.toggleGroup = function(type) {
        for (var i = 0; i < markerGroups[type].length; i++) {
            var marker = markerGroups[type][i];
            if (marker.isHidden()) {
                marker.show();
            } else {
                marker.hide();
            }
        }
    };

};