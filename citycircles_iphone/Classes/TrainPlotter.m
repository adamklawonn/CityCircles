//
//  TrainPlotter.m
//  citycircles
//
//  Created by mjamison on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrainPlotter.h"
#import "citycirclesAppDelegate.h"
#import "Models.h"

@implementation TrainPlotter


-(id) init{
	if (self = [super init])
    {	
		double MAP_LL_LONG = -112.217;
		double MAP_LL_LAT = 33.339;
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		Models *dbModels = delegate.dbModels;
		[dbModels retain];
		
		LI_SOUTH_STATIONS = [dbModels GetStationsWithinBounds: @"S" ll_lat: MAP_LL_LAT ll_long: MAP_LL_LONG ur_lat: 33.61690 ur_long: -111.77627 ];
		LI_NORTH_STATIONS = [dbModels GetStationsWithinBounds: @"N" ll_lat: MAP_LL_LAT ll_long: MAP_LL_LONG ur_lat: 33.61690 ur_long: -111.77627 ];
		
		
		DCT_SOUTH_SEGMENTS = [[NSMutableDictionary alloc] init];
		DCT_NORTH_SEGMENTS = [[NSMutableDictionary alloc] init];
		
		int station_number;
		NSMutableArray *currentRow;
		NSMutableArray *tmp_segs;
		//GET ALL SOUTH TRACK SEGMENTS
		for (int row = 0; row < [LI_SOUTH_STATIONS count]; row++){
			currentRow = (NSMutableArray *)[LI_SOUTH_STATIONS objectAtIndex: row];
			station_number = [(NSNumber *) [currentRow objectAtIndex: 4] intValue];
			tmp_segs = [dbModels GetStationSegments: station_number];
			int index = [(NSString *)[currentRow objectAtIndex: 1] intValue];
			[DCT_SOUTH_SEGMENTS setObject:tmp_segs forKey: [NSNumber numberWithInt:index]];
			[tmp_segs release];
		}
		
		//GET ALL NORTH TRACK SEGMENTS
		for (int row = 0; row < [LI_NORTH_STATIONS count]; row++){
			currentRow = (NSMutableArray *)[LI_NORTH_STATIONS objectAtIndex: row];
			station_number = [(NSNumber *) [currentRow objectAtIndex: 4] intValue];
			tmp_segs = [dbModels GetStationSegments: station_number];
			int index = [(NSString *)[currentRow objectAtIndex: 1] intValue];
			[DCT_NORTH_SEGMENTS setObject:tmp_segs forKey: [NSNumber numberWithInt:index]];
			[tmp_segs release];
		}
		
		
		//GET THE SCHEDULES
		//direction, \"index\", arrival_time
		
		NSDate *today = [NSDate date];
		NSCalendar *gregorian = [[NSCalendar alloc]
								 initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *weekdayComponents =
		[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
		NSInteger day = [weekdayComponents day];
		NSInteger weekday = [weekdayComponents weekday];
		
		weekday = weekday - 1;
		if (weekday == 0) {
			weekday = 7;
		} //mon = 1, sunday = 7
		
		//direction, \"index\", arrival_time
		NSMutableArray *LI_TRAINS_SCHEDULE = [dbModels getTrainSchedules: weekday];
		
		NSMutableArray *tmp_array;
		southTrainSchedule = [[NSMutableDictionary alloc] init];
		northTrainSchedule = [[NSMutableDictionary alloc] init];
		int this_index;
		NSString *s_this_idex;
		
		for (int row=0; row < [LI_TRAINS_SCHEDULE count]; row++) {
			currentRow = [LI_TRAINS_SCHEDULE objectAtIndex: row];
			NSString *thistime = (NSString *)[currentRow objectAtIndex: 2];
			
			NSMutableString *thisMtime = [NSMutableString stringWithString:thistime];
			[thisMtime replaceOccurrencesOfString:@":" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [thistime length])];
			
			int itime = [thisMtime intValue];
			
			
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
			[tmp_array addObject: [NSNumber numberWithInt: itime]];
		}
		
		[LI_TRAINS_SCHEDULE release];
		
		[dbModels release];
    }
    return self;
}

-(double) getSegmentLength: (NSMutableArray *) this_segments{
	double total_length = 0.0;
	
	if ([this_segments count] <= 1){
		return 0.0;
	}
	NSMutableArray *this_seg = (NSMutableArray*) [this_segments objectAtIndex:0];
	double prev_lat = [(NSNumber *)[this_seg objectAtIndex: 1] doubleValue];
	double prev_lon = [(NSNumber *)[this_seg objectAtIndex: 2] doubleValue];
	
	double curr_lat;
	double curr_lon;
	
	double lat_diff;
	double lon_diff;
	
	double curr_distance;
	for(int x = 1; x < [this_segments count]; x++){
		this_seg = (NSMutableArray*) [this_segments objectAtIndex:x];
		double curr_lat = [(NSNumber *)[this_seg objectAtIndex: 1] doubleValue];
		double curr_lon = [(NSNumber *)[this_seg objectAtIndex: 2] doubleValue];
		
		lat_diff = curr_lat - prev_lat;
		lon_diff = curr_lon - prev_lon;
		
		curr_distance = sqrt( pow(lat_diff, 2.0) + pow(lon_diff, 2.0)); 
		
		total_length += curr_distance;
		prev_lat = curr_lat;
		prev_lon = curr_lon;
	}
	return total_length;
}

-(NSArray*) getPointAtLength: (NSMutableArray *) this_segments distance: (double) distance{
	
	if ([this_segments count] <= 1){
		return [NSArray arrayWithObjects:nil];
	}
				
	NSMutableArray *this_seg = (NSMutableArray*) [this_segments objectAtIndex:0];
	double prev_lat = [(NSNumber *)[this_seg objectAtIndex: 1] doubleValue];
	double prev_lon = [(NSNumber *)[this_seg objectAtIndex: 2] doubleValue];
	
	double curr_lat;
	double curr_lon;
	
	double lat_diff;
	double lon_diff;
	
	double curr_distance;
	for(int x = 1; x < [this_segments count]; x++){
		this_seg = (NSMutableArray*) [this_segments objectAtIndex:x];
		double curr_lat = [(NSNumber *)[this_seg objectAtIndex: 1] doubleValue];
		double curr_lon = [(NSNumber *)[this_seg objectAtIndex: 2] doubleValue];
		
		lat_diff = curr_lat - prev_lat;
		lon_diff = curr_lon - prev_lon;
		
		curr_distance = sqrt( pow(lat_diff, 2.0) + pow(lon_diff, 2.0)); 
		
		distance -= curr_distance;
		prev_lat = curr_lat;
		prev_lon = curr_lon;
		if (distance <= 0) {
			break; //this is my point
		}
	}
	return [NSArray arrayWithObjects:[NSNumber numberWithDouble: prev_lat], [NSNumber numberWithDouble: prev_lon], nil];
}

-(int) get_next_arrival_time: (NSString *) direction index: (int) index{
	/*
	 //JAVASCRIPT VERSION
	 closest_time = new Date(new Date().toDateString() + ' ' + '23:59:59');
	 if (direction == "S"){
	 var this_schedule = dct_south_schedules;
	 } else {
	 var this_schedule = dct_north_schedules;
	 } 
	 var arScheds = this_schedule[index.toString()];
	 
	 if (arScheds == undefined){
	 arScheds = [];
	 }
	 var this_time;
	 for (x = 0; x < arScheds.length; x++){
	 this_time = new Date(new Date().toDateString() + ' ' + arScheds[x][2]);
	 if (this_time > now){
	 if ((this_time - now) < (closest_time - now)){
	 closest_time = this_time;
	 }
	 }
	 }
	 if ((closest_time - new Date(new Date().toDateString() + ' ' + '23:59:59')) == 0){
	 return null;
	 }
	 return closest_time;
	 */
	
	NSDate *now = [NSDate date];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
	
	int inow = ([timeComponents hour] * 10000) + ([timeComponents minute] * 100) + [timeComponents second];
	
	int closest_time = 245959;
	NSString *s_this_index = [NSString stringWithFormat:@"%d", index];
	NSMutableArray *this_schedule; 
	if ([direction isEqualToString:@"S"]) {
		this_schedule = [southTrainSchedule objectForKey: s_this_index];
	} else {
		this_schedule = [northTrainSchedule objectForKey: s_this_index];
	}
	
	int check_time;
	for (int x = 0; x < [this_schedule count]; x++) {
		//direction, \"index\", arrival_time
		check_time = [(NSNumber *)[(NSMutableArray *) this_schedule objectAtIndex: x] intValue];
		
		if (inow < check_time){
			if ((check_time - inow) < (closest_time - inow)){
				closest_time = check_time;
			}
		}
	}
	return closest_time;
	
	/*
	NSDate *closest_time = [NSDate distantFuture];
	NSString *s_this_index = [NSString stringWithFormat:@"%d", index];
	NSMutableArray *this_schedule; 
	if ([direction isEqualToString:@"S"]) {
		this_schedule = [southTrainSchedule objectForKey: s_this_index];
	} else {
		this_schedule = [northTrainSchedule objectForKey: s_this_index];
	}
	
	NSMutableArray *this_sched;
	for (int x = 0; x < [this_schedule count]; x++) {
		//direction, \"index\", arrival_time
		this_sched = [(NSMutableArray *) this_schedule objectAtIndex: x];
		NSString *this_time = [this_sched objectAtIndex:2];
		NSDate *this_date = [NSDate dateWithNaturalLanguageString: this_time];
		
		if ([now compare: this_date] == NSOrderedAscending){
			//if ((this_date - now) < (closest_time - now)){
			if (([this_date timeIntervalSinceDate:now]) < ([closest_time timeIntervalSinceDate:now])){
				closest_time = this_date;
			}
		}
	}
	return closest_time;
	 */
}


/*
 function get_prev_station_time(direction, index, next_station_time){
 closest_time = new Date(new Date().toDateString() + ' ' + '00:00:00');
 if (direction == "S"){
 var this_schedule = dct_south_schedules;
 } else {
 var this_schedule = dct_north_schedules;
 } 
 var arScheds = this_schedule[index.toString()];
 if (arScheds == undefined){
 arScheds = [];
 }
 var this_time;
 for (x = 0; x < arScheds.length; x++){
 this_time = new Date(new Date().toDateString() + ' ' + arScheds[x][2]);
 if (this_time < next_station_time){
 if ((next_station_time - this_time) < (next_station_time - closest_time)){
 closest_time = this_time;
 }
 }
 }
 
 if ((closest_time - new Date(new Date().toDateString() + ' ' + '00:00:00')) == 0){
 return null;
 }
 return closest_time;
 }
 */

-(int) get_prev_station_time: (NSString *) direction index: (int) index next_station_time: (int)next_station_time{
	NSDate *now = [NSDate date];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
	
	int inow = ([timeComponents hour] * 10000) + ([timeComponents minute] * 100) + [timeComponents second];
	
	int closest_time = 0;
	NSString *s_this_index = [NSString stringWithFormat:@"%d", index];
	NSMutableArray *this_schedule; 
	if ([direction isEqualToString:@"S"]) {
		this_schedule = [southTrainSchedule objectForKey: s_this_index];
	} else {
		this_schedule = [northTrainSchedule objectForKey: s_this_index];
	}
	
	int check_time;
	for (int x = 0; x < [this_schedule count]; x++) {
		//direction, \"index\", arrival_time
		check_time = [(NSNumber *)[(NSMutableArray *) this_schedule objectAtIndex: x] intValue];
		
		if (next_station_time > check_time){
			if ((next_station_time - check_time) < (next_station_time - closest_time)){
				closest_time = check_time;
			}
		}
	}
	return closest_time;
	
	/*
	NSDate *now = [NSDate date];
	NSDate *closest_time = [NSDate distantPast];
	NSString *s_this_index = [NSString stringWithFormat:@"%d", index];
	NSMutableArray *this_schedule; 
	if ([direction isEqualToString:@"S"]) {
		this_schedule = [southTrainSchedule objectForKey: s_this_index];
	} else {
		this_schedule = [northTrainSchedule objectForKey: s_this_index];
	}
	
	NSMutableArray *this_sched;
	for (int x = 0; x < [this_schedule count]; x++) {
		//direction, \"index\", arrival_time
		this_sched = [(NSMutableArray *) this_schedule objectAtIndex: x];
		NSString *this_time = [this_sched objectAtIndex:2];
		NSDate *this_date = [NSDate dateWithNaturalLanguageString: this_time];
		
		if ([next_station_time compare: this_date] == NSOrderedDescending){   //LESS THAN NEXT TIME
			if (([next_station_time timeIntervalSinceDate:this_date]) < ([next_station_time timeIntervalSinceDate:closest_time])){
				closest_time = this_date;
			}
		}
	}
	return closest_time;
	 */
}

-(NSMutableArray *) get_current_trains: (NSString *)direction{
	
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	NSArray *station_indexes;
	NSMutableDictionary *this_seg_dict;
	
	if ([direction isEqualToString:@"S"]) {
		station_indexes = [DCT_SOUTH_SEGMENTS allKeys];
		this_seg_dict = DCT_SOUTH_SEGMENTS;
	} else {
		station_indexes = [DCT_NORTH_SEGMENTS allKeys];
		this_seg_dict = DCT_NORTH_SEGMENTS;
	}
	
	for (NSNumber* key in station_indexes) {
		int nxt_time = [self get_next_arrival_time: direction index: [key intValue]];
		int prev_time = [self get_prev_station_time: direction index: [key intValue] - 1 next_station_time: nxt_time];
		
		if ((nxt_time == 245959) || (prev_time == 0)) {
			continue;
		}
		
		NSDate *now = [NSDate date];
		
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
		
		int inow = ([timeComponents hour] * 10000) + ([timeComponents minute] * 100) + [timeComponents second];
		
		if (inow > prev_time && inow < nxt_time){
			//GET THE SEGMENT
			
			NSMutableArray *this_segs = [this_seg_dict objectForKey:key];
			
			double path_length = [self getSegmentLength: this_segs];
			
			double perc_to_go = nxt_time - inow / nxt_time - prev_time;
			double length_to_go = path_length * perc_to_go;
			double length_complete = path_length - length_to_go;
			
			
			/*
			NSMutableArray *this_seg = [this_segs objectAtIndex: 0];
			
			NSNumber * prev_lat = (NSNumber *)[this_seg objectAtIndex: 1];
			NSNumber * prev_lon = (NSNumber *)[this_seg objectAtIndex: 2];
			
			[returnArray addObject: [NSArray arrayWithObjects: prev_lat, prev_lon, nil]];
			 */
			NSMutableArray *this_seg = [self getPointAtLength: this_segs distance: length_complete];
			if ([this_seg count] == 2) {
				[returnArray addObject: this_seg];
			}
			
			
		}
	}
	return returnArray;
}



- (void)dealloc {
	[LI_SOUTH_STATIONS release];
	[LI_NORTH_STATIONS release];
	[DCT_SOUTH_SEGMENTS release];
	[DCT_NORTH_SEGMENTS release];
	[southTrainSchedule release];
	[northTrainSchedule release];
    [super dealloc];
}

@end
