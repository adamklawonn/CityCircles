//
//  BusinessSelect.h
//  citycircles
//
//  Created by mjamison on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BusinessSelect : UIViewController 
<UITableViewDataSource, UITableViewDelegate>{
	int stationID;
	int categoryID;
	
	NSMutableArray *bizList;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
