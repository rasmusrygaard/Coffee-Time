//
//  AddMethodViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMethodView.h"

@interface AddMethodViewController : UITableViewController <UITextFieldDelegate>
{
    IBOutlet UITableViewCell *amCell;
    NSMutableDictionary *basicInfo;
    NSMutableArray *instructions;
    NSMutableArray *preparation;
}

- (UIImageView *)imageForCellAtIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, retain) IBOutlet UITableViewCell *amCell;

@end
