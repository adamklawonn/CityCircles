//
//  MainBusinessViewController.m
//  citycircles
//
//  Created by mjamison on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleView.h"
#import "citycirclesAppDelegate.h"
#import "Models.h"


@implementation ScheduleView
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
-(id) initWithStationID: (int) sID dow: (int) idow{
	if (self = [super init])
    {
		stationID = sID;
		iDow = idow;
		
		Models *dbModels = [[Models alloc] init];
		liTimes = [dbModels getTrainSchedule: iDow station_id: stationID];
		[dbModels release];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//self.title = @"Schedule";
    [super viewDidLoad];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
		
	if (section == 0){
		return @"Train Schedule";
	} 
	
}

- (UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tv.bounds.size.width, 60)] autorelease];
	
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
	
	label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
	label.backgroundColor = [UIColor clearColor];
	
	
	if (iDow == 1) {
		label.text = @"Schedule For Monday";
	} else if (iDow == 2) {
		label.text = @"Schedule For Tuesday";
	} else if (iDow == 3){
		label.text = @"Schedule For Wednesday";
	} else if (iDow == 4){
		label.text = @"Schedule For Thursday";
	} else if (iDow == 5){
		label.text = @"Schedule For Friday";
	} else if (iDow == 6){
		label.text = @"Schedule For Saturday";
	} else {
		label.text = @"Schedule For Sunday";
	}
	
	
	
	[headerView addSubview:label];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
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
	NSString *this_time = (NSString *)[(NSMutableArray *)[liTimes objectAtIndex:indexPath.row] objectAtIndex: 0];
	NSDate *this_date = [NSDate dateWithNaturalLanguageString: this_time];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"hh:mm a"];
	NSString *pretty_time = [dateFormat stringFromDate: this_date];
	
	cell.textLabel.text = pretty_time;
	return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return [liTimes count];
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tv deselectRowAtIndexPath: indexPath animated: YES];	
}

- (void)dealloc {
    [super dealloc];
}


@end
