//
//  BusinessCategorySelectViewController.m
//  citycircles
//
//  Created by mjamison on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BusinessCategorySelectViewController.h"
#import "citycirclesAppDelegate.h"
#import "Models.h"
#import "BusinessSelect.h"

@implementation BusinessCategorySelectViewController

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
	/*citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	bizCategories = delegate.bizCategories; //save a pointer to the list of stations
	 */
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
/* 
  Send the selected station to the constructor
*/

- (UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tv.bounds.size.width, 60)] autorelease];
	
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
	
	label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
	label.backgroundColor = [UIColor clearColor];
	
	label.text = @"Select Category";
	
	[headerView addSubview:label];
	
	return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

-(id) initWithStationID: (int) sID{
	if (self = [super init])
    {
		stationID = sID;
		
		Models *dbModels = [[Models alloc] init];
		
		bizCategories = [dbModels getCategoriesForStation: stationID];
		
		[dbModels release];
    }
    return self;
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
	cell.textLabel.text = (NSString *)[(NSMutableArray *)[bizCategories objectAtIndex:indexPath.row] objectAtIndex: 1];
	return cell;}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return [bizCategories count];
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int catID;

	NSMutableArray *catArray = (NSMutableArray *)[bizCategories objectAtIndex:indexPath.row];
	catID = [(NSString *)[catArray objectAtIndex: 0] intValue];
	
	BusinessSelect *bizList = [[BusinessSelect alloc] initWithStationAndCatID:stationID catID:catID];
	
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate.tabnavController selectedViewController] pushViewController: bizList animated: YES];
	
	[bizList release];
	
	[tv deselectRowAtIndexPath: indexPath animated: YES];
	
}

- (UITableViewCellAccessoryType) tableView:(UITableView *) tv accessoryTypeForRowWithIndexPath:(NSIndexPath *) indexPath{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)dealloc {
	[bizCategories release];
    [super dealloc];
}

@end


