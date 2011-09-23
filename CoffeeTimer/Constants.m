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

double const SLIDER_TAB_BAR_X = 8.0;
double const SLIDER_TAB_BAR_Y = 186.0;
double const SLIDER_TAB_BAR_W = 301.0;
double const SLIDER_TAB_BAR_H = 230.0;

double const SLIDER_DURATION = 0.3;

double const INFO_WINDOW_X = 9.0;
double const INFO_WINDOW_Y = 233.0;
double const INFO_WINDOW_W = 300.0;
double const INFO_WINDOW_H = 166.0;


double const TABBAR_INSET = 1.0;
double const TEXTFIELD_WIDTH = 100.0; // (284 - 2 * TABBAR_INSET) / 3.0
double const TEXTFIELD_HEIGHT = 49;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
