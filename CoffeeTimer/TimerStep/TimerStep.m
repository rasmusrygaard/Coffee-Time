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

- (void)setTimeInSeconds:(int)val
{
    if (val > 0) {
        timeInSeconds = val;
    }
}

/*
 * Function: + (NSString *)formattedTimeInSecondsForInterval:(int)time
 * -------------------------------------------------------------------
 * Convenience method to specify the format of the timer label.
 */

+ (NSString *)formattedTimeInSecondsForInterval:(int)time
{
    NSString *result = nil;

    if (time >= 0) {
        result = [NSString stringWithFormat:@"%02d:%02d", time / 60, time % 60];
    }
    
    return result;
    
}

/* Function: + (BOOL)stringMatchesTimeFormat:(NSString *)string
 * Checks that string matches the format dd:dd.
 * Check that string is non-nil, that its length is 5, and that all characters
 * except for the ':' are digits
 */

+ (BOOL)stringMatchesTimeFormat:(NSString *)str
{
    BOOL matches = NO;
    int len;
    
    if (str != nil && 
        ((len = str.length) == 5)) {
        
        NSRange match = [str rangeOfString:@":"];

        if (match.location == 2) {
                 
            BOOL hasFormat = YES;

            for (int i = 0; i < len; ++i) {
                
                if ((i != 2 && !isdigit([str characterAtIndex:i])) ||
                    (i == 2 && [str characterAtIndex:2] != ':')) {
                    hasFormat = NO;
                }
            }
            
            matches = hasFormat;
            
        }
    }
    
    return matches;
}

+ (int)timeInSecondsForFormattedInterval:(NSString *)time
{
    // Dead simple error checking. Need to make this slightly more intelligent, ie. detect ':'
    
    int seconds = -1;
    
    if ([self stringMatchesTimeFormat:time]) {
        NSString *min = [time substringToIndex:2];
        NSString *sec = [time substringFromIndex:3];
        
        seconds = [min intValue] * 60 + [sec intValue];
    }

    return seconds;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", stepDescription, [TimerStep formattedTimeInSecondsForInterval:timeInSeconds]];
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
