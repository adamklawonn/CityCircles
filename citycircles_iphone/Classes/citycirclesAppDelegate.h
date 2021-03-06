//
//  citycirclesAppDelegate.h
//  citycircles
//
//  Created by mjamison on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"
#import "FavoritesViewController.h"

@class citycirclesViewController;
@class HomeNavController;

@interface citycirclesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    citycirclesViewController *viewController;
	HomeNavController *navController;
	UITabBarController *tabnavController;
	
	//TEST DATA
	NSMutableArray *lrStations;
	NSMutableArray *bizCategories;
	
	//THE REAL DATA
	NSMutableArray *southStations;
	NSMutableArray *northStations;
	Models *dbModels;
	
	UIImageView *splashView;
	FavoritesViewController *fav_view;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet citycirclesViewController *viewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabnavController;
@property (nonatomic, retain) NSMutableArray *lrStations;
@property (nonatomic, retain) NSMutableArray *bizCategories;

@property (nonatomic, retain) NSMutableArray *southStations;
@property (nonatomic, retain) NSMutableArray *northStations;
@property (nonatomic, retain) FavoritesViewController *fav_view;
@property (nonatomic, retain) Models *dbModels;

//@property (nonatomic, retain) HomeNavController *navController;  //nav controller thats shows when home tab pressed
@end

