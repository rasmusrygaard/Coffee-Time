//
//  TimerStepTests.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerStepTests.h"

@implementation TimerStepTests

- (void)setUp
{
    [super setUp];
    
    step = [[[TimerStep alloc] init] retain];
}

- (void)tearDown
{
    [step release];
    
    [super tearDown];
}

- (void)testStep
{
    STAssertNotNil(step, @"Could not allocate TimerStep");
}

@end
