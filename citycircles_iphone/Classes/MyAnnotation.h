//
//  MyAnnotation.h
//  citycircles
//
//  Created by mjamison on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>
{
	double lat;
	double lon;
	NSString *this_title;
	NSString *this_subtitle;
	NSString *typeofMarker;
	int theID;
	
	
	
}

-(id) initWithData: (NSString *) sTitle subtitle: (NSString *) sSubTitle lat: (double) dLat lon: (double) dLon typeName: (NSString *)typeName;

-(NSString *) getType;
@property int theID;

@end