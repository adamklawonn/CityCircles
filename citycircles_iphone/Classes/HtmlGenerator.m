//
//  HtmlGenerator.m
//  citycircles
//
//  Created by mjamison on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HtmlGenerator.h"
#import "GlobalMercator.h"
#import "Models.h"
#import "JSON.h"
#import "citycirclesAppDelegate.h"
#import "citycirclesViewController.h"



@implementation HtmlGenerator

-(id) init{
	if (self = [super init])
    {
		mercator = [[GlobalMercator alloc] initWithTileSize: 256];
		WIDTH = 320;
		HEIGHT = 250;
		MAP_LL_LONG = -112.217;
		MAP_LL_LAT = 33.339;
		
		//FIRST FILL IN THE LIST OF STATIONS
		int station_number;
		NSMutableArray *currentRow;
		NSMutableArray *tmp_segs;
		LI_SOUTH_SEGMENTS = [[NSMutableArray alloc] init];
		LI_NORTH_SEGMENTS = [[NSMutableArray alloc] init];
		
		DCT_SOUTH_SEGMENTS = [[NSMutableDictionary alloc] init];
		DCT_NORTH_SEGMENTS = [[NSMutableDictionary alloc] init];
		
		LI_ALL_EVENTS = [[NSMutableArray alloc] init];
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		dbModels = delegate.dbModels;
		[dbModels retain];
		
		//GET ALL THE EVENTS
		LI_ALL_EVENTS = [dbModels getAllEvents];
		
		//GET ALL THE NORTH STATIONS
		LI_SOUTH_STATIONS = [dbModels GetStationsWithinBounds: @"S" ll_lat: MAP_LL_LAT ll_long: MAP_LL_LONG ur_lat: 33.61690 ur_long: -111.77627 ];
		
		//GET ALL TRACKS
		for (int row = 0; row < [LI_SOUTH_STATIONS count]; row++){
			currentRow = (NSMutableArray *)[LI_SOUTH_STATIONS objectAtIndex: row];
			station_number = [(NSNumber *) [currentRow objectAtIndex: 4] intValue];
			tmp_segs = [dbModels GetStationSegments: station_number];
			[LI_SOUTH_SEGMENTS addObjectsFromArray: tmp_segs];
			
			[DCT_SOUTH_SEGMENTS setObject:tmp_segs forKey:(NSNumber *) [currentRow objectAtIndex: 1]];
			[tmp_segs release];
		}
		
		//GET ALL THE STATIONS
		LI_NORTH_STATIONS = [dbModels GetStationsWithinBounds: @"N" ll_lat: MAP_LL_LAT ll_long: MAP_LL_LONG ur_lat: 33.61690 ur_long: -111.77627 ];
		
		//GET ALL TRACKS
		for (int row = 0; row < [LI_NORTH_STATIONS count]; row++){
			currentRow = (NSMutableArray *)[LI_NORTH_STATIONS objectAtIndex: row];
			station_number = [(NSNumber *) [currentRow objectAtIndex: 4] intValue];
			tmp_segs = [dbModels GetStationSegments: station_number];
			[LI_NORTH_SEGMENTS addObjectsFromArray: tmp_segs];
			
			[DCT_NORTH_SEGMENTS setObject:tmp_segs forKey:(NSNumber *) [currentRow objectAtIndex: 1]];
			[tmp_segs release];
		}
		
		//GET THE SCHEDULES WITH DAY OF WEEK
		LI_TRAINS_SCHEDULE = [dbModels getTrainSchedules: 4];
		
		NSMutableArray *tmp_array;
		southTrainSchedule = [[NSMutableDictionary alloc] init];
		northTrainSchedule = [[NSMutableDictionary alloc] init];
		int this_index;
		NSString *s_this_idex;
		
		for (int row=0; row < [LI_TRAINS_SCHEDULE count]; row++) {
			currentRow = [LI_TRAINS_SCHEDULE objectAtIndex: row];
			
			this_index = [(NSString *)[currentRow objectAtIndex: 1] intValue];
			s_this_idex = [NSString stringWithFormat: @"%d", this_index];
				
			//NSLog((NSString *)[currentRow objectAtIndex: 0]);
			
			if ([(NSString *)[currentRow objectAtIndex: 0] isEqualToString: @"S"]) {
				if ([southTrainSchedule objectForKey: s_this_idex] == nil) {
					tmp_array = [[NSMutableArray alloc] init];
					[southTrainSchedule setObject: tmp_array forKey: s_this_idex];
					[tmp_array release];
				} else {
					tmp_array = (NSMutableArray *) [southTrainSchedule objectForKey: s_this_idex];
				}
			} else {
				if ([northTrainSchedule objectForKey: s_this_idex] == nil) {
					tmp_array = [[NSMutableArray alloc] init];
					[northTrainSchedule setObject: tmp_array forKey: s_this_idex];
					[tmp_array release];
				} else {
					tmp_array = (NSMutableArray *) [northTrainSchedule objectForKey: s_this_idex];
				}
			}
			[tmp_array addObject: currentRow];
		}
		
    }
    return self;
}


