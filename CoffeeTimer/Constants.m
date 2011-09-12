//
//  Constants.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@implementation Constants

int const TIMER_UPDATE_INTERVAL = 0.1;

// SliderTabBarView constants

double const SLIDER_TAB_BAR_X = 19.0;
double const SLIDER_TAB_BAR_Y = 161.0;
double const SLIDER_TAB_BAR_W = 288.0;
double const SLIDER_TAB_BAR_H = 230.0;

double const INFO_WINDOW_X = 20.0;
double const INFO_WINDOW_Y = 208.0;
double const INFO_WINDOW_W = 281.0;
double const INFO_WINDOW_H = 176.0;


double const TABBAR_INSET = 1.0;
double const TEXTFIELD_WIDTH = 94.0; // (284 - 2 * TABBAR_INSET) / 3.0
double const TEXTFIELD_HEIGHT = 50;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
