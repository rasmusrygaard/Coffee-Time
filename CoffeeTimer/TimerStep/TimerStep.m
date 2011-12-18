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

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [super init];
    
    self.timeInSeconds = [aDecoder decodeIntForKey:@"timeInSeconds"];
    self.stepDescription = [aDecoder decodeObjectForKey:@"stepDescription"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:timeInSeconds forKey:@"timeInSeconds"];
    [aCoder encodeObject:stepDescription forKey:@"stepDescription"];
}

/*
 * Function: + (NSString *)formattedTimeInSecondsForInterval:(int)time
 * -------------------------------------------------------------------
 * Convenience method to specify the format of the timer label.
 */

+ (NSString *)formattedTimeInSecondsForInterval:(int)time
{
    return [NSString stringWithFormat:@"%02d:%02d", time / 60, time % 60];
    
}

+ (int)timeInSecondsForFormattedInterval:(NSString *)time
{
    // Dead simple error checking. Need to make this slightly more intelligent, ie. detect ':'
    if (time.length != 5) return -1;
    
    NSString *min = [time substringToIndex:2];
    NSString *sec = [time substringFromIndex:3];
    
    NSLog(@"Interval: %@ Returning: %d", time, [min intValue] * 60 + [sec intValue]);
    return [min intValue] * 60 + [sec intValue];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%d sec)", stepDescription, timeInSeconds];
}

- (NSString *)descriptionWithoutTime
{
    return [self stepDescription];
}

- (NSString *)formattedTimeInSeconds
{
    return [TimerStep formattedTimeInSecondsForInterval:timeInSeconds];
}

@end
