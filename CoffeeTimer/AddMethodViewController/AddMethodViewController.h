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
    IBOutlet UIView *addMethodView;
    IBOutlet UITableViewCell *amCell;
}

-(IBAction)editedEquipment:(id)sender;
-(IBAction)addInstructionsTapped:(id)sender;
-(IBAction)addPreparationTapped:(id)sender;

-(IBAction)saveButtonTapped:(id)sender;

- (UIImageView *)imageForCellAtIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, retain) IBOutlet UIView *addMethodView;
@property (nonatomic, retain) IBOutlet UITableViewCell *amCell;

@end
