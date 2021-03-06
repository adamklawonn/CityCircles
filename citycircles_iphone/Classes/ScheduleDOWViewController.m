//
//  MainBusinessViewController.m
//  citycircles
//
//  Created by mjamison on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleDOWViewController.h"
#import "citycirclesAppDelegate.h"
#import "ScheduleView.h"


@implementation ScheduleDOWViewController
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//self.title = @"Select Day Of Week";
    [super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0){
		return @"Select Day Of Week";
		
	} 
	
}

- (UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tv.bounds.size.width, 60)] autorelease];
	
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
	
	label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
	label.backgroundColor = [UIColor clearColor];
	
	label.text = @"Select Day of Week";
	
	[headerView addSubview:label];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
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



#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	if(nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	}
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Monday";
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Tuesday";
	} else if (indexPath.row == 2){
		cell.textLabel.text = @"Wednesday";
	} else if (indexPath.row == 3){
		cell.textLabel.text = @"Thursday";
	} else if (indexPath.row == 4){
		cell.textLabel.text = @"Friday";
	} else if (indexPath.row == 5){
		cell.textLabel.text = @"Saturday";
	} else {
		cell.textLabel.text = @"Sunday";
	}
	return cell;}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	int dow = indexPath.row + 1;
	ScheduleView *thisScheduleview = [[ScheduleView alloc] initWithStationID:stationID dow:dow];
	
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: thisScheduleview animated: YES];
	
	[thisScheduleview release];
	
	[tv deselectRowAtIndexPath: indexPath animated: YES];
	
}

- (UITableViewCellAccessoryType) tableView:(UITableView *) tv accessoryTypeForRowWithIndexPath:(NSIndexPath *) indexPath{
	return UITableViewCellAccessoryDisclosureIndicator;
}



- (void)dealloc {
    [super dealloc];
}


@end
