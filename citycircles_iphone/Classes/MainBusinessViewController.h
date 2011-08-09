//
//  MainBusinessViewController.h
//  citycircles
//
//  Created by mjamison on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainBusinessViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate>
{
	//NSMutableArray *lrStations;
	NSMutableArray *northStations;
	NSMutableArray *southStations;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end
