var CCTinyMCEManager = new function() {

	this.makeInstance = function( instance_name, options ) {
		tinyMCE.execCommand( "mceAddControl", false, instance_name );
	};

	this.destroyInstance = function( instance_name ) {
		tinyMCE.execCommand( "mceRemoveControl", false, instance_name );
	};

}();