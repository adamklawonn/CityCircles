//
//  FavNavController.m
//  citycircles
//
//  Created by mjamison on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavNavController.h"
#import "FavoritesViewController.h"
#import "citycirclesAppDelegate.h"


@implementation FavNavController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
	//delegate.navController = self; //save a reference to this instantiated nav controller in the app deligate
	FavoritesViewController *thisController = [[FavoritesViewController alloc] init];
	delegate.fav_view = thisController;
	self.viewControllers = [NSArray arrayWithObject: thisController]; //add the RootController
	[thisController release];
    [super viewDidLoad];
}

@end
