// Builds a new GPolygon object based on a center point and radius point. 
function GCircle( map, centerMarker, radiusMarker, borderColor, fillColor ) {

    var normalProj = map.getCurrentMapType().getProjection();
    var zoom = map.getZoom();

    var centerPt = normalProj.fromLatLngToPixel(centerMarker, zoom);
    var radiusPt = normalProj.fromLatLngToPixel(radiusMarker, zoom);

    var circlePoints = Array();

    with ( Math ) {
    	var radius = floor ( sqrt( pow( ( centerPt.x - radiusPt.x ), 2 ) + pow( ( centerPt.y - radiusPt.y ), 2 ) ) );

      for ( var a = 0 ; a < 361 ; a += 5 ) {
	      var aRad = a * ( PI / 180 );
	      y = centerPt.y + radius * sin( aRad );
	      x = centerPt.x + radius * cos( aRad );
	      var p = new GPoint( x, y );
	      circlePoints.push( normalProj.fromPixelToLatLng( p, zoom ) );
      }

      circleLine2 = new GPolygon( circlePoints, borderColor, 2, 1, fillColor, 0.5 );
			return circleLine2;
    }

};