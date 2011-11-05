//
//  BrewMethodViewController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrewMethodViewController.h"
#import "BrewMethod.h"
#import "TimerStep.h"
#import "Constants.h"
#import "SliderTabBarView.h"
#import <AudioToolbox/AudioServices.h>

@implementation BrewMethodViewController

@synthesize currentMethod, preparation, instructions, equipment, tabDisplayed, tvCell, methodBeingTimed;

/*
 * Function: - (void)initializeInfoTableView
 * Use this function to initialize the infoTableView displaying the tabs from
 * the sliderTabBarView. Do any custom styling of the table and its properties
 */

- (void)initializeInfoTableView
{
    
    // Set table style
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    infoTableView.backgroundColor = [UIColor clearColor];
    infoTableView.opaque = NO;
    
    // Set no bounce
    infoTableView.bounces = NO;
    [self.view addSubview:infoTableView];
}

- (id)init
{
    if (self = [super init]) {
        [super initWithNibName:@"BrewMethodViewController" bundle:nil];
        
        [[[self navigationItem] backBarButtonItem] setTitle:@"Methods"];
        
        if (!infoTableView) {
            CGRect infoRect = CGRectMake(INFO_WINDOW_X, 
                                         INFO_WINDOW_Y,
                                         INFO_WINDOW_W, 
                                         INFO_WINDOW_H);
            infoTableView = [[UITableView alloc] initWithFrame:infoRect style:UITableViewStylePlain];
            
            // Set up delegate and datasource roles
            infoTableView.delegate = self;
            infoTableView.dataSource = self;
            
            [self initializeInfoTableView];
        }

    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return self;
}

#pragma mark - Timer functionality

/*
 * Function: - (IBAction)startTimerClicked:(id)sender
 * --------------------------------------------------
 * This function is the callback function for the timer's start button.
 * Clicking it gets the time interval from the current method and starts
 * the timer to update the label.
 */

- (IBAction)startTimerClicked:(id)sender
{
    if (!timer) {
//        TimerStep *step = [currentMethod firstTimerStep];
//        remainingTimeAfterCurrentStep -= [step timeInSeconds];

        [self setAndStartTimerForMethod:currentMethod];
        
        methodBeingTimed = [currentMethod name];
        }
}

/*
 * Function: - (void)scheduleNotificationsForSteps:(NSArray *)timerSteps
 * Schedule local notifications for all timer steps for the current method.
 */
- (void)scheduleNotificationsForSteps:(NSArray *)timerSteps
{
    int totalTime = 0;
    for (TimerStep *t in timerSteps) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        
        totalTime += [t timeInSeconds];
        localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:totalTime];
        
        localNotif.alertBody = [t descriptionWithoutTime];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        [localNotif release];
    }
}

/*
 * Function: - (void)setAndStartTimerForMethod:(BrewMethod *)method
 * Set the timer that will run for the entire duration of the method
 */

- (void)setAndStartTimerForMethod:(BrewMethod *)method
{
    finishTime = [NSDate dateWithTimeIntervalSinceNow:([method totalTimeInSeconds])];
    [finishTime retain];
    
    
    [self scheduleNotificationsForSteps:[method timerSteps]];
    
    // Start timer
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_UPDATE_INTERVAL 
                                             target:self
                                           selector:@selector(checkTimerStatus:) 
                                           userInfo:nil
                                            repeats:YES];
    
}

/*
 * Function: - (void)resetDisplay
 * Reset the current state of the display to reflect the first
 * TimerStep for the current method
 */

- (void)resetDisplay
{
    [self resetInstructions];
    
    [currentMethod resetTimerSteps];
}


- (void)clearTimer:(NSTimer *)theTimer
{
    [finishTime release];
    
    // Clear the timer
    [theTimer invalidate]; 
    timer = nil;
}

- (void)resetTimerLabel
{
    remainingTimeAfterCurrentStep = [currentMethod totalTimeInSeconds];

    [timerLabel setText:[TimerStep formattedTimeInSecondsForInterval:remainingTimeAfterCurrentStep]];
}

- (void)resetState
{
    [self resetDisplay];
    
    // Update the info on the screen to reflect the first step
    [self resetInstructions];
    [currentMethod resetTimerSteps];
    
    methodBeingTimed = nil;
    
    [self resetTimerLabel];
}

- (IBAction)stopTimerClicked:(id)sender
{
    if (timer) { // If there is a running timer
        [self clearTimer:timer];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self resetState];
    }
}

