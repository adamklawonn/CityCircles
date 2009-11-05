(new function() {
	
	/*
	*	Defines the citycircles map type.
	*/
	citycircles.maps.Map = function( mapEl, options ) {

		this.mapEl = document.getElementById( mapEl );
		this.map = null;
		this.options = options;
		this.layers = [];
		this.render();
		
	};
	
	var map = citycircles.maps.Map;
	
	map.prototype.render = function() {
		
		this.renderMap();
		
	};
	
	map.prototype.renderMap = function() {

		this.map = new google.maps.Map2( this.mapEl );
		this.map.setCenter( new google.maps.LatLng( this.options.center[ 0 ], this.options.center[ 1 ] ), this.options.zoom );
		
	};
		
	map.prototype.getLayers = function() {
		return this.layers;
	};

	/* 
	* Defines the citycircles map layer type.
	*/
	citycircles.maps.Layer = function( name ) {
		
		this.name = name;
		
	};

}());