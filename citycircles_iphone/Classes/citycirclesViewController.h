//
//  citycirclesViewController.h
//  citycircles
//
//  Created by mjamison on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//#import "MyUIWebView.h"
#import "CSMapRouteLayerView.h"
#import "FavoritesViewController.h"
#import "TrainPlotter.h"


extern NSString * const GET_DB_URL;
extern NSString * const DB_FILE_URL;

@interface citycirclesViewController : UIViewController 
<UIWebViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>{
	//UIWebView *thiswebView;
	UIWebView *thiswebView;
	UIActivityIndicatorView *indicatorView;
	NSMutableData *responseData;
	NSURLResponse *thisResponse;
	UIAlertView *alert;
	HtmlGenerator * mygenerator;
	
	//I know this is the most confusing thing ever, sorry!
	NSString *currentURL;
	NSString *currentUrl;
	
	UIButton *btnHome;
	UIButton *btnBiz;
	UIButton *btnItin;
	UIButton *btnFavs;
	UIButton *startOver;
	//HtmlGenerator * mygenerator;
	
	//DATA FOR THE LOCATION DATA
	CLLocationManager *locationManager;
    CLLocation *mycurrentLocation;
	
	double curLats;
    double curLons;
    BOOL locationDidUpdate;
	BOOL locationUpdateFailed;
	
	//JUST USED FOR THE MAPKIT MAP
	MKMapView *mapView;
	NSMutableArray *mapAnnotations;
	NSMutableArray *points;
	NSMutableArray *northPoints;
	NSMutableArray *currTrains;
	TrainPlotter *plotter;
	
	CSMapRouteLayerView* _routeView;
	
	
}

@property (nonatomic, retain) IBOutlet UIWebView *thiswebView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UIButton *btnHome;
@property (nonatomic, retain) IBOutlet UIButton *btnBiz;
@property (nonatomic, retain) IBOutlet UIButton *btnItin;
@property (nonatomic, retain) IBOutlet UIButton *btnFavs;
@property (nonatomic, retain) IBOutlet UIButton *startOver;
@property (nonatomic, assign) double curLats;
@property (nonatomic, assign) double curLons;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CSMapRouteLayerView* routeView;


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (IBAction)launchStartOver:(id) sender;
- (void)zoomToFitMapAnnotations:(MKMapView*)mapView;
- (void)get_trains:(NSTimer *)timer;

@end

