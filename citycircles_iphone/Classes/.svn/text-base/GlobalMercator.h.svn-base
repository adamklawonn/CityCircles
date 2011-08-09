//
//  GlobalMercator.h
//  citycircles
//
//  Created by mjamison on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalMercator : NSObject {
	int tileSize;
	double initialResolution;
	double originShift;
}

-(id) initWithTileSize: (int) isize;
-(double) Resolution: (int) zoom;

-(NSMutableArray*) LatLonToMeters: (double) lat lon: (double) lon;
-(NSMutableArray*) MetersToLatLon: (double) mx my: (double) my;
-(NSMutableArray*) PixelsToMeters: (int) px py: (int) py zoom: (int) zoom;
-(NSMutableArray*) MetersToPixels: (double) mx my: (double) my zoom: (int) zoom;
-(NSMutableArray*) PixelsToTile: (int) px py: (int) py;

-(NSMutableArray*) MetersToTile: (double) mx my: (double) my zoom: (int) zoom;
-(NSMutableArray*) GoogleTile: (int) tx ty: (int) ty zoom: (int) zoom;

@end
