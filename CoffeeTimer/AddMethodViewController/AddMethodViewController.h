//
//  AddMethodViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMethodView.h"

@interface AddMethodViewController : UIViewController 
{
    IBOutlet UIView *addMethodView;
}

-(IBAction)editedEquipment:(id)sender;
-(IBAction)addInstructionsTapped:(id)sender;
-(IBAction)addPreparationTapped:(id)sender;

-(IBAction)saveButtonTapped:(id)sender;

@property (nonatomic, retain) IBOutlet UIView *addMethodView;

@end
