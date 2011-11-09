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

@interface BrewMethodViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    BrewMethod *currentMethod;
    NSMutableArray *instructions;
    NSArray *preparation;
    NSArray *equipment;
    
    IBOutlet UILabel *timerLabel;
    
    IBOutlet UIButton *startTimerButton;
    IBOutlet UIButton *stopTimerButton;
    
    IBOutlet UITableView *infoTableView;
    UITableViewCell *tvCell;
    
    NSTimer *timer;
    NSString *methodBeingTimed;
    
    NSDate *finishTime;
    int remainingTimeAfterCurrentStep;
    int secondsLeft;
    
    SliderTabBarView *stbView;
    NSString *tabDisplayed;
}

- (IBAction)startTimerClicked:(id)sender;
- (IBAction)stopTimerClicked:(id)sender;

- (NSArray *)descriptionsForCurrentTab;

- (void)removeTopInstructionsCellWithAnimation:(BOOL)animated;
- (void)resetInstructions;
- (void)updateTimeOnTopCell:(NSTimeInterval)timeElapsed;
- (void)brewMethodFinished;

- (void)setAndStartTimerForMethod:(BrewMethod *)method;
- (void)setupLabelsForTimerStep:(TimerStep *)step;

- (void)startStarredMethod;

@property (nonatomic, retain) BrewMethod *currentMethod;
@property (nonatomic, retain) NSMutableArray *instructions;
@property (nonatomic, retain) NSArray *preparation;
@property (nonatomic, retain) NSArray *equipment;
@property (nonatomic, assign) NSString *tabDisplayed;
@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;

@property (nonatomic, readonly) NSString *methodBeingTimed;

@property (nonatomic, assign) int secondsLeft;

@end
