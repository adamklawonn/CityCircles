//
//  EventView.m
//  citycircles
//
//  Created by mjamison on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventView.h"
#import "Models.h"
#import "HtmlGenerator.h"
#import "citycirclesAppDelegate.h"
#import "MyWebView.h"
#import "MapKitAnnotationProvider.h"
#import "MyAnnotation.h"
#import "CSMapRouteLayerView.h"

@implementation EventView

@synthesize basic_cell;
@synthesize basic_cell_unfav;
@synthesize basic_info;
@synthesize tableView;
@synthesize thisWebView;
@synthesize mapView;
@synthesize Title, subTitle1, subTitle2, subTitle3, thisImage, favImage;

-(id) initWithEventID: (int) evtID{
	if (self = [super init])
    {
		eventID = evtID;
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		Models *dbModels = delegate.dbModels;

		//id, name, lat, lon, address_street, address_apt, city, state, zip, phone, url, info
		eventDetails = [(NSMutableArray *)[dbModels getEventDetails: eventID] objectAtIndex: 0];
		
		
		in_favs = [dbModels getInFavorites: eventID is_business: 0];

    }
    return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	Title.text = (NSMutableString *) [eventDetails objectAtIndex: 0];
	subTitle1.text = [[(NSMutableString *) [eventDetails objectAtIndex: 7] stringByAppendingString: @" "] stringByAppendingString: [eventDetails objectAtIndex:8]];
	
	subTitle2.text = [[[[(NSMutableString *) [eventDetails objectAtIndex:9] stringByAppendingString: @", "] stringByAppendingString: [eventDetails objectAtIndex:10] ] stringByAppendingString: @" "] stringByAppendingString: [eventDetails objectAtIndex:11]];
	
	
	NSString *startDate = [self getDateFromDateTimeString: (NSString *)[eventDetails objectAtIndex:1]];
	NSString *endDate = [self getDateFromDateTimeString: (NSString *)[eventDetails objectAtIndex:5]];
	
	NSString *sub_title;
	if ([startDate isEqualToString:endDate]) {
		sub_title = startDate;
	} else {
		sub_title = [NSString stringWithFormat:@"%@ to %@", startDate, endDate];
	}
	
	sub_title = [sub_title stringByReplacingOccurrencesOfString: @"-" withString: @"/"];
	subTitle3.text = sub_title;
	
	if (!in_favs) {
		UIImage * image = [UIImage imageNamed:@"star-off-icone-7870-48.png"];
		[favImage setImage:image];
	} else {
		UIImage * image = [UIImage imageNamed:@"star-icone-9823-48.png"];
		[favImage setImage:image];
	}
	
	NSString *url_string = [(NSString *)[eventDetails objectAtIndex:15] stringByReplacingOccurrencesOfString: @"/var/www/citycircles" withString: @""];
	
	url_string = [url_string stringByReplacingOccurrencesOfString: @"/media/raid/business/projects/current/citycircles_server/citycircles_forclient" withString: @""];
	
	url_string = [NSString stringWithFormat:@"http://iphone.citycircles.com%@", url_string];
	//url_string = [NSString stringWithFormat:@"http://192.168.0.2:8001%@", url_string];
	//NSLog(url_string);
	
	NSURL * imageURL = [NSURL URLWithString:url_string];
	NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
	UIImage * image = [UIImage imageWithData:imageData];
	
	[thisImage setImage:image];
	
	
	/*
	NSURL *url = [NSURL URLWithString:@"/business/"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	 */
	/*
	
	[self.thisWebView loadRequest:requestObj];
	self.title = @"Event";
	 
	 */
	double lat = [(NSNumber *) [eventDetails objectAtIndex: 2] doubleValue];
	double lon = [(NSNumber *) [eventDetails objectAtIndex: 3] doubleValue];
	
	MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:[eventDetails objectAtIndex:0] subtitle:@"" lat:lat lon:lon typeName: @"event"];
	
	mapAnnotations = [[NSMutableArray alloc] init];
	
	[mapAnnotations addObject: this_annotation];
	
	MapKitAnnotationProvider *this_provider = [[MapKitAnnotationProvider alloc] init];
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
	 
	MKCoordinateRegion newRegion;
	newRegion.center.latitude = lat;
	newRegion.center.longitude = lon;
	newRegion.span.latitudeDelta = 0.005;
	newRegion.span.longitudeDelta = 0.01;

	[self.mapView setRegion:newRegion animated:YES];
	 
	//DRAW THE LINES
	//[self drawSegments];
	
	NSMutableArray *li_points = [[NSMutableArray alloc] initWithObjects: points, northPoints, nil];
	_routeView = [[CSMapRouteLayerView alloc] initWithRoute:li_points mapView:mapView];
	_routeView.popups = NO;
	[li_points release];
	[points release];
	[northPoints release];
	
	[this_provider release];
    [super viewDidLoad];
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
			NSLog([NSString stringWithFormat: @"%1.5f", location.coordinate.latitude]);
			NSLog([NSString stringWithFormat: @"%1.5f", location.coordinate.longitude]);
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(NSString *) getDateFromDateTimeString: (NSString *) sDateTime{
	NSArray *chunks = [sDateTime componentsSeparatedByString:@" "];
	return (NSString*) [chunks objectAtIndex: 0];
}

