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

@synthesize currentMethod, preparation, instructions, equipment, tabDisplayed, tvCell, methodBeingTimed, secondsLeft, infoTableView, autoStartMethod, superList;

/*
 * Function: - (void)initializeInfoTableView
 * Use this function to initialize the infoTableView displaying the tabs from
 * the sliderTabBarView. Do any custom styling of the table and its properties
 */

- (void)initializeInfoTableView
{    
    // Set table style
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTableView.backgroundColor = [UIColor clearColor];
    self.infoTableView.opaque = NO;
    
    self.infoTableView.bounces = NO;
    [self.view addSubview:self.infoTableView];
}

/*
 * Function: - (void)initializeDescriptions
 * Get the data for the current method from the BrewMethod class
 */

- (void)initializeDescriptions
{
    [self setInstructions:[NSMutableArray arrayWithArray:[currentMethod descriptionsForTab:@"Instructions"]]];
    [self setPreparation:[currentMethod descriptionsForTab:@"Preparation"]];
    [self setEquipment:[currentMethod descriptionsForTab:@"Equipment"]];
}


- (id)init
{
    if (self = [super init]) {
        [super initWithNibName:@"BrewMethodViewController" bundle:nil];
        
        [[[self navigationItem] backBarButtonItem] setTitle:@"Methods"];
        
        if (!self.infoTableView) {
            CGRect infoRect = CGRectMake(INFO_WINDOW_X, 
                                         INFO_WINDOW_Y,
                                         INFO_WINDOW_W, 
                                         INFO_WINDOW_H);
            self.infoTableView = [[UITableView alloc] initWithFrame:infoRect style:UITableViewStylePlain];
            
            // Set up delegate and datasource roles
            self.infoTableView.delegate = self;
            self.infoTableView.dataSource = self;
            
            [self initializeInfoTableView];
        }
        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return self;
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


- (void)clearTimer
{
    [finishTime release];
    finishTime = nil;
    
    [timer invalidate]; 
    timer = nil;
}

- (void)resetTimerLabel
{
    secondsLeft = [currentMethod totalTimeInSeconds];
    
    NSString *secondsLeftStr = [TimerStep formattedTimeInSecondsForInterval:secondsLeft];
    timerLabel.text = secondsLeftStr;
    timerLabel.accessibilityLabel = secondsLeftStr;
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
        [self setAndStartTimerForMethod:currentMethod];
        
        methodBeingTimed = [currentMethod name];
    }
}

- (void)startStarredMethod
{
    [self resetState];
    [[UIApplication sharedApplication] cancelAllLocalNotifications]; /// Kind of a hack
    [self initializeDescriptions];
    [self.infoTableView reloadData];
    [self startTimerClicked:nil];
}

- (BOOL)timerIsRunning
{
    return (timer != nil);
}

/*
 * Function: - (void)scheduleNotificationsForSteps:(NSArray *)timerSteps
 * Schedule local notifications for all timer steps for the current method.
 * Since we want to see the notification text for the next instruction and not
 * for the one that we are just finishing, we schedule notifications with the
 * next element in the array for all steps. For the last one, the alert body
 * should be a message notifying the user that their brew is done.
 */

- (void)scheduleNotificationsForSteps:(NSArray *)timerSteps
{
    int totalTime = 0;
    
    for (int i = 0, count = [timerSteps count]; i < count; ++i) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        
        totalTime += [[timerSteps objectAtIndex:i] timeInSeconds];
        localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:totalTime];
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        
        NSString *body;
        
        // If we are scheduling the last notification, notify the user that they are done
        if (i == (count - 1)) { 
            body = [NSString stringWithFormat:@"It's Coffee Time! Your %@ is done.", [currentMethod name]];
        } else {
            body = [NSString stringWithFormat:@"%@: %@",
                    [currentMethod name],
                    [[timerSteps objectAtIndex:(i + 1)] descriptionWithoutTime]];
        }
        
        localNotif.alertBody = body;
        
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
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_UPDATE_INTERVAL 
                                             target:self
                                           selector:@selector(checkTimerStatus:) 
                                           userInfo:nil
                                            repeats:YES];
    
}

