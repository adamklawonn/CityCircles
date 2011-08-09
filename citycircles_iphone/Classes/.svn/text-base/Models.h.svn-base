//
//  Models.h
//  citycircles
//
//  Created by mjamison on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@interface Models : NSObject {
	int is_connected;
	sqlite3 *database;

}

-(NSMutableArray *) getArrayFromSQL: (const char *) sSql;

-(NSMutableArray *) GetTilesForLevel: (int) level;

- (NSString *) emptyStringForNull: (char *) string_or_null;

-(NSMutableArray *) GetStationsWithinBounds: (NSString *) direction ll_lat: (double) ll_lat ll_long: (double) ll_long ur_lat: (double) ur_lat ur_long: (double) ur_long;

-(NSMutableArray *) GetStationSegments: (int) station_id;

-(NSMutableArray *) getAllStations: (NSString *)direction;

-(NSString *) getStationInfo: (int) stationID;

-(NSMutableArray *) getCategoriesForStation:(int) stationID;

-(NSMutableArray *) getBizForStationAndCat:(int) stationID categoryID: (int) categoryID;

-(NSMutableArray *) getBizDetails: (int) bizID;

-(NSMutableArray *) getTrainSchedules: (int) dayofweek;

-(NSMutableArray *) getTrainSchedule: (int) dayofweek station_id: (int) station_id;

-(NSMutableArray *) getAllEvents;

-(NSMutableArray *) getAllEventCats;

-(NSMutableArray *) getEventsPerCat: (int) category_id;

-(NSMutableArray *) getEventDetails: (int) eventID;

-(int) getInFavorites: (int) itemID is_business: (int) is_business;

-(void) deleteFromFavorites: (int) itemID is_business: (int) is_business;

-(void) addToFavorites: (int) itemID is_business: (int) is_business;

-(NSMutableArray *) getAllFavorites: (int) is_business;

-(NSMutableArray *) GetLinePoints: (NSString *) direction;

-(void) connectDB;


- (void) closedb;
@end