-(NSString *) getEventHTML: (int) evtID{
	NSMutableArray *evtDetails = [dbModels getEventDetails: evtID];
	//id, name, lat, lon, address_street, address_apt, city, state, zip, phone, url, info
	
	double lat = [(NSString *)[[evtDetails objectAtIndex: 0] objectAtIndex:2] doubleValue];
	double lon = [(NSString *)[[evtDetails objectAtIndex: 0] objectAtIndex:3] doubleValue];
	
	NSMutableArray * cw_m_x_y = (NSMutableArray *) [mercator LatLonToMeters:lat lon:lon];
	double cw_m_x = [(NSNumber *)[cw_m_x_y objectAtIndex:0] doubleValue];
	double cw_m_y = [(NSNumber *)[cw_m_x_y objectAtIndex:1] doubleValue];
	[cw_m_x_y release];
	
	NSMutableArray * cw_x_y = (NSMutableArray *) [mercator MetersToPixels:cw_m_x my:cw_m_y zoom:10];
	int cw_x = [(NSNumber *)[cw_x_y objectAtIndex:0] intValue];
	int cw_y = [(NSNumber *)[cw_x_y objectAtIndex:1] intValue];
	[cw_x_y	release];
	
	
	NSMutableArray * ll_m_x_y = (NSMutableArray *)[mercator LatLonToMeters: MAP_LL_LAT lon: MAP_LL_LONG];
	double ll_m_x = [(NSNumber *)[ll_m_x_y objectAtIndex: 0] doubleValue];
	double ll_m_y = [(NSNumber *)[ll_m_x_y objectAtIndex: 1] doubleValue];
	[ll_m_x_y release];
	
	//this is the x,y values for the world map origin at the from zoom level
	NSMutableArray * ll_x_y = (NSMutableArray *)[mercator MetersToPixels:ll_m_x my:ll_m_y zoom:10];
	int ll_x = [(NSNumber *)[ll_x_y objectAtIndex: 0] intValue];
	int ll_y = [(NSNumber *)[ll_x_y objectAtIndex: 1] intValue];
	[ll_x_y release];
	
	int center_x = cw_x - ll_x;
	//int center_y = cw_y - ll_y;
	int center_y = (HEIGHT - (cw_y - ll_y));
	
	NSMutableString *htmlData = [self getHTML:10 to_zl:15 center_x:center_x center_y:center_y from_origin_x:-1 from_origin_y:-1];
	
	
	NSMutableArray *tmparray = [[NSMutableArray alloc] initWithObjects: (NSString *)[[evtDetails objectAtIndex: 0] objectAtIndex:1], [NSNumber numberWithInt: round(WIDTH / 2.0)], [NSNumber numberWithInt: round(HEIGHT / 2.0)], nil];
	NSMutableArray *newBizList = [[NSMutableArray alloc] initWithObjects: tmparray, nil];
	[tmparray release];
	
	//NOW POPULATE THE BUSINESSES
	SBJsonWriter * writer = [[SBJsonWriter alloc] init];
	NSString * li_biz_json = (NSString *)[writer stringWithObject: newBizList];
	[newBizList release];
	
	
	htmlData = [htmlData stringByReplacingOccurrencesOfString: @"[\"{{businesses}}\"]" withString: li_biz_json];
	[evtDetails release];
	[writer release];
	NSLog(htmlData);
	return htmlData;
}


-(NSString *) getBizHTML: (int) bizID{
	NSMutableArray *bizDetails = [dbModels getBizDetails: bizID];
	//id, name, lat, lon, address_street, address_apt, city, state, zip, phone, url, info
	
	double lat = [(NSString *)[[bizDetails objectAtIndex: 0] objectAtIndex:2] doubleValue];
	double lon = [(NSString *)[[bizDetails objectAtIndex: 0] objectAtIndex:3] doubleValue];
	
	NSMutableArray * cw_m_x_y = (NSMutableArray *) [mercator LatLonToMeters:lat lon:lon];
	double cw_m_x = [(NSNumber *)[cw_m_x_y objectAtIndex:0] doubleValue];
	double cw_m_y = [(NSNumber *)[cw_m_x_y objectAtIndex:1] doubleValue];
	[cw_m_x_y release];
	
	NSMutableArray * cw_x_y = (NSMutableArray *) [mercator MetersToPixels:cw_m_x my:cw_m_y zoom:10];
	int cw_x = [(NSNumber *)[cw_x_y objectAtIndex:0] intValue];
	int cw_y = [(NSNumber *)[cw_x_y objectAtIndex:1] intValue];
	[cw_x_y	release];
	
	
	NSMutableArray * ll_m_x_y = (NSMutableArray *)[mercator LatLonToMeters: MAP_LL_LAT lon: MAP_LL_LONG];
	double ll_m_x = [(NSNumber *)[ll_m_x_y objectAtIndex: 0] doubleValue];
	double ll_m_y = [(NSNumber *)[ll_m_x_y objectAtIndex: 1] doubleValue];
	[ll_m_x_y release];
	
	//this is the x,y values for the world map origin at the from zoom level
	NSMutableArray * ll_x_y = (NSMutableArray *)[mercator MetersToPixels:ll_m_x my:ll_m_y zoom:10];
	int ll_x = [(NSNumber *)[ll_x_y objectAtIndex: 0] intValue];
	int ll_y = [(NSNumber *)[ll_x_y objectAtIndex: 1] intValue];
	[ll_x_y release];

	int center_x = cw_x - ll_x;
	//int center_y = cw_y - ll_y;
	int center_y = (HEIGHT - (cw_y - ll_y));
	
	NSMutableString *htmlData = [self getHTML:10 to_zl:15 center_x:center_x center_y:center_y from_origin_x:-1 from_origin_y:-1];
	/*
	NSMutableArray *newBizList = [[NSMutableArray alloc] init];
	NSMutableArray *tmpRow;
	NSMutableArray *currRow;
	
	for (int row=0; row < [bizDetails count]; row++) {
		currRow = [bizDetails objectAtIndex:row];
		
		tmpRow = [[NSMutableArray alloc] init];
		[tmpRow addObject: [currRow objectAtIndex: 9]];
		[tmpRow addObject: [currRow objectAtIndex: 1]];
		[tmpRow addObject: [currRow objectAtIndex: 2]];
		[tmpRow addObject: [currRow objectAtIndex: 3]];
		[tmpRow addObject: [currRow objectAtIndex: 0]];
		
		[newBizList addObject: tmpRow];
		[tmpRow release];
	}
	
	
	NSMutableArray * origin_x_y = [self getOriginFromLatLonCenter:lat lon:lon zl:15];
	int origin_x = [(NSNumber *) [origin_x_y objectAtIndex:0] intValue];
	int origin_y = [(NSNumber *) [origin_x_y objectAtIndex:1] intValue];
	[origin_x_y release];
	
	[self processStationList:newBizList zl:15 origin_x:origin_x origin_y:origin_y];
	*/
	
	
	NSMutableArray *tmparray = [[NSMutableArray alloc] initWithObjects: (NSString *)[[bizDetails objectAtIndex: 0] objectAtIndex:1], [NSNumber numberWithInt: round(WIDTH / 2.0)], [NSNumber numberWithInt: round(HEIGHT / 2.0)], nil];
	NSMutableArray *newBizList = [[NSMutableArray alloc] initWithObjects: tmparray, nil];
	[tmparray release];
	
	//NOW POPULATE THE BUSINESSES
	SBJsonWriter * writer = [[SBJsonWriter alloc] init];
	NSString * li_biz_json = (NSString *)[writer stringWithObject: newBizList];
	[newBizList release];

	
	htmlData = [htmlData stringByReplacingOccurrencesOfString: @"[\"{{businesses}}\"]" withString: li_biz_json];
	[bizDetails release];
	[writer release];
	NSLog(htmlData);
	return htmlData;
}

