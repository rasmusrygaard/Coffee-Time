//
//  TimerStep.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerStep : NSObject
{
    int timeInSeconds;
    NSString *stepDescription;
}

@property (nonatomic, copy) NSString *stepDescription;
@property (nonatomic, assign) int timeInSeconds;

+ (NSString *)formattedTimeInSecondsForInterval:(int)time;

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
