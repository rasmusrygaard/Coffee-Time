//
//  AddMethodView.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMethodView : UIView
{
    IBOutlet UILabel *equipmentField;
    IBOutlet UITableView *instructionsHints;
}

@property (nonatomic, retain) IBOutlet UILabel *equipmentField;
@property (nonatomic, retain) IBOutlet UITableView *instructionsHints;

@end
