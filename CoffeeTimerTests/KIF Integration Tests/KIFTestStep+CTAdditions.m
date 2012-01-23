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


@end
