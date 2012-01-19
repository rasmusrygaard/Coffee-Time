//
//  AddDetailViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 17/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDetailViewController : UITableViewController <UITextFieldDelegate, UITableViewDelegate>
{
    NSString *detailType;
    
    NSMutableArray *data;
    
    IBOutlet UITableViewCell *detailCell;
    
    BOOL wantsToLeaveView;
}

@property (nonatomic, assign) NSString *detailType;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, assign) IBOutlet UITableViewCell *detailCell;
@property (nonatomic, assign) BOOL wantsToLeaveView;

@end