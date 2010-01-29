(new function() {
	
	/*
	*	Defines the citycircles map type.
	*/
	citycircles.maps.Map = function( mapEl, options ) {

		this.mapEl = document.getElementById( mapEl );
		this.map = null;
		this.options = options;
		this.layers = {};
		this.interestPoints = [];
		this.interestLines = [];
		this.layersURL = "/maps/" + options.map_id + "/map_layers.json";
		this.interestPointsURL = "/maps/" + options.map_id + "/interest_points.json";
		this.interestLinesURL = "/maps/" + options.map_id + "/interest_lines.json";
    	this.markerGroups = [];

	};

	var map = citycircles.maps.Map;

	map.prototype.render = function() {
		// Pre-render checks.
		this.renderMap();
		this.renderLayers();
		//this.renderInterestLines();
		this.renderInterestPoints();
	};
	
	map.prototype.renderMap = function() {

		
		/*this.map.setCenter( new google.maps.LatLng( this.options.center[ 0 ], this.options.center[ 1 ] ), this.options.zoom );
		// If options.mouseZoom is present and true, enable zooming in/out via mouse scroll.
		if( options.mouseZoom ) {
			this.map.enableScrollWheelZoom();
		}*/
		var mapOptions = {
                    projection : new OpenLayers.Projection( "EPSG:900913" ),
                    units : "m",
                    maxResolution : 156543.0339,
                    maxExtent : new OpenLayers.Bounds( -20037508, -20037508, 20037508, 20037508.34 )
                };
    this.map = new OpenLayers.Map( 'map', mapOptions );

    // create Google Mercator layers
    var gmap = new OpenLayers.Layer.Google( "Google Streets", { 'sphericalMercator': true } );

    this.map.addLayer( gmap );
    this.map.setCenter( new OpenLayers.LonLat( this.options.center[1], this.options.center[0] ), this.options.zoom );

	};
	
  map.prototype.renderLayers = function() {

	// Only update the map control if map-control element is present.
	if( $( "map-control" ) ) {

		var scope = this;
		var url = this.layersURL;
		
		var handlers = {
			
			onSuccess : function( response ) {
				var layers = response.responseJSON;
				var mapLayerHTML = "";

				for( var i = 0; i < layers.length; i++ ) {
			    mapLayerHTML += '<input id="cc-map-layer-id-' + layers[ i ].map_layer.id + '" type="checkbox" checked />' + layers[ i ].map_layer.title + '<br />';
					//scope.layers[String(layers[i].map_layer.id)] = [];
				  var layer = new OpenLayers.Layer.Vector( layers[i].map_layer.id );
				  scope.layers[ layer.name ] = [];
				  scope.map.addLayer( layer );
				}
				$( "map-control" ).update( mapLayerHTML );
			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.renderLayers() -> " + response.responseText );
			}
			
		};
		
		var request = new Ajax.Request(  url, { method : "get", onSuccess : handlers.onSuccess, onFailure : handlers.onFailure }  );

	}
	
  };

  map.prototype.renderInterestPoints = function() {

	// Only update the map control if map-control element is present.
	if( $( "map-control" ) ) {

		var scope = this;
		var url = this.interestPointsURL;
		
		var handlers = {
			
			onSuccess : function( response ) {
				scope.interestPoints = response.responseJSON;
				var mapLayerHTML = "";
				var interestPoints = scope.interestPoints;
				for( var i = 0; i < interestPoints.length; i++ ) {
          // create marker
          var marker = new OpenLayers.Feature.Vector( new OpenLayers.Geometry.Point( interestPoints[i].interest_point.lng, interestPoints[i].interest_point.lat ), { externalGraphic : "/images/map_icons/stopcon.png", graphicWidth : 20, graphicHeight : 20 } );
				  // add marker to layers array
				  scope.layers[interestPoints[i].interest_point.map_layer_id].push( marker );
				  scope.map.getLayersByName( interestPoints[i].interest_point.map_layer_id )[0].addFeatures( marker );
				  //console.log(scope.map.getLayersByName( interestPoints[i].interest_point.map_layer_id )[0]);
				}
        
			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.renderInterestPoints() -> " + response.responseText );
			}
			
		};
		
		var request = new Ajax.Request(  url, { method : "get", onSuccess : handlers.onSuccess, onFailure : handlers.onFailure }  );

	}
	
  };

  map.prototype.renderInterestLines = function() {

	// Only update the map control if map-control element is present.
	if( $( "map-control" ) ) {

		var scope = this;
		var url = this.interestLinesURL;
		
		var handlers = {
			
			onSuccess : function( response ) {
				scope.interestLines = response.responseJSON;
				var mapLayerHTML = "";
				var interestLines = scope.interestLines; 
				var latlngsGroups = {};
				for( var i = 0; i < interestLines.length; i++ ) {
			    	if(typeof latlngsGroups[interestLines[i][0]] == "undefined") {
						latlngsGroups[String(interestLines[i][0])] = [];
					}
					var marker = new google.maps.LatLng(interestLines[i][1], interestLines[i][2]);
					latlngsGroups[String(interestLines[i][0])].push(marker);
				}
				//console.log(latlngsGroups["VMLRL"]);
				//scope.map.addOverlay(new google.maps.Polyline(latlngsGroups["VMLRL"]));		
				for(group in latlngsGroups) {
					console.log(latlngsGroups[group].length);
					scope.map.addOverlay(new google.maps.Polyline(latlngsGroups[group]));					
				}
				//scope.map.addOverlay(new google.maps.Polyline(latlngs));

			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.renderInterestPoints() -> " + response.responseText );
			}
			
		};
		
		var request = new Ajax.Request(  url, { method : "get", onSuccess : handlers.onSuccess, onFailure : handlers.onFailure }  );

	}
	
  };

	/* 
	* Defines the citycircles map layer type.
	*/
	citycircles.maps.Layer = function( name ) {
	
		this.name = name;
	
	};  

	/*
	* Defined the citycircles line shape type.
	*/
	citycircles.maps.Line = function( LatLngs ) {

	};

}());
