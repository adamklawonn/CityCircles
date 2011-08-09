//
//  BusinessSelect.m
//  citycircles
//
//  Created by mjamison on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BusinessSelect.h"
#import "Models.h"
#import "BusinessView.h"
#import "citycirclesAppDelegate.h"

@implementation BusinessSelect

@synthesize tableView;

-(id) initWithStationAndCatID: (int) sID catID: (int) catID{
	if (self = [super init])
    {
		stationID = sID;
		categoryID = catID;
		
		Models *dbModels = [[Models alloc] init];
		
		bizList = [dbModels getBizForStationAndCat: sID categoryID: catID];
		
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
    [super viewDidLoad];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0){
		return @"Select Business";
		
	} 
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tv.bounds.size.width, 60)] autorelease];
	
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
	
	label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
	label.backgroundColor = [UIColor clearColor];
	
	label.text = @"Select Business";
	
	[headerView addSubview:label];
	
	return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	if(nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	}
	cell.textLabel.text = (NSString *)[(NSMutableArray *)[bizList objectAtIndex:indexPath.row] objectAtIndex: 1];
	return cell;}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return [bizList count];
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSMutableArray *bizArray = (NSMutableArray *)[bizList objectAtIndex:indexPath.row];
	int bizID = [(NSString *)[bizArray objectAtIndex: 0] intValue];
	
	BusinessView *bizView = [[BusinessView alloc] initWithBizID:bizID];
	
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: bizView animated: YES];
	
	[bizView release];
	
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
	[bizList release];
    [super dealloc];
}


@end