#pragma mark UIWebViewDelegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *URLString = request.mainDocumentURL.relativePath;
	
	NSRange range = {0,5};
	NSString *subword = [URLString substringWithRange:range];
	HtmlGenerator * mygenerator = [[HtmlGenerator alloc] init];
	
	if ([URLString isEqualToString:@"/business"]) {
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath: path];
		NSString *htmlString;
		
		htmlString = [mygenerator getEventHTML: eventID];
		[thisWebView loadHTMLString:htmlString baseURL:baseURL];
		
		[mygenerator release];
		return false;
		
	}
	else if ([subword isEqualToString: @"/load"] || [subword isEqualToString:@"/test"]){
		
		
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath: path];
		NSString *htmlString;
		
		
		if ([URLString rangeOfString:@"/load"].location != NSNotFound) {
			//This is the initial loading
			htmlString = [mygenerator getHTML: 10 to_zl: 10 center_x: 160 center_y: 125 from_origin_x: -1 from_origin_y: -1];
			
			//NSData *htmlData = [NSData dataFromContent: filePath];
			//[self loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
			
			
		} else {
			NSArray *chunks = [URLString componentsSeparatedByString:@"/"];
			int from_zl = [(NSString *)[chunks objectAtIndex:2] intValue];
			int to_zl = [(NSString *)[chunks objectAtIndex:3] intValue];
			int center_x = [(NSString *)[chunks objectAtIndex:4] intValue];
			int center_y = [(NSString *)[chunks objectAtIndex:5] intValue];
			int from_origin_x = [(NSString *)[chunks objectAtIndex:6] intValue];
			int from_origin_y = [(NSString *)[chunks objectAtIndex:7] intValue];
			htmlString = [mygenerator getHTML: from_zl to_zl: to_zl center_x: center_x center_y: center_y from_origin_x: from_origin_x from_origin_y: from_origin_y];
			//[self loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
		}
		
		[thisWebView loadHTMLString:htmlString baseURL:baseURL];
		
		[mygenerator release];
		return false;
	} else {
		return true;
	}
	
}

