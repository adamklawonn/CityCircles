//
//  Models.m
//  citycircles
//
//  Created by mjamison on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Models.h"
#include <sqlite3.h>


@implementation Models

/*
 RETURNS
 [
	[tile1.png, 100, 100],
	[tile2.png, 200, 100],
	etc..
 ]
 */

-(id) init{
	if (self = [super init])
    {	
		is_connected = 0;
    }
    return self;
}


-(NSMutableArray *) GetTilesForLevel: (int) level{
	NSMutableString * NSsSql = [NSMutableString stringWithFormat:@"SELECT fl_name, ll_x, ll_y FROM gis2raphael_tile where level = %d;", level];
	const char *sSql = [NSsSql UTF8String];	
	
	return [self getArrayFromSQL: sSql num_columns: 3];
	
}

-(NSMutableArray *) GetStationsWithinBounds: (NSString *) sDir ll_lat: (double) ll_lat ll_long: (double) ll_long ur_lat: (double) ur_lat ur_long: (double) ur_long{
	NSMutableString * NSsSql = [NSMutableString stringWithFormat:@"SELECT name, \"index\", lat, lng, id from gis2raphael_station where (lat < %.5f and lat > %.5f and lng < %.5f and lng > %.5f", ur_lat, ll_lat, ur_long, ll_long];
	[NSsSql appendFormat: @" and direction = '%@');", sDir];
	const char *sSql = [NSsSql UTF8String];	
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 5];
	
	if ([returnArray count] > 0) {
		//get the first in the index
		int lowest_idx = 9999;
		int curr_idx;
		NSString *curr_idx_s;
		NSMutableArray *currentRow;
		
		for (int row=0; row < [returnArray count]; row++ ){
			currentRow = (NSMutableArray *)[returnArray objectAtIndex: row];
			curr_idx_s = (NSString *)[currentRow objectAtIndex: 1];
			curr_idx = [curr_idx_s intValue];
			
			if (curr_idx < lowest_idx){
				lowest_idx = curr_idx;
			}
		}
		lowest_idx = lowest_idx - 1;
	
		/*NSsSql = [NSMutableString stringWithFormat:@"SELECT name, index, lat, lng, id from gis2raphael where index = %d and direction = \"%@\");", lowest_idx, sDir];
		sSql = [NSsSql UTF8String];	
		NSMutableArray *appendArray = [self getArrayFromSQL: sSql num_columns: 5];
		[returnArray addObjectsFromArray: appendArray];
		[appendArray release];
		 */
	}
	return returnArray;
}

-(NSMutableArray *) GetStationSegments: (int) station_id{
	NSMutableString * NSsSql = [NSMutableString stringWithFormat:@"SELECT	idx, lat, lng FROM gis2raphael_segmentpoint WHERE start_station_id = %d ORDER BY idx;", station_id];
	const char *sSql = [NSsSql UTF8String];	
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	
	double lat;
	double lng;
	
	NSMutableArray *currentRow;
	
	//REPLACE THE TXT LAT/LNG WITH NSNUMBER DOUBLES
	for (int row=0; row<[returnArray count]; row++){
		currentRow = (NSMutableArray *) [returnArray objectAtIndex: row];
		
		lat = [(NSString *) [currentRow objectAtIndex:1] doubleValue];
		lng = [(NSString *) [currentRow objectAtIndex:2] doubleValue];
		
		[currentRow replaceObjectAtIndex:1 withObject: [NSNumber numberWithDouble:lat]];
		[currentRow replaceObjectAtIndex:2 withObject: [NSNumber numberWithDouble:lng]];
	}
	return returnArray;
}

-(NSMutableArray *) GetLinePoints: (NSString *) direction{
	NSMutableString * NSsSql = [NSMutableString stringWithFormat:@"SELECT	idx, gis2raphael_segmentpoint.lat, gis2raphael_segmentpoint.lng FROM gis2raphael_segmentpoint inner join gis2raphael_station on (gis2raphael_station.id = gis2raphael_segmentpoint.start_station_id) where gis2raphael_station.direction = \"%@\" ORDER BY \"index\", idx;", direction];
	const char *sSql = [NSsSql UTF8String];	
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	
	double lat;
	double lng;
	
	NSMutableArray *currentRow;
	
	//REPLACE THE TXT LAT/LNG WITH NSNUMBER DOUBLES
	for (int row=0; row<[returnArray count]; row++){
		currentRow = (NSMutableArray *) [returnArray objectAtIndex: row];
		
		lat = [(NSString *) [currentRow objectAtIndex:1] doubleValue];
		lng = [(NSString *) [currentRow objectAtIndex:2] doubleValue];
		
		[currentRow replaceObjectAtIndex:1 withObject: [NSNumber numberWithDouble:lat]];
		[currentRow replaceObjectAtIndex:2 withObject: [NSNumber numberWithDouble:lng]];
	}
	return returnArray;
}


