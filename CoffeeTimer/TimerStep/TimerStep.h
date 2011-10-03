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
- (NSString *)formattedTimeInSeconds;

- (NSString *)descriptionWithoutTime;


@end
