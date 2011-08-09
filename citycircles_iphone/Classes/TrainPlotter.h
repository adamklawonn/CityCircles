//
//  TrainPlotter.h
//  citycircles
//
//  Created by mjamison on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TrainPlotter : NSObject {
	NSMutableArray *LI_SOUTH_STATIONS;
	NSMutableArray *LI_NORTH_STATIONS;
	NSMutableDictionary *DCT_SOUTH_SEGMENTS;
	NSMutableDictionary *DCT_NORTH_SEGMENTS;
	NSMutableDictionary *southTrainSchedule;
	NSMutableDictionary *northTrainSchedule;
}
-(double) getSegmentLength: (NSMutableArray *) this_segments;
-(NSArray*) getPointAtLength: (NSMutableArray *) this_segments distance: (double) distance;
-(int) get_next_arrival_time: (NSString *) direction index: (int) index;
-(int) get_prev_station_time: (NSString *) direction index: (int) index next_station_time: (int)next_station_time;
-(NSMutableArray *) get_current_trains: (NSString *)direction;


@end