-(NSMutableArray *) getOriginFromLatLonCenter: (double) lat lon: (double) lon zl: (int) zl{
	NSMutableArray * c_m_x_y = (NSMutableArray *)[mercator LatLonToMeters: lat lon: lon];
	double c_m_x = [(NSNumber *)[c_m_x_y objectAtIndex: 0] doubleValue];
	double c_m_y = [(NSNumber *)[c_m_x_y objectAtIndex: 1] doubleValue];
	[c_m_x_y release];
	
	//this is the x,y values for the world map origin at the from zoom level
	NSMutableArray * c_x_y = (NSMutableArray *)[mercator MetersToPixels:c_m_x my:c_m_y zoom:zl];
	int c_x = [(NSNumber *)[c_x_y objectAtIndex: 0] intValue];
	int c_y = [(NSNumber *)[c_x_y objectAtIndex: 1] intValue];
	[c_x_y release];
	
	int ll_x = round(c_x - (WIDTH / 2.0));
	int ll_y = round(c_y - (HEIGHT / 2.0));
	
	return [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt: ll_x], [NSNumber numberWithInt: ll_y], nil];
}

-(void) logTime{
	
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	
	[formatter release];
	
	NSLog(dateString);
}


-(NSString *) getHTML: (int) from_zl to_zl: (int) to_zl center_x: (int) center_x center_y: (int) center_y from_origin_x: (int) from_origin_x from_origin_y: (int) from_origin_y{
	[self logTime];
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	citycirclesViewController * thisview = delegate.viewController;
	double curLat = thisview.curLats;
	double curLon = thisview.curLons;
	
	
	int world_origin_x; //default to the from origin
	int world_origin_y;
	int curr_zl;
	int nxt_zl;
	
    center_y = HEIGHT - center_y;
    
    if (to_zl == 15 || to_zl == 12){
        nxt_zl = 15;
	} else {
		nxt_zl = 12;
	}
	
	curr_zl = to_zl;
	
			
	//CONVERT CENTER_X, CENTER_Y TO METERS AT FROM ZOOM LEVEL
	NSMutableArray * ll_m_x_y = (NSMutableArray *)[mercator LatLonToMeters: MAP_LL_LAT lon: MAP_LL_LONG];
	double ll_m_x = [(NSNumber *)[ll_m_x_y objectAtIndex: 0] doubleValue];
	double ll_m_y = [(NSNumber *)[ll_m_x_y objectAtIndex: 1] doubleValue];
	[ll_m_x_y release];

	int ll_x;
	int ll_y;
	
	if (from_origin_x == -1){
		//this is the x,y values for the world map origin at the from zoom level
		NSMutableArray * ll_x_y = (NSMutableArray *)[mercator MetersToPixels:ll_m_x my:ll_m_y zoom:from_zl];
		ll_x = [(NSNumber *)[ll_x_y objectAtIndex: 0] intValue];
		ll_y = [(NSNumber *)[ll_x_y objectAtIndex: 1] intValue];
		[ll_x_y release];
	} else {
		ll_x = from_origin_x;
		ll_y = from_origin_y;
	}
	//center_x, center_y origin at the from zoom level
	int c_w_x = ll_x + center_x;
	int c_w_y = ll_y + center_y;
	
	//now make this meters
	NSMutableArray * c_w_m_x_y = (NSMutableArray *) [mercator PixelsToMeters: c_w_x py: c_w_y zoom: from_zl];
	double c_w_m_x = [(NSNumber *)[c_w_m_x_y objectAtIndex: 0] doubleValue];
	double c_w_m_y = [(NSNumber *)[c_w_m_x_y objectAtIndex: 1] doubleValue];
	[c_w_m_x_y release];
	
			
	//NOW MAKE THIS CENTER_X, CENTER_Y AT THE NEW ZOOM LEVEL
	//n_c_w_x, n_c_w_y = mercator.MetersToPixels(c_w_m_x, c_w_m_y, to_zl)
	NSMutableArray * n_c_w_x_y = (NSMutableArray *) [mercator MetersToPixels: c_w_m_x my: c_w_m_y zoom: to_zl];
	int n_c_w_x = [(NSNumber *)[n_c_w_x_y objectAtIndex: 0] intValue];
	int n_c_w_y = [(NSNumber *)[n_c_w_x_y objectAtIndex: 1] intValue];
	[n_c_w_x_y release];
			
	//CALCULATE THE NEW ZOOM LVLS ORIGIN IN THE WORLD
	int n_ll_w_x = round(n_c_w_x - (WIDTH / 2.0)); //new lower left world x
	int n_ll_w_y = round(n_c_w_y - (HEIGHT / 2.0)); // y
			
	//TEST
	NSMutableArray * t_ll_w_m_x_y = [mercator PixelsToMeters:n_ll_w_x py:n_ll_w_y zoom:to_zl];
	double t_ll_w_m_x = [(NSNumber *)[t_ll_w_m_x_y objectAtIndex:0] doubleValue];
	double t_ll_w_m_y = [(NSNumber *)[t_ll_w_m_x_y objectAtIndex:1] doubleValue];
	[t_ll_w_m_x_y release];
	
	NSMutableArray * t_ll_w_m_lat_long = [mercator MetersToLatLon:t_ll_w_m_x my:t_ll_w_m_y];
	double t_ll_w_m_lat = [(NSNumber *)[t_ll_w_m_lat_long objectAtIndex:0] doubleValue];
	double t_ll_w_m_long = [(NSNumber *)[t_ll_w_m_lat_long objectAtIndex:1] doubleValue];
	[t_ll_w_m_lat_long release];
	//ENDTEST
	
	world_origin_x = n_ll_w_x;
	world_origin_y = n_ll_w_y;
			
	int n_ur_w_x = n_ll_w_x + WIDTH;
	int n_ur_w_y = n_ll_w_y + HEIGHT;
	
	
	//GET THE LL & UR LAT/LONG BOUNDS FOR THE VIEWABLE MAP
	//FIRST THE LL
	NSMutableArray * n_ll_w_m_x_y = [mercator PixelsToMeters:n_ll_w_x py:n_ll_w_y zoom:to_zl];
	double n_ll_w_m_x = [(NSNumber *)[n_ll_w_m_x_y objectAtIndex:0] doubleValue];
	double n_ll_w_m_y = [(NSNumber *)[n_ll_w_m_x_y objectAtIndex:1] doubleValue];
	[n_ll_w_m_x_y release];
	
	NSMutableArray * n_ll_w_lat_long = [mercator MetersToLatLon:n_ll_w_m_x my:n_ll_w_m_y];
	double n_ll_w_lat = [(NSNumber *)[n_ll_w_lat_long objectAtIndex:0] doubleValue];
	double n_ll_w_long = [(NSNumber *)[n_ll_w_lat_long objectAtIndex:1] doubleValue];
	[n_ll_w_lat_long release];
	
	//NOW THE UR
	NSMutableArray * n_ur_w_m_x_y = [mercator PixelsToMeters:n_ur_w_x py:n_ur_w_y zoom:to_zl];
	double n_ur_w_m_x = [(NSNumber *)[n_ur_w_m_x_y objectAtIndex:0] doubleValue];
	double n_ur_w_m_y = [(NSNumber *)[n_ur_w_m_x_y objectAtIndex:1] doubleValue];
	[n_ur_w_m_x_y release];
	
	NSMutableArray * n_ur_w_lat_long = [mercator MetersToLatLon:n_ur_w_m_x my:n_ur_w_m_y];
	double n_ur_w_lat = [(NSNumber *)[n_ur_w_lat_long objectAtIndex:0] doubleValue];
	double n_ur_w_long = [(NSNumber *)[n_ur_w_lat_long objectAtIndex:1] doubleValue];
	[n_ur_w_lat_long release];
	
			
	NSMutableArray *li_tiles = [[NSMutableArray alloc] init];
	
	
	NSMutableArray *alltiles = [dbModels GetTilesForLevel: to_zl];
	NSMutableArray *tile_origin_x_y;
	NSMutableArray *currentRow;
	NSMutableArray *tmp_tile_record;
	
	int tile_origin_x;
	int tile_origin_y;
	
	NSString *current_tile_fl_name;
	int current_tile_x;
	int current_tile_y;
	
	int n_tile_ll_w_x;
	int n_tile_ll_w_y;
	int n_tile_ur_w_x;
	int n_tile_ur_w_y;
	
	//THIS GETS THE ORIGIN OF THE TILES COORDINATES AT THIS ZOOM LEVELS POSSIBLE VIEWABLE AREA
	
	tile_origin_x_y = [mercator MetersToPixels: ll_m_x my: ll_m_y zoom: to_zl];
	tile_origin_x = [(NSNumber *) [tile_origin_x_y objectAtIndex: 0] intValue];
	tile_origin_y = [(NSNumber *) [tile_origin_x_y objectAtIndex: 1] intValue];
	[tile_origin_x_y release];
	
	//MAKE A LIST OF TILES AT THIS ZOOM LEVEL THAT TOUCH THE VIEWABLE AREA
	for (int row=0; row < [alltiles count]; row++ ){
		//CONVERT THE TILES X,Y VALUES TO WORLD PIXEL X,Y AT THIS NEW ZOOM LEVEL
		//THE MAP TILES X,Y VALUES ARE IN RELATION TO THE MAX BOUNDS OF THE MAP, NOT VIEWABLE AREA
		currentRow = [alltiles objectAtIndex: row];
		
		current_tile_fl_name = (NSString*)[currentRow objectAtIndex: 0];
		current_tile_fl_name = [current_tile_fl_name stringByReplacingOccurrencesOfString: @"gtiles/" withString: @""];
		current_tile_x = [(NSNumber*) [currentRow objectAtIndex: 1] intValue];
		current_tile_y = [(NSNumber *)[currentRow objectAtIndex: 2] intValue];
		
		n_tile_ll_w_x = round(tile_origin_x + current_tile_x);
		n_tile_ll_w_y = round(tile_origin_y + current_tile_y);
			
		n_tile_ur_w_x = n_tile_ll_w_x + WIDTH;
		n_tile_ur_w_y = n_tile_ll_w_y + HEIGHT;
		
		if (n_ur_w_x > n_tile_ll_w_x && n_ll_w_x < n_tile_ur_w_x &&
			n_ur_w_y > n_tile_ll_w_y && n_ll_w_y < n_tile_ur_w_y){
			//they overlap, add to the list
			current_tile_fl_name = [@"" stringByAppendingString:current_tile_fl_name];
			tmp_tile_record = [[NSMutableArray alloc] initWithObjects: current_tile_fl_name, [NSNumber numberWithInt: n_tile_ll_w_x - n_ll_w_x], [NSNumber numberWithInt: HEIGHT - (256 + (n_tile_ll_w_y - n_ll_w_y))], nil];
			//tmp_tile_record = [[NSMutableArray alloc] initWithObjects: current_tile_fl_name, [NSNumber numberWithInt: n_tile_ll_w_x - n_ll_w_x], [NSNumber numberWithInt:  (n_tile_ll_w_y - n_ll_w_y)], nil];
			
			[li_tiles addObject: tmp_tile_record ];
			[tmp_tile_record release];
		}
	}
	
	SBJsonWriter * writer = [[SBJsonWriter alloc] init];
	NSString * li_tiles_json = (NSString *)[writer stringWithObject: li_tiles];
	[li_tiles release];
	
	
	
	//GET ALL THE EVENTS
	NSMutableArray *allEvents = [self newProcessStationList:LI_ALL_EVENTS zl:to_zl origin_x:n_ll_w_x origin_y:n_ll_w_y];
	NSString *li_allevents = (NSString *) [writer stringWithObject:allEvents];
	[allEvents release];
	
	 //GET THE STATIONS THAT ARE VIEWABLE
	/*
	NSMutableArray *southStations = [[NSMutableArray alloc] init];
	for (int row = 0; row < [LI_SOUTH_STATIONS count]; row++) {
		[southStations addObject: (NSMutableArray *)[LI_SOUTH_STATIONS objectAtIndex: row]];
	}
	[self processStationList: southStations zl: to_zl origin_x: n_ll_w_x origin_y: n_ll_w_y];
	 */
	NSMutableArray *southStations = [self newProcessStationList:LI_SOUTH_STATIONS zl:to_zl origin_x:n_ll_w_x origin_y:n_ll_w_y];
	
	NSString *li_southStations = (NSString *) [writer stringWithObject:southStations];
	[southStations release];
	
	

	/*
	NSMutableArray *northStations = [[NSMutableArray alloc] init];
	for (int row = 0; row < [LI_NORTH_STATIONS count]; row++) {
		[northStations addObject: (NSMutableArray *)[LI_NORTH_STATIONS objectAtIndex: row]];
	}
	
	[self processStationList: northStations zl: to_zl origin_x: n_ll_w_x origin_y: n_ll_w_y];
	 */
	
	NSMutableArray *northStations = [self newProcessStationList:LI_NORTH_STATIONS zl:to_zl origin_x:n_ll_w_x origin_y:n_ll_w_y];
	NSString *li_northStations = (NSString *) [writer stringWithObject:northStations];
	 
	[northStations release];
	
	//GET THE STATION SETGMENTS
	//Make copies so I don't change the values in the original 
	NSMutableDictionary * this_dct_south_segs = [[NSMutableDictionary alloc] init ]; //WithDictionary:DCT_SOUTH_SEGMENTS copyItems:YES];
	NSMutableDictionary * this_dct_north_segs = [[NSMutableDictionary alloc] init ]; //WithDictionary: DCT_NORTH_SEGMENTS copyItems: YES];
	NSString * dct_south_segs_json;
	NSString * dct_north_segs_json;
	
	//THIS IS FOR THE TRIMMED VERSION
	NSMutableDictionary *dct_south_paths = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *dct_north_paths = [[NSMutableDictionary alloc] init];
	
	NSMutableArray *lines;
	
	//SAVE THE CURRENT CENTER AND ZOOM TO THE CLASS TO BE USED LATER
	prop_curr_zl = to_zl;
	prop_n_ll_w_x = n_ll_w_x;
	prop_n_ll_w_y = n_ll_w_y;
	
	
	//THE NEW OPTIMIZED JSON
	NSString * dct_south_paths_json;
	NSString * dct_north_paths_json;
	
	//HOLD THE LIGHTRAIL LINES TO DRAW
	
	//the new dct based degments
	NSMutableArray *tmp_array;
	NSNumber * key;
	NSArray * southKeys = (NSArray *)[DCT_SOUTH_SEGMENTS allKeys];
	for( int row=0; row < [southKeys count]; row++){
		key = [southKeys objectAtIndex: row];
		tmp_array = [DCT_SOUTH_SEGMENTS objectForKey: key];
		
		NSMutableArray *processed_array = [self newProcessSegPointList: tmp_array zl: to_zl origin_x: n_ll_w_x origin_y: n_ll_w_y];
		int l = 99999999;
		int t = -99999999;
		int r = -99999999;
		int b = 99999999;
		int this_x;
		int this_y;
		int rel_x;
		int rel_y;
		
		NSString *rel_x_s;
		NSString *rel_y_s;
		
		int last_x = 9999999;
		int last_y = 9999999;
		NSString *this_x_s;
		NSString *this_y_s;
		
		NSMutableArray *this_row;
		
		NSString *path_str = @"";
		
		for (int x = 0; x < [processed_array count]; x++){
			
			this_row = (NSMutableArray *)[processed_array objectAtIndex: x];
			this_x = [(NSNumber *)[this_row objectAtIndex: 1] intValue];
			this_y = [(NSNumber *)[this_row objectAtIndex: 2] intValue];
			
			if (this_x == last_x && this_y == last_x) {
				continue;
			} 

			if (this_x < l) {
				l = this_x;
			}
			if (this_x > r){
				r = this_x;
			}
			if (this_y > t){
				t = this_y;
			}
			if (this_y < b){
				b = this_y;
			}
			
			rel_x = this_x - last_x;
			rel_y = this_y - last_y;
			
			this_x_s = [NSString stringWithFormat:@"%d", this_x];
			this_y_s = [NSString stringWithFormat:@"%d", this_y];
			
			rel_x_s = [NSString stringWithFormat:@"%d", rel_x];
			rel_y_s = [NSString stringWithFormat:@"%d", rel_y];
			
			if ([path_str isEqualToString:@""]) {
				path_str = [NSString stringWithFormat:@"M %@ %@", this_x_s, this_y_s];
			} else {
				path_str = [NSString stringWithFormat:@"%@ l %@ %@", path_str, rel_x_s, rel_y_s];
			}
			last_x = this_x;
			last_y = this_y;
		}
		[processed_array release];
		
		//SET THE SOUTH PATHS IF IT TOUCHES THE VIEWABLE AREA		
		if (WIDTH > l && 0 < r &&
			HEIGHT > b && 0 < t){
			[dct_south_paths setObject:path_str forKey:key];
		}
	}
		//[this_dct_south_segs setObject: processed_array forKey: key];
		
			
		
		
		NSArray * northKeys = (NSArray *)[DCT_NORTH_SEGMENTS allKeys];
		for( int row=0; row < [northKeys count]; row++){
			key = [northKeys objectAtIndex: row];
			tmp_array = [DCT_NORTH_SEGMENTS objectForKey: key];
			
			NSMutableArray *processed_array = [self newProcessSegPointList: tmp_array zl: to_zl origin_x: n_ll_w_x origin_y: n_ll_w_y];
			int l = 99999999;
			int t = -99999999;
			int r = -99999999;
			int b = 99999999;
			int this_x;
			int this_y;
			int rel_x;
			int rel_y;
			
			NSString *rel_x_s;
			NSString *rel_y_s;
			
			int last_x = 9999999;
			int last_y = 9999999;
			NSString *this_x_s;
			NSString *this_y_s;
			
			NSMutableArray *this_row;
			
			NSString *path_str = @"";
			
			for (int x = 0; x < [processed_array count]; x++){
				
				this_row = (NSMutableArray *)[processed_array objectAtIndex: x];
				this_x = [(NSNumber *)[this_row objectAtIndex: 1] intValue];
				this_y = [(NSNumber *)[this_row objectAtIndex: 2] intValue];
				
				if (this_x == last_x && this_y == last_x) {
					continue;
				} 
				
				if (this_x < l) {
					l = this_x;
				}
				if (this_x > r){
					r = this_x;
				}
				if (this_y > t){
					t = this_y;
				}
				if (this_y < b){
					b = this_y;
				}
				
				rel_x = this_x - last_x;
				rel_y = this_y - last_y;
				
				this_x_s = [NSString stringWithFormat:@"%d", this_x];
				this_y_s = [NSString stringWithFormat:@"%d", this_y];
				
				rel_x_s = [NSString stringWithFormat:@"%d", rel_x];
				rel_y_s = [NSString stringWithFormat:@"%d", rel_y];
				
				if ([path_str isEqualToString:@""]) {
					path_str = [NSString stringWithFormat:@"M %@ %@", this_x_s, this_y_s];
				} else {
					path_str = [NSString stringWithFormat:@"%@ l %@ %@", path_str, rel_x_s, rel_y_s];
				}
				last_x = this_x;
				last_y = this_y;
			}
			
			//path_str = [NSString stringWithFormat:@"%@ ", path_str];
			
			//SET THE SOUTH PATHS IF IT TOUCHES THE VIEWABLE AREA
			
			if (WIDTH > l && 0 < r &&
				HEIGHT > b && 0 < t){
				[dct_north_paths setObject:path_str forKey:key];
			}
			
			//[this_dct_south_segs setObject: processed_array forKey: key];
			[processed_array release];
		}
		
		[this_dct_north_segs release];
		[this_dct_south_segs release];
		
		//the new optimized paths
		dct_south_paths_json = (NSString *)[writer stringWithObject: dct_south_paths];
		dct_north_paths_json = (NSString *)[writer stringWithObject: dct_north_paths];
		
		[dct_south_paths release];
		[dct_north_paths release];
	
	//WRITE THE JSON FOR THE SCHEDULES
	NSString * northTrainSchedule_json = (NSString *) [writer stringWithObject:northTrainSchedule];
	NSString * southTrainSchedule_json = (NSString *) [writer stringWithObject:southTrainSchedule];
	
	[writer release];
	
	//CONVERT THE CURRENT LOCATION OF THE USER
	//convert lat/lng to meters
	//NSLog([NSString stringWithFormat: @"Current Lon: %.5f", curLon ]);
	//NSLog([NSString stringWithFormat: @"Current Lat: %.5f", curLat ]);
	NSMutableArray * cur_pnt_lat_lng = [mercator LatLonToMeters:curLat lon:curLon];
	int curr_m_x = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 0] doubleValue];
	int curr_m_y = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 1] doubleValue];
	[cur_pnt_lat_lng release];
	
	//convert meters to x,y at world
	NSMutableArray * cur_w_x_y = [mercator MetersToPixels:curr_m_x my:curr_m_y zoom:to_zl];
	int curr_w_x = [(NSNumber *) [cur_w_x_y objectAtIndex:0] intValue];
	int curr_w_y = [(NSNumber *) [cur_w_x_y objectAtIndex:1] intValue];
	
	int curLocx = curr_w_x - n_ll_w_x;
	int curLocy = (HEIGHT - (curr_w_y - n_ll_w_y));
	[cur_w_x_y release];
	
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
	NSString *htmlData = [NSString stringWithContentsOfFile: filePath];
	
	NSString *returnData = [NSString stringWithFormat:htmlData, li_southStations, li_northStations,  
				northTrainSchedule_json, southTrainSchedule_json, li_tiles_json, [NSString stringWithFormat:@"%d", world_origin_x], 
				[NSString stringWithFormat:@"%d", world_origin_y], [NSString stringWithFormat:@"%d", curr_zl],
				[NSString stringWithFormat:@"%d", nxt_zl], li_allevents, dct_south_paths_json, dct_north_paths_json,
				[NSString stringWithFormat:@"%d", curLocx], [NSString stringWithFormat:@"%d", curLocy]];
	
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{tiles|safe}}" withString: li_tiles_json];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{world_origin_x}}" withString: [NSString stringWithFormat:@"%d", world_origin_x]];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{world_origin_y}}" withString: [NSString stringWithFormat:@"%d", world_origin_y]];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{curr_zl}}" withString: [NSString stringWithFormat:@"%d", curr_zl]];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{nxt_zl}}" withString: [NSString stringWithFormat:@"%d", nxt_zl]];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{north_stations}}" withString: li_southStations];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{south_stations}}" withString: li_northStations];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"[\"{{li_trains_schedule}}\"]" withString: li_train_schedule_json];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"[\"{{all_events}}\"]" withString: li_allevents];
	
	
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{\"dct_north_schedules\": []}" withString: northTrainSchedule_json];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{\"dct_south_schedules\": []}" withString: southTrainSchedule_json];
	
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{dct_south_stations}}" withString: dct_south_segs_json];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{dct_north_stations}}" withString: dct_north_segs_json];
	
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{cur_Locx}}" withString: [NSString stringWithFormat:@"%d", curLocx]];
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"{{cur_Locy}}" withString: [NSString stringWithFormat:@"%d", curLocy]];
	
	//htmlData = [htmlData stringByReplacingOccurrencesOfString: @"\"{{points|safe}}\"" withString: li_lines];
	
	//NSString *returnString = [[NSString alloc] initWithString: htmlData];

	//NSLog(returnData);
	[self logTime];
	return returnData;
}

