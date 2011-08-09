//
//  EventView.h
//  citycircles
//
//  Created by mjamison on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CSMapRouteLayerView.h"

@interface EventView : UIViewController 
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIWebViewDelegate, MKMapViewDelegate>{
	UITableView *tableView;
	UITableViewCell *basic_info;
	
	int eventID;
	int in_favs;
	NSMutableArray *eventDetails;
	UITableViewCell *basic_cell; //holds the instantiated nib
	UITableViewCell *basic_cell_unfav; //holds the instantiated nib
	UIWebView *thisWebView;
	
	MKMapView *mapView;
	NSMutableArray *mapAnnotations;
	NSMutableArray *points;
	NSMutableArray *northPoints;
	CSMapRouteLayerView* _routeView;
	
	UILabel *Title;
	UILabel *subTitle1;
	UILabel *subTitle2;
	UILabel *subTitle3;
	UIImageView *thisImage;
	UIImageView *favImage;
}

-(id) initWithEventID: (int) evtID;

@property (nonatomic, retain) IBOutlet UILabel *Title;
@property (nonatomic, retain) IBOutlet UILabel *subTitle1;
@property (nonatomic, retain) IBOutlet UILabel *subTitle2;
@property (nonatomic, retain) IBOutlet UILabel *subTitle3;
@property (nonatomic, retain) IBOutlet UIImageView *thisImage;
@property (nonatomic, retain) IBOutlet UIImageView *favImage;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *basic_info;
@property (nonatomic, retain) IBOutlet UITableViewCell *basic_cell;
@property (nonatomic, retain) IBOutlet UITableViewCell *basic_cell_unfav;
@property (nonatomic, retain) IBOutlet UIWebView *thisWebView;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
-(NSString *) getDateFromDateTimeString: (NSString *) sDateTime;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
