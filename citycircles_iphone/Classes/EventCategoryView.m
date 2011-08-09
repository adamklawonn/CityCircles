//
//  EventCategoryView.m
//  citycircles
//
//  Created by mjamison on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventCategoryView.h"
#import "Models.h"
#import "EventPerCatList.h"
#import "citycirclesAppDelegate.h"


@implementation EventCategoryView
@synthesize tableView;
/* get the active categories */
-(id) init{
	if (self = [super init])
    {		
		Models *dbModels = [[Models alloc] init];
		activeEventCats = [dbModels getAllEventCats];
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
	//self.title = @"Select Category";
    [super viewDidLoad];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0){
		return @"Select Category";
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
	
	if ([activeEventCats count] == 0){
		label.text = @"No events listings at this time";
	} else {
		label.text = @"Select Category";
	}

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
	NSMutableArray *thiscell = (NSMutableArray *)[activeEventCats objectAtIndex: indexPath.row];
	
	cell.textLabel.text = (NSString *)[thiscell objectAtIndex: 1];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return [activeEventCats count];
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSMutableArray *this_row = (NSMutableArray *)[activeEventCats objectAtIndex: indexPath.row];
	
	int cat_id = [(NSNumber *)[this_row objectAtIndex: 2] intValue];
	
	EventPerCatList *this_view = [[EventPerCatList alloc] initwithCatID: cat_id];
	
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: this_view animated: YES];
	//[this_view release];
	
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
	[activeEventCats release];
	[tableView release];
    [super dealloc];
}


@end