-(NSMutableArray *) processLatLong: (double) Lat Lon:(double) Lon{
	//convert lat/lng to meters
	NSMutableArray * cur_pnt_lat_lng = [mercator LatLonToMeters:Lat lon:Lon];
	double curr_m_x = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 0] doubleValue];
	double curr_m_y = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 1] doubleValue];
	[cur_pnt_lat_lng release];
	
	//convert meters to x,y at world
	NSMutableArray * cur_w_x_y = [mercator MetersToPixels:curr_m_x my:curr_m_y zoom:prop_curr_zl];
	int curr_w_x = [(NSNumber *) [cur_w_x_y objectAtIndex:0] intValue];
	int curr_w_y = [(NSNumber *) [cur_w_x_y objectAtIndex:1] intValue];
	[cur_w_x_y release];
	
	int curr_fo_x = curr_w_x - prop_n_ll_w_x;
	int curr_fo_y = (HEIGHT - (curr_w_y - prop_n_ll_w_y));
	
	NSMutableArray * returnArray = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt: curr_fo_x], [NSNumber numberWithInt: curr_fo_y], Nil];
	
	return returnArray;
}

-(NSMutableArray *) newProcessSegPointList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	NSMutableArray *currentRow;
	
	double curr_lat;
	double curr_lng;
	double curr_m_x;
	double curr_m_y;
	
	int curr_w_x;
	int curr_w_y;
	
	int curr_fo_x; //from viewable origin
	int curr_fo_y;
	
	
	NSMutableArray *cur_pnt_lat_lng;
	NSMutableArray *cur_w_x_y;
	NSMutableArray *new_tmp_row;
	
	for (int idx = 0; idx < [in_array count]; idx++) {
		currentRow = (NSMutableArray *) [in_array objectAtIndex: idx];
		curr_lat = [(NSString *)[currentRow objectAtIndex: 1] doubleValue];
		curr_lng = [(NSString *)[currentRow objectAtIndex: 2] doubleValue];
		
		
		//convert lat/lng to meters
		cur_pnt_lat_lng = [mercator LatLonToMeters:curr_lat lon:curr_lng];
		curr_m_x = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 0] doubleValue];
		curr_m_y = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 1] doubleValue];
		[cur_pnt_lat_lng release];
		
		//convert meters to x,y at world
		cur_w_x_y = [mercator MetersToPixels:curr_m_x my:curr_m_y zoom:zl];
		curr_w_x = [(NSNumber *) [cur_w_x_y objectAtIndex:0] intValue];
		curr_w_y = [(NSNumber *) [cur_w_x_y objectAtIndex:1] intValue];
		[cur_w_x_y release];
		
		curr_fo_x = curr_w_x - origin_x;
		curr_fo_y = (HEIGHT - (curr_w_y - origin_y));
		
		new_tmp_row = [[NSMutableArray alloc] init];
		
		for (int x = 0; x < [currentRow count]; x++) {
			if (x == 1) {
				[new_tmp_row addObject: [NSNumber numberWithInt: curr_fo_x]];
			} else if (x == 2) {
				[new_tmp_row addObject: [NSNumber numberWithInt: curr_fo_y]];
			} else {
				[new_tmp_row addObject: [currentRow objectAtIndex: x]];
			}
		}
		
		/*
		[currentRow replaceObjectAtIndex:1 withObject: [NSNumber numberWithInt: curr_fo_x]];
		[currentRow replaceObjectAtIndex:2 withObject: [NSNumber numberWithInt: curr_fo_y]];
		 */
		[returnArray addObject: new_tmp_row];
		[new_tmp_row release];
	}
	return returnArray;
}

