//
//  KIFTestStep+CTAdditions.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFTestStep+CTAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIScrollView-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"


@implementation KIFTestStep (CTAdditions)

+ (id)stepToTapSliderTabWithLabel:(NSString *)label
{
    CGPoint p;
    
    if ([label isEqualToString:@"Preparation"]) {
        p = CGPointMake(53, 22);
    } else if ([label isEqualToString:@"Instructions"]) {
        p = CGPointMake(133, 12);
    } else if ([label isEqualToString:@"Equipment"]) {
        p = CGPointMake(255, 29);
    } else {
        return nil;
    }
    
    return [KIFTestStep stepToTapScreenAtPoint:p];
}

+ (id)stepToDismissKeyboard
{
    return [KIFTestStep stepToTapViewWithAccessibilityLabel:@"done"];
}

#define TOP_DELETE_BUTTON 75
#define DELETE_BUTTON_HEIGHT 44
#define CONFIRM_DELETE_W 74
#define CONFIRM_DELETE_X 235

+ (NSArray *)steptoTapDeleteAtCellWithIndex:(int)index
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [array addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake( DELETE_BUTTON_HEIGHT / 2, TOP_DELETE_BUTTON + index * DELETE_BUTTON_HEIGHT + (DELETE_BUTTON_HEIGHT / 2))]];
    
    [array addObject:[KIFTestStep stepToWaitForTimeInterval:1 description:@"Wait for delete button to appear"]];
    
    [array addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(CONFIRM_DELETE_X + CONFIRM_DELETE_W / 2, TOP_DELETE_BUTTON + index * DELETE_BUTTON_HEIGHT + (DELETE_BUTTON_HEIGHT / 2))]];
    
    return array;
}


@end