- (IBAction)stopTimerClicked:(id)sender
{
    if (timer) { // If there is a running timer
        [self clearTimer];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self resetState];
    }
}

/* - (void)removeTopInstructionsCellWithAnimation
 * Removes the top cell from the infoTableView. Should only be called
 * when the Instructions tab is active, since this method will remove
 * the top cell regardless of which tab is displayed.
 */

- (void)removeTopInstructionsCellWithAnimation:(BOOL)animated
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if (animated) {
        [self.infoTableView beginUpdates];
        
        [self.instructions removeObjectAtIndex:0];
        
        if ([tabDisplayed isEqualToString:@"Instructions"]) {
            [self.infoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path]
                                      withRowAnimation:UITableViewRowAnimationTop];
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self.infoTableView endUpdates];
    } else {
        [self.instructions removeObjectAtIndex:0];
        [self.infoTableView reloadData];
    }
    
    // Update the accessibilityLabel of the top cell to reflect that 
    // it is now the current step
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell   = [self.infoTableView cellForRowAtIndexPath:ip];
    cell.accessibilityLabel = @"Current step: "; /// Include time left after merge

    UILabel *label  = (UILabel *)[cell viewWithTag:1];
    cell.accessibilityHint  = [label text];

    /* Make sure that the accessible interface is updatet too */    
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
    
}

/* - (void)resetInstructions
 * Grab the array of instructions and populate the tableview with the cells. This will
 * add any cells that were previously removed during the runtime of the timer. 
 */

- (void)resetInstructions
{
    NSArray *instArr = [currentMethod descriptionsForTab:@"Instructions"];
    [self setInstructions:[NSMutableArray arrayWithArray:instArr]];
    [self.infoTableView reloadData];
}

- (void)updateTimeOnTopCell:(NSTimeInterval)timeElapsed /// get rid of parameter
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // Only update time if we have not exhausted all notifications
    if ([notifications count] > 0) {
        UILocalNotification *currentNotif = [notifications objectAtIndex:0];
        
        UITableViewCell *topCell = [self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 
                                                                                                inSection:0]];
        
        NSTimeInterval remainingTime = [[currentNotif fireDate] timeIntervalSinceNow];
        NSString *remaininTimeStr = [TimerStep formattedTimeInSecondsForInterval:remainingTime];
        
        UILabel *label;
        label = (UILabel *)[topCell viewWithTag:2];
        label.text = remaininTimeStr;
    }
}

/* Function: - (BOOL)timerIsDone
 * Returns true if finishTime is at or after the current system time
 */

- (BOOL)timerIsDone
{
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceNow:0];
    NSComparisonResult compar = [currentTime compare:finishTime];
    
    return (compar == NSOrderedSame ||
            compar == NSOrderedDescending);
}