#pragma mark UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section == 99){
		//THIS IS THE BASIC INFO SECTION
		/* 
		 0 gis2raphael_event.name
		 1 start_datetime
		 2 lat
		 3 lon
		 4 gis2raphael_event.id as id
		 5 end_datetime
		 6 gis2raphael_eventcategory.name as cat_name
		 7 address_street
		 8 address_apt
		 9 city
		 10 state
		 11 zip
		 12 phone
		 13 url
		 14 info
		 */
		
		UITableViewCell *info_cell;
		if (in_favs == 1){
			info_cell = basic_info;
		} else {
			info_cell = basic_cell_unfav;
		}


		
		UIImageView *imageView;
		imageView = (UIImageView *) [info_cell viewWithTag:0];
		UILabel *lable1 = (UILabel *) [info_cell viewWithTag:1];
		UILabel *lable2 = (UILabel *) [info_cell viewWithTag:2];
		UILabel *lable3 = (UILabel *) [info_cell viewWithTag:3];
		
		lable1.text = (NSMutableString *) [eventDetails objectAtIndex: 0];
		lable2.text = [[(NSMutableString *) [eventDetails objectAtIndex: 7] stringByAppendingString: @" "] stringByAppendingString: [eventDetails objectAtIndex:8]];
		
		lable3.text = [[[[(NSMutableString *) [eventDetails objectAtIndex:9] stringByAppendingString: @", "] stringByAppendingString: [eventDetails objectAtIndex:10] ] stringByAppendingString: @" "] stringByAppendingString: [eventDetails objectAtIndex:11]];
		
		NSString *url_string = [(NSString *)[eventDetails objectAtIndex:15] stringByReplacingOccurrencesOfString: @"/var/www/citycircles" withString: @""];
		
		url_string = [url_string stringByReplacingOccurrencesOfString: @"/media/raid/business/projects/current/citycircles_server/citycircles_forclient" withString: @""];
		
		url_string = [NSString stringWithFormat:@"http://iphone.citycircles.com%@", url_string];
		//url_string = [NSString stringWithFormat:@"http://192.168.0.8001%@", url_string];
		//NSLog(url_string);
		
		NSURL * imageURL = [NSURL URLWithString:url_string];
		NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
		UIImage * image = [UIImage imageWithData:imageData];
		
		[imageView setImage:image];

		
		return info_cell;
	} else if (indexPath.section == 1) {
		/*ADD TO FAVORITES */
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
		if(nil == cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		}
		if (in_favs == 0) {
			cell.textLabel.text = @"Add to favorites.";
		} else {
			cell.textLabel.text = @"Delete from favorites.";
		}

		return cell;
	} else {
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
		if(nil == cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		}
		cell.textLabel.text = @"Information";
		return cell;
		
	}
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.section == 1) {

		Models *dbModels = [[Models alloc] init];
	
	
		if (in_favs) {
			[dbModels deleteFromFavorites:eventID is_business: 0];
		} else {
			[dbModels addToFavorites:eventID is_business:0];
		}
		
		in_favs = [dbModels getInFavorites: eventID is_business: 0];
		
		if (!in_favs) {
			UIImage * image = [UIImage imageNamed:@"star-off-icone-7870-48.png"];
			[favImage setImage:image];
		} else {
			UIImage * image = [UIImage imageNamed:@"star-icone-9823-48.png"];
			[favImage setImage:image];
		}
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		[delegate.fav_view reloadData];
		[dbModels release];
		[tv deselectRowAtIndexPath: indexPath animated: YES];
		[tv reloadData];
	} else if (indexPath.section == 0){
		MyWebView *thisView = (MyWebView *)[[MyWebView alloc] initWithString:[eventDetails objectAtIndex:14]];
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		/*
		 [delegate.navController pushViewController:thisView animated: YES];
		 */
		[[delegate.tabnavController selectedViewController] pushViewController:thisView animated: YES];
		[thisView release];
	}
}

- (UITableViewCellAccessoryType) tableView:(UITableView *) tv accessoryTypeForRowWithIndexPath:(NSIndexPath *) indexPath{
	if (indexPath.section == 0 || indexPath.section == 1 ){
		return UITableViewCellAccessoryDisclosureIndicator;
	} else {
		return UITableViewCellAccessoryNone;
	}

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 99){
		return 100.0;
	}
	else {
		return 44.0;
	}
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapView release];
	[mapAnnotations release];
    [super dealloc];
}


@end
