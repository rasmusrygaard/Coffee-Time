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

#define UPDATE_INTERVAL 

@implementation BrewMethodViewController

@synthesize currentMethod;

- (id)init
{
    [super initWithNibName:@"BrewMethodViewController" bundle:nil];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return self;
}

/**                     **
 ** Timer functionality **
 **                     **/

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
        TimerStep *step = [currentMethod firstTimerStep];
        
        [self setAndStartTimerForStep:step];
        
        methodBeingTimed = [currentMethod name];
    }
}

- (void)setAndStartTimerForStep:(TimerStep *)step
{
    finishTime = [NSDate dateWithTimeIntervalSinceNow:([step timeInSeconds] + 1)];
    [finishTime retain];
    
    // Start timer
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_UPDATE_INTERVAL 
                                             target:self
                                           selector:@selector(checkTimerStatus:) 
                                           userInfo:nil
                                            repeats:YES];
    
}

- (IBAction)stopTimerClicked:(id)sender
{
    if (timer) {
        [timer invalidate];
        timer = nil;
        
        TimerStep *firstStep = [currentMethod firstTimerStep];
        
        [self setupLabelsForTimerStep:firstStep];
    }
}

- (void)checkTimerStatus:(NSTimer *)theTimer
{
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceNow:0];
    NSComparisonResult compar = [currentTime compare:finishTime];
    
    if (compar == NSOrderedSame || // If the time is after the end of the timer
        compar == NSOrderedDescending) {
        
        TimerStep *nextStep = [currentMethod nextTimerStep];
        
        [theTimer invalidate]; 
        timer = nil;
        
        if (nextStep) {
            [self setupLabelsForTimerStep:nextStep];
            [self setAndStartTimerForStep:nextStep];
        } else {
            [self setupLabelsForTimerStep:[currentMethod firstTimerStep]];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                                message:[NSString stringWithFormat:@"Your %@ is done", [currentMethod name]]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        }
    } else {
        NSTimeInterval timeElapsed = [finishTime timeIntervalSinceDate:currentTime];
        [timerLabel setText:[TimerStep formattedTimeInSecondsForInterval:(int)timeElapsed]];
    }
}

- (void)setupLabelsForTimerStep:(TimerStep *)step
{
    [timerLabel setText:[step formattedTimeInSeconds]];
    [descriptionLabel setText:[step description]];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**                      **
 ** TabBar functionality **
 **                      **/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *t = [touches anyObject];
    if ([t view] == stbView) {
//        NSLog(@"Touch in %@", [stbView tabTitleForTouch:t]);
        NSString *tab = [stbView tabTitleForTouch:t];
        [stbView updateDisplayForTab:tab
                           forMethod:currentMethod];
    } else {
        NSLog(@"Touches in viewcontroller");        
    }

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

    // Do any additional setup after loading the view from its nib.
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
    
    [nameLabel setText:[currentMethod name]];
    [self setupLabelsForTimerStep:[currentMethod firstTimerStep]];
    
    NSLog(@"current: %@ nameLabel: %@", methodBeingTimed, [nameLabel text]);
    if (timer && 
        ![[nameLabel text] isEqualToString:methodBeingTimed]) {
        // If we're on a new method, forget about the old timer
        [timer invalidate];
        timer = nil;
        NSLog(@"stopping timer!");
       
    }
    // Button setup
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [nameLabel release];
    nameLabel = nil;
    
    [timerLabel release];
    timerLabel = nil;
    
    [descriptionLabel release];
    descriptionLabel = nil;
    
    [changeMethodButton release];
    changeMethodButton = nil;
    
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
    
    [nameLabel release];
    [timerLabel release];
    [descriptionLabel release];
    
    [changeMethodButton release];
    [startTimerButton release];
    [stopTimerButton release];
    [timer release];
    
    [finishTime release];   
    
    [super dealloc];
}

@end