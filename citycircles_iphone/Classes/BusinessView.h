//
//  BusinessView.h
//  citycircles
//
//  Created by mjamison on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CSMapRouteLayerView.h"


@interface BusinessView : UIViewController 
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIWebViewDelegate>{
	UITableView *tableView;
	UITableViewCell *basic_info;
	
	int businessID;
	int in_favs;
	NSMutableArray *bizDetails;
	UITableViewCell *basic_cell; //holds the instantiated nib
	UIWebView *thisWebView;
	
	MKMapView *mapView;
	NSMutableArray *mapAnnotations;
	NSMutableArray *points;
	NSMutableArray *northPoints;
	CSMapRouteLayerView* _routeView;
	
	UILabel *Title;
	UILabel *subTitle1;
	UILabel *subTitle2;
	UIImageView *thisImage;
	UIImageView *favImage;
	
	
}

-(id) initWithBizID: (int) bizID;
@property (nonatomic, retain) IBOutlet UILabel *Title;
@property (nonatomic, retain) IBOutlet UILabel *subTitle1;
@property (nonatomic, retain) IBOutlet UILabel *subTitle2;
@property (nonatomic, retain) IBOutlet UIImageView *thisImage;
@property (nonatomic, retain) IBOutlet UIImageView *favImage;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *basic_info;
@property (nonatomic, retain) IBOutlet UITableViewCell *basic_info_unfav;
@property (nonatomic, retain) IBOutlet UITableViewCell *basic_cell;
@property (nonatomic, retain) IBOutlet UIWebView *thisWebView;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
