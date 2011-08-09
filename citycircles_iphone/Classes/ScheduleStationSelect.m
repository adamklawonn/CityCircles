//
//  MainBusinessViewController.m
//  citycircles
//
//  Created by mjamison on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleStationSelect.h"
#import "citycirclesAppDelegate.h"
#import "ScheduleDOWViewController.h"
#import "StationInfoMainViewController.h"

@implementation ScheduleStationSelect
@synthesize tableView;

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
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	//lrStations = delegate.lrStations; //save a pointer to the list of stations
	northStations = delegate.northStations;
	southStations = delegate.southStations;
    [super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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



#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	if(nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	}
	if (indexPath.section == 0) {
		cell.textLabel.text = (NSString *)[(NSMutableArray *)[southStations objectAtIndex:indexPath.row] objectAtIndex: 1];
	} else {
		NSMutableArray *stationArray = (NSMutableArray *)[northStations objectAtIndex:indexPath.row];
		cell.textLabel.text = (NSString *)[stationArray objectAtIndex: 1];
	}
	
	
	return cell;}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [southStations count];
	} else {
		return [northStations count];
	}
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0){
		return @"South Stations";
		
	} else {
		return @"North Stations";
	}
	
}

- (UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tv.bounds.size.width, 60)] autorelease];
	
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
	
	label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
	label.backgroundColor = [UIColor clearColor];
	
	if (section == 0){
		label.text = @"South Stations";
	} else {
		label.text = @"North Stations";
	}
	
	[headerView addSubview:label];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int stationID;
	
	if (indexPath.section == 0) {
		NSMutableArray *stationArray = (NSMutableArray *)[southStations objectAtIndex:indexPath.row];
		stationID = [(NSNumber*)[stationArray objectAtIndex: 0] intValue];
	} else {
		NSMutableArray *stationArray = (NSMutableArray *)[northStations objectAtIndex:indexPath.row];
		stationID = [(NSNumber*)[stationArray objectAtIndex: 0] intValue];
	}
	
	
	
	/*
	ScheduleDOWViewController *thisScheduleDOWview = [[ScheduleDOWViewController alloc] initWithStationID: stationID];
	
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: thisScheduleDOWview animated: YES];
	
	[thisScheduleDOWview release];
	*/
	StationInfoMainViewController *stationInfoMain = [[StationInfoMainViewController alloc] initWithStationID:stationID];
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: stationInfoMain animated: YES];
	
	[stationInfoMain release];
	
	[tv deselectRowAtIndexPath: indexPath animated: YES];
	
}

- (UITableViewCellAccessoryType) tableView:(UITableView *) tv accessoryTypeForRowWithIndexPath:(NSIndexPath *) indexPath{
	return UITableViewCellAccessoryDisclosureIndicator;
}



- (void)dealloc {
    [super dealloc];
}


@end
