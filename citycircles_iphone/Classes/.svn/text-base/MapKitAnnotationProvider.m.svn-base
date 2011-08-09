//
//  MapKitAnnotationProvider.m
//  citycircles
//
//  Created by mjamison on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapKitAnnotationProvider.h"
#import "Models.h"
#import "citycirclesAppDelegate.h"
#import "MyAnnotation.h"


@implementation MapKitAnnotationProvider

@synthesize DCT_SOUTH_SEGMENTS, DCT_NORTH_SEGMENTS;
@synthesize LI_SOUTH_POINTS, LI_NORTH_POINTS;

-(id) init{
	if (self = [super init])
    {	
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		Models *dbModels = delegate.dbModels;
		li_events = [dbModels getAllEvents];
		
		
		MAP_LL_LONG = -112.217;
		MAP_LL_LAT = 33.339;
		
		DCT_SOUTH_SEGMENTS = [[NSMutableDictionary alloc] init];
		DCT_NORTH_SEGMENTS = [[NSMutableDictionary alloc] init];
		
		LI_SOUTH_POINTS = [dbModels GetLinePoints: @"S"];
		LI_NORTH_POINTS = [dbModels GetLinePoints: @"N"];
		
		
		
		
		
		//GET ALL THE NORTH STATIONS
		LI_SOUTH_STATIONS = [dbModels GetStationsWithinBounds: @"S" ll_lat: MAP_LL_LAT ll_long: MAP_LL_LONG ur_lat: 33.61690 ur_long: -111.77627 ];
		/*
		//GET ALL TRACKS
		NSMutableArray *currentRow;
		int station_number;
		
		for (int row = 0; row < [LI_SOUTH_STATIONS count]; row++){
			currentRow = (NSMutableArray *)[LI_SOUTH_STATIONS objectAtIndex: row];
			station_number = [(NSNumber *) [currentRow objectAtIndex: 4] intValue];
			NSMutableArray *tmp_segs = [dbModels GetStationSegments: station_number];
			//[LI_SOUTH_SEGMENTS addObjectsFromArray: tmp_segs];
			//NSLog([NSString stringWithFormat: @"%d", [tmp_segs count] ]);
			[DCT_SOUTH_SEGMENTS setObject:tmp_segs forKey:(NSNumber *) [currentRow objectAtIndex: 1]];
			
			
			//NSNumber *tmp_num = [(NSMutableArray *)[DCT_SOUTH_SEGMENTS objectForKey:(NSNumber *) [currentRow objectAtIndex: 1]] objectAtIndex: 0];
			//NSLog([NSString stringWithFormat:@"%1.5f", tmp_num]);
			
			[tmp_segs release];
		}
		*/
		//GET ALL THE STATIONS
		LI_NORTH_STATIONS = [dbModels GetStationsWithinBounds: @"N" ll_lat: MAP_LL_LAT ll_long: MAP_LL_LONG ur_lat: 33.61690 ur_long: -111.77627 ];
		/*
		//GET ALL TRACKS
		for (int row = 0; row < [LI_NORTH_STATIONS count]; row++){
			currentRow = (NSMutableArray *)[LI_NORTH_STATIONS objectAtIndex: row];
			station_number = [(NSNumber *) [currentRow objectAtIndex: 4] intValue];
			NSMutableArray *tmp_segs = [dbModels GetStationSegments: station_number];
			//[LI_NORTH_SEGMENTS addObjectsFromArray: tmp_segs];
			
			[DCT_NORTH_SEGMENTS setObject:tmp_segs forKey:(NSNumber *) [currentRow objectAtIndex: 1]];
			[tmp_segs release];
		}
		*/
		
		
    }
    return self;
}
-(NSMutableArray *) get_Events{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	//gis2raphael_event.name, start_datetime, lat, lon, gis2raphael_event.id as id, end_datetime, gis2raphael_eventcategory.name as cat_name
	for (int x=0; x < [li_events count]; x++) {
		NSMutableArray *this_row = [li_events objectAtIndex:x];
		NSString *startDate = [self getDateFromDateTimeString: (NSString *)[this_row objectAtIndex:1]];
		NSString *endDate = [self getDateFromDateTimeString: (NSString *)[this_row objectAtIndex:5]];
		
		NSString *sub_title;
		if ([startDate isEqualToString:endDate]) {
			sub_title = startDate;
		} else {
			sub_title = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
		}
		
		double lat = [(NSNumber *) [this_row objectAtIndex: 2] doubleValue];
		double lon = [(NSNumber *) [this_row objectAtIndex: 3] doubleValue];
			 
		MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:[this_row objectAtIndex:0] subtitle:sub_title lat:lat lon:lon typeName: @"event"];
		
		[returnArray addObject: this_annotation];
		this_annotation.theID = [(NSNumber *)[this_row objectAtIndex: 4] intValue];
		[this_annotation release];
	}
	return returnArray;
}

