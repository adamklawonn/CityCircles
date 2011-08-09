//
//  EventPerCatList.m
//  citycircles
//
//  Created by mjamison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventPerCatList.h"
#import "citycirclesAppDelegate.h"
#import "EventView.h"

@implementation EventPerCatList
@synthesize tableView;
/* get the active categories */
-(id) initwithCatID: (int) catID{
	if (self = [super init])
    {		
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
		li_events = [delegate.dbModels getEventsPerCat: catID];
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
	//self.title = @"Events";
    [super viewDidLoad];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0){
		return @"Select Event";
		
	} 
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark UITableViewDataSource Methods

- (UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tv.bounds.size.width, 60)] autorelease];
	
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
	
	label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
	label.backgroundColor = [UIColor clearColor];
	
	label.text = @"Select Event";
	
	[headerView addSubview:label];
	
	return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	if(nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	}
	NSMutableArray *thiscell = (NSMutableArray *)[li_events objectAtIndex: indexPath.row];
	
	NSArray *chunks = [(NSString *)[thiscell objectAtIndex: 0] componentsSeparatedByString:@" "];
	
	NSString *thisDate = (NSString *)[chunks objectAtIndex: 0];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", thisDate, (NSString *)[thiscell objectAtIndex: 1]];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return [li_events count];
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSMutableArray *this_row = [li_events objectAtIndex:indexPath.row];
	int event_id = [(NSNumber *)[this_row objectAtIndex: 2] intValue];
	
	EventView *thisView = [[EventView alloc] initWithEventID: event_id];
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: thisView animated: YES];
	[thisView release];
	
	[tv deselectRowAtIndexPath: indexPath animated: YES];	
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
