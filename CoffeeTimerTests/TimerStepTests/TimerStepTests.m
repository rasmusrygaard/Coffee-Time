//
//  TimerStepTests.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerStepTests.h"
#import "TimerStep.h"

@implementation TimerStepTests

- (void)setUp
{
    [super setUp];
    
    step = [[[TimerStep alloc] init] retain];
    STAssertEquals(step.timeInSeconds, 0, @"Default time is not 0");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"00:00", @"Default formatted time is not \"00:00\"");
    
    STAssertEquals(step.stepDescription, @"", @"Step description is not the empty string");
}

- (void)tearDown
{
    [step release];
    
    [super tearDown];
}

- (void)testTimeSimple
{
    step.timeInSeconds = 10;
    STAssertEquals(step.timeInSeconds, 10, @"Incorrect time for step");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"00:10", @"Incorrect formatted time");
    
    step.timeInSeconds = 30;
    STAssertEquals(step.timeInSeconds, 30, @"Incorrect time for step");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"00:30", @"Incorrect formatted time");
    
    step.timeInSeconds = 60;
    STAssertEquals(step.timeInSeconds, 60, @"Incorrect time for step");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"01:00", @"Incorrect formatted time");
    
    step.timeInSeconds = 121;
    STAssertEquals(step.timeInSeconds, 121, @"Incorrect time for step");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"02:01", @"Incorrect formatted time");
    
    step.timeInSeconds = 600;
    STAssertEquals(step.timeInSeconds, 600, @"Incorrect time for step");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"10:00", @"Incorrect formatted time");
}

- (void)testTimeAdvanced
{
    step.timeInSeconds = 0;
    STAssertEquals(step.timeInSeconds, 0, @"Incorrect time for step");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"00:00", @"Incorrect formatted time");
    
    step.timeInSeconds = -1;
    STAssertEquals(step.timeInSeconds, 0, @"Incorrect time for step");
    STAssertEqualObjects(step.formattedTimeInSeconds, @"00:00", @"Incorrect formatted time");
    
    
}
                   

- (void)testStep
{
    
    STAssertNotNil(step, @"Could not allocate TimerStep");
}

@end