/* - (void)removeTopInstructionsCellWithAnimation
 * Removes the top cell from the infoTableView. Should only be called
 * when the Instructions tab is active, since this method will remove
 * the top cell regardless of which tab is displayed.
 */

- (void)removeTopInstructionsCellWithAnimation
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [infoTableView beginUpdates];

    [instructions removeObjectAtIndex:0];

    if ([tabDisplayed isEqualToString:@"Instructions"]) {
        [infoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path]
                             withRowAnimation:UITableViewRowAnimationTop];
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [infoTableView endUpdates];

//    [infoTableView reloadData];
}

/* - (void)resetInstructions
 * Grab the array of instructions and populate the tableview with the cells. This will
 * add any cells that were previously removed during the runtime of the timer. 
 */

- (void)resetInstructions
{
    NSArray *instArr = [currentMethod descriptionsForTab:@"Instructions"];
    [self setInstructions:[NSMutableArray arrayWithArray:instArr]];
    [infoTableView reloadData];
}

- (void)updateTimeOnTopCell:(NSTimeInterval)timeElapsed /// get rid of parameter
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *currentNotif = [notifications objectAtIndex:0];
    
    UILabel *label;
    UITableViewCell *topCell = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 
                                                                                       inSection:0]];
    
    NSTimeInterval timeLeft = [[currentNotif fireDate] timeIntervalSinceNow];
    
    label = (UILabel *)[topCell viewWithTag:2];
    [label setText:[TimerStep formattedTimeInSecondsForInterval:(int)timeLeft]];
}

- (BOOL)timerIsDone
{
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceNow:0];
    NSComparisonResult compar = [currentTime compare:finishTime];
    
    return (compar == NSOrderedSame ||
            compar == NSOrderedDescending);
}

- (void)updateRemainingTime
{
    NSTimeInterval timeElapsed = [finishTime timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    [timerLabel setText:[TimerStep formattedTimeInSecondsForInterval:timeElapsed]];
    
    if ([tabDisplayed isEqualToString:@"Instructions"]) {
        [self updateTimeOnTopCell:timeElapsed];
    }
}

- (void)checkTimerStatus:(NSTimer *)theTimer
{
    if ([self timerIsDone]) {
        /*
        [self clearTimer:theTimer];
        
        TimerStep *nextStep = [currentMethod nextTimerStep];
        
        if (nextStep) { // If there is a next step
            
            [self setupLabelsForTimerStep:nextStep];
            [self setAndStartTimerForStep:nextStep];
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            localNotif.alertBody = [nextStep descriptionWithoutTime];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            
            
            // Delete first cell
            [self removeTopInstructionsCellWithAnimation];
            
        } else {*/
            AudioServicesPlayAlertSound(1000);
            NSString *msg = [NSString stringWithFormat:@"Time for a delicious cup of %@!", [currentMethod name]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"It's Coffee Time!"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            methodBeingTimed = nil;
            [self resetState];
        [self clearTimer:theTimer];
//            [self resetDisplay];
     /*   }*/
        
    } else {
        [self updateRemainingTime];
    }
}

/* - (void)setupLabelsForTimerStep:(TimerStep *)step
 * -------------------------------------------------
 * Update the labels on the screen to reflect the info of the TimerStep
 */

- (void)setupLabelsForTimerStep:(TimerStep *)step
{
    remainingTimeAfterCurrentStep -= [step timeInSeconds];
    [timerLabel setText:[TimerStep formattedTimeInSecondsForInterval:remainingTimeAfterCurrentStep]];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - sliderTabBar functionality

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *t = [touches anyObject];
    
    // If touch is inside tabBar
    if ([t view] == stbView) {
        NSString *tab = [stbView tabTitleForTouch:t];
        [stbView updateDisplayForTab:tab
                           forMethod:currentMethod];
        
        tabDisplayed = tab;

        [NSTimer scheduledTimerWithTimeInterval:SLIDER_DURATION
                                         target:self
                                       selector:@selector(updateTable:) 
                                       userInfo:nil
                                        repeats:NO];
    }

}

/*
 * Function: - (void)updateTable:(NSTimer *)theTimer
 * Update the tableView after the slider animation timer has fired
 */

- (void)updateTable:(NSTimer *)theTimer
{
    [infoTableView reloadData];
}

#pragma mark - TableView functionality

- (NSArray *)descriptionsForCurrentTab
{
    NSArray *tabArray;
    
    if (tabDisplayed == @"Instructions") {
        tabArray = instructions;
    } else if (tabDisplayed == @"Preparation") {
        tabArray = preparation;
    } else {
        tabArray = equipment;
    }
    
    return tabArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the array of descriptions
    NSArray *descriptions = [self descriptionsForCurrentTab];
    
    UITableViewCell *cell;
    
    if ([tabDisplayed isEqualToString:@"Instructions"]) {
        cell = [infoTableView dequeueReusableCellWithIdentifier:@"BrewMethodTableViewCell"];
        
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"BrewMethodTableViewCell" owner:self options:nil];
            cell = tvCell;
            [self setTvCell:nil];
        }
    } else {
        cell = [infoTableView dequeueReusableCellWithIdentifier:@"BrewMethodTableViewSimpleCell"];
        
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"BrewMethodTableViewSimpleCell" owner:self options:nil];
            cell = tvCell;
            [self setTvCell:nil];
        }
    }
    
    [[cell backgroundView] setContentMode:UIViewContentModeScaleToFill];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell.png"]];
    [cell setBackgroundView:img];
    [img release];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [descriptions objectAtIndex:indexPath.row];
    label.numberOfLines = 0;
    
    // Display time for cells under "Instructions"
    if ([tabDisplayed isEqualToString:@"Instructions"]) {
        label = (UILabel *)[cell viewWithTag:2];
        NSString *text = [[currentMethod timeIntervals] objectAtIndex:indexPath.row];
        label.text = text;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *steps;
    
    if([tabDisplayed isEqualToString:@"Instructions"]) {

        steps = instructions;

    } else {

        steps = [currentMethod descriptionsForTab:tabDisplayed];
    }
    
    return [steps count];
}

