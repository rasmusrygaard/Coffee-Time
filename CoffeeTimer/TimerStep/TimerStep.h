//
//  TimerStep.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerStep : NSObject <NSCoding>
{
    int timeInSeconds;
    NSString *stepDescription;
}

@property (nonatomic, copy) NSString *stepDescription;
@property (nonatomic, assign) int timeInSeconds;

/* Function: - (BOOL)stringMatchesTimeFormat:(NSString *)string
 * Returns true if the string has the format dd:dd where d is a digit
 */

- (BOOL)stringMatchesTimeFormat:(NSString *)string;

/* Function: + (NSString *)formattedTimeInSecondsForInterval:(int)time;
 * Returns an NSString* of format mm:ss given a time interval in seconds.
 * Returns nil iff time < 0.
 */

+ (NSString *)formattedTimeInSecondsForInterval:(int)time;

/* Function: + (int)timeInSecondsForFormattedInterval:(NSString *)time
 * Return an integer representing the value of the min/sec interval in seconds.
 * Expects parameter to have format mm:ss.
 * Returns -1 if input string does not have correct format.
 */

+ (int)timeInSecondsForFormattedInterval:(NSString *)time;

- (id)initWithDescription:(NSString *)desc timeInSeconds:(int)time;

/* Function: - (NSString *)formattedTimeInSeconds;
 * Return a string of the type MM:SS for the given timer step
 */

- (NSString *)formattedTimeInSeconds;

/* Function: - (NSString *)descriptionWithoutTime;
 * Return the description of the step without any time information.
 * Note that this is different from the overloaded description method.
 */

- (NSString *)descriptionWithoutTime;


@end