-(void) processSegPointList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y{
	
	NSMutableArray *currentRow;
	
	double curr_lat;
	double curr_lng;
	double curr_m_x;
	double curr_m_y;
	
	int curr_w_x;
	int curr_w_y;
	
	int curr_fo_x; //from viewable origin
	int curr_fo_y;
	
	
	NSMutableArray *cur_pnt_lat_lng;
	NSMutableArray *cur_w_x_y;
	
	for (int idx = 0; idx < [in_array count]; idx++) {
		currentRow = (NSMutableArray *) [in_array objectAtIndex: idx];
		curr_lat = [(NSString *)[currentRow objectAtIndex: 1] doubleValue];
		curr_lng = [(NSString *)[currentRow objectAtIndex: 2] doubleValue];
		
		
		//convert lat/lng to meters
		cur_pnt_lat_lng = [mercator LatLonToMeters:curr_lat lon:curr_lng];
		curr_m_x = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 0] doubleValue];
		curr_m_y = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 1] doubleValue];
		[cur_pnt_lat_lng release];
		
		//convert meters to x,y at world
		cur_w_x_y = [mercator MetersToPixels:curr_m_x my:curr_m_y zoom:zl];
		curr_w_x = [(NSNumber *) [cur_w_x_y objectAtIndex:0] intValue];
		curr_w_y = [(NSNumber *) [cur_w_x_y objectAtIndex:1] intValue];
		
		curr_fo_x = curr_w_x - origin_x;
		curr_fo_y = (HEIGHT - (curr_w_y - origin_y));
		
		[currentRow replaceObjectAtIndex:1 withObject: [NSNumber numberWithInt: curr_fo_x]];
		[currentRow replaceObjectAtIndex:2 withObject: [NSNumber numberWithInt: curr_fo_y]];
		
	}
	return;
}

