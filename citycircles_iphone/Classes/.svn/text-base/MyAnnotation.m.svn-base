//
//  MyAnnotation.m
//  citycircles
//
//  Created by mjamison on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize theID;

-(id) initWithData: (NSString *) sTitle subtitle: (NSString *) sSubTitle lat: (double) dLat lon: (double) dLon typeName: (NSString *)typeName{
	if (self = [super init])
    {	
		lat = dLat;
		lon = dLon;
		this_title = [sTitle retain];
		this_subtitle = [sSubTitle retain];
		
		typeofMarker = [typeName retain];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = lat;
    theCoordinate.longitude = lon;
    return theCoordinate; 
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return this_title;
}

// optional
- (NSString *)subtitle
{
    return this_subtitle;
}

-(NSString *) getType{
	return typeofMarker;
}

- (void)dealloc
{
	[this_title release];
	[this_subtitle release];
	[typeofMarker release];
    [super dealloc];
}

@end