//
//  AddDetailViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 17/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDetailViewController : UITableViewController
{
    NSString *detailType;
    NSMutableArray *data;
}

@property (nonatomic, assign) NSString *detailType;
@property (nonatomic, retain) NSMutableArray *data;

@end