-(NSMutableArray*) newProcessStationList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	NSMutableArray *currentRow;
	
	double curr_lat;
	double curr_lng;
	double curr_m_x;
	double curr_m_y;
	
	int curr_w_x;
	int curr_w_y;
	
	int curr_fo_x; //from viewable origin
	int curr_fo_y;
	
	int curr_station_id;
	
	NSMutableArray *cur_pnt_lat_lng;
	NSMutableArray *cur_w_x_y;
	NSMutableArray *new_tmp_row;
	
	for (int idx = 0; idx < [in_array count]; idx++) {
		currentRow = (NSMutableArray *) [in_array objectAtIndex: idx];
		curr_lat = [(NSString *)[currentRow objectAtIndex: 2] doubleValue];
		curr_lng = [(NSString *)[currentRow objectAtIndex: 3] doubleValue];
		
		//convert the station id
		curr_station_id = [(NSString *) [currentRow objectAtIndex:4] intValue];
		
		//convert lat/lng to meters
		cur_pnt_lat_lng = [mercator LatLonToMeters:curr_lat lon:curr_lng];
		curr_m_x = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 0] doubleValue];
		curr_m_y = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 1] doubleValue];
		[cur_pnt_lat_lng release];
		
		//convert meters to x,y at world
		cur_w_x_y = [mercator MetersToPixels:curr_m_x my:curr_m_y zoom:zl];
		curr_w_x = [(NSNumber *) [cur_w_x_y objectAtIndex:0] intValue];
		curr_w_y = [(NSNumber *) [cur_w_x_y objectAtIndex:1] intValue];
		[cur_w_x_y release];
		
		curr_fo_x = curr_w_x - origin_x;
		curr_fo_y = (HEIGHT - (curr_w_y - origin_y));
		
		new_tmp_row = [[NSMutableArray alloc] init];
		
		for (int x = 0; x < [currentRow count]; x++) {
			if (x == 2) {
				[new_tmp_row addObject: [NSNumber numberWithInt: curr_fo_x]];
			} else if (x == 3) {
				[new_tmp_row addObject: [NSNumber numberWithInt: curr_fo_y]];
			} else if (x == 4) {
				[new_tmp_row addObject: [NSNumber numberWithInt: curr_station_id]];
			} else {
				[new_tmp_row addObject: [currentRow objectAtIndex: x]];
			}
		}
		/*
		[currentRow replaceObjectAtIndex:4 withObject: [NSNumber numberWithInt: curr_station_id]];
		[currentRow replaceObjectAtIndex:2 withObject: [NSNumber numberWithInt: curr_fo_x]];
		[currentRow replaceObjectAtIndex:3 withObject: [NSNumber numberWithInt: curr_fo_y]];
		 */
		[returnArray addObject: new_tmp_row];
		[new_tmp_row release];
	}
	return returnArray;
}

