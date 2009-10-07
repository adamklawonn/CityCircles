var ckeditorManager = new function() {

  this.instances = [];
  
  this.makeInstance = function( instance_name ) {
    
    if( this.instances[ instance_name ] == null ) {
      this.instances[ instance_name ] = CKEDITOR.replace( instance_name, { toolbar : 'Basic' } );
    } else {
      CKEDITOR.remove( this.instances[ instance_name ] );
      this.instances[ instance_name ] = CKEDITOR.replace( instance_name, { toolbar : 'Basic' } );
    }
    
  };

}();