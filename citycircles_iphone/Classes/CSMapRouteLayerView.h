//
//  CSMapRouteLayerView.h
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CSMapRouteLayerView : UIView <MKMapViewDelegate>
{
	MKMapView* _mapView;
	NSArray* _points;
	NSArray* _northPoints;
	UIColor* _lineColor;
	BOOL popups;
	// the data representing the route points. 
	MKPolyline* _routeLine;
	MKPolyline* _routeNorthLine;
	
	
	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
	MKPolylineView* _routeNorthLineView;
}

-(id) initWithRoute:(NSArray*)routePoints mapView:(MKMapView*)mapView;

@property (nonatomic, retain) NSArray* points;
@property (nonatomic, retain) NSArray* northPoints;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) UIColor* lineColor; 
@property BOOL popups;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolyline* routeNorthLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic, retain) MKPolylineView* routeNorthLineView;

- (void)showStationDetails:(id)sender;
- (void)showDetails:(id)sender;
-(void) drawLines;

@end
