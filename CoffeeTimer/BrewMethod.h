//
//  BrewMethod.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerStep.h"

@interface BrewMethod : NSObject
{
    NSString *name; // Name of brew method

    NSArray *timerSteps; // Timer steps

    NSArray *prepArray; // Array of preparation 
    NSArray *equipArray; // Array of equipment
    
    int stepCounter;
}

+(NSMutableArray *)initBrewMethods;

- (id)initWithName:(NSString *)name timerStepArray:(NSArray *)steps;

- (id)initWithName:(NSString *)methodName 
    timerStepArray:(NSArray *)steps
       preparation:(NSArray *)prepArray
         equipment:(NSArray *)equipArray;


- (TimerStep *)firstTimerStep;
- (TimerStep *)nextTimerStep;
- (NSArray *)descriptionsForTab:(NSString *)tabName;

- (NSString *)commaSeparatedTimerSteps;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *timerSteps;
@property (nonatomic, retain) NSArray *prepArray;
@property (nonatomic, retain) NSArray *equipArray;

@end