/*
 RETURNS AN NSMutableArray IN THIS FORMAT	
	[ 
		[0, "MCDOWELL", 0, 33.00, -111.90],
		...
	],
*/
-(NSMutableArray *) getAllStations: (NSString *)direction{
	NSMutableString * NSsSql = [NSMutableString stringWithFormat:@"select id, name, 'index', lat, lng from gis2raphael_station where direction = \"%@\" order by 'index' asc", direction];
	const char *sSql = [NSsSql UTF8String];
	
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 5];
	
	//REPLACE THE TXT LAT/LNG WITH NSNUMBER DOUBLES
	double lat;
	double lng;
	NSMutableArray *currentRow;
	
	for (int row=0; row<[returnArray count]; row++){
		currentRow = (NSMutableArray *) [returnArray objectAtIndex: row];
		
		lat = [(NSString *) [currentRow objectAtIndex:3] doubleValue];
		lng = [(NSString *) [currentRow objectAtIndex:4] doubleValue];
		
		[currentRow replaceObjectAtIndex:3 withObject: [NSNumber numberWithDouble:lat]];
		[currentRow replaceObjectAtIndex:4 withObject: [NSNumber numberWithDouble:lng]];
	}
	return returnArray;
}

-(NSString *) getStationInfo: (int) stationID{
	NSMutableString *NSsSql = [NSMutableString stringWithFormat:@"select id, info from gis2raphael_station where id = %d", stationID];
	const char *sSql = [NSsSql UTF8String];
	
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 2];
	
	NSString *returnString = [(NSMutableArray *)[returnArray objectAtIndex: 0] objectAtIndex: 1];
	//NSString *returnString = (NSString *)[returnArray objectAtIndex: 0];
	NSLog(@"HI");
	NSLog(returnString);
	
	return returnString;
}

-(NSMutableArray *) getCategoriesForStation:(int) stationID{
	NSMutableString * NSsSql = [NSMutableString stringWithFormat:@"select gis2raphael_businesscategory.id, gis2raphael_businesscategory.name from gis2raphael_businesscategory inner join gis2raphael_business on (gis2raphael_business.category_id = gis2raphael_businesscategory.id) inner join gis2raphael_business_stations on (gis2raphael_business_stations.business_id = gis2raphael_business.id) where station_id = %d group by gis2raphael_businesscategory.id, gis2raphael_businesscategory.name", stationID];
	
	const char *sSql = [NSsSql UTF8String];	
	//NSLog(NSsSql);
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 2];
	
	NSMutableArray *currentRow;
	int cat_id;
	
	//make the category id a number
	for (int row=0; row<[returnArray count]; row++){
		currentRow = (NSMutableArray *) [returnArray objectAtIndex: row];
		
		cat_id = [(NSString *) [currentRow objectAtIndex:0] intValue];
		
		[currentRow replaceObjectAtIndex:0 withObject: [NSNumber numberWithInt:cat_id]];
	}
	return returnArray;
}

-(NSMutableArray *) getBizForStationAndCat:(int) stationID categoryID: (int) categoryID{
	NSMutableArray * NSsSql = [NSMutableString stringWithFormat:@"SELECT gis2raphael_business.id, name	FROM	gis2raphael_business inner join gis2raphael_business_stations on (business_id = gis2raphael_business.id) where station_id = %d and category_id = %d", stationID, categoryID];
	
	const char *sSql = [NSsSql UTF8String];	
	//NSLog(NSsSql);
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 2];
	
	NSMutableArray *currentRow;
	int cat_id;
	
	//make the category id a number
	for (int row=0; row<[returnArray count]; row++){
		currentRow = (NSMutableArray *) [returnArray objectAtIndex: row];
		
		cat_id = [(NSString *) [currentRow objectAtIndex:0] intValue];
		
		[currentRow replaceObjectAtIndex:0 withObject: [NSNumber numberWithInt:cat_id]];
	}
	return returnArray;	
}

-(NSMutableArray *) getBizDetails: (int) bizID{
	NSMutableString *NSsSql = [NSMutableString stringWithFormat:@"SELECT id, name, lat, lon, address_street, address_apt, city, state, zip, phone, url, info, thumb_path from gis2raphael_business where id = %d", bizID];
	const char *sSql = [NSsSql UTF8String];	
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 13];
	
	return returnArray;
}

