(new function() {
	
	/*
	*	Defines the citycircles map type.
	*/
	citycircles.maps.Map = function( mapEl, options ) {

		this.mapEl = document.getElementById( mapEl );
		this.map = null;
		this.options = options;
		this.layers = [];
		this.layersURL = "/maps/" + options.map_id + "/map_layers.json";
    this.markerGroups = [];
    
			
	};
	
	var map = citycircles.maps.Map;
	
	map.prototype.render = function() {
		// Pre-render checks.
    // Need to ensure everything is loaded.
    this.renderMap();
		this.getLayers();
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
		  var mapLayerHTML = "";
		  var layers = this.layers; 
					
		  for( var i = 0; i < layers.length; i++ ) {
         
        mapLayerHTML += '<input id="cc-map-layer-id-' + layers[ i ].map_layer.id + '" type="checkbox" checked />' + layers[ i ].map_layer.title + '<br />';
		  }
					
		  $( "map-control" ).update( mapLayerHTML );
		}
  }

	
	map.prototype.getLayers = function() {
	  
    var scope = this;
		var url = this.layersURL;
		
		var handlers = {
			
			onSuccess : function( response ) {
			  scope.layers = response.responseJSON;
        scope.renderLayers();
			},
			
			onFailure : function( response ) {
				console.log( "Request failed: citycircles.maps.Map.getLayers() -> " + response.responseText );
			}
			
		};
		
		var request = new Ajax.Request(  url, { method : "get", onSuccess : handlers.onSuccess, onFailure : handlers.onFailure }  );
		
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
