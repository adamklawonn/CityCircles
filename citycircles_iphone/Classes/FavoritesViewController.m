//
//  FavoritesViewController.m
//  citycircles
//
//  Created by mjamison on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Models.h"
#import "BusinessView.h"
#import "EventView.h"
#import "citycirclesAppDelegate.h"

@implementation FavoritesViewController
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

-(id) init{
	if (self = [super init])
    {		
		Models *dbModels = [[Models alloc] init];
		liBizFavs = [dbModels getAllFavorites: 1];
		liEventFavs = [dbModels getAllFavorites: 0];
		[dbModels release];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) reloadData{
	[liBizFavs release];
	[liEventFavs release];
	Models *dbModels = [[Models alloc] init];
	liBizFavs = [dbModels getAllFavorites: 1];
	liEventFavs = [dbModels getAllFavorites: 0];
	[dbModels release];
	[tableView reloadData];
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
	NSMutableArray *thiscell;
	if (indexPath.section == 0){
		thiscell = [liBizFavs objectAtIndex: indexPath.row];
	} else {
		thiscell = [liEventFavs objectAtIndex: indexPath.row];
	}
	
	cell.textLabel.text = (NSString *)[thiscell objectAtIndex: 1];
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0){
		return @"Favorite Businesses";
		
	}  else {
		return @"Favorite Events";
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
		if ([liBizFavs count] == 0) {
			label.text = @"No Favorite Businesses";
		} else {
			label.text = @"Favorite Businesses";
		}

		
	} else {
		if ([liEventFavs count] == 0) {
			label.text = @"No Favorite Events";
		} else {
			label.text = @"Favorite Events";
		}

		
	}
	
	[headerView addSubview:label];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [liBizFavs count];
	} else {
		return [liEventFavs count];
	}
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	
	
	if (indexPath.section == 0){
		NSMutableArray *bizDetails = [liBizFavs objectAtIndex: indexPath.row];
		BusinessView *thisView = [[BusinessView alloc] initWithBizID:  [(NSString *)[bizDetails objectAtIndex: 0] intValue]];
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
		[[delegate.tabnavController selectedViewController] pushViewController: thisView animated: YES];
		[thisView release];
	} else {
		NSMutableArray *evnDetails = [liEventFavs objectAtIndex: indexPath.row];
		EventView *thisView = [[EventView alloc] initWithEventID:  [(NSString *)[evnDetails objectAtIndex: 0] intValue]];
		citycirclesAppDelegate *delegate = (citycirclesAppDelegate *)[[UIApplication sharedApplication] delegate];
		[[delegate.tabnavController selectedViewController] pushViewController: thisView animated: YES];
		[thisView release];
	}
	
	
	
	[tv deselectRowAtIndexPath: indexPath animated: YES];	
}



- (void)dealloc {
	[liBizFavs release];
	[liEventFavs release];
	[tableView release];
    [super dealloc];
}


@end
