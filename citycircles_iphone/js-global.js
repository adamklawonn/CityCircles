/*
 * dependencies
 *  dataStations = []
 *  dataBusinesses = []
 *  dataSchedule = []
 *  
 * options:
 *  override current time:
 * 		customTime = "07:15 AM";
 */

$(document).ready(function(){
				  //alert("hello");

/*
 *  event callback functions *********************************************
 */

		
		// map click
		function clickMap(x,y){
			debug("zoom: "+x+","+y);
			alert("You clicked zoom at " + x + ","+y);
		}
		
		// station click
		function clickStation(id){
			debug("station: " + id);
			alert("You clicked station " + id);
		}
		
		// business click
		function clickBusiness(id){
			debug("business: " + id);
			alert("You clicked business " + id);
		}

		// train click
		function clickTrain(id){
			debug("train: " + id);
				  alert("map click");
		}

/*
 *  map setup and animation *********************************************
 */

	// get container
		mapContainer = $("#container");

	// debug handler	
		function debug(v){
			// log to console
			$.log(v);	

		}

	// bind map click event
		mapContainer.click(function(e){
			// get container offset
			var t = $(this).offset().top;
			var l = $(this).offset().left;
			// calculate coordinates within container
			var x = e.clientX - l;
			var y = e.clientY - t;  
			// debug
			clickMap(x,y);
		});
		
	// add train route
	/* http://raphaeljs.com/reference.html#path
	 * http://raphaeljs.com/reference.html#attr 
	 */ 
	// add route segments
		// create canvas
		mapContainer.append('<div id="raphael"></div>');
			var raphaelCanvas = Raphael("raphael",320, 250);
		// add to map
			if(typeof dataStations != "undefined"){
				  debug("ok");
				$(dataStations).each(function(i,current){
					// get next station
					if (typeof dataStations[i + 1] != "undefined") {
						var next = dataStations[i+1];
						// set coordinates
						sx = current.x;
						sy = current.y;
						ex = next.x;
						ey = next.y;
						//debug("M"+sx+" "+sy+"L"+ex+" "+ey);
						// draw path using Raphael
						var c = raphaelCanvas.path("M"+sx+" "+sy+"L"+ex+" "+ey);
						c.attr({
							"stroke":			"#fff",
							"stroke-width": 	6	
						});
						var c = raphaelCanvas.path("M"+sx+" "+sy+"L"+ex+" "+ey);
						c.attr({
							"stroke":			"#999",
							"stroke-width": 	4	
						});
					}
				});
			}
		
	// add map tiles
		mapContainer.prepend('<img src="1.png" alt="" id="tiles" />');
		
	// add stations
		// add to map
			if(typeof dataStations != "undefined"){
				$(dataStations).each(function(i,data){
					// set coordinates
					var x = data.x - 13;
					var y = data.y - 27;
					// add marker to map
					mapContainer.append('<img class="station" src="station.png" id="station-' + data.id + '" style="left:' + x + 'px; top:' + y + 'px;">');
				});
			}
		// bind click events
			mapContainer.find(".station")
				.click(function(){
					var id = $(this).attr("id");
					id = id.replace("station-","");
					clickStation(id);
					return false; // prevent trigger of map container click
				});

	// add businesses
		// add to map
			if(typeof dataBusinesses != "undefined"){
				$(dataBusinesses).each(function(i,data){
					// set coordinates
					var x = data.x - 13;
					var y = data.y - 27;
					// add marker to map
					mapContainer.append('<img class="business" src="business.png" id="business-' + data.id + '" style="left:' + x + 'px; top:' + y + 'px;">');
				});
			}
		// bind click events
			mapContainer.find(".business")
				.click(function(){
					var id = $(this).attr("id");
					id = id.replace("business-","");
					clickBusiness(id);
					return false; // prevent trigger of map container click
				});
				
	// plot trains
		
		// get current time or custom time
			if (typeof customTime == "undefined") {
				var n = new Date();
				var currentTime = n.getMinutes() + n.getHours() * 60;
			} else {
				var currentTime = convertTimeInteger(customTime);
			}
			debug("currentTime = "+currentTime);
		
		// convert short time string to integer
			function convertTimeInteger(t){
				// get hours
				var x = t.split(":");
				var h = parseInt(x[0]);
				// get minutes
				var y = x[1].split(" ");
				var m = parseInt(y[0]);
				var p = y[1];
				debug(h+","+m+","+p);
				if(p == "P" || p == "p"){
					h = parseInt(h) + 12;
				}
				var i = parseInt(m + h * 60);
				return i;
			}
		
		// convert integer time to short time
			function convertTimeShort(t){
				var h = parseInt(t/60);
				var m = parseInt(t-(h*60));
				if(m<10){
					m = "0" + m;
				}
				var p = "AM";
				if(h > 12){
					h -= 12;
					var p = "PM";
				}
				return h+":"+m+" "+p;
			}
		// function to get station by id
			function getStation(id){
				if(typeof dataStations != "undefined"){
					var ret = false;
					$(dataStations).each(function(i,data){
						if(data.id == id){
							ret = data;
							return;
						}
					});
					return ret;
				}
			}
		// convert schedule to list of animations
			var segments = [];
			// step through each line of the schedule
			if(typeof dataSchedule != "undefined"){
				$(dataSchedule).each(function(i,t){
					// step through each column on schedule
					$(t).each(function(i,c){
						// check if has next station
						if(typeof t[i+1] != "undefined"){
							// new segment
							var segment = {};
							// set start time
							segment.time_start = convertTimeInteger(c.time);
							// set start station
							segment.station_start = getStation(c.station_id);
							// set stop time
							segment.time_stop = convertTimeInteger(t[i+1].time);
							// set stop station
							segment.station_stop = getStation(t[i+1].station_id);
							// set direction
							segment.direction = c.direction.toLowerCase();
							// add segment to list
							segments.push(segment);
						}
					});
				});
			}
			
		// plot trains on map
			function plotTrains(currentTime){
				//debug(currentTime);
				// find all segments surrounding current time
				if(typeof segments != "undefined"){
					// remove old trains
					mapContainer.find(".train").remove();
					$(segments).each(function(i,s){
						if(s.time_start <= currentTime && s.time_stop >= currentTime){
							/*
							debug(s);
							debug("current time "+currentTime);
							debug("start " + s.time_start);
							debug("stop " + s.time_stop);
							*/
							// set percent of segment to stop at station
							stationWait = .2;
							// calculate progress from start to stop point
							var p = parseFloat((currentTime - s.time_start) / (s.time_stop - s.time_start)) * (1 + stationWait);
							if(p > 1){ p = 1;}
							// calculate position of marker							
							var x = parseInt((s.station_stop.x - s.station_start.x) * p) + s.station_start.x - 13;
							var y = parseInt((s.station_stop.y - s.station_start.y) * p) + s.station_start.y;
							// set direction of marker
							if(s.direction == "eastbound"){
								var dir = "east";
								y -= 27;
							} else {
								var dir = "west";
							}
							//debug("train "+i+" "+x+","+y+" "+p);
							mapContainer.append('<img id="train-'+i+'" class="train" src="train-'+dir+'.png" style="left:'+x+'px;top:'+y+'px;">');
						}
					});
				}
				// bind click events
					mapContainer.find(".train")
						.click(function(){
							var id = $(this).attr("id");
							id = id.replace("train-","");
							clickTrain(id);
							return false; // prevent trigger of map container click
						});
				
			}
			plotTrains(currentTime);

/*
 *  demo features *********************************************
 */

		
	// manual trigger of train plotting
		$("#setTime").click(function(){
			setTime();
		});
		
		function setTime(){
			var h = $("#time-h").val();
			var m = $("#time-m").val();
			var p = $("#time-p").val();
			var t = convertTimeInteger(h+":"+m+" "+p);
			debug(t);
			plotTrains(t);
			return t;			
		}
		
	// animate trains from starting time
		$("#startAnimation").toggle(
			function(){
				$(this).attr("value","Stop");
				// display a minute of time over this many seconds
				animateInterval = 100;
				animateIncrement = .1;
				currentTime = setTime();
				// start now
				plotTrains(currentTime);
				//debug(animateInterval);
				// animate every second
				animateTrainTimer = setInterval(function(){
					// increase current time
					currentTime += animateIncrement;
					// update time on screen
					$("#timeDisplay").text(convertTimeShort(currentTime));
					//debug(currentTime);
					// replot trains
					plotTrains(currentTime);
				},animateInterval)
			},
			function(){
				$(this).attr("value","Start");
				clearInterval(animateTrainTimer);
			}
		);
		

});



/*
 * Console logger plugin
 * @version 1.2
 * @author Simplimation
 * 
 * Usage: $.log("message goes here %s", value);
 *  %s	String
 *  %d, %i	Integer (numeric formatting is not yet supported)
 *  %f	Floating point number (numeric formatting is not yet supported)
 *  %o	Object hyperlink
 * 
 *  only logs if globalVars.log = true
 */

	$.log = function() {
	  	if(window.console) {
			if($.browser.safari){
				// Safari console
				var args = "";
				$.each(arguments,function(i,val){
					args += " " + val;
				});
				window.console.log(args); // fix to show args, Safari doesn't like .apply
			}
			if ($.browser.mozilla) {
				// Firefox with firebug
				window.console.log.apply(this, arguments);
			}
			// append to debug container
			var args = "";
			$.each(arguments,function(i,val){
				args += " " + val;
			});
			$("#debug").append("<div>" + args + "</div>");
	  	} else {
	  		// no Firebug
	    	//alert(message);
		}
	};

