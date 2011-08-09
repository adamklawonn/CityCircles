//
//  CSMapRouteLayerView.m
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CSMapRouteLayerView.h"
#import "MyAnnotation.h"
#import "EventView.h"
#import "citycirclesAppDelegate.h"
#import "StationInfoMainViewController.h"


@implementation CSMapRouteLayerView
@synthesize mapView   = _mapView;
@synthesize points    = _points;
@synthesize lineColor = _lineColor;
@synthesize northPoints = _northPoints;
@synthesize popups;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize routeNorthLine = _routeNorthLine;
@synthesize routeNorthLineView = _routeNorthLineView;

-(id) initWithRoute:(NSArray*)routePoints mapView:(MKMapView*)mapView
{
	self = [super initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
	[self setBackgroundColor:[UIColor clearColor]];
	
	[self setMapView:mapView];
	
	_points = [(NSArray *) [routePoints objectAtIndex: 0] retain];
	_northPoints = [(NSArray *) [routePoints objectAtIndex: 1] retain];
	
	//[self setPoints:routePoints];
	
	[self.mapView setDelegate:self];
	//[self.mapView addSubview:self];
	
	[self drawLines];
	// add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
	}
	if (nil != self.routeNorthLine) {
		[self.mapView addOverlay:self.routeNorthLine];
	}
	
	return self;
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}

-(void) drawLines{
	MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
	for (int x = 0; x < _points.count; x++) {
		CLLocation* location = [_points objectAtIndex:x];
		MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
		pointArr[x] = point;
	}
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count:_points.count];
	
	
	MKMapPoint* pointNorthArr = malloc(sizeof(CLLocationCoordinate2D) * _northPoints.count);
	for (int x = 0; x < _northPoints.count; x++) {
		CLLocation* location = [_northPoints objectAtIndex:x];
		MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
		pointNorthArr[x] = point;
	}
	self.routeNorthLine = [MKPolyline polylineWithPoints:pointNorthArr count:_northPoints.count];
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now. 
		if(nil == self.routeLineView)
		{
			self.routeLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
			self.routeLineView.fillColor = [UIColor colorWithRed:0.17578125 green:0.30859375 blue:0.56640625 alpha:1.0];
			self.routeLineView.strokeColor = [UIColor colorWithRed:0.42578125 green:0.1328125 blue:0.52734375 alpha:1.0];
			self.routeLineView.lineWidth = 3;
		}
		
		overlayView = self.routeLineView;
		
	} else if (overlay == self.routeNorthLine) {
		//if we have not yet created an overlay view for this overlay, create it now. 
		if(nil == self.routeNorthLineView)
		{
			self.routeNorthLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeNorthLine] autorelease];
			self.routeNorthLineView.fillColor = [UIColor colorWithRed:0.17578125 green:0.30859375 blue:0.56640625 alpha:1.0];
			self.routeNorthLineView.strokeColor = [UIColor colorWithRed:0.42578125 green:0.1328125 blue:0.52734375 alpha:1.0];
			self.routeNorthLineView.lineWidth = 3;
		}
		
		overlayView = self.routeNorthLineView;
	}
	
	return overlayView;
	
}

