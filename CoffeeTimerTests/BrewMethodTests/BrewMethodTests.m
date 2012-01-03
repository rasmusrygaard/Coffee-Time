//
//  BrewMethodTests.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrewMethodTests.h"
#import "BrewMethod.h"

#define NUM_STEPS 300
#define MAX_TIME 200

@implementation BrewMethodTests 

@synthesize bm;

- (void)setUp
{
    [super setUp];
    
    bm = [[BrewMethod alloc] init];
}

- (void)tearDown
{
    [bm release];
    
    [super tearDown];
}

- (void)testInitialization
{
    STAssertNotNil(bm, @"Could not allocate BrewMethod");
    
    STAssertNil(bm.timerSteps, @"Timer steps are not nil on init");
    STAssertNil(bm.prepArray, @"Prep array is not nil on init");
    STAssertNil(bm.equipArray, @"Equipment array is not nil on init");
    
    STAssertEqualObjects(bm.name, @"", @"Name is not \"\" on init");
    
    STAssertNil([bm firstTimerStep], @"First timer step is not nil on empty method");
    STAssertNil([bm nextTimerStep], @"Next timer step is not nil on empty method");
    
    STAssertEquals([bm totalTimeInSeconds], 0, @"Total time is not 0 for empty method");
    STAssertNil([bm timeIntervals], @"Time intervals method does not return nil for empty method");
    
    STAssertNil([bm commaSeparatedTimerSteps], @"Timer step string is not empty for empty method");
}

- (void)testSimple
{
    TimerStep *t1 = [[TimerStep alloc] initWithDescription:@"First step"
                                            timeInSeconds:10];
    TimerStep *t2 = [[TimerStep alloc] initWithDescription:@"Second step"
                                            timeInSeconds:70];
    TimerStep *t3 = [[TimerStep alloc] initWithDescription:@"Third step"
                                            timeInSeconds:15];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:t1, t2, t3, nil];
    
    bm.timerSteps = [NSArray arrayWithArray:arr];
    
    STAssertEquals([bm totalTimeInSeconds], 95, @"Incorrect total time in seconds");
    
    STAssertEqualObjects([bm commaSeparatedTimerSteps], @"First step (00:10), Second step (01:10), Third step (00:15)", @"Incorrect string of timer steps");
    
    STAssertEqualObjects([bm firstTimerStep], t1, @"First timer step does not match");
    STAssertEqualObjects([bm nextTimerStep], t2, @"Second timer step does not match");
    STAssertEqualObjects([bm nextTimerStep], t3, @"Third timer step does not match");
    
    STAssertNil([bm nextTimerStep], @"nextTimerStep does not return nil after adding all steps");
    
    [bm resetTimerSteps];
    
    STAssertEqualObjects([bm nextTimerStep], t2, @"Resetting timer steps changes order of steps");
    STAssertEqualObjects([bm firstTimerStep], t1, @"Resetting steps changes first step");
    
}

- (void)testStress
{
    NSArray *verbs = [[NSArray alloc] initWithObjects:@"Work", @"Make", @"Do", @"Pour", @"Drink", nil];
    NSArray *pnoun = [[NSArray alloc] initWithObjects:@"It", @"That", @"This", @"Something", @"Anything", nil];
    
    int verbsLen = [verbs count];
    int pnounLen = [pnoun count];

    NSMutableArray *descriptions = [[NSMutableArray alloc] init];
    NSMutableArray *times        = [[NSMutableArray alloc] init];
    NSMutableArray *steps        = [[NSMutableArray alloc] init];
    
    int time, totalTime;
    NSString *str;
    // Create a number of timer steps
    for (int i = 0; i < NUM_STEPS; ++i) {
        str = [NSString stringWithFormat:@"%@ %@", 
                         [verbs objectAtIndex:(rand() % verbsLen)],
                         [pnoun objectAtIndex:(rand() % pnounLen)]];
        
        [descriptions addObject:str];
        
        time = (rand() % MAX_TIME);
        totalTime += time;
        [times addObject:[NSNumber numberWithInt:time]];
        
        [steps addObject:[[TimerStep alloc] initWithDescription:str 
                                                  timeInSeconds:time]];
    }
    
    STAssertEquals([bm totalTimeInSeconds], totalTime, @"Total time mismatch");
    
    
    BrewMethod *bm2 = [[BrewMethod alloc] initWithName:@"Test"
                                        timerStepArray:steps];
    
    int index;
    // Make sure that the steps in the method matches the generated steps
    for (int i = 0; i < NUM_STEPS; ++i) {
        index = rand() % NUM_STEPS;
        STAssertEqualObjects([[bm2.timerSteps objectAtIndex:index] descriptionWithoutTime], [descriptions objectAtIndex:index], @"Mismatch between descriptions at index %d", index);
        STAssertEquals([[bm2.timerSteps objectAtIndex:index] timeInSeconds], [[times objectAtIndex:index] intValue], @"Mismatch between times at index: %d", index);
    }
    
    [descriptions release];
    [times release];
    [steps release];
    
    bm2.timerSteps = nil;
    STAssertNil([bm firstTimerStep], @"First timer step is not nil after removing steps");
    STAssertNil([bm nextTimerStep], @"Next timer step is not nil after removing steps");
    
}

@end
