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
    this.postsURL = "/posts.json";
  	this.markerGroups = [];
  	this.transformProjection = "EPSG:4326";
  	this.googleProjection = "EPSG:900913";

	};

	var map = citycircles.maps.Map;

	map.prototype.render = function() {
		// Pre-render checks.
		this.renderMap();
		this.renderLayers();
		//this.renderInterestLines();
		//this.renderInterestPoints();
	};
	
	map.prototype.renderMap = function() {

		// increase reload attempts 
    OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
    
    // set map options
		var mapOptions = {
                    projection: new OpenLayers.Projection( this.googleProjection ),
                    displayProjection : new OpenLayers.Projection( this.transformProjection ),
                    units : "m",
                    numZoomLevels : 18,
                    maxResolution : 156543.0339,
                    maxExtent : new OpenLayers.Bounds( -20037508, -20037508, 20037508, 20037508.34 )
                    };

    this.map = new OpenLayers.Map( 'map', mapOptions );

    // create Google Mercator layers
    var gmap = new OpenLayers.Layer.Google( "Google", { 'sphericalMercator' : true } );

    this.map.addLayer( gmap );
    this.map.addControl( new OpenLayers.Control.LayerSwitcher() );
    this.map.addControl( new OpenLayers.Control.PanZoom( { zoomWorldIcon : false } ) );
    this.map.setCenter( new OpenLayers.LonLat( this.options.center[1], this.options.center[0] ).transform( new OpenLayers.Projection( this.transformProjection ), new OpenLayers.Projection( this.googleProjection ) ), this.options.zoom );

	};
	
  map.prototype.renderLayers = function() {

	// Only update the map control if map-control element is present.
	if( $( "map-control" ) ) {

		var scope = this;
		var url = this.layersURL;
		
		var handlers = {
			
			onSuccess : function( response ) {
				var layers = response.responseJSON;

				for( var i = 0; i < layers.length; i++ ) {
				  //if( layers[i].map_layer.shortname != "lightrailline" ) {
				  //  var strategy = new OpenLayers.Strategy.Cluster( { distance : 2, threshold : 3 } );
  				//  var layer = new OpenLayers.Layer.Vector( layers[i].map_layer.title, { strategies : [ strategy ] } );
				  //} else {
				    var layer = new OpenLayers.Layer.Vector( layers[i].map_layer.title );
				  //}
				  scope.layers[ layer.name ] = [];
				  scope.map.addLayer( layer );
				}
				
				// trigger other events that depend on layers
				scope.renderInterestLines();
			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.renderLayers() -> " + response.responseText );
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
			    if( typeof latlngsGroups[ interestLines[i].interest_line.shortname ] == "undefined" ) {
					  latlngsGroups[ interestLines[i].interest_line.shortname ] = [];
					}
					var marker = new OpenLayers.Geometry.Point( interestLines[i].interest_line.lng, interestLines[i].interest_line.lat ).transform( new OpenLayers.Projection( scope.transformProjection ), new OpenLayers.Projection( scope.googleProjection ) );
					latlngsGroups[ String( interestLines[i].interest_line.shortname ) ].push( marker );
				}

				// set the layer to the primary layer
				// this needs to be flagged in the db
				// interate through the separate lines and draw them
				var mapLayer = scope.map.getLayersByName( interestLines[0].interest_line.map_layer.title )[0];
				var style = {
                        strokeColor: "#8F2323",
                        strokeWidth: 4,
                        strokeDashstyle: "solid",
                        pointRadius: 6,
                        pointerEvents: "visiblePainted"
                    };
				for(group in latlngsGroups) {
				  var lineString = new OpenLayers.Geometry.LineString( latlngsGroups[ group ] );
				  var vectorFeature = new OpenLayers.Feature.Vector( lineString, null, style );
				  mapLayer.addFeatures( vectorFeature );
				}
        // render interest points
        scope.renderInterestPoints();
			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.renderInterestPoints() -> " + response.responseText );
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
          var marker = new OpenLayers.Feature.Vector( new OpenLayers.Geometry.Point( interestPoints[i].interest_point.lng, interestPoints[i].interest_point.lat ).transform( new OpenLayers.Projection( scope.transformProjection ), new OpenLayers.Projection( scope.googleProjection ) ), {}, { fill : true, fillColor : "#333333", fillOpacity : 1, pointRadius : 8, label : "S", fontSize: "0.7em", fontColor: "#fff" } );
          // { externalGraphic : "/images/map_icons/stopcon.png", graphicWidth : 20, graphicHeight : 20 }
				  // add marker to layers array
				  scope.layers[ interestPoints[i].interest_point.map_layer.title ].push( marker );
				  scope.map.getLayersByName( interestPoints[i].interest_point.map_layer.title )[0].addFeatures( marker );
				}
				// render posts
        scope.renderPosts();
			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.renderInterestPoints() -> " + response.responseText );
			}
			
		};
		
		var request = new Ajax.Request(  url, { method : "get", onSuccess : handlers.onSuccess, onFailure : handlers.onFailure }  );

	}
	
  };

  map.prototype.renderPosts = function() {

	// Only update the map control if map-control element is present.
	if( $( "map-control" ) ) {

		var scope = this;
		var url = this.postsURL;
		
		var handlers = {
			
			onSuccess : function( response ) {
				scope.posts = response.responseJSON;
				var mapLayerHTML = "";
				var posts = scope.posts;
				for( var i = 0; i < posts.length; i++ ) {
          // create marker
          var marker = new OpenLayers.Feature.Vector( new OpenLayers.Geometry.Point( posts[i].post.lng, posts[i].post.lat ).transform( new OpenLayers.Projection( scope.transformProjection ), new OpenLayers.Projection( scope.googleProjection ) ), {}, { fill : true, fillColor : posts[i].post.post_type.map_fill_color, fillOpacity : 1, pointRadius : 4, strokeColor : posts[i].post.post_type.map_stroke_color, strokeWidth : posts[i].post.post_type.map_stroke_width } );
					
				  //add data to marker
				  marker.data = posts[i];
					
				  // add marker to layers array
				  scope.layers[ posts[i].post.map_layer.title ].push( marker );
				  scope.map.getLayersByName( posts[i].post.map_layer.title )[0].addFeatures( marker );
				}
              
              //Pathfinder edit
			  // Declaring an instance of the class that handles the problem of overlapping markers
			  var radiating_points = new RadiatingPOI(scope.map);
              
 
			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.renderPosts() -> " + response.responseText );
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