- (void)drawRect:(CGRect)rect
{
	// only draw our lines if we're not int he moddie of a transition and we 
	// acutally have some points to draw. 
	if(!self.hidden && nil != self.points && self.points.count > 0)
	{
		CGContextRef context = UIGraphicsGetCurrentContext(); 
		
		if(nil == self.lineColor)
			self.lineColor = [UIColor blueColor];
		
		//CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
		//CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
		CGContextSetRGBStrokeColor(context, 0.42578125, 0.1328125, 0.52734375, 0.6);
		CGContextSetRGBFillColor(context, 0.17578125, 0.30859375, 0.56640625, 0.6);

		// Draw them with a 2.0 stroke width so they are a bit more visible.
		CGContextSetLineWidth(context, 4.0);
		
		for(int idx = 0; idx < self.points.count; idx++)
		{
			CLLocation* location = [self.points objectAtIndex:idx];
			CGPoint point = [_mapView convertCoordinate:location.coordinate toPointToView:self];
			
			if(idx == 0)
			{
				// move to the first point
				CGContextMoveToPoint(context, point.x, point.y);
			}
			else
			{
				CGContextAddLineToPoint(context, point.x, point.y);
			}
		}
		
		CGContextStrokePath(context);
	}
	
	if(!self.hidden && nil != self.northPoints && self.northPoints.count > 0)
	{
		CGContextRef context = UIGraphicsGetCurrentContext(); 
		
		if(nil == self.lineColor)
			self.lineColor = [UIColor blueColor];
		
		//CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
		//CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
		CGContextSetRGBStrokeColor(context, 0.42578125, 0.1328125, 0.52734375, 0.6);
		CGContextSetRGBFillColor(context, 0.17578125, 0.30859375, 0.56640625, 0.6);
		
		// Draw them with a 2.0 stroke width so they are a bit more visible.
		CGContextSetLineWidth(context, 4.0);
		
		for(int idx = 0; idx < self.northPoints.count; idx++)
		{
			CLLocation* location = [self.northPoints objectAtIndex:idx];
			CGPoint point = [_mapView convertCoordinate:location.coordinate toPointToView:self];
			
			if(idx == 0)
			{
				// move to the first point
				CGContextMoveToPoint(context, point.x, point.y);
			}
			else
			{
				CGContextAddLineToPoint(context, point.x, point.y);
			}
		}
		
		CGContextStrokePath(context);
	}
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
	//NSLog(NSStringFromClass([annotation class]));
	
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
	}
    
    // handle our two custom annotations
    //
	if ([annotation isKindOfClass:[MyAnnotation class]]){
		
		//MyAnnotation *this_annotation = (MyAnnotation *) this_annotation;
		if ([[annotation getType] isEqualToString:@"event"])
		{
			// try to dequeue an existing pin view first
			static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
			MKPinAnnotationView* pinView = (MKPinAnnotationView *)
			[_mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
			if (!pinView)
			{
				// if an existing pin view was not available, create one
				MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
													   initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
				customPinView.pinColor = MKPinAnnotationColorPurple;
				customPinView.animatesDrop = YES;
				customPinView.canShowCallout = YES;
				
				// add a detail disclosure button to the callout which will open a new view controller page
				//
				// note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
				//  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
				//
				
				UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				
				MyAnnotation *this_annotation = (MyAnnotation *) annotation;
				if (this_annotation.theID >0) {
					rightButton.tag = this_annotation.theID;
					[rightButton addTarget:self
					action:@selector(showDetails:)
					forControlEvents:UIControlEventTouchUpInside];
					customPinView.rightCalloutAccessoryView = rightButton;
				} 
				return customPinView;
			}
			else
			{
				pinView.annotation = annotation;
			}
			return pinView;
		} else if ([[annotation getType] isEqualToString:@"station"]) {
			static NSString* SFAnnotationIdentifier = @"SFAnnotationIdentifier";
			MKPinAnnotationView* pinView =
            (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
			if (!pinView)
			{
				MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
																				 reuseIdentifier:SFAnnotationIdentifier] autorelease];
				annotationView.canShowCallout = YES;
				
				UIImage *flagImage = [UIImage imageNamed:@"ico-gmap-s.png"];
				
				CGRect resizeRect;
				
				resizeRect.size = flagImage.size;
				CGSize maxSize = CGRectInset(self.bounds,
											 10.0f,
											 10.0f).size;
				//maxSize.height -= self.navigationController.navigationBar.frame.size.height + 40.0f;
				if (resizeRect.size.width > maxSize.width)
					resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
				if (resizeRect.size.height > maxSize.height)
					resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
				
				resizeRect.origin = (CGPoint){0.0f, 0.0f};
				UIGraphicsBeginImageContext(resizeRect.size);
				[flagImage drawInRect:resizeRect];
				UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();
				
				annotationView.image = resizedImage;
				annotationView.opaque = NO;
				
				UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				
				MyAnnotation *this_annotation = (MyAnnotation *) annotation;
				if (this_annotation.theID >0) {
					rightButton.tag = this_annotation.theID;
					[rightButton addTarget:self
									action:@selector(showStationDetails:)
						  forControlEvents:UIControlEventTouchUpInside];
					annotationView.rightCalloutAccessoryView = rightButton;
				} 
				
				
				/*
				 UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
				 annotationView.leftCalloutAccessoryView = sfIconView;
				 [sfIconView release];
				 */	
				return annotationView;
			}
			else
			{
				pinView.annotation = annotation;
			}
			return pinView;
		} else if ([[annotation getType] isEqualToString:@"train_west"] || [[annotation getType] isEqualToString:@"train_east"]) {
			
			
			static NSString* SFAnnotationIdentifier;
			if ([[annotation getType] isEqualToString:@"train_west"]) {
				SFAnnotationIdentifier = @"TWAnnotationIdentifier";
			} else {
				SFAnnotationIdentifier = @"TEAnnotationIdentifier";
			}

			
			MKPinAnnotationView* pinView =
            (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
			if (!pinView)
			{
				MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
																				 reuseIdentifier:SFAnnotationIdentifier] autorelease];
				annotationView.canShowCallout = YES;
				UIImage *flagImage;
				if ([[annotation getType] isEqualToString:@"train_west"]) {
					flagImage = [UIImage imageNamed:@"train-west.png"];
				} else {
					flagImage = [UIImage imageNamed:@"train-east.png"];
				}

				
				
				CGRect resizeRect;
				
				
				resizeRect.size = CGSizeMake(18.0, 36.0);
				
				
				/*
				resizeRect.size = flagImage.size;
				CGSize maxSize = CGRectInset(self.bounds,
											 10.0f,
											 10.0f).size;
				//maxSize.height -= self.navigationController.navigationBar.frame.size.height + 40.0f;
				if (resizeRect.size.width > maxSize.width)
					resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
				if (resizeRect.size.height > maxSize.height)
					resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
				*/
				/*
				resizeRect.origin = (CGPoint){0.0f, 0.0f};
				UIGraphicsBeginImageContext(resizeRect.size);
				[flagImage drawInRect:resizeRect];
				UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();
				*/
				annotationView.image = flagImage;
				annotationView.opaque = NO;
				
				UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				
				MyAnnotation *this_annotation = (MyAnnotation *) annotation;
				if (this_annotation.theID >0) {
					rightButton.tag = this_annotation.theID;
					[rightButton addTarget:self
									action:@selector(showStationDetails:)
						  forControlEvents:UIControlEventTouchUpInside];
					annotationView.rightCalloutAccessoryView = rightButton;
				} 
				
				
				/*
				 UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
				 annotationView.leftCalloutAccessoryView = sfIconView;
				 [sfIconView release];
				 */	
				return annotationView;
			}
			else
			{
				pinView.annotation = annotation;
			}
			return pinView;
		}

	}
    else {
		return nil;
	}

}


- (void)showDetails:(id)sender
{
    // the detail view does not want a toolbar so hide it
    //[self.navigationController setToolbarHidden:YES animated:NO];
	UIButton* btn = (UIButton *) sender;
	
	EventView *thisView = [[EventView alloc] initWithEventID: btn.tag];
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: thisView animated: YES];
	[thisView release];
}

- (void)showStationDetails:(id)sender
{
    // the detail view does not want a toolbar so hide it
    //[self.navigationController setToolbarHidden:YES animated:NO];
	UIButton* btn = (UIButton *) sender;
	
	StationInfoMainViewController *thisView = [[StationInfoMainViewController alloc] initWithStationID: btn.tag];
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: thisView animated: YES];
	[thisView release];
}

#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition. 
	self.hidden = YES;
	mapView.showsUserLocation = YES;
	//[self setNeedsDisplay];
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display. 
	self.hidden = NO;
	[self setNeedsDisplay];
}


-(void) dealloc
{
	[_points release];
	[_mapView release];
	[super dealloc];
}

@end