-(NSMutableArray *) get_Event: (int) eventID{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
	Models *dbModels = delegate.dbModels;
	
	NSMutableArray *bizDetails = [dbModels getEventDetails: eventID];
	
	
	//gis2raphael_event.name, start_datetime, lat, lon, gis2raphael_event.id as id, end_datetime, gis2raphael_eventcategory.name as cat_name
	for (int x=0; x < [li_events count]; x++) {
		NSMutableArray *this_row = [li_events objectAtIndex:x];
		NSString *startDate = [self getDateFromDateTimeString: (NSString *)[this_row objectAtIndex:1]];
		NSString *endDate = [self getDateFromDateTimeString: (NSString *)[this_row objectAtIndex:5]];
		
		NSString *sub_title;
		if ([startDate isEqualToString:endDate]) {
			sub_title = startDate;
		} else {
			sub_title = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
		}
		
		double lat = [(NSNumber *) [this_row objectAtIndex: 2] doubleValue];
		double lon = [(NSNumber *) [this_row objectAtIndex: 3] doubleValue];
		
		MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:[this_row objectAtIndex:0] subtitle:sub_title lat:lat lon:lon typeName: @"event"];
		this_annotation.theID = 0; //don't do callout
		[returnArray addObject: this_annotation];
		
		[this_annotation release];
	}
	return returnArray;
}

-(NSMutableArray *) get_AllStations{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	NSMutableArray *stationLocs = [[NSMutableArray alloc] init];
	
	for (int row = 0; row < [LI_SOUTH_STATIONS count]; row++){
		NSMutableArray *this_row = [LI_SOUTH_STATIONS objectAtIndex:row];
		//name, \"index\", lat, lng, id
		double this_lat = [(NSNumber *)[this_row objectAtIndex:2] doubleValue];
		double this_lon = [(NSNumber *)[this_row objectAtIndex:3] doubleValue];
		
		NSMutableString *tmpLoc = [NSString stringWithFormat:@"%1.5f%1.5f", this_lat, this_lon];
		
		if ([stationLocs containsObject:tmpLoc]) {
			continue;  //we only want unique station locations
		}
		[stationLocs addObject: tmpLoc];
		
		//THIS IS A UNIQUE LOCATION
		NSString *stationTitle = (NSString *)[this_row objectAtIndex:0];
		
		MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:stationTitle subtitle:@"" lat:this_lat lon:this_lon typeName: @"station"];
		this_annotation.theID = [(NSNumber *)[this_row objectAtIndex: 4] intValue];
		[returnArray addObject: this_annotation]; //adds a reference
		
		[this_annotation release];
	}
	
	for (int row = 0; row < [LI_NORTH_STATIONS count]; row++){
		NSMutableArray *this_row = [LI_NORTH_STATIONS objectAtIndex:row];
		//name, \"index\", lat, lng, id
		double this_lat = [(NSNumber *)[this_row objectAtIndex:2] doubleValue];
		double this_lon = [(NSNumber *)[this_row objectAtIndex:3] doubleValue];
		
		NSMutableString *tmpLoc = [NSString stringWithFormat:@"%1.5f%1.5f", this_lat, this_lon];
		
		if ([stationLocs containsObject:tmpLoc]) {
			continue;  //we only want unique station locations
		}
		[stationLocs addObject: tmpLoc];
		
		//THIS IS A UNIQUE LOCATION
		NSString *stationTitle = (NSString *)[this_row objectAtIndex:0];
		
		MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:stationTitle subtitle:@"" lat:this_lat lon:this_lon typeName: @"station"];
		this_annotation.theID = [(NSNumber *)[this_row objectAtIndex: 4] intValue];
		[returnArray addObject: this_annotation]; //adds a reference
		
		[this_annotation release];
	}
	
	[stationLocs release]; //no longer needed
	
	return returnArray;
}


/*
-(NSMutableArray *) get_SouthStations{
	
}

-(NSMutableArray *) get_NorthStations{
}
*/
-(NSString *) getDateFromDateTimeString: (NSString *) sDateTime{
	NSArray *chunks = [sDateTime componentsSeparatedByString:@" "];
	return (NSString*) [chunks objectAtIndex: 0];
}

- (void)dealloc {
	[li_events release];
    [super dealloc];
}
@end
