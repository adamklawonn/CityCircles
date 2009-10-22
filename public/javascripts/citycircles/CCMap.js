(new function() {
	
	/*
	*	Defines the citycircles map type.
	*/
	citycircles.maps.Map = function( mapEl, options ) {

		this.mapEl = document.getElementById( mapEl );
		this.layers = [];
		
	};
	
	var map = citycircles.maps.Map;
		
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