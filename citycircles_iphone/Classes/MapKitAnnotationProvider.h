//
//  MapKitAnnotationProvider.h
//  citycircles
//
//  Created by mjamison on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MapKitAnnotationProvider : NSObject {
	NSMutableArray *li_north_stations;
	NSMutableArray *li_south_stations;
	NSMutableArray *li_events; //EVENTS GOING ON RIGHT NOW
	
	double MAP_LL_LONG;
	double MAP_LL_LAT;
	
	NSMutableArray *LI_SOUTH_STATIONS;
	NSMutableArray *LI_NORTH_STATIONS;
	
	NSMutableDictionary *DCT_SOUTH_SEGMENTS;
	NSMutableDictionary *DCT_NORTH_SEGMENTS;
	
	NSMutableArray *LI_SOUTH_POINTS;
	NSMutableArray *LI_NORTH_POINTS;
	
}


-(NSMutableArray *) get_Events;
-(NSMutableArray *) get_Event: (int) eventID;
-(NSMutableArray *) get_AllStations;
-(NSString *) getDateFromDateTimeString: (NSString *) sDateTime;


@property (retain) NSMutableDictionary *DCT_SOUTH_SEGMENTS;
@property (retain) NSMutableDictionary *DCT_NORTH_SEGMENTS;

@property (retain) NSMutableArray *LI_SOUTH_POINTS;
@property (retain) NSMutableArray *LI_NORTH_POINTS;
/*
-(NSMutableArray *) get_SouthStations;
-(NSMutableArray *) get_NorthStations;
 
*/
@end
