//
//  HtmlGenerator.h
//  citycircles
//
//  Created by mjamison on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalMercator.h"
#import "Models.h"


@interface HtmlGenerator : NSObject {
	GlobalMercator * mercator;
	int HEIGHT;
	int WIDTH;
	double MAP_LL_LONG;
	double MAP_LL_LAT;
	
	int prop_curr_zl;
	int prop_n_ll_w_x;
	int prop_n_ll_w_y;
	//to_zl origin_x: n_ll_w_x origin_y: n_ll_w_y
	
	NSMutableArray *LI_NORTH_STATIONS;
	NSMutableArray *LI_SOUTH_STATIONS;
	
	NSMutableArray *LI_NORTH_SEGMENTS;
	NSMutableArray *LI_SOUTH_SEGMENTS;
	
	NSMutableDictionary *DCT_NORTH_SEGMENTS;
	NSMutableDictionary *DCT_SOUTH_SEGMENTS;
	
	NSMutableArray *LI_TRAINS_SCHEDULE;
	
	NSMutableArray *DCT_TRAIN_SCHEDULE;
	
	NSMutableDictionary *southTrainSchedule;
	
	NSMutableDictionary *northTrainSchedule;
	
	NSMutableArray *LI_ALL_EVENTS;
	
	Models * dbModels;
	

}

-(id) init;
-(void) processStationList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y;
-(NSString *) getHTML: (int) from_zl to_zl: (int) to_zl center_x: (int) center_x center_y: (int) center_y from_origin_x: (int) from_origin_x from_origin_y: (int) from_origin_y;
-(void) processSegPointList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y;
-(NSString *) getBizHTML: (int) bizID;
-(NSMutableArray*) newProcessStationList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y;
-(NSMutableArray *) newProcessSegPointList: (NSMutableArray *) in_array zl: (int) zl origin_x: (int) origin_x origin_y: (int) origin_y;
-(NSMutableArray *) processLatLong: (double) Lat Lon:(double) Lon;
-(NSString *) getEventHTML: (int) evtID;
-(void) logTime;
@end

