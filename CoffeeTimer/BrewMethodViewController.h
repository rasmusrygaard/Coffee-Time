//
//  BrewMethodViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrewMethod.h"
#import "SliderTabBarView.h"

@interface BrewMethodViewController : UIViewController
{
    BrewMethod *currentMethod;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *timerLabel;
    IBOutlet UILabel *descriptionLabel;
    
    IBOutlet UIButton *changeMethodButton;
    IBOutlet UIButton *startTimerButton;
    IBOutlet UIButton *stopTimerButton;
    
    IBOutlet UITableView *infoTableView;
    NSTimer *timer;
    NSString *methodBeingTimed;
    
    NSDate *finishTime;
    
    SliderTabBarView *stbView;
}

- (IBAction)startTimerClicked:(id)sender;
- (IBAction)stopTimerClicked:(id)sender;

- (void)setAndStartTimerForStep:(TimerStep *)step;
- (void)setupLabelsForTimerStep:(TimerStep *)step;

@property (nonatomic, retain) BrewMethod *currentMethod;

@end