//GET TRAIN SCHEDULES
-(NSMutableArray *) getTrainSchedules: (int) dayofweek{
	NSMutableString *NSsSql = [NSMutableString stringWithFormat:@"SELECT	direction, \"index\", arrival_time  FROM gis2raphael_arivaltime inner join gis2raphael_trainschedule on (gis2raphael_trainschedule.id = gis2raphael_arivaltime.trainschedule_id) inner join gis2raphael_station on (gis2raphael_station.id = gis2raphael_trainschedule.station_id) where day_of_week = %d", dayofweek];
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	
	return returnArray;
}

//GET TRAIN SCHEDULE
-(NSMutableArray *) getTrainSchedule: (int) dayofweek station_id: (int) station_id{
	NSMutableString *NSsSql = [NSMutableString stringWithFormat:@"SELECT arrival_time  FROM gis2raphael_arivaltime inner join gis2raphael_trainschedule on (gis2raphael_trainschedule.id = gis2raphael_arivaltime.trainschedule_id) inner join gis2raphael_station on (gis2raphael_station.id = gis2raphael_trainschedule.station_id) where day_of_week = %d and gis2raphael_station.id = %d order by arrival_time", dayofweek, station_id];
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	
	return returnArray;
}


/*
 GET ALL EVENTS WITHIN A TIMEFRAME
*/
-(NSMutableArray *) getAllEvents{
	NSString *NSsSql = @"SELECT	gis2raphael_event.name, start_datetime, lat, lon, gis2raphael_event.id as id, end_datetime, gis2raphael_eventcategory.name as cat_name	FROM	gis2raphael_event inner join gis2raphael_eventcategory on (gis2raphael_event.category_id = gis2raphael_eventcategory.id) where datetime(start_datetime) < datetime('now') and datetime(end_datetime) > datetime('now')";
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 7];
	
	return returnArray;
}

/*
 GET ALL FUTURES EVENT CATEGORIES
 */
-(NSMutableArray *) getAllEventCats{
	NSString *NSsSql = @"SELECT	min(start_datetime) as start_datetime, gis2raphael_eventcategory.name as cat_name, gis2raphael_eventcategory.id	FROM	gis2raphael_event inner join gis2raphael_eventcategory on (gis2raphael_event.category_id = gis2raphael_eventcategory.id) where datetime(end_datetime) > datetime('now') GROUP BY cat_name, gis2raphael_eventcategory.id	";
	//NSString *NSsSql = @"SELECT	gis2raphael_eventcategory.name as cat_name, gis2raphael_eventcategory.id	FROM	gis2raphael_eventcategory GROUP BY start_datetime, cat_name";
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	NSLog([NSString stringWithFormat: @"%d", [returnArray count]]);
	return returnArray;
}

/*
 GET ALL FUTURE EVENTS FOR CATEGORY
 */
-(NSMutableArray *) getEventsPerCat: (int) category_id{
	NSString *NSsSql = [NSString stringWithFormat: @"SELECT	start_datetime, gis2raphael_event.name, gis2raphael_event.id as event_id 	FROM	gis2raphael_event inner join gis2raphael_eventcategory on (gis2raphael_event.category_id = gis2raphael_eventcategory.id) where (datetime(end_datetime) > datetime('now') AND gis2raphael_eventcategory.id = %d) order by start_datetime", category_id];
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	
	return returnArray;
}


/*
 GET EVENT DETAILS
 */
-(NSMutableArray *) getEventDetails: (int) eventID{
	NSString *NSsSql = [NSString stringWithFormat:@"SELECT	gis2raphael_event.name, start_datetime, lat, lon, gis2raphael_event.id as id, end_datetime, gis2raphael_eventcategory.name as cat_name, address_street, address_apt, city, state, zip, phone, url, info, thumb_path FROM	gis2raphael_event inner join gis2raphael_eventcategory on (gis2raphael_event.category_id = gis2raphael_eventcategory.id) where gis2raphael_event.id = %d;", eventID];
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 16];
	
	return returnArray;
}

-(void) deleteFromFavorites: (int) itemID is_business: (int) is_business{
	NSString *NSsSql;
	if (is_business >=1 ) {
		NSsSql = [NSString stringWithFormat:@"delete from favs.favorites where itemID = %d and is_business = 1", itemID];
	} else {
		NSsSql = [NSString stringWithFormat:@"delete from favs.favorites where itemID = %d and is_event = 1", itemID];
	}
	
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	return;
}

