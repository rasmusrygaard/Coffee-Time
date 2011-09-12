//
//  TimerStep.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimerStep.h"

@implementation TimerStep

@synthesize stepDescription, timeInSeconds;

/*
 * Function: + (NSString *)formattedTimeInSecondsForInterval:(int)time
 * -------------------------------------------------------------------
 * Convenience method to specify the format of the timer label.
 */

+ (NSString *)formattedTimeInSecondsForInterval:(int)time
{
    return [NSString stringWithFormat:@"%02d:%02d", time / 60, time % 60];
    
}

- (id)init
{
    return [self initWithDescription:@"" 
                       timeInSeconds:0];
}

- (id)initWithDescription:(NSString *)desc 
            timeInSeconds:(int)time
{
    if (self = [super init]) {
        [self setStepDescription:desc];
        [self setTimeInSeconds:time];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%d sec)", stepDescription, timeInSeconds];
}

- (NSString *)formattedTimeInSeconds
{
    return [TimerStep formattedTimeInSecondsForInterval:timeInSeconds];
}

@end
