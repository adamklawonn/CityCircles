//
//  BusinessView.m
//  citycircles
//
//  Created by mjamison on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "citycirclesAppDelegate.h"
#import "BusinessView.h"
#import "Models.h"
#import "MyWebView.h"
#import "HtmlGenerator.h"
#import "CSMapRouteLayerView.h"
#import "MyAnnotation.h"
#import "MapKitAnnotationProvider.h"


@implementation BusinessView

@synthesize basic_cell;
@synthesize basic_info;
@synthesize tableView;
@synthesize thisWebView;
@synthesize basic_info_unfav;
@synthesize mapView;
@synthesize Title, subTitle1, subTitle2, thisImage, favImage;

-(id) initWithBizID: (int) bizID{
	if (self = [super init])
    {
		businessID = bizID;
		
		Models *dbModels = [[Models alloc] init];
		//id, name, lat, lon, address_street, address_apt, city, state, zip, phone, url, info
		bizDetails = [(NSMutableArray *)[dbModels getBizDetails: bizID] objectAtIndex: 0];
		in_favs = [dbModels getInFavorites: bizID is_business: 1];
		
		[dbModels release];
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
	//id, name, lat, lon, address_street, address_apt, city, state, zip, phone, url, info, thumb_path
	Title.text = (NSMutableString *) [bizDetails objectAtIndex: 1];
	subTitle1.text = [[(NSMutableString *) [bizDetails objectAtIndex: 4] stringByAppendingString: @" "] stringByAppendingString: [bizDetails objectAtIndex:5]];
	
	subTitle2.text = [[[[(NSMutableString *) [bizDetails objectAtIndex:6] stringByAppendingString: @", "] stringByAppendingString: [bizDetails objectAtIndex:7] ] stringByAppendingString: @" "] stringByAppendingString: [bizDetails objectAtIndex:8]];
	
	if (!in_favs) {
		UIImage * image = [UIImage imageNamed:@"star-off-icone-7870-48.png"];
		[favImage setImage:image];
	} else {
		UIImage * image = [UIImage imageNamed:@"star-icone-9823-48.png"];
		[favImage setImage:image];
	}
	
	NSString *url_string = [(NSString *)[bizDetails objectAtIndex:12] stringByReplacingOccurrencesOfString: @"/var/www/citycircles" withString: @""];
	
	url_string = [url_string stringByReplacingOccurrencesOfString: @"/media/raid/business/projects/current/citycircles_server/citycircles_forclient" withString: @""];
	
	url_string = [NSString stringWithFormat:@"http://iphone.citycircles.com%@", url_string];
	//url_string = [NSString stringWithFormat:@"http://192.168.0.2:8001%@", url_string];
	
	NSURL * imageURL = [NSURL URLWithString:url_string];
	NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
	UIImage * image = [UIImage imageWithData:imageData];
	
	[thisImage setImage:image];
	
	double lat = [(NSNumber *) [bizDetails objectAtIndex: 2] doubleValue];
	double lon = [(NSNumber *) [bizDetails objectAtIndex: 3] doubleValue];
	
	MyAnnotation * this_annotation = [[MyAnnotation alloc] initWithData:[bizDetails objectAtIndex:1] subtitle:@"" lat:lat lon:lon typeName: @"event"];
	
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
	
	NSMutableArray *li_points = [[NSMutableArray alloc] initWithObjects: points, northPoints, nil];
	_routeView = [[CSMapRouteLayerView alloc] initWithRoute:li_points mapView:mapView];
	_routeView.popups = NO;
	[li_points release];
	[points release];
	[northPoints release];
	
	[this_provider release];
    [super viewDidLoad];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section == 0) {
		static NSString *MyIdentifier = @"basic_info";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"basic_cell" owner:self options:nil];  //makes basic_cell point to a new object
			cell = basic_cell;
			self.basic_cell = nil;
		}
		UILabel *label;
		label = (UILabel *)[cell viewWithTag:10];
		label.text = @"Phone";
		
		label = (UILabel *)[cell viewWithTag:11];
		label.text = (NSString *)[bizDetails objectAtIndex: 9];
		return cell;
	} else if (indexPath.section == 1) {
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
		if(nil == cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		}
		cell.textLabel.text = @"Description";
		return cell;
		
	} else{
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
	}
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
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
		
		htmlString = [mygenerator getBizHTML: businessID];
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

#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		NSString *thisNumber = (NSString *)[bizDetails objectAtIndex:9];
		thisNumber = [thisNumber stringByReplacingOccurrencesOfString: @"(" withString:@""];
		thisNumber = [thisNumber stringByReplacingOccurrencesOfString: @")" withString:@""];
		thisNumber = [thisNumber stringByReplacingOccurrencesOfString: @"-" withString:@""];
		thisNumber = [thisNumber stringByReplacingOccurrencesOfString: @" " withString:@""];
		NSString *tocall = [@"tel:" stringByAppendingString:thisNumber];
		NSURL *tocallurl = [NSURL URLWithString: tocall];
		[[UIApplication sharedApplication] openURL:tocallurl];
	} else if (indexPath.section == 1) {
				
		MyWebView *thisView = (MyWebView *)[[MyWebView alloc] initWithString:[bizDetails objectAtIndex:11]];
				
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
				/*
				 [delegate.navController pushViewController:thisView animated: YES];
				 */
		[[delegate.tabnavController selectedViewController] pushViewController:thisView animated: YES];
		thisView.title = @"Information";
		[thisView release];
	} else {
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		
		if (in_favs) {
			[delegate.dbModels deleteFromFavorites:businessID is_business: 1];
		} else {
			[delegate.dbModels addToFavorites:businessID is_business:1];
		}
		
		in_favs = [delegate.dbModels getInFavorites: businessID is_business: 1];

		[delegate.fav_view reloadData];
		
		if (!in_favs) {
			UIImage * image = [UIImage imageNamed:@"star-off-icone-7870-48.png"];
			[favImage setImage:image];
		} else {
			UIImage * image = [UIImage imageNamed:@"star-icone-9823-48.png"];
			[favImage setImage:image];
		}
		
		[tv deselectRowAtIndexPath: indexPath animated: YES];
		[tv reloadData];
	}


	[tv deselectRowAtIndexPath: indexPath animated: YES];
	
	
}

- (UITableViewCellAccessoryType) tableView:(UITableView *) tv accessoryTypeForRowWithIndexPath:(NSIndexPath *) indexPath{
	if (indexPath.section >= 0){
	return UITableViewCellAccessoryDisclosureIndicator;
	}
	else {
		return UITableViewCellAccessoryNone;
	}

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
    [super dealloc];
}


@end