/* Function: -(CGFloat)tableView:(UITableView *)tableView 
 heightForRowAtIndexPath:(NSIndexPath *)indexPath
 * Determine the height for a row in the info table. If the text can fit in MIN_CELL_HEIGHT
 * use that as the height. Otherwise, have the text fit with CELL_INSET padding.
 */

-(CGFloat)tableView:(UITableView *)tableView 
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *descriptions = [self descriptionsForCurrentTab];
    NSString *text = [descriptions objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0 ];
    
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(INFO_CELL_WIDTH, MAXFLOAT)];
    
    CGFloat height;
    if (textSize.height + CELL_INSET < MIN_CELL_HEIGHT) {
        height = MIN_CELL_HEIGHT;
    } else {
        height = textSize.height + CELL_INSET;
    }

    return height;
    
}

- (void)initializeDescriptions
{
    NSMutableArray *instr = [NSMutableArray arrayWithArray:[currentMethod descriptionsForTab:@"Instructions"]];
    [self setInstructions:instr];
    [self setPreparation:[currentMethod descriptionsForTab:@"Preparation"]];
    [self setEquipment:[currentMethod descriptionsForTab:@"Equipment"]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [startTimerButton addTarget:self 
                         action:@selector(startTimerClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [stopTimerButton addTarget:self 
                        action:@selector(stopTimerClicked:) 
              forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Create a rectangle for the sliderTabBarView
    CGRect rect = CGRectMake(SLIDER_TAB_BAR_X, 
                             SLIDER_TAB_BAR_Y, 
                             SLIDER_TAB_BAR_W, 
                             SLIDER_TAB_BAR_H);
    stbView = [[SliderTabBarView alloc] initWithFrame:rect];
    [stbView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:stbView];
    
    if (timer) {
        if(![self.navigationItem.title isEqualToString:methodBeingTimed]) {
            // If we're on a new method, forget about the old timer
            [timer invalidate];
            timer = nil;
        
            methodBeingTimed = nil;
            
            [self initializeDescriptions];
            [self resetTimerLabel];
        }
    } else {
        [self initializeDescriptions];
        [self resetTimerLabel];   
    } 
     [self setTabDisplayed:@"Instructions"];
    
    [infoTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [timerLabel release];
    timerLabel = nil;
    
    [startTimerButton release];
    startTimerButton = nil;
    
    [stopTimerButton release];
    stopTimerButton = nil;
    
    [stbView release];
    stbView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [stbView release];
    
    [currentMethod release];

    [timerLabel release];
    
    [startTimerButton release];
    [stopTimerButton release];
    [timer release];
    
    [finishTime release];
    
    [instructions release];
    [preparation release];
    [equipment release];
    
    [super dealloc];
}

@end