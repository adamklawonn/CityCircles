//
//  citycirclesViewController.m
//  citycircles
//
//  Created by mjamison on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "citycirclesViewController.h"
//#import "MyWebView.h";
#import "HtmlGenerator.h"
#import <CoreLocation/CoreLocation.h>
#import "EventView.h"
#import "citycirclesAppDelegate.h"
#import "MapKitAnnotationProvider.h"
#import "MyAnnotation.h"
#import "CSMapRouteLayerView.h"
#import "TrainPlotter.h"


NSString * const GET_DB_URL = @"http://iphone.citycircles.com/get_db_date/";
NSString * const DB_FILE_URL = @"http://iphone.citycircles.com/static/citycircles_data.db";
NSString * const GOOGLE_MAP = @"http://iphone.citycircles.com/google_map/";


/*
NSString * const GET_DB_URL = @"http://192.168.0.2:8001/get_db_date/";
NSString * const DB_FILE_URL = @"http://192.168.0.2:8001/static/citycircles_data.db";
NSString * const GOOGLE_MAP = @"http://192.168.0.2:8001/google_map/";
*/

@implementation citycirclesViewController

@synthesize thiswebView;
@synthesize indicatorView;
@synthesize btnHome;
@synthesize btnBiz;
@synthesize btnItin;
@synthesize btnFavs;
@synthesize startOver;
@synthesize curLats;
@synthesize curLons;
@synthesize mapView;
@synthesize routeView = _routeView;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(IBAction)launchStartOver:(id) sender{
	NSURL *url = [NSURL URLWithString:@"/load/"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[self.thiswebView loadRequest:requestObj];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSURL *url = [NSURL URLWithString:@"http://www.simplimation.com/dev/cc/"];
	//NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//[self.thiswebView loadRequest:requestObj];
	//mygenerator = [[HtmlGenerator alloc] init];
	self.curLats = 0.0;
	self.curLons = 0.0;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath: path];
	
	if (0) {
		NSURL *url = [NSURL URLWithString:GOOGLE_MAP];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[self.thiswebView loadRequest:requestObj];
	}
	
	if (0) {
		NSURL *url = [NSURL URLWithString:@"/load/"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[self.thiswebView loadRequest:requestObj];
	}
	
	if (1){
		mapView.showsUserLocation = YES;
		
		MapKitAnnotationProvider *this_provider = [[MapKitAnnotationProvider alloc] init];
		mapAnnotations = [this_provider get_Events];
		
		NSMutableArray *tmp_array;
		NSNumber * key;
		NSArray * southKeys = (NSArray *)[this_provider.DCT_SOUTH_SEGMENTS allKeys];
		
		points = [[NSMutableArray alloc] init];
		
		
		for (int row=0; row < [this_provider.LI_SOUTH_POINTS count]; row++){
			NSMutableArray *tmp_segs = (NSMutableArray *)[this_provider.LI_SOUTH_POINTS objectAtIndex: row];
			double lat = [(NSNumber *) [tmp_segs objectAtIndex: 1] doubleValue];
			double lon = [(NSNumber *) [tmp_segs objectAtIndex: 2] doubleValue];
			
			CLLocation* location = [[CLLocation alloc] initWithLatitude: lat longitude: lon ];
			
			[points addObject: location];
			[location release];
		}
		
		northPoints = [[NSMutableArray alloc] init];
		
		for (int row=0; row < [this_provider.LI_NORTH_POINTS count]; row++){
			NSMutableArray *tmp_segs = (NSMutableArray *)[this_provider.LI_NORTH_POINTS objectAtIndex: row];
			double lat = [(NSNumber *) [tmp_segs objectAtIndex: 1] doubleValue];
			double lon = [(NSNumber *) [tmp_segs objectAtIndex: 2] doubleValue];
			
			CLLocation* location = [[CLLocation alloc] initWithLatitude: lat longitude: lon ];
			
			[northPoints addObject: location];
			[location release];
		}
		
		NSMutableArray *stations = [this_provider get_AllStations];
		[mapAnnotations addObjectsFromArray: stations];
		//[stations release];
		
		for (int x = 0; x < [mapAnnotations count]; x++){
			[self.mapView addAnnotation:[mapAnnotations objectAtIndex:x]];
		}
		
		/* Center The Map 
		 MAP_LL_LONG = -112.217;
		 MAP_LL_LAT = 33.339;
		 */
		
		/*
		MKCoordinateRegion newRegion;
		newRegion.center.latitude = 33.339;
		newRegion.center.longitude = -112.217;
		newRegion.span.latitudeDelta = 0.3;
		newRegion.span.longitudeDelta = 0.6;
		
		[self.mapView setRegion:newRegion animated:YES];
		 */
		[self zoomToFitMapAnnotations: self.mapView];
		
		//DRAW THE LINES
		[self drawSegments];
		
		NSMutableArray *li_points = [[NSMutableArray alloc] initWithObjects: points, northPoints, nil];
		
		_routeView = [[CSMapRouteLayerView alloc] initWithRoute:li_points mapView:mapView];
		_routeView.popups = YES;
		[li_points release];
		
		[points release];
		[northPoints release];
		
	}
	
	
	/*UPDATE THE LOCAL DATABASE IS NEEDED*/
	[indicatorView startAnimating];
	
	//See if I need to update the app
	currentUrl = GET_DB_URL;
	NSURL *theURL = [[NSURL URLWithString: currentUrl] retain];
	currentURL = theURL;
	responseData = [[NSMutableData alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL: theURL];
	
	//NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//GET THE LOCATION MANAGER UPDATER STARTED
	
	locationManager = [[CLLocationManager alloc]init];
	//locationManager.desiredAccuracy = kCLLocationAccuracy;//kCLLocationAccuracyBest;
	locationManager.distanceFilter = 1000;
	locationManager.delegate = self;
	
	
	locationDidUpdate = NO;
	locationUpdateFailed = NO;
	
	[locationManager startUpdatingLocation];
	mapView.showsUserLocation = YES;
	
	currTrains = [[NSMutableArray alloc] init];
	
	plotter = [[TrainPlotter alloc] init];
	
	[self get_trains:nil];
	
	NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self     selector:@selector(get_trains:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:countdownTimer forMode:NSDefaultRunLoopMode];
	
    [super viewDidLoad];
}

- (void)get_trains:(NSTimer *)timer
{
	
	//REMOVE THE PREVIOUS TRAINS
	for	(MyAnnotation *this_train in currTrains){
		[self.mapView removeAnnotation:this_train];
		
	}
	[currTrains release];
	currTrains = [[NSMutableArray alloc] init];
	
	NSMutableArray *curr_trains = [plotter get_current_trains: @"S"];
	for (NSArray *this_coord in curr_trains){
		double this_lat = [(NSNumber *)[this_coord objectAtIndex: 0] doubleValue];
		double this_lon = [(NSNumber *)[this_coord objectAtIndex: 1] doubleValue];
		
		MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:@"Southeast Bound" subtitle:@"" lat:this_lat lon:this_lon typeName: @"train_east"];
		this_annotation.theID = 0;
		
		//[mapAnnotations addObject: this_annotation];
		[self.mapView addAnnotation: this_annotation];
		[currTrains addObject:this_annotation];
		[this_annotation release];
	}
	
	[curr_trains release];
	
	curr_trains = [plotter get_current_trains: @"N"];
	for (NSArray *this_coord in curr_trains){
		double this_lat = [(NSNumber *)[this_coord objectAtIndex: 0] doubleValue];
		double this_lon = [(NSNumber *)[this_coord objectAtIndex: 1] doubleValue];
		
		MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:@"Northwest Bound" subtitle:@"" lat:this_lat lon:this_lon typeName: @"train_west"];
		this_annotation.theID = 0;
		
		//[mapAnnotations addObject: this_annotation];
		[self.mapView addAnnotation: this_annotation];
		[currTrains addObject:this_annotation];
		[this_annotation release];
	}
	[curr_trains release];
    //[countdown setIntegerValue:59];
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    if([mapView.annotations count] == 0)
        return;
	
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    for(MyAnnotation* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}


- (void)drawSegments
{
	// only draw our lines if we're not int he moddie of a transition and we
	// acutally have some points to draw.
	if(points.count > 0)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		UIColor *lineColor = [UIColor blueColor];
		
		CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
		
		// Draw them with a 2.0 stroke width so they are a bit more visible.
		CGContextSetLineWidth(context, 2.0);
		
		for(int idx = 0; idx < points.count; idx++)
		{
			CLLocation* location = [points objectAtIndex:idx];
			//NSLog(location.coordinate.longitude);
			CGPoint point = [mapView convertCoordinate: location.coordinate  toPointToView:mapView];
			
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog( [error localizedDescription]);
	[indicatorView stopAnimating];
	//[indicatorView removeFromSuperview];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
	thisResponse = (NSURLResponse *)response;
	[responseData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[responseData appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//Check for errors
	if (currentUrl == GET_DB_URL){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *filepath = [documentsPath stringByAppendingPathComponent:@"citycircles_data.db"];
		
		NSFileManager *mymanager = [NSFileManager defaultManager];
		
		NSDate *fileModDate = [[mymanager fileAttributesAtPath:filepath traverseLink:YES] objectForKey:NSFileModificationDate];
		
		NSString *content = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
		
		long long db_timestamp = [content longLongValue];
		long long local_db_timestamp = (long long)[fileModDate timeIntervalSince1970];
		if (db_timestamp > local_db_timestamp) {
			alert = [[UIAlertView alloc] initWithTitle:@"Update Database?" message:@"There have been updates to the data.  Would you like to retreive them?\nWarning, may take a few minutes" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update", nil ];
			
			[alert show];
			[alert autorelease];
		} else {
			[indicatorView stopAnimating];
			//[indicatorView removeFromSuperview];
		}
	} else {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *filepath = [documentsPath stringByAppendingPathComponent:@"citycircles_data.db"];
		
		
		//NSData *theDbData = [NSData dataWithContentsOfURL: theURL];
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		
		[delegate.dbModels closedb];//closes the connection
		
		[responseData writeToFile: filepath atomically: YES];
		
		[delegate.dbModels connectDB];
		
		
		[indicatorView stopAnimating];
		//[indicatorView removeFromSuperview];
	}
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1){
		currentUrl = DB_FILE_URL;
		NSURL *theURL = [NSURL URLWithString: currentUrl];
		NSURLRequest *request = [NSURLRequest requestWithURL: theURL];
		[[NSURLConnection alloc] initWithRequest:request delegate:self];
		
		//[mymanager copyItemAtPath:<#(NSString *)srcPath#> toPath:<#(NSString *)dstPath#> error:<#(NSError **)error#>
	} else {
		[indicatorView stopAnimating];
		//[indicatorView removeFromSuperview];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	if ( [request.mainDocumentURL.relativePath isEqualToString:@"/allCorrect/false"] ) {
		NSLog( @"Nope, that is not right!" );
		return false;
	}
	
	if ( [request.mainDocumentURL.relativePath isEqualToString:@"/allCorrect/true"] ) {
		NSLog( @"You got them all!" );
		return false;
	}
	
	return true;
	
}
 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *URLString = request.mainDocumentURL.relativePath;
	
	NSRange range = {0,5};
	NSString *subword = [URLString substringWithRange:range];
	if ([subword isEqualToString: @"/load"] 
		|| [subword isEqualToString:@"/test"]
		|| [subword isEqualToString:@"/evnt"]
		){
	
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath: path];
		NSString *htmlString = @"";
		//mygenerator = [[HtmlGenerator alloc] init];
		
		if ([subword isEqualToString: @"/load"]){//([URLString rangeOfString:@"/load"].location != NSNotFound) {
			//This is the initial loading
			htmlString = [mygenerator getHTML: 10 to_zl: 10 center_x: 160 center_y: 125 from_origin_x: -1 from_origin_y: -1];
			
			//NSData *htmlData = [NSData dataFromContent: filePath];
			//[self loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
			
			
		} else if ([subword isEqualToString: @"/evnt"]){
			NSArray *chunks = [URLString componentsSeparatedByString:@"/"];
			int eventID = [(NSString *)[chunks objectAtIndex:2] intValue];
			
			citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
			
			EventView *eventView = [[EventView alloc] initWithEventID: eventID];
			
			//[thisListProvider getData];
			
			//[self pushViewController:eventView animated: YES];
			[[delegate.tabnavController selectedViewController] pushViewController: eventView animated: YES];
			
			//[tabBarController.viewControllers objectAtIndex
			[eventView release];
			
		} 
		
		else {
			[indicatorView startAnimating];
			NSArray *chunks = [URLString componentsSeparatedByString:@"/"];
			int from_zl = [(NSString *)[chunks objectAtIndex:2] intValue];
			int to_zl = [(NSString *)[chunks objectAtIndex:3] intValue];
			int center_x = [(NSString *)[chunks objectAtIndex:4] intValue];
			int center_y = [(NSString *)[chunks objectAtIndex:5] intValue];
			int from_origin_x = [(NSString *)[chunks objectAtIndex:6] intValue];
			int from_origin_y = [(NSString *)[chunks objectAtIndex:7] intValue];
			htmlString = [mygenerator getHTML: from_zl to_zl: to_zl center_x: center_x center_y: center_y from_origin_x: from_origin_x from_origin_y: from_origin_y];
			//[self loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
			[indicatorView stopAnimating];
		}
	
		/*
		//return [super loadHTMLString: htmlString baseURL: baseURL];
		
		//NSData *htmlData = [NSData data: filePath];
		//NSLog(htmlString);
		//NSData *htmlData= (NSData *)[htmlString dataUsingEncoding:NSUTF8StringEncoding];
		//[super loadRequest:request];
		//[thiswebView loadData: htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
		 */
		if ([htmlString isEqualToString: @""]){
			//do nothing
		} else {
			[thiswebView loadHTMLString:htmlString baseURL:baseURL];
			
		}
		//[mygenerator release];
		return false;
	} else {
		return true;
	}

}

#pragma mark locationManager stuff
-(void)locationManager: (CLLocationManager *)manager
   didUpdateToLocation: (CLLocation *)newLocation
          fromLocation: (CLLocation *)oldLocation{
	
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"currentLocationDidUpdate" object: self];
	
    //[locationManager stopUpdatingLocation];
	
	if (1){//(locationDidUpdate != YES){ //only do this once
		NSLog(@"Core Location says location available");
		//[mapView setCenterCoordinate:newLocation.coordinate];
		
		curLats = (double) newLocation.coordinate.latitude;
		curLons = (double) newLocation.coordinate.longitude;
		
		NSLog([NSString stringWithFormat:@"IS VISIBLE: %d", mapView.userLocationVisible]);
		
		NSMutableArray *x_y = [mygenerator processLatLong: curLats Lon: curLons];
		int x = [(NSNumber *)[x_y objectAtIndex: 0] intValue];
		int y = [(NSNumber *)[x_y objectAtIndex: 1] intValue];
		[x_y release];
		
		NSString *jsstring = [NSString stringWithFormat:@"updateLocation(%d, %d)", x, y];
		NSString *result = [thiswebView stringByEvaluatingJavaScriptFromString:jsstring];
		//self.curLats = 33.4518;
		//self.curLons = -112.07;
		
		
		
		
		mycurrentLocation  = newLocation;
		NSLog(@"current position is then %@", [mycurrentLocation description]);
		locationDidUpdate = YES;
		//mapView.showsUserLocation = YES;
		
	}
	return;
	
}

-(void)locationManager: (CLLocationManager *)manager
	  didFailWithError:(NSError *) error {
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapAnnotations release];
	[mapView release];
	[locationManager release];
	[mygenerator release];
    [super dealloc];
}

@end
