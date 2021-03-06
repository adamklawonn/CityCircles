//
//  StationInfoMainViewController.m
//  citycircles
//
//  Created by mjamison on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StationInfoMainViewController.h"
#import "ScheduleDOWViewController.h"
#import "StationInfoView.h"
#import "citycirclesAppDelegate.h"
#import "MyWebView.h"
#import "Models.h"

@implementation StationInfoMainViewController

@synthesize tableView;
/*
 Send the selected station to the constructor
 */
-(id) initWithStationID: (int) sID{
	if (self = [super init])
    {
		stationID = sID;
		
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
	//self.title = @"Station Information";
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
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	if(nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	}
		
	if (indexPath.section == 0) {
		cell.textLabel.text = @"Schedules";
	} else {
		cell.textLabel.text = @"Information";
	}

	return cell;}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return 1;	
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		ScheduleDOWViewController *thisScheduleDOWview = [[ScheduleDOWViewController alloc] initWithStationID: stationID];
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
		[[delegate.tabnavController selectedViewController] pushViewController: thisScheduleDOWview animated: YES];
		[thisScheduleDOWview release];
	} else {
		Models *dbModels = [[Models alloc] init];
		
		NSString *stationInfo = [dbModels getStationInfo: stationID];
		
		if ([stationInfo isEqualToString:@""]) {
			stationInfo = @"No information at this time.";
		}
		
		[dbModels release];
		
		MyWebView *thisView = (MyWebView *)[[MyWebView alloc] initWithString:stationInfo];
		
		//thisView.title = @"Station Information";
		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
		/*
		 [delegate.navController pushViewController:thisView animated: YES];
		 */
		[[delegate.tabnavController selectedViewController] pushViewController:thisView animated: YES];
		[thisView release];
	}
	[tv deselectRowAtIndexPath: indexPath animated: YES];
	
}

- (UITableViewCellAccessoryType) tableView:(UITableView *) tv accessoryTypeForRowWithIndexPath:(NSIndexPath *) indexPath{
	return UITableViewCellAccessoryDisclosureIndicator;
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