-(void) addToFavorites: (int) itemID is_business: (int) is_business{
	[self deleteFromFavorites:itemID is_business:is_business];
	NSString *NSsSql;
	
	if (is_business >=1 ) {
		NSsSql = [NSString stringWithFormat:@"insert into favs.favorites (itemID, is_business) values (%d, 1)", itemID];
	} else {
		NSsSql = [NSString stringWithFormat:@"insert into favs.favorites (itemID, is_event) values (%d, 1)", itemID];
	}
	
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	
	return;
}


/*
 GET IS IN FAVORITES?
 */
-(int) getInFavorites: (int) itemID is_business: (int) is_business{
	NSString *NSsSql;
	if (is_business >=1 ) {
		NSsSql = [NSString stringWithFormat:@"select * from favs.favorites where itemID = %d and is_business = 1", itemID];
	} else {
		NSsSql = [NSString stringWithFormat:@"select * from favs.favorites where itemID = %d and is_event = 1", itemID];
	}

	
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 3];
	
	if ([returnArray count] > 0){
		return 1;
	} else {
		return 0;
	}
}

/*
 GET ALL FAVORITES
 */
-(NSMutableArray *) getAllFavorites: (int) is_business{
	NSString *NSsSql;
	if (is_business >=1 ) {
		NSsSql = @"select itemID, name from favs.favorites inner join gis2raphael_business on (id = itemID) where is_business = 1";
	} else {
		NSsSql = @"select itemID, name from favs.favorites inner join gis2raphael_event on (id = itemID) where is_event = 1";
	}
	
	const char *sSql = [NSsSql UTF8String];
	NSMutableArray *returnArray = [self getArrayFromSQL: sSql num_columns: 2];
	
	return returnArray;
}



- (NSString *) emptyStringForNull: (char *) string_or_null{
	if (string_or_null == NULL)
		return @"";
	else
		return [NSString stringWithUTF8String: string_or_null];
}


-(void) connectDB{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *sqlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"citycircles_data.db"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *filepath = [documentsPath stringByAppendingPathComponent:@"citycircles_data.db"];
	
	//NSLog(filepath);
	if (![fileManager fileExistsAtPath:filepath]){
		[fileManager copyItemAtPath:sqlPath toPath:filepath error:nil];
		
	}
	
	/* make sure the user data database is there in the documents folder */
	NSString *usersqlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"user_data.db.rsd"];
	NSString *userfilepath = [documentsPath stringByAppendingPathComponent:@"user_data.db.rsd"];
	if (![fileManager fileExistsAtPath:userfilepath]){
		[fileManager copyItemAtPath:usersqlPath toPath:userfilepath error:nil];
	}
	/* end copy userdb */
	if (sqlite3_open([filepath UTF8String], &database) == SQLITE_OK){
		is_connected = 1;
	}
	
	/* make sure user db in linked */
	if ([fileManager changeCurrentDirectoryPath: documentsPath] == NO)
	{
		NSLog(@"Directory does not exist – take appropriate action");
	}
	
	sqlite3_exec(database,"ATTACH DATABASE 'user_data.db.rsd' AS 'favs';", NULL, NULL, NULL);
	/*end make-link */
	return;
}

//RUNS THE PASSED SQL STATEMENT AND RETURNS THE RESULTS
-(NSMutableArray *) getArrayFromSQL: (const char *) sSql num_columns: (int) num_columns{
	if (is_connected == 0) {
		[self connectDB];
	}
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	NSMutableArray *tmp_array;
	int x;
			
	sqlite3_stmt *compiledStatement;
	if(sqlite3_prepare_v2(database, sSql, -1, &compiledStatement, NULL) == SQLITE_OK){
		while(sqlite3_step(compiledStatement) == SQLITE_ROW){
			tmp_array = [[NSMutableArray alloc] init];
			if (num_columns == 1) {
				[returnArray addObject: [self emptyStringForNull:(char *) sqlite3_column_text(compiledStatement, 1)]];
			} else {
				for (x = 0; x < num_columns; x++){
					[tmp_array addObject: [self emptyStringForNull:(char *) sqlite3_column_text(compiledStatement, x)]];
				}
					
				[returnArray addObject: tmp_array];
				[tmp_array release]; //add object adds a ref, can release it
			}
		}
	
		sqlite3_finalize(compiledStatement);
	}
		
	
	return returnArray;
}

- (void) closedb{
	sqlite3_close(database);
	return;
}
- (void)dealloc {
	sqlite3_close(database);
    [super dealloc];
}

@end
