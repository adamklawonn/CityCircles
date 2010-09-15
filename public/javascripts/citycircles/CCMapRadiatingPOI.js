/****************************************************************
 *
 * CCMapRadiatingPOI.js
 * This file is used to solve the problem of 
 * ovelapping icons on an OpenLayers map.
 * This feature is relying on the standards in OpenLayers
 * except for animation which is covered by  
 * Animator class from: http://berniecode.com/writing/animator.html
 * Author: Aleksnadar "Sasha" Dzeletovic, Pathfinder Development
 * for CityCircles www.citycircles.org
 *
 ****************************************************************/
var RadiatingPOI = Class.create({

    initialize: function(map) {
        // Used to store overlapping POIs (Points of Interest)
        this.matching_POIs = new Array();

        //SVG namespace
        this.svgns = "http://www.w3.org/2000/svg";

        //describes the state of the marker radiating
        this.radiating_state = "closed";//"opened"

		this.animation_layer_name = "Animation Layer";

		//limit of overlapping POIs that will be processed
		this.subset_size = 20;

		this.map = map;

        scope = this;

		//add listeners that triger radiating
		for ( var i=0; i < scope.map.layers.length; i++ )
		{
		  	if(scope.map.layers[i].name != scope.animation_layer_name)
			{
				scope.map.layers[i].events.on({'click': scope.poiMouseOverHandler} );				
			}
		}
		
		//layer that contains all the animations
		//points in scope are copied to it for animation
		//original points are invisible during animation
		this.animation_layer = new OpenLayers.Layer.Vector(this.animation_layer_name);
		this.map.addLayer(this.animation_layer);
		
		//OpenLayers.Tween class proved unfited to use for a multi-part animation,
		//using Animator class from: http://berniecode.com/writing/animator.html
		//which proved to be way easier to work with
		this.animation = new Animator({ onComplete: this.reverseDoneHandler });
		this.animation.addSubject(this.animatePOIs);
		
		//reset any radiating artifacts on map zoom or move
		scope.map.events.on({"movestart": scope.resetRadiatingPOIs});
		
		
		
	},
/*************************************************
 * Returns a random integer between "from" and "to" 
 *************************************************/
	randomFromTo : function(from, to){
		return Math.floor(Math.random() * (to - from + 1) + from);
	},
/************************************
 * Sorts coordinates (lon,lat) clockwise 
 ************************************/	
	sortClockwise: function(p1, p2)
	{
		var pp1 = scope.map.getViewPortPxFromLonLat(new OpenLayers.LonLat(p1.lon, p1.lat));
		var pp2 = scope.map.getViewPortPxFromLonLat(new OpenLayers.LonLat(p2.lon, p2.lat));
	    return (pp2.x * pp1.y) - (pp1.x * pp2.y);
	},	
/*************************************************
 * Returns a rectangle object {x,y,width,height} 
 * based on Point.Geometry
 *************************************************/
    getRect: function(poi) {
		var bounds = poi.geometry.bounds;
        return {
            x: poi.layer.getViewPortPxFromLonLat(new OpenLayers.LonLat(poi.geometry.x,poi.geometry.y)).x - poi.style.pointRadius,
            y: poi.layer.getViewPortPxFromLonLat(new OpenLayers.LonLat(poi.geometry.x,poi.geometry.y)).y - poi.style.pointRadius,
            width: poi.style.pointRadius*2,
            height: poi.style.pointRadius*2
        };
    },
/*************************************************
 * Checks if value is between min and max
 *************************************************/
    valueInRange: function(value, min, max) {
        return (value <= max) && (value >= min);
    },
/*************************************************
 * Returns a boolean if rectangles {x,y,width,height}
 * A and B are overlapping
 *************************************************/
    rectOverlap: function(A, B) {
        var xOverlap = scope.valueInRange(A.x, B.x, B.x + B.width) ||
        scope.valueInRange(B.x, A.x, A.x + A.width);

        var yOverlap = scope.valueInRange(A.y, B.y, B.y + B.height) ||
        scope.valueInRange(B.y, A.y, A.y + A.height);

        return xOverlap && yOverlap;
    },
/***************************************************
 * Iterates though all the properties of an object
 * and compares are all values the same.
 * Returns a boolean
 ***************************************************/
    objectsAreSame: function(x, y) {
        var objectsAreSame = true;
        for (var propertyName in x) {
            if (x[propertyName] !== y[propertyName]) {
                objectsAreSame = false;
                break;
            }
        }
        return objectsAreSame;
    },
/*************************************************
 * Returns an [X,Y] array of 2D center of mass
 * 
 *************************************************/
    getCenterOfMass: function(array) {
        var xSum = 0;
        var ySum = 0;
        var l = array.length;
        for (var i = 0; i < l; i++) {
            xSum += array[i].poi.layer.getViewPortPxFromLonLat(new OpenLayers.LonLat(array[i].lon,array[i].lat)).x;
            ySum += array[i].poi.layer.getViewPortPxFromLonLat(new OpenLayers.LonLat(array[i].lon,array[i].lat)).y;
        }
        return [xSum / l, ySum / l]
    },
/*************************************
 * Revert POIs to non radiating state
 *************************************/
    revertRadiatedState: function(event) {
		//animate the points back to origin and destroy animation artifacts at end
		scope.animation.toggle();

    },
/*************************************
 * Fires when animationis done
 *************************************/
	reverseDoneHandler: function(value) {
		if(scope.animation.state == 0)
		{
			scope.animation_layer.events.un({"mouseover":scope.animPOIMouseOverHandler });
			scope.animation_layer.events.un({"mouseout":scope.animPOIMouseOutHandler });
			scope.animation_layer.events.un({"click":scope.animPOIClickHandler });
			scope.resetRadiatingPOIs();
		}
		if(scope.animation.state == 1)
		{
			//reson why we are unregistering events first is to make sure
			//we never get duplicates of listeners
			scope.animation_layer.events.un({"mouseover":scope.animPOIMouseOverHandler });
			scope.animation_layer.events.un({"mouseout":scope.animPOIMouseOutHandler });
			scope.animation_layer.events.un({"click":scope.animPOIClickHandler });
			scope.animation_layer.events.on({"mouseover":scope.animPOIMouseOverHandler });
			scope.animation_layer.events.on({"mouseout":scope.animPOIMouseOutHandler });
			scope.animation_layer.events.on({"click":scope.animPOIClickHandler });
		}
	},
/****************************
 * map zoomend event handler
 ****************************/
    resetRadiatingPOIs: function(event) {
		//kill revert listener

        scope.map.events.un({"click": scope.revertRadiatedState});

        //Add listeners to radiate again
        for ( var i=0; i < scope.map.layers.length; i++ )
		{
			if(scope.map.layers[i].name != scope.animation_layer_name)
			{
				scope.map.layers[i].events.un({'click': scope.poiMouseOverHandler} );				
				scope.map.layers[i].events.on({'click': scope.poiMouseOverHandler} );				
			}
		}

		//move POIs to original state and reset style
		for ( var i=0; i < scope.matching_POIs.length; i++ )
		{
			var mPOI = scope.matching_POIs[i];
        	//"turn on" original POI
			mPOI.poi.style.display = "block";
			mPOI.poi.layer.drawFeature(mPOI.poi);
		}
		scope.animation_layer.removeFeatures(scope.animation_layer.features);

		scope.mathcing_POIs = new Array();
	
    },
/***************************************************
 * Animate POIs
 * Used by OpenLayers.Tween as an eachStep callback
 ***************************************************/
animatePOIs: function(value) {

		for (var i=0; i < scope.matching_POIs.length; i++)
		{
			var mPOI = scope.matching_POIs[i];
			var lon_delta = mPOI.new_lon - mPOI.lon;
			var lon_current = mPOI.new_lon - lon_delta*(1-value);
			
			var lat_delta = mPOI.new_lat - mPOI.lat;
			var lat_current = mPOI.new_lat - lat_delta*(1-value);
			
			var anim_lonlat_point = new OpenLayers.LonLat(lon_current,lat_current);
			var current_point = new OpenLayers.LonLat(mPOI.lon, mPOI.lat);

			if(mPOI.origin_line != null && mPOI.origin_line != undefined)
			{
				mPOI.origin_line.geometry.components[1].x = anim_lonlat_point.lon;
				mPOI.origin_line.geometry.components[1].y = anim_lonlat_point.lat;
				scope.animation_layer.drawFeature(mPOI.origin_line);
			}
			if(mPOI.anim_poi != null && mPOI.anim_poi != undefined)
			{
				mPOI.anim_poi.move(anim_lonlat_point);			
			}
		}
    },
/***************************************************
 * Animated POI mouse over event handler
 ***************************************************/
animPOIMouseOverHandler: function(event) {
	//event is valid only for objects that are not LineString like origin_line
	if(event.target._geometryClass != "OpenLayers.Geometry.LineString")
	{
		//implement anim_poi behaviour on mouse over
		event.target.style.stroke = "#FF0000";
	}
	
},
/***************************************************
 * Animated POI mouse out event handler
 ***************************************************/
animPOIMouseOutHandler: function(event) {
	//event is valid only for objects that are not LineString like origin_line
	if(event.target._geometryClass != "OpenLayers.Geometry.LineString")
	{
		//implement anim_poi behaviour on mouse over
		event.target.style.stroke = "#222222";
	}

},
/***************************************************
 * Animated POI click event handler
 ***************************************************/
animPOIClickHandler: function(event) {
	//event is valid only for objects that are not LineString like origin_line
	if(event.target._geometryClass != "OpenLayers.Geometry.LineString")
	{
		//implement anim_poi behaviour on mouse over
		alert("You have clicked me! I'm feature "+event.target._featureId);
	}

},
/***************************************************
 * Returns 
 ***************************************************/
animPOIClickHandler: function(event) {
	//event is valid only for objects that are not LineString like origin_line
	if(event.target._geometryClass != "OpenLayers.Geometry.LineString")
	{
		//implement anim_poi behaviour on mouse over
		var anim_poi_id = event.target._featureId;
		var anim_poi = scope.animation_layer.getFeatureById(anim_poi_id);
		var related_link = "posts"+/*anim_poi.data.post.post_type.shortname*/"/"+anim_poi.data.post.id;
		var full_link = location.protocol+ "//" +location.host +"/"+ related_link;
		window.open(full_link);
	}
},
/*******************************
 * POI mouseover handler
 * Radiates overlapping POIs
 *******************************/
    poiMouseOverHandler: function(event) {
        //overlapping POIs storage
        scope.matching_POIs = new Array();
		//stores biggest POI radius
        biggest_radius = 0;
		
		//rectangle of the clicked POI
        var target_poi_rect = scope.getRect(event.object.getFeatureById(event.target._featureId));

		//iterate though all POIs
        for (var i = 0; i < scope.map.layers.length; i++)
        {
	        if(scope.map.layers[i].features != undefined)
	        { 
        		for (var j = 0; j < scope.map.layers[i].features.length; j++)
	            {
		            var temp_poi = scope.map.layers[i].features[j];
					if(temp_poi.geometry.CLASS_NAME == "OpenLayers.Geometry.Point")
					{
						var temp_poi_rect = scope.getRect(temp_poi);

			            //if temp_poi overlaps targeted marker and temp_poi layer is visible
			            if (scope.rectOverlap(target_poi_rect, temp_poi_rect) && temp_poi.layer.visibility == true )
			            {
			                scope.matching_POIs.push({
			                    poi: temp_poi,
			                    lon: temp_poi.geometry.x,
			                    lat: temp_poi.geometry.y
			                });
			                if (temp_poi.style.pointRadius > biggest_radius) {
			                    biggest_radius = temp_poi.style.pointRadius;
			                }
			            }
					}
		        }
	        }
        }

        //how many pois?
        var n = scope.matching_POIs.length;

        //spred out POIs only if there is more than one
        if (n > 1)
        {
			//sort clockwise
			scope.matching_POIs.sort(scope.sortClockwise);
	
			//Remove POI radiating interaction
            for ( var i=0; i < scope.map.layers.length; i++ )
			{
			  scope.map.layers[i].events.un({'click': scope.poiMouseOverHandler} );
			}
			
			//filter down scope.mathchingPOIs down to "subset_size"
			//if its length is bigger than "subset_size"
			if(n > scope.subset_size)
			{
				//chops one random object from array
				//returns true if array length is 20
				var chopper = function(array){
					array.splice(scope.randomFromTo(0,array.length),1)
					return (array.length <= scope.subset_size)? true : false;
				}
				for ( var i=0; i < n; i++ )
				{
					if(chopper(scope.matching_POIs))
					{
						break;
					}
				}
				
				//set number of POIs to new value ( should always be 20 )
				//based on "chopper"
				n = scope.matching_POIs.length;
			}	
			
			//radius of (biggest_radius*4) is assumed for spacing POIs
            radius = (n * (biggest_radius * 4)) / (2 * Math.PI);
            var rad = Math.PI / 180;
            var angle = 360 / n;

            //find the center of mass for all the POIs that are overlapping
			var center = scope.getCenterOfMass(scope.matching_POIs);

            //calculate new position and create elements of animation
            for (var i = 0; i < n; ++i)
            {
				var mPOI = scope.matching_POIs[i];
				//calculate new position
                var radians = (rad * (angle * i));
                var new_x = center[0] + Math.cos(radians) * radius;
                var new_y = center[1] + Math.sin(radians) * radius;

				//add the [LonLat] new position to matching_POIs 
				var temp_new_poi_lonlat_point = scope.animation_layer.getLonLatFromViewPortPx(new OpenLayers.Pixel(new_x, new_y));
                mPOI['new_lon'] = temp_new_poi_lonlat_point['lon'];
                mPOI['new_lat'] = temp_new_poi_lonlat_point['lat'];
				var new_poi_lonlat_point = {"lon":temp_new_poi_lonlat_point.lon,
									        "lat":temp_new_poi_lonlat_point.lat};

            	//make current [LonLat] POI point for tween
				var temp_current_poi_lonlat_point = new OpenLayers.LonLat(mPOI.lon, mPOI.lat);
				var current_poi_lonlat_point = {"lon":temp_current_poi_lonlat_point.lon,
												"lat":temp_current_poi_lonlat_point.lat};

				//----------------------------
				//setup animating origin line
				//----------------------------				
				var origin_line = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(
								[new OpenLayers.Geometry.Point(current_poi_lonlat_point.lon, current_poi_lonlat_point.lat),
								new OpenLayers.Geometry.Point(current_poi_lonlat_point.lon, current_poi_lonlat_point.lat)]	
						)
					);
				var origin_line_style = new Object();
				origin_line_style.graphicZIndex = 0;
				origin_line_style.strokeOpacity = 1;
				origin_line_style.strokeWidth = 1;
				origin_line_style.strokeLinecap = "round";
				origin_line_style.strokeColor = "#222222";
				origin_line.style = origin_line_style;
				
				//add to animation_layer
				scope.animation_layer.addFeatures([origin_line]);

				//add to matching_POIs
				mPOI.origin_line = origin_line;

				//--------------------
				//setup animating POI
				//--------------------
                mPOI['anim_poi'] = mPOI.poi.clone();
				mPOI.anim_poi.data = mPOI.poi.data;
				scope.animation_layer.addFeatures([mPOI.anim_poi]);
				
				//create a new style object based on current one
				var style_clone = Object.toJSON(mPOI.poi.layer.getFeatureById(mPOI.poi.id).style).evalJSON();
				style_clone.strokeColor = "#222222";
				scope.animation_layer.getFeatureById(mPOI.anim_poi.id).style = style_clone;
				mPOI.poi.layer.getFeatureById(mPOI.poi.id).style.display = "none";
				
				//refresh original to force invisibility
				mPOI.poi.layer.drawFeature(mPOI.poi);				
			}
			
			//start animation
			scope.animation.play();
			
			//add click listener that reverts state to not radiating
            //once opening animation is complete
            scope.map.events.un({"click": scope.revertRadiatedState});
            scope.map.events.on({"click": scope.revertRadiatedState});
      }
    }

});





