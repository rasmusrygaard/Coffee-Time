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

@protocol BrewMethodList <NSObject>

-(void)resetAfterFinishedMethod;

@end

@interface BrewMethodViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    BrewMethod *currentMethod;
    
    /* Model data references */
    NSMutableArray *instructions;
    NSArray *preparation;
    NSArray *equipment;
    
    /* Labels */
    IBOutlet UILabel *timerLabel;
    
    /* Buttons */
    IBOutlet UIButton *startTimerButton;
    IBOutlet UIButton *stopTimerButton;
    
    /* TableView */
    IBOutlet UITableView *infoTableView;
    UITableViewCell *tvCell;
    
    /* Timer Functionality */
    NSTimer *timer;
    NSString *methodBeingTimed;
    NSDate *finishTime;
    
    /* KVO for list */
    int secondsLeft;
    
    /* Slider tab bar */
    SliderTabBarView *stbView;
    NSString *tabDisplayed;
    
    BOOL autoStartMethod;
    
    /* The parent view should be able to reset */
    id<BrewMethodList> superList;
}

- (IBAction)startTimerClicked:(id)sender;
- (IBAction)stopTimerClicked:(id)sender;

- (NSArray *)descriptionsForCurrentTab;

/* Function: - (void)removeTopInstructionsCellWithAnimation:(BOOL)animated
 *                                           remainingSteps:(int)remaining
 * This function is almost indentical to removeTopInstructionsCell.. without
 * the second parameter. The difference is that we here get rid of any additional
 * instructions before removing with or without animation, making sure that the UI
 * is up to date. This would be relevant if multiple notifications have fired
 * between updates to the UI, meaning that there are redundant cells present.
 * The second parameter should specify the number of cells in the tableView _after_
 * removing the top cell. So, if we want to have only 1 cell left, remaining should be 1
 */

- (void)removeTopInstructionsCellWithAnimation:(BOOL)animated
                                remainingSteps:(int)remaining;

- (void)removeTopInstructionsCellWithAnimation:(BOOL)animated;
- (void)resetInstructions;
- (void)updateTimeOnTopCell;
- (void)brewMethodFinished;

- (void)setAndStartTimerForMethod:(BrewMethod *)method;

- (void)startStarredMethod;
- (BOOL)timerIsRunning;

@property (nonatomic, retain) BrewMethod *currentMethod;
@property (nonatomic, retain) NSMutableArray *instructions;
@property (nonatomic, retain) NSArray *preparation;
@property (nonatomic, retain) NSArray *equipment;
@property (nonatomic, assign) NSString *tabDisplayed;

@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property (nonatomic, retain) UITableView *infoTableView;

@property (nonatomic, readonly) NSString *methodBeingTimed;

@property (nonatomic, assign) int secondsLeft;

@property (nonatomic, assign) BOOL autoStartMethod;

@property (nonatomic, assign) id<BrewMethodList> superList;

@end
