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
    	// Need to ensure everything is loaded.
		this.renderMap();
		this.renderLayers();
		this.renderInterestLines();
		this.renderInterestPoints();
	};
	
	map.prototype.renderMap = function() {

		this.map = new google.maps.Map2( this.mapEl );
		this.map.setCenter( new google.maps.LatLng( this.options.center[ 0 ], this.options.center[ 1 ] ), this.options.zoom );
		// If options.mouseZoom is present and true, enable zooming in/out via mouse scroll.
		if( options.mouseZoom ) {
			this.map.enableScrollWheelZoom();
		}

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
					scope.layers[String(layers[i].map_layer.id)] = [];
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
					var marker = new google.maps.Marker(new google.maps.LatLng(interestPoints[i].interest_point.lat, interestPoints[i].interest_point.lng));
			    	scope.map.addOverlay(marker);
					scope.layers[interestPoints[i].interest_point.map_layer_id].push(marker);
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
