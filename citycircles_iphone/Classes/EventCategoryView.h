//
//  EventCategoryView.h
//  citycircles
//
//  Created by mjamison on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventCategoryView : UIViewController 
<UITableViewDataSource, UITableViewDelegate>{
	NSMutableArray *activeEventCats;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end
