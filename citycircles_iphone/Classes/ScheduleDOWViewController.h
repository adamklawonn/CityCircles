//
//  ScheduleDOWViewController.h
//  citycircles
//
//  Created by mjamison on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduleDOWViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate>{
	int stationID;
}
-(id) initWithStationID: (int) sID;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end
