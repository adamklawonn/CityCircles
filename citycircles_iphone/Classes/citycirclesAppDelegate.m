//
//  citycirclesAppDelegate.m
//  citycircles
//
//  Created by mjamison on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "citycirclesAppDelegate.h"
#import "citycirclesViewController.h"
#import "Models.h"

@implementation citycirclesAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize tabnavController;
@synthesize lrStations;
@synthesize bizCategories;
@synthesize southStations;
@synthesize northStations;
@synthesize dbModels;
@synthesize fav_view;
//@synthesize navController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	//TODO: PULL IN STATIONS FROM DATABASE
	NSMutableArray *thisArray = [[NSMutableArray alloc] initWithObjects: @"McDowell", @"Thunderbird", nil];
	self.lrStations = thisArray;
	
	self.bizCategories = [[NSMutableArray alloc] initWithObjects: @"Fast Food", @"Coffee Shops", nil];
	
	dbModels = [[Models alloc] init];
	
	self.southStations = [dbModels getAllStations: @"S"];
	self.northStations = [dbModels getAllStations: @"N"];

    // Add the view controller's view to the window and display.
    //[self.window addSubview:viewController.view];
	[self.window addSubview:tabnavController.view];
    [self.window makeKeyAndVisible];
	
	// Make this interesting.  
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];  
	splashView.image = [UIImage imageNamed:@"Default.png"];  
	[window addSubview:splashView];  
	[window bringSubviewToFront:splashView];  
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:2.0];  
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];  
	[UIView setAnimationDelegate:self];   
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];  
	splashView.alpha = 0.0;  
	splashView.frame = CGRectMake(-60, -85, 440, 635);  
	[UIView commitAnimations]; 
	

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[dbModels release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