- (void)updateRemainingTime
{
    self.secondsLeft = [finishTime timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *secondsLeftStr = [TimerStep formattedTimeInSecondsForInterval:secondsLeft];
    self->timerLabel.text = secondsLeftStr;
    self->timerLabel.accessibilityLabel = secondsLeftStr;
    
    if ([tabDisplayed isEqualToString:@"Instructions"]) {
        [self updateTimeOnTopCell:secondsLeft];
    }
}

- (void)brewMethodFinished
{
    [self.superList resetAfterFinishedMethod];
    AudioServicesPlayAlertSound(1000);
    NSString *msg = [NSString stringWithFormat:@"Enjoy a delicious cup of %@ brew!", [currentMethod name]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"It's Coffee Time!"
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    methodBeingTimed = nil;
    [self resetState];
    [self clearTimer];
}

- (void)checkTimerStatus:(NSTimer *)theTimer
{
    [self updateRemainingTime];
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
    [self.infoTableView reloadData];
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
    NSArray *descriptions = [self descriptionsForCurrentTab];
    
    UITableViewCell *cell;
    
    if ([tabDisplayed isEqualToString:@"Instructions"]) { /// TODO: Consider moving this into separate function
        cell = [self.infoTableView dequeueReusableCellWithIdentifier:@"BrewMethodTableViewCell"];
        
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"BrewMethodTableViewCell" owner:self options:nil];
            cell = tvCell;
            [self setTvCell:nil];
        }
    } else {
        cell = [self.infoTableView dequeueReusableCellWithIdentifier:@"BrewMethodTableViewSimpleCell"];
        
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
    
    if ([tabDisplayed isEqualToString:@"Instructions"]) {
        TimerStep *t = [descriptions objectAtIndex:indexPath.row];
        
        label       = (UILabel *)[cell viewWithTag:1];
        label.text  = [t descriptionWithoutTime];
        label.numberOfLines = 0;
        
        label       = (UILabel *)[cell viewWithTag:2];
        label.text  = [t formattedTimeInSeconds];
        
        /* Accessibility */
        if (indexPath.row == 0) {
            label.accessibilityLabel = @"Current step";
        } else {
            label.accessibilityLabel = [NSString stringWithFormat:@"Step %d", indexPath.row];
        }
    } else {
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        label.text = [descriptions objectAtIndex:indexPath.row];
        label.numberOfLines = 0;
    }
    
    /* Accessibility */
    cell.isAccessibilityElement = NO;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRows;
    
    if([tabDisplayed isEqualToString:@"Instructions"]) {
        
        numRows = [instructions count];
        
    } else {
        
        NSArray *steps = [currentMethod descriptionsForTab:tabDisplayed];
        numRows = [steps count];
        
    }

    return numRows;
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
    NSString *text;
    
    if ([tabDisplayed isEqualToString:@"Instructions"]) {
        if (indexPath.row >= [descriptions count])
            return MIN_CELL_HEIGHT; /// Kind of a hack
        
        TimerStep *t = [descriptions objectAtIndex:indexPath.row];
        text = [t descriptionWithoutTime];
    } else {
        text = [descriptions objectAtIndex:indexPath.row];
    }
    
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    [startTimerButton addTarget:self 
                         action:@selector(startTimerClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [stopTimerButton addTarget:self 
                        action:@selector(stopTimerClicked:) 
              forControlEvents:UIControlEventTouchUpInside];
    
    /* Accessibility */
    timerLabel.isAccessibilityElement   = YES;
    timerLabel.accessibilityHint        = @"Displays remaining time";
    
    startTimerButton.isAccessibilityElement = YES;
    startTimerButton.accessibilityHint      = @"Starts the timer";
    startTimerButton.accessibilityLabel     = @"Start";
    
    stopTimerButton.isAccessibilityElement  = YES;
    stopTimerButton.accessibilityHint       = @"Stops the timer";
    stopTimerButton.accessibilityLabel      = @"Stop";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!stbView) {
        CGRect rect = CGRectMake(SLIDER_TAB_BAR_X, 
                                 SLIDER_TAB_BAR_Y, 
                                 SLIDER_TAB_BAR_W, 
                                 SLIDER_TAB_BAR_H);
        stbView = [[SliderTabBarView alloc] initWithFrame:rect];
        [stbView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:stbView];
        
        /* Accessibility */
        stbView.isAccessibilityElement = NO;
        
        [self setTabDisplayed:@"Instructions"];
    }
    
    // If there is a timer running and we are not launching to auto start a method
    if (timer && !self.autoStartMethod) {
        if(![self.navigationItem.title isEqualToString:methodBeingTimed]) {
            // If we're on a new method, forget about the old timer
            [timer invalidate];
            timer = nil;
            
            methodBeingTimed = nil;
            
            [self initializeDescriptions];
            [self resetTimerLabel];
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            // Always display the Instructions tab for new methods
            [self setTabDisplayed:@"Instructions"];
            [stbView updateDisplayForTab:@"Instructions"
                               forMethod:currentMethod];
        }
    } else {
        [self initializeDescriptions];
        [self resetTimerLabel];   
    } 
    
    [self.infoTableView reloadData];
    
    // Reset state
    self.autoStartMethod = false;
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