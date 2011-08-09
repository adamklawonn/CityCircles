//
//  GlobalMercator.m
//  citycircles
//
//  Created by mjamison on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlobalMercator.h"
#include <math.h>


@implementation GlobalMercator

-(id) initWithTileSize: (int) isize{
	
	if (self = [super init]){
		tileSize = isize;
		initialResolution = 2.0 * M_PI * 6378137 / (double)tileSize;
		originShift = 2 * M_PI * 6378137 / 2.0;
	}
    return self;
}

-(double) Resolution: (int) zoom{
	return initialResolution / pow(2, zoom);
}



-(NSMutableArray*) LatLonToMeters: (double) lat lon: (double) lon{
	double mx = lon * originShift / 180.0;
	double my = log( tan((90 + lat) * M_PI / 360.0 )) / (M_PI / 180.0);
	
	my = my * originShift / 180.0;
	
	return [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithDouble: mx], [NSNumber numberWithDouble: my], nil];
}

-(NSMutableArray*) MetersToLatLon: (double) mx my: (double) my{
	double lon = (mx / originShift) * 180.0;
	double lat = (my / originShift) * 180.0;
	
	lat = 180.0 / M_PI * (2 * atan( exp( lat * M_PI / 180.0)) - M_PI / 2.0);
	
	return [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithDouble: lat], [NSNumber numberWithDouble: lon], nil];
}


-(NSMutableArray*) PixelsToMeters: (int) px py: (int) py zoom: (int) zoom{
	double res = [self Resolution: zoom];
	double mx = px * res - originShift;
	double my = py * res - originShift;
	return [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithDouble: mx], [NSNumber numberWithDouble: my], nil];
}

-(NSMutableArray*) MetersToPixels: (double) mx my: (double) my zoom: (int) zoom{
	double res = [self Resolution: zoom];
	int px = ceil((mx + originShift) / res);
	int py = ceil((my + originShift) / res);
	return [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt: px], [NSNumber numberWithInt: py], nil];
}

-(NSMutableArray*) PixelsToTile: (int) px py: (int) py{
	int tx = (int) ceil( px / (float)tileSize ) - 1;
	int ty = (int) ceil( py / (float)tileSize ) - 1;
	return [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt: tx], [NSNumber numberWithInt: ty], nil];
	//return [[NSMutableArray alloc] initWithObjects: tx, ty, nil];
}

-(NSMutableArray*) GoogleTile: (int) tx ty: (int) ty zoom: (int) zoom{
	return [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt: tx], [NSNumber numberWithInt: (pow(2, zoom) - 1) - ty], nil];
}


@end
