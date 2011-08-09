//
//  FavoritesViewController.h
//  citycircles
//
//  Created by mjamison on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavoritesViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate>{
	NSMutableArray *liBizFavs;
	NSMutableArray *liEventFavs;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
-(void) reloadData;
@end