-(void) processStationList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y{
	
	NSMutableArray *currentRow;
	
	double curr_lat;
	double curr_lng;
	double curr_m_x;
	double curr_m_y;
	
	int curr_w_x;
	int curr_w_y;
	
	int curr_fo_x; //from viewable origin
	int curr_fo_y;
	
	int curr_station_id;
	
	NSMutableArray *cur_pnt_lat_lng;
	NSMutableArray *cur_w_x_y;
	
	for (int idx = 0; idx < [in_array count]; idx++) {
		currentRow = (NSMutableArray *) [in_array objectAtIndex: idx];
		curr_lat = [(NSString *)[currentRow objectAtIndex: 2] doubleValue];
		curr_lng = [(NSString *)[currentRow objectAtIndex: 3] doubleValue];
		
		//convert the station id
		curr_station_id = [(NSString *) [currentRow objectAtIndex:4] intValue];
		
		//convert lat/lng to meters
		cur_pnt_lat_lng = [mercator LatLonToMeters:curr_lat lon:curr_lng];
		curr_m_x = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 0] doubleValue];
		curr_m_y = [(NSNumber *)[cur_pnt_lat_lng objectAtIndex: 1] doubleValue];
		[cur_pnt_lat_lng release];
		
		//convert meters to x,y at world
		cur_w_x_y = [mercator MetersToPixels:curr_m_x my:curr_m_y zoom:zl];
		curr_w_x = [(NSNumber *) [cur_w_x_y objectAtIndex:0] intValue];
		curr_w_y = [(NSNumber *) [cur_w_x_y objectAtIndex:1] intValue];
		
		curr_fo_x = curr_w_x - origin_x;
		curr_fo_y = (HEIGHT - (curr_w_y - origin_y));
		
		[currentRow replaceObjectAtIndex:4 withObject: [NSNumber numberWithInt: curr_station_id]];
		[currentRow replaceObjectAtIndex:2 withObject: [NSNumber numberWithInt: curr_fo_x]];
		[currentRow replaceObjectAtIndex:3 withObject: [NSNumber numberWithInt: curr_fo_y]];
		
	}
	return;
}
- (void)dealloc {
	
	[mercator release];
	[LI_SOUTH_SEGMENTS release];
	[LI_NORTH_SEGMENTS release];
	[LI_SOUTH_STATIONS release];
	[LI_NORTH_STATIONS release];
	[DCT_NORTH_SEGMENTS release];
	[DCT_SOUTH_SEGMENTS release];
	[northTrainSchedule release];
	[southTrainSchedule release];
	[LI_ALL_EVENTS release];
	[dbModels release];
	
	
	[super dealloc];
	
}
@end



