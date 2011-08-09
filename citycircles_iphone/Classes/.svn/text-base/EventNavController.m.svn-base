//
//  EventNavController.m
//  citycircles
//
//  Created by mjamison on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventNavController.h"
#import "EventCategoryView.h"

@implementation EventNavController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//citycirclesAppDelegate *delegate = (citycirclesAppDelegate *) [[UIApplication sharedApplication] delegate];
	//delegate.navController = self; //save a reference to this instantiated nav controller in the app deligate
	EventCategoryView *thisController = [[EventCategoryView alloc] init];
	self.viewControllers = [NSArray arrayWithObject: thisController]; //add the RootController
	[thisController release];
    [super viewDidLoad];
}


@end
