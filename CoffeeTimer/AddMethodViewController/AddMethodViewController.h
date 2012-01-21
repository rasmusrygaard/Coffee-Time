//
//  AddMethodViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMethodView.h"
#import "BrewMethod.h"

#import "AddDetailViewController.h"

@interface AddMethodViewController : UITableViewController <UITextFieldDelegate>
{
    AddDetailViewController *adVC;
    
    IBOutlet UITableViewCell *amCell;
    
    NSMutableDictionary *basicInfo;
    NSMutableArray *instructions;
    NSMutableArray *preparation;
    
    id delegate;
}

- (void)userDidFinishEditingBrewMethod:(BrewMethod *)bm;

- (UIImageView *)imageForCellAtIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, retain) IBOutlet UITableViewCell *amCell;
@property (nonatomic, retain) AddDetailViewController *adVC;

@end
