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

- (void)testConvenienceMethods
{
    // + (int)timeInSecondsForFormattedInterval:(NSString *)time 
    // Simple
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"00:10"], 10, @"Incorrect time in seconds for formatted interval string");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"00:00"], 0, @"Incorrect time in seconds for formatted interval string");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"01:15"], 75, @"Incorrect time in seconds for formatted interval string");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"13:37"], 817, @"Incorrect time in seconds for formatted interval string");
    
    // Edge cases
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"abc"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"ab:ab"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"00:xx"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"xx:00"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"-11:00"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"-1:00"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"11"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"11111"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");

    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"11::11"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"1::11"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:nil], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@""], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    STAssertEquals([TimerStep timeInSecondsForFormattedInterval:@"11:111"], -1, @"Incorrect time in seconds for formatted interval string, edge cases");
    
    // + (NSString *)formattedTimeInSecondsForInterval:(int)time;
    // Simple cases
    STAssertEqualObjects([TimerStep formattedTimeInSecondsForInterval:10], @"00:10", @"Wrong interval for formatted time, simple tests");
    
    STAssertEqualObjects([TimerStep formattedTimeInSecondsForInterval:35], @"00:35", @"Wrong interval for formatted time, simple tests");
    
    STAssertEqualObjects([TimerStep formattedTimeInSecondsForInterval:200], @"03:20", @"Wrong interval for formatted time, simple tests");
    
    STAssertEqualObjects([TimerStep formattedTimeInSecondsForInterval:99], @"01:39", @"Wrong interval for formatted time, simple tests");
    
    // Edge cases
        STAssertEqualObjects([TimerStep formattedTimeInSecondsForInterval:0], @"00:00", @"Wrong interval for formatted time, edge cases");
    
    STAssertEqualObjects([TimerStep formattedTimeInSecondsForInterval:-1], nil, @"Wrong interval for formatted time, edge cases");
    
    STAssertEqualObjects([TimerStep formattedTimeInSecondsForInterval:-100], nil, @"Wrong interval for formatted time, edge cases");
}
                   

- (void)testStep
{
    
    STAssertNotNil(step, @"Could not allocate TimerStep");
}

@end
